package open3d.objects
{
	import __AS3__.vec.Vector;
	
	import flash.events.Event;
	import flash.geom.Vector3D;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import open3d.animation.Frame;
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
		private var loadScale:Number;
		
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
		 * @param material	The texture material that will be applied to object
		 * @param filename	The path to the file that will be loaded
		 * @param fps		The number of frames per second to animate at
		 * @param scale		The internal load scaling (experiment for your liking)
 		 * @author Philippe Ajoux (philippe.ajoux@gmail.com)
 		 * @modifier katopz@sleepydesign.com
		 */
		public function MD2(data:ByteArray, material:Material, fps:int = 24, scale:Number = 10)
		{
			this.material = material;
			super(material, fps, scale);
			loadScale = scale;
			//file = filename;
			//visible = false;
			//load(filename);
			parse(data);
			buildFaces(material);
		}
		/*
		override protected function buildFaces(material:Material):void
		{
			this.material = material;
			this.material.update();
		}
		*/
		/**
		 * Actually load the file using a URLLoader instance
		 * 
		 * @param filename	Path to MD2 file to load
		 */
		private function load(filename:String):void
		{
			loader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			loader.addEventListener(Event.COMPLETE, parse, false, 0, true);
			
			try
			{
	            loader.load(new URLRequest(filename));
			}
			catch(e:Error)
			{
				trace("Error in loading MD2 file (" + filename + "): \n" + e.message + "\n" + e.getStackTrace());
			}
		}
		
		/**
		 * Parse the MD2 file. This is actually pretty straight forward.
		 * Only complicated parts (bit convoluded) are the frame loading.
		 */
		private function parse(data:ByteArray):void
		{
			var a:int, b:int, c:int, ta:int, tb:int, tc:int;
			var vertices:Array = [];
			//var faces:Array = []//TODO//this.faceList;
			var i:int, uvs:Array = [];
			var indices:Array = [];
			var uvDatas:Array = []
			//var data:ByteArray = loader.data;
			
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
				vertices.push(new Vector3D(0,0,0));

			// UV coordinates
			//		Load them!
			data.position = offset_st;
			for (i = 0; i < num_st; i++)
				uvs.push(new UV(data.readShort() / skinwidth,  ( data.readShort() / skinheight) ));

			// Faces
			//		Creates the faces with the proper references to vertices
			//		NOTE: DO NOT change the order of the variable assignments here, 
			//			  or nothing will work.
			data.position = offset_tris;
			var j:int=0;
			for (i = 0; i < num_tris; i++)
			{
				a = data.readUnsignedShort();
				b = data.readUnsignedShort();
				c = data.readUnsignedShort();
				ta = data.readUnsignedShort();
				tb = data.readUnsignedShort();
				tc = data.readUnsignedShort();
				
				trace(uvs[tc], uvs[tb], uvs[ta]);
				
				/*
				triangles.uvtData.push
				(
					uvs[tc].u, uvs[tc].v, 
					uvs[tb].u, uvs[tb].v, 
					uvs[ta].u, uvs[ta].v
				);
				*/
				trace(triangles.uvtData);
				
			}
			
			triangles.uvtData.push(0,0,1, 1,0,1, 0,1,1, 1,1,1);
			
			// Frame animation data
			//		This part is a little funky.
			data.position = offset_frames;
			readFrames(data);
						
			j=0;
			for (i = 0; i < Frame(frames[0]).vertices.length; i++)
			{
				vin.push(Frame(frames[0]).vertices[i].x,
						 Frame(frames[0]).vertices[i].y,
						 Frame(frames[0]).vertices[i].z);
				
				trace( Frame(frames[0]).vertices[i]);
			}
			/*vin.push(
				0,-150,-160,
				0,150,-160,
				0,150,160,
				0,-150,160
				)*/
				
			//   ___   ___   ___         ___  
			// 0|  /|1|  /|4|  /|(3*i)+0|  /|(3*i)+1
			//  | / | | / | | / |		| / |
			// 3|/__|2|/__|5|/__|(3*i)+3|/__|(3*i)+2
			
			for (i = 0; i < num_tris; i++)
			{
				//
			}
			
			triangles.indices.push(0, 1, 2);
			triangles.indices.push(1, 2, 3);
			
			/*
			for (i = 0; i < num_tris/3; i+=3)
			{
				trace("Vector3D("+vin[i]+", "+vin[i+1]+", "+vin[i+2]+")");
			}
			*/
			//loader.close();
			//visible = true;
			trace("__________________________________" + 
				  "\n_______Parsed MD2_________________" +
				  "\n|" + 
				  "\n|\tvertices:" + vin.length/3 +
				  "\n|\ttexture vertices:" + uvs.length +
				  "\n|\tfaces:" + num_tris +
				  "\n|_________________________________"
				  );
		}
		
		/**
		 * Reads in all the frames
		 */
		private function readFrames(data:ByteArray):void
		{
			var sx:Number, sy:Number, sz:Number;
			var tx:Number, ty:Number, tz:Number;
			var verts:Vector.<Vector3D>, frame:Frame;
			var i:int, j:int, char:int;
			
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
				
				for (j = 0; j < 16; j++)
					if ((char = data.readUnsignedByte()) != 0)
						frame.name += String.fromCharCode(char);
				
				// Note, the extra data.position++ in the for loop is there 
				// to skip over a byte that holds the "vertex normal index"
				for (j = 0; j < num_vertices; j++, data.position++)
					verts.push(new Vector3D(
						(sx * data.readUnsignedByte() + tx) * loadScale, 
						(sy * data.readUnsignedByte() + ty) * loadScale,
						(sz * data.readUnsignedByte() + tz) * loadScale));
						
				addFrame(frame);
				
			}
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