package com.cutecoma.engine3d.core.frustum
{
	import com.cutecoma.engine3d.common.math.*;
	import com.cutecoma.engine3d.core.signal.*;
	import com.cutecoma.engine3d.core.transform.*;

	public class Frustum extends Object
	{
		private var _pNear:Plane;
		private static const EPSILON:Number = 0.001;

		public function Frustum(param1:TransformProxy)
		{
			_pNear = new Plane();
			param1.addSignalListener(TransformSignal.PROJECTION_UPDATE, this.projectionUpdateHandler);
		}

		public function get nearPlane():Plane
		{
			return _pNear;
		}

		private function projectionUpdateHandler(param1:TransformSignal):void
		{
			var _loc_2:* = param1.transform.rawData;
			_pNear.x = _loc_2[2];
			_pNear.y = _loc_2[6];
			_pNear.z = _loc_2[10];
			_pNear.w = _loc_2[14];
		}
	}
}