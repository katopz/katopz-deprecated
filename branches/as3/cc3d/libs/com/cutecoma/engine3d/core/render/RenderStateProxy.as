package com.cutecoma.engine3d.core.render
{

	public class RenderStateProxy extends Object
	{
		private var _fillMode:int = 1;
		private var _textureSmoothing:Boolean = false;
		private var _clipping:int = 4;
		private var _ZSorting:int = 2;
		private var _triangleCulling:String = "positive";

		public function RenderStateProxy()
		{

		}

		public function get fillMode():int
		{
			return _fillMode;
		}

		public function get textureSmoothing():Boolean
		{
			return _textureSmoothing;
		}

		public function get clipping():int
		{
			return _clipping;
		}

		public function get zSorting():int
		{
			return _ZSorting;
		}

		public function get triangleCulling():String
		{
			return _triangleCulling;
		}

		public function set fillMode(value:int):void
		{
			_fillMode = value;
		}

		public function set textureSmoothing(value:Boolean):void
		{
			_textureSmoothing = value;
		}

		public function set clipping(value:int):void
		{
			_clipping = value;
		}

		public function set zSorting(value:int):void
		{
			_ZSorting = value;
		}

		public function set triangleCulling(value:String):void
		{
			_triangleCulling = value;
		}
	}
}