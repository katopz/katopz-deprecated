package open3d.objects  
{
	import flash.events.Event;
	
	import open3d.materials.*;
	import open3d.utils.LoaderUtil;

	/**
	 * Collada Parser
	 * @author kris@neuroproductions.be
	 *
	 * Modify/Optimize
	 * @author katopz
	 */
	public class Collada extends Mesh
	{
		public static var LOCATION:String =""//"http://www.neuroproductions.be/uploads/blog/examples/collada/"
		
		public var materials : Object = {}
		private var indicesPos : int = 0
		private var scale : Number;
		private var _customMaterial : Material;
		
		public function Collada(data:* = null, material:Material = null, scale:Number=1)
		{
			super();
			this.material = _customMaterial = material;
			this.scale = scale;
			
			if (data)
			{
				if (data is XML)
				{
					parse(data, scale);
				}
				else
				{
					load(data);
				}
			}
		}
		
		public function load(uri:String):Object
		{
			return LoaderUtil.load(uri, onLoad);
		}
		
		private function onLoad(event:Event):void
		{
			if(event.type == Event.COMPLETE)
				parse(XML(event.target.data), scale);
		}
		
		public function parse(xml : XML, scale : Number) : void
		{
			default xml namespace = "http://www.collada.org/2005/11/COLLADASchema";
			this.scale = scale;
			
			var mat : BitmapFileMaterial;
			for each (var imgXML:XML in xml.library_images.image)
			{
				mat = new BitmapFileMaterial(String(imgXML.init_from));
				//var idName : String = imgXML.@name.toString();
				//mat.id = idName.replace("-image", "");
				//materials[mat.id] = mat;
			}
			
			/*
			var defaultMat : Material2 = new Material2()
			defaultMat.id = "FrontColorNoCullingID"
			defaultMat.load()
			materials["FrontColorNoCullingID"] = defaultMat
			*/
			
			_vin = new Vector.<Number>();
			_triangles.uvtData = new Vector.<Number>();
			_triangles.indices = new Vector.<int>();
			
			for each (var geomXML:XML in xml.library_geometries.geometry)
			{
				parseGeomXMLTriangles(geomXML)
			}
			
			buildFaces(_customMaterial?_customMaterial:mat);
		}
			
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
			
			var j:int = 0;
			var k:int = 0;
			var _triangles_uvtData:Vector.<Number> = _triangles.uvtData;
			
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
					
					var nitri : int = int(indices_arr[i + 2]) 
					indicesUV.push(nitri)
				}
				
				for (i = 0;i < indices.length; i += 3) 
				{
					_vin[j++] = -vertices[ indices[i + 0] * 3 + 0];
					_vin[j++] = vertices[ indices[i + 0] * 3 + 1];
					_vin[j++] = vertices[ indices[i + 0] * 3 + 2];
					
					_vin[j++] = -vertices[ indices[i + 1] * 3 + 0];
					_vin[j++] = vertices[ indices[i + 1] * 3 + 1];
					_vin[j++] = vertices[ indices[i + 1] * 3 + 2];
					
					_vin[j++] = -vertices[ indices[i + 2] * 3 + 0];
					_vin[j++] = vertices[ indices[i + 2] * 3 + 1];
					_vin[j++] = vertices[ indices[i + 2] * 3 + 2];
				
					_triangles_uvtData[k++] = uvts[ indicesUV[i + 0] * 2 + 0];
					_triangles_uvtData[k++] = uvts[ indicesUV[i + 0] * 2 + 1];
					_triangles_uvtData[k++] = vertices[ indices[i + 0] * 3 + 2];
			
					_triangles_uvtData[k++] = uvts[ indicesUV[i + 1] * 2 + 0];
					_triangles_uvtData[k++] = uvts[ indicesUV[i + 1] * 2 + 1];
					_triangles_uvtData[k++] = vertices[ indices[i + 1] * 3 + 2];
				
					_triangles_uvtData[k++] = uvts[ indicesUV[i + 2] * 2 + 0];
					_triangles_uvtData[k++] = uvts[ indicesUV[i + 2] * 2 + 1];
					_triangles_uvtData[k++] = vertices[ indices[i + 2] * 3 + 2];
					
					_triangles.indices.push(i+2, i+1, i);
				}
			}
		}
	}
}
