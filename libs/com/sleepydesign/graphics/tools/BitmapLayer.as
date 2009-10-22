package com.sleepydesign.graphics.tools
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * Bitmap Layer to place raw bitmap, use for Bitmap editor
	 * @author katopz
	 */	
	public class BitmapLayer extends Sprite
	{
		private var _canvasLayer:Sprite;
		private var _bitmap:Bitmap;
		
		public function get bitmap():Bitmap
		{
			return _bitmap;
		}
		
		public function set bitmap(value:Bitmap):void
		{
			if(_bitmap != value)
			{
				if(_bitmap)
					removeChild(_bitmap);
				_bitmap = value;
				addChild(_bitmap);
				
				_bitmap.x = _canvasLayer.width/2 - _bitmap.width/2;
				_bitmap.y = _canvasLayer.height/2 - _bitmap.height/2;
				
				dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		public function BitmapLayer(canvasLayer:Sprite, bitmap:Bitmap=null)
		{
			if(bitmap)
				this.bitmap = bitmap;
			_canvasLayer = canvasLayer;
			
			graphics.clear();
			graphics.beginFill(0xFFFFFF, 0);
			graphics.drawRect(0, 0, canvasLayer.width, canvasLayer.height);
			graphics.endFill();
		}
	}
}