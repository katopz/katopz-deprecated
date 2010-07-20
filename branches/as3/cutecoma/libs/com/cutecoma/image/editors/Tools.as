package com.cutecoma.image.editors
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	public class Tools extends Sprite
	{
		protected var _bitmap:Bitmap;
		protected var _canvas:Sprite;

		protected var _bitmapLayer:BitmapLayer;

		protected var _bitmapRectangle:Rectangle;
		protected var _canvasRectangle:Rectangle;

		public static var isCTRL:Boolean = false;

		public function Tools(bitmapLayer:BitmapLayer, canvas:Sprite)
		{
			this._bitmapLayer = bitmapLayer;

			this._canvas = canvas;
			this.bitmap = bitmapLayer.bitmap;

			bitmapLayer.addEventListener(Event.CHANGE, onBitmapChange);

			addEventListener(Event.ADDED_TO_STAGE, onStage);
		}

		private function onBitmapChange(event:Event):void
		{
			bitmap = _bitmapLayer.bitmap;
		}

		public function get bitmap():Bitmap
		{
			return _bitmap;
		}

		public function set bitmap(value:Bitmap):void
		{
			if (value)
			{
				_bitmap = value;
				_bitmapRectangle = bitmap.getRect(_bitmap.parent);
				_canvasRectangle = _canvas.getRect(_canvas.parent);
				_canvasRectangle.inflate(-6, -6);
			}
		}

		protected function onStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onStage);

			// mouse
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseIsDown);
			stage.addEventListener(Event.MOUSE_LEAVE, onMouseIsLeave);

			// key
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyHandler);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyHandler);
		}

		protected function onMouseIsLeave(event:Event):void
		{
			idle();
		}

		protected function onMouseIsUp(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseIsUp);
			idle();
		}

		protected function onMouseIsDown(event:MouseEvent):void
		{
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseIsUp);
		}

		private function keyHandler(event:KeyboardEvent):void
		{
			isCTRL = event.ctrlKey;
		}

		protected function draw(event:Event = null):void
		{

		}

		protected function idle():void
		{

		}
	}
}