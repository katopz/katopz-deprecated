/**
* ...
* @author katopz@sleepydesign.com
* @version 0.1
*/

package com.sleepydesign.utils {

	public class Math2DUtil {
		
		public static function random (start:Number, end:Number=null) : Number
		{
			if(!end){
				end=start;
				start=0;
			}
			return Math.floor(start +(Math.random() * (end - start + 1)));
		}
		
		public static function distance(firstPoint:Point, secondPoint:Point):Number 
		{
			var x:Number = secondPoint.x - firstPoint.x;
			var y:Number = secondPoint.y - firstPoint.y;
			
			return Math.sqrt(x * x + y * y);
		}
	}
	
}
