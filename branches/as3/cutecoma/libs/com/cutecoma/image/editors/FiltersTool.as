package com.cutecoma.image.editors
{
	import de.popforge.imageprocessing.capture.ICaptureDevice;
	import de.popforge.imageprocessing.capture.WebCam;
	import de.popforge.imageprocessing.core.Histogram;
	import de.popforge.imageprocessing.core.Image;
	import de.popforge.imageprocessing.core.ImageFormat;
	import de.popforge.imageprocessing.filters.*;
	import de.popforge.imageprocessing.filters.binarization.*;
	import de.popforge.imageprocessing.filters.color.*;
	import de.popforge.imageprocessing.filters.convolution.*;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getTimer;

	public class FiltersTool extends Sprite
	{
		private var _bitmap:Bitmap; // = new SampleBitmap as Bitmap;

		//-- test environment
		private const imageFormat:int = ImageFormat.RGB;
		private const showHistograms:Boolean = false;
		private var queue:FilterQueue;

		//-- display stuff
		private var image:Image;
		private var screen:BitmapData;
		private var screenBitmap:Bitmap;
		private var translate:Matrix;

		// option, TODO separate filter
		private var _level:LevelsCorrection; // = new LevelsCorrection(false);
		private var _bright:BrightnessCorrection; // = new BrightnessCorrection(0, false);

		public function FiltersTool()
		{
			
		}

		public function set bitmap(value:Bitmap):void
		{
			if (_bitmap == value)
				return;
				
			_bitmap = value;

			screen = new BitmapData(_bitmap.width, _bitmap.height << 1, false, 0);
			image = new Image(_bitmap.width, _bitmap.height, imageFormat);
			translate = new Matrix();
			Histogram.DETAIL = 4;

			_level = new LevelsCorrection(false);
			_bright = new BrightnessCorrection(0, false);

			var _gamma:Number = 1;
			var _from:Number = 0;
			var _to:Number = 255;

			_level.automatic = false;
			// shadow input level
			_level.from = [_from, _from, _from];
			// hilight input level
			_level.to = [_to, _to, _to];
			// midtone inpupt level
			_level.gamma = [_gamma, _gamma, _gamma];

			// queue
			queue = new FilterQueue();
			queue.addFilter(_level);
			queue.addFilter(_bright);
		}

		public function setBrightness(bitmapData:BitmapData, brightness:Number):BitmapData
		{
			_bright.brightness = brightness;

			image.loadBitmapData(bitmapData, true);

			//-- draw original image
			image.render(screen);

			//-- apply filter queue
			queue.apply(image);

			//-- draw resulting image
			translate.identity();
			translate.translate(0, _bitmap.height);

			return image.bitmapData;
		}

		public function setGamma(bitmapData:BitmapData, gamma:Number):BitmapData
		{
			var _gamma:Number = gamma;
			//var _from:Number = 0;
			//var _to:Number = 255;

			if (_gamma < 0.3)
				_gamma = 0.3;

			if (_gamma > 3)
				_gamma = 3;

			//_level.automatic = false;
			// shadow input level
			//_level.from = [_from, _from, _from];
			// hilight input level
			//_level.to = [_to, _to, _to];
			// midtone inpupt level
			_level.gamma = [_gamma, _gamma, _gamma];

			image.loadBitmapData(bitmapData, true);

			//-- draw original image
			image.render(screen);

			//-- apply filter queue
			queue.apply(image);

			//-- draw resulting image
			translate.identity();
			translate.translate(0, _bitmap.height);

			return image.bitmapData;
		}
	}
}
