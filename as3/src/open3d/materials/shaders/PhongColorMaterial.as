package open3d.materials.shaders {
	import open3d.geom.Vertex;
	import open3d.materials.BitmapMaterial;
	import open3d.objects.Light;

	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.IGraphicsData;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Utils3D;
	import flash.geom.Vector3D;

	/**
	 * @author kris
	 */
	public class PhongColorMaterial extends BitmapMaterial implements IShader {

		
		private var _light : Light;
		private var normals : Vector.<Vector3D>;
		private var vertices : Vector.<Vertex>;

		private var faceNormals : Vector.<Vector3D>;

		public function PhongColorMaterial(color : uint,light : Light) {
			
			
			_light = light;
			trace(_light)
			// TODO: Implement params
			var bitmapData : BitmapData = getShadingBitmap(color);
			
			
			super(bitmapData);
		}

		private var _vout : Vector.<Number>;

		public 	function calculateNormals(_vout : Vector.<Number>,indices : Vector.<int>) : void {
			if (faceNormals != null) return;
			
			this._vout = _vout;
			var trianglesLength : int = indices.length / 9;
			faceNormals = new Vector.<Vector3D>(trianglesLength, true);
			vertices = new Vector.<Vertex>(_vout.length / 3, true);
			
			for (var i : int = 0;i < trianglesLength; i++) {
				var vec : Vector.<Number> = new Vector.<Number>(9, true);
				vec[0] = _vout[indices[i * 9]];		
				vec[1] = _vout[indices[i * 9 + 1]];
				vec[2] = _vout[indices[i * 9 + 2]];
				vec[3] = _vout[indices[i * 9 + 3]];
				vec[4] = _vout[indices[i * 9 + 4]];
				vec[5] = _vout[indices[i * 9 + 5]];
				vec[6] = _vout[indices[i * 9 + 6]];
				vec[7] = _vout[indices[i * 9 + 7]];
				vec[8] = _vout[indices[i * 9 + 8 ]];
				
				var faceNormal : Vector3D = calculateNormal(vec);
				faceNormals[i] = faceNormal;
				
				vertices[indices[i * 9  ]] = addNormal(vertices[indices[i * 9  ]], faceNormal);
				vertices[indices[i * 9 + 1 ]] = addNormal(vertices[indices[i * 9 + 1 ]], faceNormal);
				vertices[indices[i * 9 + 2 ]] = addNormal(vertices[indices[i * 9 + 2]], faceNormal);
				vertices[indices[i * 9 + 3 ]] = addNormal(vertices[indices[i * 9 + 3 ]], faceNormal);
				vertices[indices[i * 9 + 4 ]] = addNormal(vertices[indices[i * 9 + 4 ]], faceNormal);
				vertices[indices[i * 9 + 5 ]] = addNormal(vertices[indices[i * 9 + 5 ]], faceNormal);
				vertices[indices[i * 9 + 6 ]] = addNormal(vertices[indices[i * 9 + 6 ]], faceNormal);
				vertices[indices[i * 9 + 7 ]] = addNormal(vertices[indices[i * 9 + 7 ]], faceNormal);
				vertices[indices[i * 9 + 8 ]] = addNormal(vertices[indices[i * 9 + 8 ]], faceNormal);
			}
			calculateVertexNormals();
		}

		private function addNormal(v : Vertex, faceNormal : Vector3D) : Vertex {
			if (v == null) v = new Vertex();
		
			v.addFaceNormal(faceNormal);
			return v;
		}

		private function calculateVertexNormals() : void {
			for (var i : int = 0;i < vertices.length; i++) {	
				vertices[i].calculateNormal();
			}
		}

		//TODO replace with Vector3Ds
		public function calculateNormal(tVector : Vector.<Number>) : Vector3D {
			
			//
			var normal : Vector3D = new Vector3D();
			var  dif1 : Vector.<Number> = new Vector.<Number>();
			var  dif2 : Vector.<Number> = new Vector.<Number>();
			//TODO Vector3D.substract??
			dif1.push(tVector[0] - tVector[3], tVector[1] - tVector[4], tVector[2] - tVector[5]);
			dif2.push(tVector[6] - tVector[3], tVector[7] - tVector[4], tVector[8] - tVector[5]);
			//
		
			//TODO Vector3D.crossProduct
			//A x B = <Ay*Bz - Az*By, Az*Bx - Ax*Bz, Ax*By - Ay*Bx>
			normal.x = ((dif1[1] * dif2[2]) - (dif1[2] * dif2[1]));
			normal.y = ((dif1[0] * dif2[2]) - (dif1[2] * dif2[0] )) * -1;
			normal.z = ((dif1[0] * dif2[1] ) - (dif1[1] * dif2[0]));
		
			
			normal.normalize();
		
			return normal;
		}

		
		
		public function getUVData(m : Matrix3D) : Vector.<Number> {
			var uvData : Vector.<Number> = new Vector.<Number>();
			var projectedNormal : Vector3D ;
			var texCoord : Point = new Point(); 
			for (var i : int = 0;i < vertices.length; i++) {
				projectedNormal = Utils3D.projectVector(m, vertices[i].normal);
				projectedNormal.normalize()
				calculateTexCoord(texCoord, projectedNormal);
				//texCoord.x=Math.random()
				//texCoord.y =Math.random()
				uvData.push(texCoord.x, texCoord.y, 1)
			}
			return uvData;
		}

		
		
		public function calculateTexCoord(texCoord : Point, normal : Vector3D, doubleSided : Boolean = false) : void {
			var v : Vector3D = _light.direction;
			texCoord.x = v.x * normal.x + v.y * normal.y + v.z * normal.z;
			if (texCoord.x < 0) texCoord.x = (doubleSided) ? -texCoord.x : 0;
			v = _light.halfVector;
			texCoord.y = v.x * normal.x + v.y * normal.y + v.z * normal.z;
			if (texCoord.y < 0) texCoord.y = (doubleSided) ? -texCoord.y : 0;
		}

		
		
		
		
		protected function getShadingBitmap(color : uint, alpha_ : Number = 1.0,amb : int = 64, dif : int = 192, spc : int = 0, pow : Number = 8, emi : int = 0, doubleSided : Boolean = false) : BitmapData {
			var colorTable : BitmapData = new BitmapData(256, 256, false);
			var i : int, r : int, c : int,
            lightTable : BitmapData = new BitmapData(256, 256, false),
            rct : Rectangle = new Rectangle();
        
			// base color
			var alpha : Number = alpha_;
			colorTable.fillRect(colorTable.rect, color);

			// ambient/diffusion/emittance
			var ea : Number = (256 - emi) * 0.00390625,
            eb : Number = emi * 0.5;
			r = dif - amb;
			rct.width = 1; 
			rct.height = 256; 
			rct.y = 0;
			for (i = 0;i < 256; ++i) {
				rct.x = i;
				lightTable.fillRect(rct, (((i * r) >> 8) + amb) * 0x10101);
			}
			colorTable.draw(lightTable, null, new ColorTransform(ea, ea, ea, 1, eb, eb, eb, 0), BlendMode.HARDLIGHT);
        
			// specular/power
			if (spc > 0) {
				rct.width = 256; 
				rct.height = 1; 
				rct.x = 0;
				for (i = 0;i < 256; ++i) {
					rct.y = i;
					c = int(Math.pow(i * 0.0039215686, pow) * spc);
					lightTable.fillRect(rct, ((c < 255) ? c : 255) * 0x10101);
				}
				colorTable.draw(lightTable, null, null, BlendMode.ADD);
			}
			lightTable.dispose();
			var _nega_filter : int = 0;
			// double sided
			_nega_filter = (doubleSided) ? -1 : 0;
			return colorTable;
		}

		override public function update() : void {
			graphicsData = Vector.<IGraphicsData>([_graphicsBitmapFill, triangles]);
			graphicsData.fixed = true;
			super.update();
		}
	}
}
