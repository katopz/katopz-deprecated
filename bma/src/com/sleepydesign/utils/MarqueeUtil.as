package com.sleepydesign.utils
{

	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	import flash.utils.Timer;

	public class MarqueeUtil
	{

		private static var timer:Timer;
		private static var list:Array;
		private static var pointer:Dictionary;

		public static function dispose(tf:TextField):MarqueeBitmap
		{
			if (!pointer)
				return null;

			var tfmq:MarqueeBitmap;

			if (pointer[tf])
			{
				tfmq = pointer[tf];
				pointer[tf] = null;
				ArrayUtil.removeItem(list, tfmq);

				trace(" ! remove tf : " + tf);
			}

			return tfmq;
		}

		public static function marquee(tf:TextField, rect:Rectangle, speed:Number):MarqueeBitmap
		{
			var bitmapData:BitmapData = BitmapUtil.getBitmapData(tf);
			
			if(isNaN(speed))
				speed = 0;
			
			var tfmq:MarqueeBitmap = new MarqueeBitmap(tf, rect, bitmapData, speed);

			// bye
			tf.visible = false;

			// keen for update
			//tf.addEventListener(Event.CHANGE, onChange);

			// move it
			if (!timer)
			{
				timer = new Timer(30 / 1000);
				timer.addEventListener(TimerEvent.TIMER, onTimer);
				timer.start();
			}

			// list
			if (!list)
				list = [];

			list.push(tfmq);

			if (!pointer)
				pointer = new Dictionary;

			pointer[tf] = tfmq;

			return tfmq;
		}

		private static function onTimer(event:Event):void
		{
			for each (var tfmq:MarqueeBitmap in list)
			{
				tfmq.graphics.clear();
				
				if(tfmq.speed == 0 )
				{
					tfmq.tf.visible = true;
					//tfmq.mat.identity();
				} else{
					tfmq.tf.visible = false;
					tfmq.mat.translate(tfmq.speed, 0);
					tfmq.graphics.beginBitmapFill(tfmq.bitmapData, tfmq.mat);
					tfmq.graphics.drawRect(tfmq.rect.x, tfmq.rect.y, tfmq.rect.width, tfmq.rect.height);
				}
			}
		}

		public static function update(tf:TextField, speed:Number = 0):void
		{
			trace(" ! onChange tf : " + tf);

			var tfmq:MarqueeBitmap = pointer[tf];
			
			tf.multiline = false;
			tf.autoSize = "center";
			
			var bitmapData:BitmapData = BitmapUtil.getBitmapData(tf);
			
			tfmq.graphics.lineStyle();
			tfmq.graphics.beginBitmapFill(bitmapData);
			tfmq.graphics.drawRect(tfmq.rect.x, tfmq.rect.y, tfmq.rect.width, tfmq.rect.height);
			tfmq.graphics.endFill();
			
			tfmq.bitmapData = bitmapData;
			tfmq.speed = speed;
		}
	}
}
import com.sleepydesign.utils.DrawUtil;

import flash.display.BitmapData;
import flash.display.Sprite;
import flash.geom.Matrix;
import flash.geom.Rectangle;
import flash.text.TextField;

internal class MarqueeBitmap extends Sprite
{
	public var bitmapData:BitmapData;
	public var rect:Rectangle;
	public var mat:Matrix;
	public var speed:Number;
	public var tf:TextField;

	public function MarqueeBitmap(tf:TextField, rect:Rectangle, bitmapData:BitmapData, speed:Number)
	{
		this.tf = tf;
		this.rect = rect;
		this.bitmapData = bitmapData;
		this.speed = speed;

		mat = new Matrix;

		DrawUtil.drawBitmapRectTo(graphics, rect, bitmapData);
	}
}
