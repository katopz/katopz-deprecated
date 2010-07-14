package com.cutecoma.effects
{
	import flash.display.BitmapData;
	import flash.display.IBitmapDrawable;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class DetectPixels
	{
		private var bd:IBitmapDrawable;
		private var rect:Rectangle;
		private var map:BitmapData;
		private var mapList:Array;
		private var accuracy:uint;
		private var threshold:uint = 0x80FFFFFF;

		public function DetectPixels(a:uint = 1)
		{
			accuracy = a;
		}

		public function search(t:IBitmapDrawable, r:Rectangle, th:uint = 0x80FFFFFF):void
		{
			bd = t;
			rect = r;
			threshold = th;
			var w:uint = rect.width / accuracy;
			var h:uint = rect.height / accuracy;
			detect(w, h);
		}

		private function detect(w:uint, h:uint):void
		{
			map = new BitmapData(w, h, true, 0x00000000);
			var matrix:Matrix = new Matrix();
			matrix.scale(1 / accuracy, 1 / accuracy);
			map.lock();
			map.draw(bd, matrix);
			map.unlock();
			mapList = [];
			for (var x:uint = 0; x < w; x++)
			{
				for (var y:uint = 0; y < h; y++)
				{
					var color:uint = map.getPixel32(x, y);
					if (color >= threshold)
					{
						var px:int = x * accuracy + rect.x;
						var py:int = y * accuracy + rect.y;
						var point:Point = new Point(px, py);
						mapList.push(point);
					}
				}
			}
		}

		public function pixels():Array
		{
			return mapList;
		}
	}
}