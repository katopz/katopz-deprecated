/**
* ...
* @author katopz@sleepydesign.com
* @version 0.1
*/

package com.sleepydesign.utils {

	public class MathUtil {
		
		public static function random (start:Number, end:Number=null) : Number
		{
			if(!end){
				end=start;
				start=0;
			}
			return Math.floor(start +(Math.random() * (end - start + 1)));
		}
		
	}
	
}
