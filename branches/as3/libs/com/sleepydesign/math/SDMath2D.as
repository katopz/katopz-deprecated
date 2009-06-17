package com.sleepydesign.math
{
	import flash.geom.Point;
	
	public class SDMath2D
	{
		public static function distance(firstPoint:Point, secondPoint:Point):Number 
		{
			var x:Number = secondPoint.x - firstPoint.x;
			var y:Number = secondPoint.y - firstPoint.y;
			
			return Math.sqrt(x * x + y * y);
		}
	}
}