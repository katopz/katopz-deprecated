package com.cutecoma.engine3d.api.mesh.shape
{
	import flash.display.*;
	import com.cutecoma.engine3d.api.*;
	import com.cutecoma.engine3d.api.mesh.*;
	import com.cutecoma.engine3d.common.vertex.*;

	public class Sphere extends BaseMesh
	{
		public function Sphere(segmentH:int = 16, segmentV:int = 16)
		{
			init(segmentH, segmentV);
		}

		private function init(segmentH:int = 16, segmentV:int = 16):void
		{
			var _loc_6:Number;
			var _loc_7:int = 0;
			var _loc_8:Number;
			var _loc_9:Number;
			var _loc_10:Number;
			var _loc_11:Number;
			var _loc_12:Number;
			var _loc_13:Number;
			var _loc_14:Vertex;
			var _loc_3:int = 0;
			var _loc_4:* = new Vector.<int>;
			vertexBuffer = new Vector.<Vertex>;
			var _loc_5:int = 0;
			
			while (_loc_5 != segmentH)
			{
				_loc_6 = _loc_5 / (segmentH - 1) * Math.PI * 2;
				_loc_7 = 0;
				while (_loc_7 != segmentV)
				{
					_loc_8 = (_loc_7 / (segmentV - 1) - 0.5) * Math.PI;
					_loc_9 = Math.cos(_loc_8) * Math.cos(_loc_6);
					_loc_10 = -Math.sin(_loc_8);
					_loc_11 = Math.cos(_loc_8) * Math.sin(_loc_6);
					_loc_12 = _loc_5 / (segmentH - 1);
					_loc_13 = _loc_7 / (segmentV - 1);
					_loc_14 = new Vertex(_loc_9, _loc_10, _loc_11, _loc_12, _loc_13, _loc_9, _loc_10, _loc_11);
					vertexBuffer.push(_loc_14);
					_loc_7++;
				}
				_loc_5++;
			}
			subsets.push(_loc_4);
			_loc_5 = 0;
			while (_loc_5 != segmentH - 1)
			{
				_loc_7 = 0;
				while (_loc_7 != segmentV - 1)
				{
					_loc_4.push(_loc_3 + 1, _loc_3 + segmentV + 1, _loc_3, _loc_3, _loc_3 + segmentV + 1, _loc_3 + segmentV);
					_loc_7++;
					_loc_3++;
				}
				_loc_5++;
				_loc_3++;
			}
		}

		override public function draw(device:Device, sprite:Sprite = null):void
		{
			super.draw(device, sprite);
		}
	}
}