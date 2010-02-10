package com.cutecoma.engine3d.api.mesh.shape
{
	import com.cutecoma.engine3d.api.mesh.*;
	import com.cutecoma.engine3d.common.vertex.*;

	public class Triangle extends BaseMesh
	{
		public function Triangle()
		{
			var _loc_1:* = Vector.<Vertex>([new Vertex(0, 0, 0.5, 1, 0, 0, -1, 0), new Vertex(0.5, 0, -0.5, 1, 1, 0, -1, 0), new Vertex(-0.5, 0, -0.5, 0, 1, 0, -1, 0)]);
			var _loc_2:* = Vector.<int>([0, 2, 1]);
			super(_loc_1, Vector.<Vector.<int>>([_loc_2]));
		}
	}
}