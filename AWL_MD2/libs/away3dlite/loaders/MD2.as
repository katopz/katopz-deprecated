﻿package away3dlite.loaders{    import away3dlite.animators.*;    import away3dlite.animators.frames.Frame;    import away3dlite.arcane;    import away3dlite.core.utils.*;        import flash.utils.*;		use namespace arcane;	    /**    * File loader for the MD2 file format.    */    public class MD2 extends AbstractParser    {		/** @private */        arcane override function prepareData(data:*):void        {        	md2 = Cast.bytearray(data);        				var a:int, b:int, c:int, ta:int, tb:int, tc:int, i1:int, i2:int, i3:int;			var i:int, uvs:Array = [];						// Make sure to have this in Little Endian or you will hate you life.			// At least I did the first time I did this for a while.			md2.endian = Endian.LITTLE_ENDIAN;			// Read the header and make sure it is valid MD2 file			readMD2Header(md2);			if (ident != 844121161 || version != 8)				throw new Error("Error loading MD2 file: Not a valid MD2 file/bad version");			// UV coordinates			//		Load them!			md2.position = offset_st;			for (i = 0; i < num_st; i++)			{				var _a:int = md2.readShort(); 				var _b:int = md2.readShort(); 				uvs.push( _a/skinwidth, (_b/skinheight));			}							_mesh._uvtData.length = _mesh._vertices.length = num_tris*9;			_vertexIndices.length = num_tris*3;						// Faces			//		Creates the faces with the proper references to vertices			//		NOTE: DO NOT change the order of the variable assignments here, 			//			  or nothing will work.			md2.position = offset_tris;			for (i = 0; i < num_tris; i++) 			{				i1 = i*3;				i2 = i1 + 1;				i3 = i1 + 2;								//collect vertices				a = md2.readUnsignedShort();				b = md2.readUnsignedShort();				c = md2.readUnsignedShort();				_vertexIndices[i1] = a;				_vertexIndices[i2] = b;				_vertexIndices[i3] = c;								//collect indices				_mesh._indices.push(i3, i2, i1);								//collect face lengths				_mesh._faceLengths.push(3);								//collect uvData 				ta = md2.readUnsignedShort();				tb = md2.readUnsignedShort();				tc = md2.readUnsignedShort();								var _uvtData:Vector.<Number> = _mesh._uvtData;								_uvtData[i1*3 + 0] = uvs[ta*2 + 0];				_uvtData[i1*3 + 1] = uvs[ta*2 + 1];				_uvtData[i1*3 + 2] = 1;								_uvtData[i2*3 + 0] = uvs[tb*2 + 0];				_uvtData[i2*3 + 1] = uvs[tb*2 + 1];				_uvtData[i2*3 + 2] = 1;								_uvtData[i3*3 + 0] = uvs[tc*2 + 0];				_uvtData[i3*3 + 1] = uvs[tc*2 + 1];				_uvtData[i3*3 + 2] = 1;			}						// Frame animation data			//		This part is a little funky.			md2.position = offset_frames;			readFrames(md2);                        //setup vertices for the first frame			_mesh._vertices = _mesh.frames[0].vertices.concat();						if (material)				_mesh.material = material;						_mesh.buildFaces();                        _mesh.type = ".MD2";        }                /* raw data */        protected var md2:ByteArray;        /* magic number: "IDP2" */        protected var ident:int;        /* version: must be 8 */        protected var version:int;        protected var skinwidth:int;        protected var skinheight:int;        /* size in bytes of a frame */        protected var framesize:int;        /* number of skins */        protected var num_skins:int;        /* number of vertices per frame */        protected var num_vertices:int;        /* number of texture coordinates */        protected var num_st:int;        /* number of triangles */        protected var num_tris:int;        /* number of opengl commands */        protected var num_glcmds:int;        /* number of frames */        protected var num_frames:int;        /* offset skin data */        protected var offset_skins:int;        /* offset texture coordinate data */        protected var offset_st:int;        /* offset triangle data */        protected var offset_tris:int;        /* offset frame data */        protected var offset_frames:int;        /* offset OpenGL command data */        protected var offset_glcmds:int;        /* offset end of file */        protected var offset_end:int;            	protected var _mesh:MovieMesh;    	    	// temporary use		protected var _vertexIndices:Vector.<int> = new Vector.<int>();		protected var _vertices:Vector.<Number> = new Vector.<Number>();				// center mesh		protected var minX:Number = Infinity, maxX:Number = -Infinity, minY:Number = Infinity, maxY:Number = -Infinity, minZ:Number = Infinity, maxZ:Number = -Infinity;				// texture file name		public var textureName:String;				/**		 * Reads in all the frames		 */		protected function readFrames(data:ByteArray):void		{			var sx:Number, sy:Number, sz:Number;			var tx:Number, ty:Number, tz:Number;			var fvertices:Vector.<Number>, frame:Frame;			var tvertices:Vector.<Number>;			var i:int, j:int, k:int, charCode:int;						for (i = 0; i < num_frames; i++) {				tvertices = new Vector.<Number>();				fvertices = new Vector.<Number>(num_tris*9, true);				frame = new Frame("", fvertices);				// scale				sx = data.readFloat();				sy = data.readFloat();				sz = data.readFloat();				// translate				tx = data.readFloat();				ty = data.readFloat();				tz = data.readFloat();								// read frame name				k = 0;				for (j = 0; j < 16; j++) {					charCode = data.readUnsignedByte();										if (int(charCode) >= 0x30 && int(charCode) <= 0x7A && k < 3)						frame.name += String.fromCharCode(charCode);										if (int(charCode) >= 0x30 && int(charCode) <= 0x39)						k++; 				}								// Note, the extra data.position++ in the for loop is there 				// to skip over a byte that holds the "vertex normal index"				var _a:Number,_b:Number,_c:Number;				for (j = 0; j < num_vertices; j++, data.position++)				{					_a = data.readUnsignedByte();					_b = data.readUnsignedByte();					_c = data.readUnsignedByte();					tvertices.push(						((sx*_a + tx)*scaling), 						((sy*_b + ty)*scaling), 						((sz*_c + tz)*scaling)					);				}								for (j = 0; j < num_tris*3; j++) 				{					fvertices[j*3 + 0] = tvertices[_vertexIndices[j]*3 + 0];					fvertices[j*3 + 1] = tvertices[_vertexIndices[j]*3 + 1];					fvertices[j*3 + 2] = tvertices[_vertexIndices[j]*3 + 2];										//collect min/max for 1 frame only					if (centerMeshes && i==0)					{						minX = (fvertices[j*3+0]<minX)?fvertices[j*3+0]:minX;						minY = (fvertices[j*3+1]<minY)?fvertices[j*3+1]:minY;						minZ = (fvertices[j*3+2]<minZ)?fvertices[j*3+2]:minZ;						maxX = (fvertices[j*3+0]>maxX)?fvertices[j*3+0]:maxX;						maxY = (fvertices[j*3+1]>maxY)?fvertices[j*3+1]:maxY;						maxZ = (fvertices[j*3+2]>maxZ)?fvertices[j*3+2]:maxZ;					}				}								if (centerMeshes && i==0)				for (j = 0; j < num_tris*3; j++) 				{					fvertices[j*3 + 0] -= (maxX + minX)/2;	                fvertices[j*3 + 1] -= (maxY + minY)/2;					fvertices[j*3 + 2] -= (maxZ + minZ)/2;				}								_mesh.addFrame(frame);			}						_vertices.fixed = true;		}		/**		 * Reads in all that MD2 Header data that is declared as protected variables.		 * I know its a lot, and it looks ugly, but only way to do it in Flash		 */		protected function readMD2Header(data:ByteArray):void		{			ident = data.readInt();			version = data.readInt();			skinwidth = data.readInt();			skinheight = data.readInt();			framesize = data.readInt();			num_skins = data.readInt();			num_vertices = data.readInt();			num_st = data.readInt();			num_tris = data.readInt();			num_glcmds = data.readInt();			num_frames = data.readInt();			offset_skins = data.readInt();			offset_st = data.readInt();			offset_tris = data.readInt();			offset_frames = data.readInt();			offset_glcmds = data.readInt();			offset_end = data.readInt();						// texture			data.position = 0x44;			textureName = "";			do{				var charCode:uint = data.readUnsignedByte();				if(charCode != 0x00)					textureName+=String.fromCharCode(charCode);			}while(charCode != 0x00)		}            	/**    	 * A scaling factor for all geometry in the model. Defaults to 1.    	 */        public var scaling:Number = 1;            	/**    	 * Controls the automatic centering of geometry data in the model, improving culling and the accuracy of bounding dimension values.    	 */        public var centerMeshes:Boolean;        		/**		 * Creates a new <code>MD2</code> object.		 */        public function MD2()        {            _mesh = (_container = new MovieMesh()) as MovieMesh;            binary = true;        }    }}