/*
Copyright (c) 2007, Yahoo! Inc. All rights reserved.
Code licensed under the BSD License:
http://developer.yahoo.com/flash/license.html
*/
package com.yahoo.astra.fl.charts
{
	/**
	 * A type of chart that displays its data in categories.
	 * 
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9
	 * @author Josh Tynjala
	 */
	public interface ICategoryChart
	{
		
	//--------------------------------------
	//  Properties
	//--------------------------------------
		
		/**
		 * The names of the categories displayed on the category axis. If the
		 * chart does not have a category axis, this value will be ignored.
		 */
		function get categoryNames():Array
		
		/**
		 * @private
		 */
		function set categoryNames(value:Array):void
	}
}