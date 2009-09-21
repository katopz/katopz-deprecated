package away3dlite.primitives{	import away3dlite.arcane;	import away3dlite.core.base.Mesh;
	import away3dlite.loaders.data.FaceData;
	import away3dlite.materials.Material;
	
	import flash.geom.Vector3D;
		use namespace arcane;	
	/**	 * Cube	 * @author katopz	 */	public class SimpleCube extends Mesh	{		public function SimpleCube(size:Number=100, material:Material = null ) 		{			size = size/2;						var v0:Vector3D = new Vector3D(size, size, size);			var v1:Vector3D = new Vector3D(-size, size, size);			var v2:Vector3D = new Vector3D(-size, -size, size);			var v3:Vector3D = new Vector3D(size, -size, size);			var v4:Vector3D = new Vector3D(size, size, -size);			var v5:Vector3D = new Vector3D(-size, size, -size);			var v6:Vector3D = new Vector3D(-size, -size, -size);			var v7:Vector3D = new Vector3D(size, -size, -size);						// 8 vertices			var vertices:Vector.<Vector3D> = new Vector.<Vector3D>();			vertices.push(v0);			vertices.push(v1);						vertices.push(v2);			vertices.push(v3);						vertices.push(v4);			vertices.push(v5);						vertices.push(v6);			vertices.push(v7);						// front			var faceDatas:Vector.<FaceData> = new Vector.<FaceData>();			faceDatas.push( new FaceData(0, 2, 1, vertices, Vector.<UV>([new UV(0, 0), new UV(1, 1), new UV(1, 0)])));			faceDatas.push( new FaceData(0, 3, 2, vertices, Vector.<UV>([new UV(0, 0), new UV(0, 1), new UV(1, 1)])));						// top			faceDatas.push( new FaceData(0, 1, 5, vertices, Vector.<UV>([new UV(0, 0), new UV(1, 0), new UV(1, 1)])));			faceDatas.push( new FaceData(0, 5, 4, vertices, Vector.<UV>([new UV(0, 0), new UV(1, 1), new UV(0, 1)])));						// back			faceDatas.push( new FaceData(4, 5, 6, vertices, Vector.<UV>([new UV(0, 0), new UV(0, 1), new UV(1, 1)])));			faceDatas.push( new FaceData(4, 6, 7, vertices, Vector.<UV>([new UV(0, 0), new UV(1, 1), new UV(1, 0)])));						// bottom			faceDatas.push( new FaceData(3, 6, 2, vertices, Vector.<UV>([new UV(0, 0), new UV(1, 1), new UV(1, 0)])));			faceDatas.push( new FaceData(3, 7, 6, vertices, Vector.<UV>([new UV(0, 0), new UV(0, 1), new UV(1, 1)])));						// right			faceDatas.push( new FaceData(1, 6, 5, vertices, Vector.<UV>([new UV(0, 0), new UV(1, 1), new UV(0, 1)])));			faceDatas.push( new FaceData(1, 2, 6, vertices, Vector.<UV>([new UV(0, 0), new UV(1, 0), new UV(1, 1)])));						// left			faceDatas.push( new FaceData(4, 3, 0, vertices, Vector.<UV>([new UV(0, 0), new UV(1, 1), new UV(0, 1)])));			faceDatas.push( new FaceData(4, 7, 3, vertices, Vector.<UV>([new UV(0, 0), new UV(1, 0), new UV(1, 1)])));						// uvtData			var n:int = -1;			for each (var face:FaceData in faceDatas)			{				_vertices.push(vertices[face.a].x, vertices[face.a].y, vertices[face.a].z);				_vertices.push(vertices[face.b].x, vertices[face.b].y, vertices[face.b].z);				_vertices.push(vertices[face.c].x, vertices[face.c].y, vertices[face.c].z);								_uvtData.push(face.uvMap[0].u, face.uvMap[0].v, 1);				_uvtData.push(face.uvMap[1].u, face.uvMap[1].v, 1);				_uvtData.push(face.uvMap[2].u, face.uvMap[2].v, 1);				n += 3;				_indices.push(n, n - 1, n - 2);			}						this.material = material;						buildFaces();		}	}}import flash.geom.Vector3D;internal class FaceData{	public var a:uint;	public var b:uint;	public var c:uint;	public var v0:Vector3D;	public var v1:Vector3D;	public var v2:Vector3D;		public var uvMap:Vector.<UV>;	public function FaceData(a:uint, b:uint, c:uint, v:Vector.<Vector3D>, uvMap:Vector.<UV> = null)	{		this.a = a;		this.b = b;		this.c = c;		this.v0 = v[a];		this.v1 = v[b];		this.v2 = v[c];		this.uvMap = uvMap;	}}	internal class UV	{		public var u:Number;		public var v:Number;		public function UV(u:Number = 0, v:Number = 0)		{			this.u = u;			this.v = v;		}		public function toString():String		{			return "UV: " + u + "/" + v;		}		public function clone():UV		{			return new UV(u, v);		}	}