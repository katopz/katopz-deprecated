/*
Copyright (c) 2007, Yahoo! Inc. All rights reserved.
Code licensed under the BSD License:
http://developer.yahoo.com/flash/license.html
*/
package com.yahoo.astra.fl.charts.skins
{
	/**
	 * A type of skin that supports color customization.
	 * 
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9
	 * @author Josh Tynjala
	 */
	public interface IProgrammaticSkin
	{
		
	//--------------------------------------
	//  Properties
	//--------------------------------------
	
		/**
		 * The color used to draw the skin.
		 */
		function get fillColor():uint;
		
		/**
		 * @private
		 */
		function set fillColor(value:uint):void;
	}
}