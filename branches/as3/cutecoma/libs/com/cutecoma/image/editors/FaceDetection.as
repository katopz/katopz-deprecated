package com.cutecoma.image.editors
{
	import com.sleepydesign.events.RemovableEventDispatcher;
	import com.sleepydesign.net.FileUtil;
	import com.sleepydesign.system.SystemUtil;
	
	import flash.display.*;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import jp.maaash.ObjectDetection.ObjectDetector;
	import jp.maaash.ObjectDetection.ObjectDetectorEvent;
	import jp.maaash.ObjectDetection.ObjectDetectorOptions;

	public class FaceDetection extends RemovableEventDispatcher
	{
		public static var faceURL:String = "face.zip";

		public static function detect(bitmapData:BitmapData, eventHandler:Function):ObjectDetector
		{
			var detector:ObjectDetector = new ObjectDetector;
			var _options:ObjectDetectorOptions = new ObjectDetectorOptions;
			_options.min_size = 50;
			_options.startx = ObjectDetectorOptions.INVALID_POS;
			_options.starty = ObjectDetectorOptions.INVALID_POS;
			_options.endx = ObjectDetectorOptions.INVALID_POS;
			_options.endy = ObjectDetectorOptions.INVALID_POS;

			detector.options = _options;

			detector.addEventListener(ObjectDetectorEvent.DETECTION_COMPLETE, function(event:ObjectDetectorEvent):void
				{
					detector.removeEventListener(ObjectDetectorEvent.DETECTION_COMPLETE, arguments.callee);
					if (event.rects)
						eventHandler(event);
				});

			detector.loadHaarCascades(faceURL);
			detector.detect(bitmapData);

			return detector;
		}

		public static function getTransparentRect(bitmapData:BitmapData):Rectangle
		{
			return bitmapData.getColorBoundsRect(0xFF000000, 0x00000000, true);
		}
	}
}