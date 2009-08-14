package com.si3d.objects
{
	import flash.display.*;
	import flash.filters.ConvolutionFilter;
	import flash.geom.*;

	public class Landscape extends Bitmap
	{
		// This color gradation is refered from psyrak's BumpyPlanet
		// http://wonderfl.kayac.com/code/d79cd85845773958620f42cb3e6cb363c2020c73
		public var gradation:*={color: [0x000080, 0x0066ff, 0xcc9933, 0x00cc00, 0x996600, 0xffffff], alpha: [100, 100, 100, 100, 100, 100], ratio: [0, 96, 96, 128, 168, 192]};
		public var pixels:BitmapData, texture:BitmapData, rect:Rectangle;

		function Landscape(w:int, h:int)
		{
			texture=new BitmapData(w * 2, h * 2, false, 0);
			pixels=new BitmapData(w, h, false, 0);
			rect=new Rectangle(0, 0, w, h);
			super(pixels);

			// height map
			var hmap:BitmapData=new BitmapData(w, h, false, 0);
			hmap.perlinNoise(w * 0.5, h * 0.5, 10, Math.random() * 0xffffffff, true, false, 0, true);
			hmap.colorTransform(hmap.rect, new ColorTransform(1.5, 1.5, 1.5, 1, -64, -64, -64, 0));

			// texture
			var mapR:Array=new Array(256), mapG:Array=new Array(256), mapB:Array=new Array(256);
			var gmap:BitmapData=new BitmapData(256, 1, false, 0), render:Shape=new Shape(), mat:Matrix=new Matrix();
			mat.createGradientBox(256, 1, 0, 0, 0);
			render.graphics.clear();
			render.graphics.beginGradientFill("linear", gradation.color, gradation.alpha, gradation.ratio, mat);
			render.graphics.drawRect(0, 0, 256, 1);
			render.graphics.endFill();
			gmap.draw(render);
			for (var i:int=0; i < 256; ++i)
			{
				var col:uint=gmap.getPixel(i, 0);
				mapR[i]=col & 0xff0000;
				mapG[i]=col & 0x00ff00;
				mapB[i]=col & 0x0000ff;
			}
			gmap.dispose();
			mat.identity();
			texture.paletteMap(hmap, hmap.rect, hmap.rect.topLeft, mapR, mapG, mapB);

			// shading
			var smap:BitmapData=new BitmapData(w, h, false, 0);
			smap.applyFilter(hmap, hmap.rect, hmap.rect.topLeft, new ConvolutionFilter(3, 3, [-1, -1, 0, -1, 0, 1, 0, 1, 1], 1, 0, true, true));
			texture.draw(smap, null, new ColorTransform(4, 4, 4, 1, 160, 160, 160, 0), "multiply");

			// copy 2x2
			pt.x=w;
			pt.y=h;
			texture.copyPixels(texture, hmap.rect, pt);
			pt.x=0;
			pt.y=h;
			texture.copyPixels(texture, hmap.rect, pt);
			pt.x=w;
			pt.y=0;
			texture.copyPixels(texture, hmap.rect, pt);
			pt.x=0;
			pt.y=0;
		}

		private var pt:Point=new Point();

		public function update(_globalVel:*):void
		{
			rect.x=(int(rect.x - _globalVel.x)) & (pixels.width - 1);
			rect.y=(int(rect.y - _globalVel.z)) & (pixels.height - 1);
			pixels.copyPixels(texture, rect, pt);
		}
	}
}