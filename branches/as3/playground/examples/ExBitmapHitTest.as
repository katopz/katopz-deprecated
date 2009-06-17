package examples
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	[SWF(backgroundColor="0xFFFFFF", frameRate="30", width="800", height="600")]
	public class ExBitmapHitTest extends Sprite
	{
		public function ExBitmapHitTest()
		{
			var bitmapData:BitmapData = new BitmapData(40, 40, true, 0xFFFFFFFF);
			var circle1:Shape = new Shape();
			circle1.graphics.beginFill(0x000000);
			circle1.graphics.drawRect(5,5,10,10);
			circle1.graphics.drawRect(30,30,10,10);
			
			circle1.graphics.beginFill(0xFF0000);
			circle1.graphics.drawRect(20,20,10,10);
			
			circle1.graphics.endFill();
			bitmapData.draw(circle1);
			
			var pathBitmapData:BitmapData = new BitmapData(40, 40, true, 0x00000000);
			var hitBitmapData:BitmapData = new BitmapData(40, 40, true, 0x00000000);
			
			var line:Shape = new Shape();
			line.graphics.lineStyle(2,0xFFFFFF,1);
			line.graphics.moveTo(0,0);
			line.graphics.lineTo(20,20);
			line.graphics.endFill();
			pathBitmapData.draw(line);
			
			var pt:Point = new Point(0, 0);
			
			//remove non black color
			//bitmapData.threshold(bitmapData, bitmapData.rect, pt, "<", 0xFFFFFFFF, 0x00000000, 0xFFFFFFFF, false);
			//bitmapData.threshold(bitmapData, bitmapData.rect, pt, "==", 0xFF000000, 0x00000000, 0xFFFFFFFF, false);
	bitmapData.threshold(bitmapData, bitmapData.rect, pt, ">", 0xFF000000, 0x00000000, 0xFFFFFFFF, false);
			//bitmapData.threshold(bitmapData, bitmapData.rect, pt, "==", 0xFF0000, 0x00000000, 0xFFFFFFFF, false);
			
			hitBitmapData.copyPixels(bitmapData, bitmapData.rect, pt, pathBitmapData, pt);
			
			//trace(hitBitmapData.getColorBoundsRect(0xFF000000, 0xFF000000, false))
			trace("++"+hitBitmapData.getColorBoundsRect(0xFF000000, 0xFF000000, true))
			/*
			trace(hitBitmapData.getColorBoundsRect(0x000000, 0xFFFFFF, false))
			trace(hitBitmapData.getColorBoundsRect(0xFFFFFF, 0xFFFFFF, false))
			trace(hitBitmapData.getColorBoundsRect(0xFFFFFF, 0x000000, false))
			*/
			//trace(hitBitmapData.rect)
			trace(hitBitmapData.rect.isEmpty())
			
			var bm1:Bitmap = new Bitmap(bitmapData);
			this.addChild(bm1);
			
			var bm2:Bitmap = new Bitmap(pathBitmapData);
			this.addChild(bm2);
			
			bm2.x = 40;
			
			var bm3:Bitmap = new Bitmap(hitBitmapData);
			this.addChild(bm3);
			
			bm3.x = 80;
			
		}
	}
}
