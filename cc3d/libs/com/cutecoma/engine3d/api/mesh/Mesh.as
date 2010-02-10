package com.cutecoma.engine3d.api.mesh
{
	import com.cutecoma.engine3d.api.mesh.loader.max.*;
	import com.cutecoma.engine3d.api.mesh.shape.*;
	import com.cutecoma.engine3d.common.vertex.Vertex;

	public class Mesh extends BaseMesh
	{
		public static const CUBE:BaseMesh = new Cube();
		public static const SQUARE:BaseMesh = new Square();
		public static const TRIANGLE:BaseMesh = new Triangle();
		public static const SPHERE:BaseMesh = new Sphere();

		public function Mesh(param1:Vector.<Vertex> = null, param2:Vector.<Vector.<int>> = null)
		{
			super(param1, param2);
		}

		public static function fromAsset(param1:Class):Mesh
		{
			var _loc_2:* = new Max3DSLoader();
			var _loc_3:BaseMesh;
			_loc_2.loadAsset(param1);
			_loc_3 = _loc_2.max3DS.mesh;
			return new Mesh(_loc_3.vertexBuffer, _loc_3.subsets);
		}
	}
}