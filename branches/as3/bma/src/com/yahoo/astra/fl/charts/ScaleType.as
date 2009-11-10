/*
Copyright (c) 2007, Yahoo! Inc. All rights reserved.
Code licensed under the BSD License:
http://developer.yahoo.com/flash/license.html
*/
package com.yahoo.astra.fl.charts
{
	/**
	 * Scale types available to <code>IAxis</code> objects.
	 * 
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9
	 * @author Josh Tynjala
	 */
	public class ScaleType
	{
		
	//--------------------------------------
	//  Constants
	//--------------------------------------
	
		/**
		 * The ScaleType.LINEAR constant specifies that chart axis objects
		 * should be displayed on a linear scale.
		 */
		public static const LINEAR:String = "linear";
		
		/**
		 * The ScaleType.LOGARITHMIC constant specifies that chart axis objects
		 * should be displayed on a logarithmic scale.
		 */
		public static const LOGARITHMIC:String = "logarithmic";
	}
}
