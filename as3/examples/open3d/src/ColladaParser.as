package  
{
	import __AS3__.vec.Vector;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	import open3d.materials.*;
	import open3d.objects.Mesh;
	

	/**
	 * @author kris@neuroproductions.be
	 */
	public class ColladaParser extends Mesh
	{
		public static var LOCATION:String =""//"http://www.neuroproductions.be/uploads/blog/examples/collada/"
		public var indicesFull : Vector.<int> = new Vector.<int>();
		/*public var indicesUV : Vector.<int> = new Vector.<int>();
		public var uvtsTriangle : Vector.<Number> = new Vector.<Number>();*/
		public var uvtsFull : Vector.<Number> = new Vector.<Number>();
		public var verticesFull : Vector.<Number> = new Vector.<Number>();
		public  var __triangles : Array = new Array();
		public var materials : Object = new Object()
		private var indicesPos : int = 0
		private var scale : Number

		public function parse(xml : XML,scale : Number) : void
		{
			default xml namespace = "http://www.collada.org/2005/11/COLLADASchema";
			this.scale = scale
			for each (var imgXML:XML in xml.library_images.image)
			{
				
				var mat : Material2 = new Material2()
				mat.url = imgXML.init_from

				var idName : String = imgXML.@name.toString()
				mat.id = idName.replace("-image", "")
				materials[mat.id] = mat
				mat.load()
			}
			
			var defaultMat : Material2 = new Material2()
			defaultMat.id = "FrontColorNoCullingID"
			defaultMat.load()
			materials["FrontColorNoCullingID"] = defaultMat
			
			
			
			
			for each (var geomXML:XML in xml.library_geometries.geometry)
			{
				
				parseGeomXMLFull(geomXML)
				parseGeomXMLTriangles(geomXML)
			}
			
			
			_vin = verticesFull.concat();
			_triangles.uvtData = uvtsFull.concat();
			//_triangles.uvtData = new Vector.<Number>(_vin.length);
			
			_triangles.indices = indicesFull.concat();
			/*
			var ii:Number=0;
			for each(var indices:Number in _triangles.indices)
			{
				indices = ii++
			}
			*/
			trace(_vin.length, _triangles.uvtData.length, _triangles.indices.length)
			
			//var bitmapMaterial:BitmapMaterial = new BitmapMaterial(new BitmapData(100,100,false,0xFF0000));
			var bitmapMaterial:BitmapFileMaterial = new BitmapFileMaterial("images/texture0.jpg");
			
			//var bitmapMaterial:LineMaterial = new LineMaterial()
			
			buildFaces(bitmapMaterial);
		}
		
        [Embed(source = "assets/sea01.jpg")]
        private var Texture		:Class;
		private var texture		:BitmapData = Bitmap(new Texture()).bitmapData;
		
		private function parseGeomXMLTriangles(geomXML : XML) : void
		{
			var id : String = geomXML.@id
			
			
			
			var uvts : Vector.<Number> = new Vector.<Number>();
			var vertices : Vector.<Number> = new Vector.<Number>();
			
			
			for each (var xmls:XML in geomXML.mesh.source)
			{
				if  (xmls.@id == id + "-position" || xmls.@id == id + "-positions")
				{
					var verticesString : String = xmls.float_array.toString()
				}
				if  (xmls.@id == id + "-uv" || xmls.@id == id + "-map1")
				{
					var uvString : String = xmls.float_array.toString()
				}
			}
			var uv_arr : Array = uvString.split(" ")
			var vertices_arr : Array = verticesString.split(" ")
			
			for (var i : uint = 0;i < vertices_arr.length; i++) 
			{
				var n : Number = vertices_arr[i]
				vertices.push(n * scale)
				
			}
			for (i = 0;i < uv_arr.length; i++) 
			{
				n = Number(uv_arr[i])
				
				uvts.push(n)
			}
			
			
			
			for each (var trian : XML in geomXML.mesh.triangles) 
			{
				
				var indices : Vector.<int> = new Vector.<int>();
				var indicesUV : Vector.<int> = new Vector.<int>();
				
				var indicesString : String = trian.p.toString()		
				var mats : String = trian.@material
				
				var indices_arr : Array = indicesString.split(" ")
				for (i = 0;i < indices_arr.length; i += 3) 
				{
					var ni : int = int(indices_arr[i])
					indices.push(ni)
					
					//katopz
					//_triangles.indices.push(ni);
					
					var nitri : int = int(indices_arr[i + 2]) 
					indicesUV.push(nitri)
				}
				
				for (i = 0;i < indices.length; i += 3) 
				{
					var triangle : Triangle = new Triangle()
				
					triangle.vertices[0] = vertices[ indices[i + 0] * 3 + 0];
					triangle.vertices[1] = vertices[ indices[i + 0] * 3 + 1];
					triangle.vertices[2] = vertices[ indices[i + 0] * 3 + 2];
					
					triangle.vertices[3] = vertices[ indices[i + 1] * 3 + 0];
					triangle.vertices[4] = vertices[ indices[i + 1] * 3 + 1];
					triangle.vertices[5] = vertices[ indices[i + 1] * 3 + 2];
					
					triangle.vertices[6] = vertices[ indices[i + 2] * 3 + 0];
					triangle.vertices[7] = vertices[ indices[i + 2] * 3 + 1];
					triangle.vertices[8] = vertices[ indices[i + 2] * 3 + 2];
				
				
					triangle.uvData[0] = uvts[ indicesUV[i + 0] * 2 + 0];
					triangle.uvData[1] = uvts[ indicesUV[i + 0] * 2 + 1];
					triangle.uvData[2] = triangle.vertices[2];
			
					triangle.uvData[3] = uvts[ indicesUV[i + 1] * 2 + 0];
					triangle.uvData[4] = uvts[ indicesUV[i + 1] * 2 + 1];
					triangle.uvData[5] = triangle.vertices[5];
				
					triangle.uvData[6] = uvts[ indicesUV[i + 2] * 2 + 0];
					triangle.uvData[7] = uvts[ indicesUV[i + 2] * 2 + 1];
					triangle.uvData[8] = triangle.vertices[8];
					
					triangle.mat = mats;
					__triangles.push(triangle)
				}
			}
		}

		private var count : int = 0

		private function parseGeomXMLFull(geomXML : XML) : void
		{
			
				
			
			var id : String = geomXML.@id
			var mats : String
			var indicesString : String
			var s : String = ""
			for each (var trian : XML in geomXML.mesh.triangles) 
			{
				
				indicesString += s + trian.p.toString()	
				s = " "		
			}
			
			
			if (indicesString == "" || indicesString == null)return;
			
			
			
			for each (var xmls:XML in geomXML.mesh.source)
			{
				if  (xmls.@id == id + "-position" || xmls.@id == id + "-positions")
				{
					var verticesString : String = xmls.float_array.toString()
				}
				if  (xmls.@id == id + "-uv" || xmls.@id == id + "-map1")
				{
					var uvString : String = xmls.float_array.toString()
				}
			}
			var uv_arr : Array = uvString.split(" ")
		
			var vertices_arr : Array = verticesString.split(" ")
			
			for (var i : Number = 0;i < vertices_arr.length; i++) 
			{
				var n : Number = vertices_arr[i]
				verticesFull.push(n * scale)
				uvtsFull.push(0)
			}
			
			var indices_arr : Array = indicesString.split(" ")
			
			for (i = 0;i < indices_arr.length; i += 3) 
			{
				var ni : int = int(indices_arr[i]) + indicesPos
				indicesFull.push(ni)
			}
			
			indicesPos += (vertices_arr.length) / 3
		}
	}
}
