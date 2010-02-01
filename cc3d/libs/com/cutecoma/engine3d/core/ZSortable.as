package com.cutecoma.engine3d.core
{
	import com.cutecoma.engine3d.core.frustum.*;

	import flash.geom.*;

	public interface ZSortable
	{
		public function ZSortable();

		function zSort(param1:Vector3D, param2:Frustum):Vector.<int>;
	}
}