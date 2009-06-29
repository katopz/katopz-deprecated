package open3d.objects{	import flash.geom.Vector3D;
	
	import open3d.data.FaceData;
	import open3d.geom.UV;
	import open3d.materials.Material;	/**	 * Cube	 * @author katopz	 */	public class Cube extends Mesh	{		public function Cube(size:Number=100, material:Material = null ) 		{			var v0:Vector3D = new Vector3D(-size, -size, -size);			var v1:Vector3D = new Vector3D(size, -size, -size);			var v2:Vector3D = new Vector3D(size, size, -size);			var v3:Vector3D = new Vector3D(-size, size, -size);			var v4:Vector3D = new Vector3D(-size, -size, size);			var v5:Vector3D = new Vector3D(size, -size, size);			var v6:Vector3D = new Vector3D(size, size, size);			var v7:Vector3D = new Vector3D(-size, size, size);						// 8 vertices			var vertices:Array = [];			vertices.push(v0);			vertices.push(v1);						vertices.push(v2);			vertices.push(v3);						vertices.push(v4);			vertices.push(v5);						vertices.push(v6);			vertices.push(v7);						// front			var faceDatas:Vector.<FaceData> = new Vector.<FaceData>();			faceDatas.push( new FaceData(0, 2, 1, v0, v2, v1, [new UV(0, 0), new UV(1, 1), new UV(1, 0)]));			faceDatas.push( new FaceData(0, 3, 2, v0, v3, v2, [new UV(0, 0), new UV(0, 1), new UV(1, 1)]));						// top			faceDatas.push( new FaceData(0, 1, 5, v0, v1, v5,[new UV(0, 0), new UV(1, 0), new UV(1, 1)]));			faceDatas.push( new FaceData(0, 5, 4, v0, v5, v4,[new UV(0, 0), new UV(1, 1), new UV(0, 1)]));			// back			faceDatas.push( new FaceData(4, 5, 6, v4, v5, v6,[new UV(0, 0), new UV(0, 1), new UV(1, 1)]));			faceDatas.push( new FaceData(4, 6, 7, v4, v6, v7,[new UV(0, 0), new UV(1, 1), new UV(1, 0)]));			// bottom			faceDatas.push( new FaceData(3, 6, 2, v3, v6, v2,[new UV(0, 0), new UV(1, 1), new UV(1, 0)]));			faceDatas.push( new FaceData(3, 7, 6, v3, v7, v6,[new UV(0, 0), new UV(0, 1), new UV(1, 1)]));			// right			faceDatas.push( new FaceData(1, 6, 5, v1, v6, v5,[new UV(0, 0), new UV(1, 1), new UV(0, 1)]));			faceDatas.push( new FaceData(1, 2, 6, v1, v2, v6,[new UV(0, 0), new UV(1, 0), new UV(1, 1)]));			// left			faceDatas.push( new FaceData(4, 3, 0, v4, v3, v0,[new UV(0, 0), new UV(1, 1), new UV(0, 1)]));			faceDatas.push( new FaceData(4, 7, 3, v4, v7, v3,[new UV(0, 0), new UV(1, 0), new UV(1, 1)]));						// uvtData			var n:int = -1;			for each (var face:FaceData in faceDatas)			{				_vin.push(vertices[face.a].x, vertices[face.a].y, vertices[face.a].z);				_vin.push(vertices[face.b].x, vertices[face.b].y, vertices[face.b].z);				_vin.push(vertices[face.c].x, vertices[face.c].y, vertices[face.c].z);								_triangles.uvtData.push(face.uvMap[0].u, face.uvMap[0].v, 1);				_triangles.uvtData.push(face.uvMap[1].u, face.uvMap[1].v, 1);				_triangles.uvtData.push(face.uvMap[2].u, face.uvMap[2].v, 1);				n += 3;				_triangles.indices.push(n - 2, n - 1, n);			}						buildFaces(material);		}	}}