package com.cutecoma.engine3d.api.texture
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.net.*;
	import flash.utils.*;

	public class TexturePool extends Texture
	{
		protected var _order:Dictionary;
		protected var _SampleSize:int = 128;

		public function TexturePool(... args)
		{
			var _loc_5:String;
			var _loc_6:Loader;
			var _loc_2:* = args[0] is Array ? (args[0]) : (args);
			var _loc_3:int = 0;
			var _loc_4:* = new BitmapData(_SampleSize * _loc_2.length, _SampleSize);
			_bitmap = new Bitmap(_loc_4);
			_order = new Dictionary();
			for each (_loc_5 in _loc_2)
			{
				_loc_6 = new Loader();
				_order[_loc_6] = _loc_3++;
				_loc_6.contentLoaderInfo.addEventListener(Event.COMPLETE, this.onComplete);
				_loc_6.load(new URLRequest(_loc_5));
			}
		}

		protected function onComplete(event:Event):void
		{
			var _loc_2:* = event.target as LoaderInfo;
			var _loc_3:* = event.target.content.bitmapData;
			var _loc_4:* = _SampleSize / _loc_3.width;
			var _loc_5:* = _SampleSize / _loc_3.height;
			var _loc_6:* = new Matrix();
			new Matrix().scale(_loc_4, _loc_5);
			_loc_6.translate(_order[_loc_2.loader] * _SampleSize, 0);
			_bitmap.bitmapData.draw(_loc_3, _loc_6);
		}
	}
}