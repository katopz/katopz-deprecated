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
	import flash.utils.Dictionary;
	import flash.utils.Timer;

	public class MarqueeUtil
	{

		private static var timer:Timer;
		private static var list:Array;
		private static var pointer:Dictionary;
		
		public static function dispose(tf:TextField):MarqueeBitmap
		{
			if(!pointer)
				return null;
				
			var tfmq:MarqueeBitmap;
			
			if( pointer[tf])
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
			var tfmq:MarqueeBitmap = new MarqueeBitmap(rect, bitmapData, speed);
				
			// bye
			tf.visible = false;
			
			// keen for update
			//tf.addEventListener(Event.CHANGE, onChange);
			
			// move it
			if(!timer)
			{
				timer = new Timer(30/1000);
				timer.addEventListener(TimerEvent.TIMER, onTimer);
				timer.start();
			}
			
			// list
			if(!list)
				list = [];
			
			list.push(tfmq);
			
			if(!pointer)
				pointer = new Dictionary;
					
			pointer[tf] = tfmq;
			
			return tfmq;
		}
		
		private static function onTimer(event:Event):void
		{
			for each(var tfmq:MarqueeBitmap in list)
			{
				tfmq.mat.translate(tfmq.speed,0);
				
				tfmq.graphics.clear(); 
				tfmq.graphics.beginBitmapFill(tfmq.bitmapData, tfmq.mat);
				tfmq.graphics.drawRect(tfmq.rect.x, tfmq.rect.y, tfmq.rect.width, tfmq.rect.height);
			}
		}
		
		public static function update(tf:TextField, speed:Number = 0):void
		{
			trace(" ! onChange tf : " + tf);
			
			var tfmq:MarqueeBitmap = pointer[tf];
			
			var bitmapData:BitmapData = BitmapUtil.getBitmapData(tf);
			DrawUtil.drawBitmapRect(tfmq.rect, bitmapData);
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

internal class MarqueeBitmap extends Sprite
{
	public var bitmapData:BitmapData;
	public var rect:Rectangle;
	public var mat:Matrix;
	public var speed:Number;
	
	public function MarqueeBitmap(rect:Rectangle, bitmapData:BitmapData, speed:Number)
	{
		this.rect = rect;
		this.bitmapData = bitmapData;
		this.speed = speed;
		
		mat = new Matrix;
			
		DrawUtil.drawBitmapRectTo(graphics, rect, bitmapData);
	}
}
