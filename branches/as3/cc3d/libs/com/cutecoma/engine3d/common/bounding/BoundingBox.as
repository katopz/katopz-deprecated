package com.cutecoma.engine3d.common.bounding
{
	import flash.geom.*;

	public class BoundingBox extends Object
	{
		private var _Min:Vector3D;
		private var _Max:Vector3D;

		public function BoundingBox(param1:Vector3D, param2:Vector3D)
		{
			_Min = param1;
			_Max = param2;
		}

		public function get min():Vector3D
		{
			return _Min;
		}

		public function get max():Vector3D
		{
			return _Max;
		}
	}
}