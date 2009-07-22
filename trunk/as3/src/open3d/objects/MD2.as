package open3d.objects
{
	import flash.events.Event;
	import flash.geom.Vector3D;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import open3d.animation.Frame;
	import open3d.data.FaceData;
	import open3d.geom.UV;
	import open3d.materials.Material;

	/**
	 * File loader for the Md2 file format.
	 * @author Philippe Ajoux (philippe.ajoux@gmail.com)
	 *
	 * Modify/Optimize
	 * @author katopz
	 */
	public class MD2 extends KeyframeMesh
	{
		// [internal] Used for loading the MD2 file
		private var file:String;
		private var loader:URLLoader;
		private var _scale:Number;

		// [internal] Md2 file format has a bunch of header information
		// that is typically just read straight into a C-style struct, but
		// since this is not C =( we have to create variables for all of it.
		private var ident:int, version:int;
		private var skinwidth:int, skinheight:int;
		private var framesize:int;
		private var num_skins:int, num_vertices:int, num_st:int;
		private var num_tris:int, num_glcmds:int, num_frames:int;
		private var offset_skins:int, offset_st:int, offset_tris:int;
		private var offset_frames:int, offset_glcmds:int, offset_end:int;

		/**
		 * Md2 class lets you load a Quake 2 MD2 file with animation!
		 *
		 * @param data		MD2 binary data
		 * @param material	The texture material that will be applied to object
		 * @param scale		The internal load scaling (experiment for your liking)
		 * @param fps		The number of frames per second to animate at
		 * 
		 * @author Philippe Ajoux (philippe.ajoux@gmail.com)
		 * @modifier katopz@sleepydesign.com
		 */
		public function MD2(data:* = null, material:Material = null, scale:Number = 10, fps:int = 24)
		{
			
			super(material, fps);
			_scale = scale;

			if (data)
			{
				if (data is ByteArray)
				{
					parse(data);
				}
				else
				{
					load(data);
				}
			}
		}

		/**
		 * Actually load the file using a URLLoader instance
		 *
		 * @param uri	Path to MD2 file to load
		 */
		private function load(uri:String):void
		{
			loader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			loader.addEventListener(Event.COMPLETE, onLoad, false, 0, true);

			try
			{
				loader.load(new URLRequest(uri));
			}
			catch (e:Error)
			{
				trace(" ! Error in loading MD2 file (" + uri + "): \n" + e.message + "\n" + e.getStackTrace());
			}
		}

		private function onLoad(event:Event):void
		{
			parse(ByteArray(event.target.data));
		}

		/**
		 * Parse the MD2 file. This is actually pretty straight forward.
		 * Only complicated parts (bit convoluded) are the frame loading.
		 */
		private function parse(data:ByteArray):void
		{
			var a:int, b:int, c:int, ta:int, tb:int, tc:int;
			var vertices:Vector.<Vector3D> = new Vector.<Vector3D>();
			var i:int, uvs:Array = [];
			var indices:Array = [];
			var uvDatas:Array = []

			// Make sure to have this in Little Endian or you will hate you life.
			// At least I did the first time I did this for a while.
			data.endian = Endian.LITTLE_ENDIAN;

			// Read the header and make sure it is valid MD2 file
			readMd2Header(data);
			if (ident != 844121161 || version != 8)
				throw new Error("Error loading MD2 file (" + file + "): Not a valid MD2 file/bad version");

			// Vertice setup
			// 		Be sure to allocate memory for the vertices to the object
			//		These vertices will be updated each frame with the proper coordinates
			for (i = 0; i < num_vertices; i++)
				vertices.push(new Vector3D(0, 0, 0));

			// UV coordinates
			//		Load them!
			data.position = offset_st;
			for (i = 0; i < num_st; i++)
				uvs.push(new UV(data.readShort() / skinwidth, (data.readShort() / skinheight)));

			// Faces
			//		Creates the faces with the proper references to vertices
			//		NOTE: DO NOT change the order of the variable assignments here, 
			//			  or nothing will work.
			data.position = offset_tris;
			faceDatas = new Vector.<FaceData>(num_tris, true);
			var j:int = 0;
			for (i = 0; i < num_tris; i++)
			{
				a = data.readUnsignedShort();
				b = data.readUnsignedShort();
				c = data.readUnsignedShort();
				ta = data.readUnsignedShort();
				tb = data.readUnsignedShort();
				tc = data.readUnsignedShort();

				faceDatas[i] = new FaceData(a, b, c, vertices, Vector.<UV>([uvs[ta], uvs[tb], uvs[tc]]));
			}
			
			// Frame animation data
			//		This part is a little funky.
			data.position = offset_frames;
			readFrames(data);

			// TODO : optimize/promote to face class
			var n:int = -1;
			i = 0;
			
			var a0:Vector3D;
			var b0:Vector3D;
			var c0:Vector3D;
			
			for each (var face:FaceData in faceDatas)
			{
				a0 = Frame(frames[0]).vertices[face.a];
				b0 = Frame(frames[0]).vertices[face.b];
				c0 = Frame(frames[0]).vertices[face.c];
				
				_vin[i++] = a0.x;
				_vin[i++] = a0.y;
				_vin[i++] = a0.z;
				
				_vin[i++] = b0.x;
				_vin[i++] = b0.y;
				_vin[i++] = b0.z;

				_vin[i++] = c0.x;
				_vin[i++] = c0.y;
				_vin[i++] = c0.z;

				_triangles.uvtData.push(face.uvMap[0].u, face.uvMap[0].v, 1);
				_triangles.uvtData.push(face.uvMap[1].u, face.uvMap[1].v, 1);
				_triangles.uvtData.push(face.uvMap[2].u, face.uvMap[2].v, 1);

				n += 3;

				_triangles.indices.push(n - 2, n - 1, n);
			}

			buildFaces(material);
		}

		/**
		 * Reads in all the frames
		 */
		private function readFrames(data:ByteArray):void
		{
			var sx:Number, sy:Number, sz:Number;
			var tx:Number, ty:Number, tz:Number;
			var verts:Vector.<Vector3D>, frame:Frame;
			var i:int, j:int, k:int, char:int;
			
			for (i = 0; i < num_frames; i++)
			{
				verts = new Vector.<Vector3D>();
				frame = new Frame("", verts);

				sx = data.readFloat();
				sy = data.readFloat();
				sz = data.readFloat();

				tx = data.readFloat();
				ty = data.readFloat();
				tz = data.readFloat();

				k = 0;
				for (j = 0; j < 16; j++)
				{
					char = data.readUnsignedByte();
					if (int(char) >= 0x30 && int(char) <= 0x7A && k<3)
					{
						frame.name += String.fromCharCode(char);
					}
					if (int(char) >= 0x30 && int(char) <= 0x39)k++; 
				}

				// Note, the extra data.position++ in the for loop is there 
				// to skip over a byte that holds the "vertex normal index"
				for (j = 0; j < num_vertices; j++, data.position++)
					verts.push(new Vector3D((sx * data.readUnsignedByte() + tx) * _scale, (sy * data.readUnsignedByte() + ty) * _scale, (sz * data.readUnsignedByte() + tz) * _scale));
				
				addFrame(frame);
			}
			
			verts.fixed = true;
		}

		/**
		 * Reads in all that MD2 Header data that is declared as private variables.
		 * I know its a lot, and it looks ugly, but only way to do it in Flash
		 */
		private function readMd2Header(data:ByteArray):void
		{
			ident = data.readInt();
			version = data.readInt();
			skinwidth = data.readInt();
			skinheight = data.readInt();
			framesize = data.readInt();
			num_skins = data.readInt();
			num_vertices = data.readInt();
			num_st = data.readInt();
			num_tris = data.readInt();
			num_glcmds = data.readInt();
			num_frames = data.readInt();
			offset_skins = data.readInt();
			offset_st = data.readInt();
			offset_tris = data.readInt();
			offset_frames = data.readInt();
			offset_glcmds = data.readInt();
			offset_end = data.readInt();
		}
	}
}