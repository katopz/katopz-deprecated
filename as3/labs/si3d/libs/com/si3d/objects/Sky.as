package com.si3d.objects
{
	import __AS3__.vec.Vector;

	import flash.display.*;
	import flash.geom.*;

	public class Sky extends Shape
	{
		// This color gradation is refered from nemu90kWw's 水平線
		// http://wonderfl.kayac.com/code/2b527a2efe155b7f69330822a3c7f7733ab6ea7e
		public var gradation:*={color: [0x103860, 0x4070B8, 0x60B0E0, 0xD0F0F0, 0x0033c0, 0x0033c0], alpha: [100, 100, 100, 100, 100, 0], ratio: [0, 128, 192, 216, 224, 255]};

		function Sky()
		{
			var mat:Matrix=new Matrix();
			mat.createGradientBox(700, 380, Math.PI / 2);
			graphics.beginGradientFill("linear", gradation.color, gradation.alpha, gradation.ratio, mat);
			graphics.drawRect(0, 0, 700, 380);
			graphics.endFill();
		}
	}
}