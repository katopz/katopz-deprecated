/*
Copyright (c) 2007, Yahoo! Inc. All rights reserved.
Code licensed under the BSD License:
http://developer.yahoo.com/flash/license.html
*/
package com.yahoo.astra.fl.charts
{
	/**
	 * Position values available to axis ticks.
	 * 
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9
	 * @author Josh Tynjala
	 */
	public class TickPosition
	{
		
	//--------------------------------------
	//  Constants
	//--------------------------------------
	
		/**
		 * The TickPosition.OUTSIDE constant specifies that chart axis ticks
		 * should be displayed on the outside of the axis.
		 */
		public static const OUTSIDE:String = "outside";
		
		/**
		 * The TickPosition.INSIDE constant specifies display of chart axis
		 * ticks should be displayed on the inside of the axis.
		 */
		public static const INSIDE:String = "inside";
		
		/**
		 * The TickPosition.CROSS constant specifies display of chart axis ticks
		 * should be displayed crossing the axis.
		 */
		public static const CROSS:String = "cross";
	}
}
