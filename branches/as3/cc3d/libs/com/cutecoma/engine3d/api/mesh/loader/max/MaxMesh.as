package com.cutecoma.engine3d.api.mesh.loader.max
{
	import flash.geom.*;
	import com.cutecoma.engine3d.common.vertex.*;

	public class MaxMesh extends MaxObject
	{
		protected var _vertices:Vector.<Vertex> = null;
		protected var _indices:Vector.<int> = null;
		protected var _materialName:String = null;
		protected var _mappedFaces:Vector.<int> = null;

		public function MaxMesh(chunk:Chunk)
		{
			super(chunk);
		}

		public function get vertices():Vector.<Vertex>
		{
			return _vertices;
		}

		public function get indices():Vector.<int>
		{
			return _indices;
		}

		public function get materialName():String
		{
			return _materialName;
		}

		public function get mappedFaces():Vector.<int>
		{
			return _mappedFaces;
		}

		override protected function initialize():void
		{
			super.initialize();

			_AFunctions[Chunk.MESH] = enterChunk;
			_AFunctions[Chunk.MESH_VERTICES] = this.parseVertices;
			_AFunctions[Chunk.MESH_INDICES] = this.parseIndices;
			_AFunctions[Chunk.MESH_MAPPING] = this.parseMapping;
			_AFunctions[Chunk.MESH_MATERIAL] = this.parseMaterial;
		}

		protected function parseVertices(chunk:Chunk):void
		{
			var _loc_5:Number;
			var _loc_6:Number;
			var _loc_7:Number;
			var _loc_8:Vector3D = null;
			var _loc_2:* = chunk.data;
			var _loc_3:* = _loc_2.readUnsignedShort();
			_vertices = new Vector.<Vertex>(_loc_3, true);
			var _loc_4:int = 0;
			while (_loc_4 < _loc_3)
			{
				_loc_5 = _loc_2.readFloat();
				_loc_6 = _loc_2.readFloat();
				_loc_7 = _loc_2.readFloat();
				_loc_8 = new Vector3D(_loc_5, _loc_6, _loc_7);
				_loc_8 = Max3DS.TRANSFORM.transformVector(_loc_8);
				_vertices[_loc_4] = new Vertex(_loc_8.x, _loc_8.y, _loc_8.z);
				_loc_4++;
			}
		}

		protected function parseIndices(chunk:Chunk):void
		{
			var _loc_2:* = chunk.data;
			var _loc_3:* = _loc_2.readUnsignedShort();
			_indices = new Vector.<int>(_loc_3 * 3, true);
			var _loc_4:int = 0;
			var _loc_5:int = 0;
			while (_loc_4 < _loc_3)
			{
				_indices[_loc_5] = _loc_2.readUnsignedShort();
				_indices[int(_loc_5 + 1)] = _loc_2.readUnsignedShort();
				_indices[int(_loc_5 + 2)] = _loc_2.readUnsignedShort();
				_loc_2.position = _loc_2.position + 2;
				_loc_4++;
				_loc_5 = _loc_5 + 3;
			}
		}

		protected function parseMapping(chunk:Chunk):void
		{
			var _loc_2:* = chunk.data;
			var _loc_3:* = _loc_2.readUnsignedShort();
			var _loc_4:int = 0;
			while (_loc_4 < _loc_3)
			{
				this.vertices[_loc_4].u = _loc_2.readFloat();
				this.vertices[_loc_4].v = 1 - _loc_2.readFloat();
				_loc_4++;
			}
		}

		protected function parseMaterial(chunk:Chunk):void
		{
			var _loc_2:* = chunk.data;
			var _loc_3:int = 0;
			_materialName = chunk.readString();
			_loc_3 = _loc_2.readUnsignedShort();
			_mappedFaces = new Vector.<int>(_loc_3, true);
			var _loc_4:int = 0;
			while (_loc_4 < _loc_3)
			{
				_mappedFaces[_loc_4] = _loc_2.readUnsignedShort();
				_loc_4++;
			}
		}

		override protected function finalize():void
		{
			var _loc_2:Vertex = null;
			var _loc_3:int = 0;
			var _loc_4:int = 0;
			var _loc_5:int = 0;
			var _loc_6:Vertex = null;
			var _loc_7:Vertex = null;
			var _loc_8:Vertex = null;
			var _loc_9:Vector3D = null;
			super.finalize();
			var _loc_1:int = 0;
			while (_loc_1 < _indices.length)
			{
				_loc_3 = _indices[_loc_1];
				_loc_4 = _indices[int(_loc_1 + 1)];
				_loc_5 = _indices[int(_loc_1 + 2)];
				_loc_6 = _vertices[_loc_3];
				_loc_7 = _vertices[_loc_4];
				_loc_8 = _vertices[_loc_5];
				_loc_9 = _loc_6.subtract(_loc_8).crossProduct(_loc_6.subtract(_loc_7));
				_loc_6.nx = _loc_6.nx + _loc_9.x;
				_loc_6.ny = _loc_6.ny + _loc_9.y;
				_loc_6.nz = _loc_6.nz + _loc_9.z;
				_loc_7.nx = _loc_7.nx + _loc_9.x;
				_loc_7.ny = _loc_7.ny + _loc_9.y;
				_loc_7.nz = _loc_7.nz + _loc_9.z;
				_loc_7.nx = _loc_7.nx + _loc_9.x;
				_loc_7.ny = _loc_7.ny + _loc_9.y;
				_loc_7.nz = _loc_7.nz + _loc_9.z;
				_loc_1 = _loc_1 + 3;
			}
			for each (_loc_2 in _vertices)
			{
				_loc_9 = new Vector3D(_loc_2.nx, _loc_2.ny, _loc_2.nz);
				_loc_9.normalize();
				_loc_2.nx = -_loc_9.x;
				_loc_2.ny = -_loc_9.y;
				_loc_2.nz = -_loc_9.z;
			}
		}
	}
}