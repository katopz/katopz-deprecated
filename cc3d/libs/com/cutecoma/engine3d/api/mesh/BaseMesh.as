package com.cutecoma.engine3d.api.mesh
{
	import flash.display.*;
	import com.cutecoma.engine3d.api.*;
	import com.cutecoma.engine3d.common.*;
	import com.cutecoma.engine3d.common.bounding.*;
	import com.cutecoma.engine3d.common.vertex.*;
	import com.cutecoma.engine3d.core.bsp.*;

	public class BaseMesh extends Object implements IClonable
	{
		protected const TRIANGLELIST:Number = 1;
		protected var _name:String;
		private var _vertexBuffer:Vector.<Vertex>;
		private var _subsets:Vector.<Vector.<int>>;
		private var _bSphere:BoundingSphere;

		public function BaseMesh(param1:Vector.<Vertex> = null, param2:Vector.<Vector.<int>> = null)
		{
			_subsets = new Vector.<Vector.<int>>;
			_vertexBuffer = param1;
			if (param2 && param2.length)
				_subsets = _subsets.concat(param2);
		}

		public function set name(value:String):void
		{
			_name = value;
		}

		public function set vertexBuffer(value:Vector.<Vertex>):void
		{
			_vertexBuffer = value;
		}

		public function set subsets(value:Vector.<Vector.<int>>):void
		{
			_subsets = value;
		}

		public function set boundingSphere(value:BoundingSphere):void
		{
			_bSphere = value;
		}

		public function get name():String
		{
			return _name;
		}

		public function get vertexBuffer():Vector.<Vertex>
		{
			return _vertexBuffer;
		}

		public function get subsets():Vector.<Vector.<int>>
		{
			return _subsets;
		}

		public function get boundingSphere():BoundingSphere
		{
			return _bSphere;
		}

		public function draw(device:Device, sprite:Sprite = null):void
		{
			var _loc_3:Vector.<int>;
			if (!_vertexBuffer || !_vertexBuffer.length)
				return;

			if (_subsets && _subsets.length != 0)
			{
				for each (_loc_3 in _subsets)
					device.drawPrimitive(this.TRIANGLELIST, _vertexBuffer, _loc_3, BspTree, sprite);
			}
			else
			{
				device.drawPrimitive(this.TRIANGLELIST, _vertexBuffer, null, BspTree, sprite);
			}
		}

		public function clone():IClonable
		{
			var _loc_3:Vertex;
			var _loc_4:Vector.<int>;
			var _loc_1:* = new BaseMesh(new Vector.<Vertex>(_vertexBuffer.length, true));
			var _loc_2:int = 0;
			for each (_loc_3 in _vertexBuffer)
				_loc_1.vertexBuffer[_loc_2++] = _loc_3.clone() as Vertex;

			for each (_loc_4 in _subsets)
				_loc_1.subsets.push(_loc_4.concat());

			return _loc_1 as IClonable;
		}
	}
}