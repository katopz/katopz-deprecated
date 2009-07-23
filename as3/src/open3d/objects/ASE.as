package open3d.objects
{
	import flash.events.Event;
	import flash.geom.Vector3D;
	import flash.utils.ByteArray;
	import flash.utils.unescapeMultiByte;
	
	import open3d.geom.UV;
	import open3d.materials.Material;
	import open3d.utils.LoaderUtil;

	/**
	 * Parses single ASE mesh from ByteArray.
	 * @author makc
	 * @link http://makc.googlecode.com/svn/trunk/flash/fp10_ase
	 *
	 * Modify/Optimize
	 * @author katopz
	 */
	public class ASE extends Mesh
	{
		private var vertexCoords:Vector.<Vector3D> = new Vector.<Vector3D>();
		private var _scale:Number;
		
		private function createVertex(x:Number, y:Number, z:Number, id:int):void
		{
			vertexCoords[id] = new Vector3D(_scale*x, _scale*y, _scale*z);
		}

		private var uvs:Array = [];

		private function createUV(u:Number, v:Number, id:int):void
		{
			uvs[id] = new UV(u, v);
		}

		private var faceVertices:Array = [];

		private function setFaceVertices(vertices:Array, id:int):void
		{
			faceVertices[id] = vertices;
		}

		private var faceUVs:Array = [];

		private function setFaceUVs(uvs:Array, id:int):void
		{
			faceUVs[id] = uvs;
		}

		private var _faceLists:Array = [];

		private function registerFace(id:int):void
		{
			_faceLists.push(id);
		}

		override protected function buildFaces(material:Material):void
		{
			var n:int = -1;
			var i:int;

			_vin = new Vector.<Number>();
			for each (var id:int in _faceLists)
			{
				var length:int = Math.min(faceVertices[id].length, faceUVs[id].length);
				for (i = 0; i < length; i++)
				{
					var vertex:Vector3D = vertexCoords[faceVertices[id][i]];
					_vin.push(vertex.x, vertex.y, vertex.z);
					n++;

					var uv:UV = uvs[faceUVs[id][i]];
					_triangles.uvtData.push(uv.u, uv.v, 1);
				}
				_triangles.indices.push(n - 2, n - 1, n);
			}

			super.buildFaces(material);
		}

		public function ASE(data:* = null, material:Material = null, scale:Number = 1)
		{
			_material = material;
			_scale = scale;

			if (data)
			{
				if (data is ByteArray)
				{
					parse(data, material);
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
				parse(ByteArray(event.target.data), material);
		}
		
		public function parse(data:ByteArray, material:Material):void
		{
			this.material = material;
			
			var lines:Array = unescapeMultiByte(data.toString()).split('\n');
			while (lines.length > 0)
			{
				var parsed:Array = String(lines.shift()).split(/^\s*\*MESH_([^\s]+)\s*([^\s].*)\s+$/);
				if (parsed.length == 4)
				{
					switch (parsed[1])
					{
						case "VERTEX":
							var vertexData:Array = String(parsed[2]).split(/\s+/);
							createVertex(parseFloat(vertexData[1]), -parseFloat(vertexData[2]), parseFloat(vertexData[3]), vertexData[0]);
							break;
						case "FACE":
							var faceData:Array = String(parsed[2]).split(/(\d+)[^\d]+(\d+)[^\d]+(\d+)[^\d]+(\d+)[^\d].*MTLID\s+(\d+)/);
							registerFace(faceData[1]);
							setFaceVertices([faceData[2], faceData[3], faceData[4]], faceData[1]);
							break;
						case "TVERT":
							var uvsData:Array = String(parsed[2]).split(/\s+/);
							createUV(parseFloat(uvsData[1]), parseFloat(uvsData[2]), uvsData[0]);
							break;
						case "TFACE":
							var uvsMapData:Array = String(parsed[2]).split(/\s+/);
							setFaceUVs([uvsMapData[1], uvsMapData[2], uvsMapData[3]], uvsMapData[0]);
							break;
					}
				}
			}

			buildFaces(material);
		}
	}
}