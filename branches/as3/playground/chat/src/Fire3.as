package
{
	import flash.display.*;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.filters.DisplacementMapFilter;
	import flash.filters.DisplacementMapFilterMode;
	import flash.geom.Matrix;
	import flash.geom.Point;

	[SWF(backgroundColor="#000000", frameRate="30", width="800", height="600")]
	public class Fire3 extends Sprite
	{
		private var perlinNoiseBitmap:BitmapData = new BitmapData(100, 100, true, 0);
		private var displacementMapBitmap:BitmapData = new BitmapData(100, 100, true, 0);

		private var factor:Number = 6;
		private var fireStrength:Number = 30;

		private var noiseOffsets:Array = [];
		private var noiseOffsetDeltas:Array = [];

		private var rnd:Number = Math.floor(Math.random() * 10);
		private var sampleSize:Number = 50;

		private var container:Sprite;
		private var bitmap:Bitmap;

		private var filter:DisplacementMapFilter;

		public function Fire3()
		{
			createGradientFire(container = new Sprite);
			addChild(container);

			container.x = container.width / 2;
			container.y = container.height;

			/*
			   var _mask:Sprite = new Sprite;
			   container.mask = _mask;
			   createEggMask(_mask);
			 */

			var bitmapData:BitmapData = new BitmapData(100, 100, true, 0x00000000);
			bitmapData.draw(container, container.transform.matrix);

			bitmap = new Bitmap(bitmapData);
			addChild(bitmap);
			bitmap.y = 150;
			//bitmap.blendMode = BlendMode.ADD;

			var i:int = 0;
			while (i < 3)
			{
				noiseOffsetDeltas[i] = new Point(Math.random() * (factor / 4) - factor / 8, Math.random() * (factor / 4) + factor / 4 * 3);
				noiseOffsets[i] = new Point(0, 0);
				i++;
			}

			noiseOffsetDeltas[0].x = noiseOffsetDeltas[0].x / 3;

			filter = new DisplacementMapFilter(perlinNoiseBitmap, new Point(0, 0), 1, 1, 10, fireStrength, DisplacementMapFilterMode.CLAMP, 0);

			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		private function createGradientFire(target:Sprite, w:Number = 100, h:Number = 100):void
		{
			var colors:Array = [0xFF0000, 0x990000, 0xFF9900, 0xFFFF66, 0xFFFFFF, 0xFFFFFF];
			var alphas:Array = [1, 1, 1, 1, 1, 1];
			var ratios:Array = [25, 51, 127, 204, 229, 255];
			var matrix:Matrix = new Matrix();

			matrix.createGradientBox(w, -h, -0.5 * Math.PI, 0, 0);
			target.graphics.clear();
			target.graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, matrix, SpreadMethod.PAD, InterpolationMethod.RGB, 0.75);
			target.graphics.drawRect(-w * 0.5, -h + 20, w, h);
			target.graphics.endFill();
		}

		private function createEggMask(target:Sprite, w:Number = 100, h:Number = 100):void
		{
			target.graphics.clear();
			target.graphics.beginFill(0xFFFFFF);
			target.graphics.moveTo(-w * 0.5, -h * 0.2);
			target.graphics.curveTo(-w * 0.4, -h, 0, -h);
			target.graphics.curveTo(w * 0.4, -h, w * 0.5, -h * 0.2);
			target.graphics.curveTo(w * 0.5, 0, 0, 0);
			target.graphics.curveTo(-w * 0.5, 0, -w * 0.5, -h * 0.2);
			target.graphics.endFill();
		}

		private function onEnterFrame(event:Event):void
		{
			var i:int = 0;
			while (i < 3)
			{
				noiseOffsets[i].x = noiseOffsets[i].x + noiseOffsetDeltas[i].x;
				noiseOffsets[i].y = noiseOffsets[i].y + noiseOffsetDeltas[i].y;
				i++;
			}

			perlinNoiseBitmap.perlinNoise(sampleSize / 2, sampleSize, 3, rnd, false, true, 1, true, noiseOffsets);
			container.filters = [filter];
			bitmap.filters = [filter, new BlurFilter(0, 16)];
		}
	}
}