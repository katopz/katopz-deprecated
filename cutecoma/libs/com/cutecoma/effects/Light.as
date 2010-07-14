package com.cutecoma.effects
{
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.geom.Matrix;

	public class Light extends Shape
	{
		private static var center:uint = 3;
		private static var light:uint = 15;
		private static var color:uint = 0xFFFFFF;

		public function Light()
		{
			draw();
		}

		private function draw():void
		{
			graphics.beginFill(color);
			graphics.drawCircle(0, 0, center);
			graphics.endFill();
			var colors:Array = [color, color];
			var alphas:Array = [0.6, 0];
			var ratios:Array = [0, 255];
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(light * 2, light * 2, 0, -light, -light);
			graphics.beginGradientFill(GradientType.RADIAL, colors, alphas, ratios, matrix);
			graphics.drawCircle(0, 0, light);
			graphics.endFill();
		}
	}
}