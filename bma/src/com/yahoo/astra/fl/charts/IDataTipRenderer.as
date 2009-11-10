/*
Copyright (c) 2007, Yahoo! Inc. All rights reserved.
Code licensed under the BSD License:
http://developer.yahoo.com/flash/license.html
*/
package com.yahoo.astra.fl.charts
{
	/**
	 * A renderer for a mouse-over datatip on a chart.
	 * 
	 * <p>Important: Must be a subclass of <code>DisplayObject</code></p>
	 * 
	 * @see flash.display.DisplayObject
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9
	 * @author Josh Tynjala
	 */
	public interface IDataTipRenderer
	{
		
	//--------------------------------------
	//  Properties
	//--------------------------------------
	
		/**
		 * The text that appears in the data tip's label.
		 */
		function get text():String;
		
		/**
		 * @private
		 */
		function set text(value:String):void;
		
		/**
		 * The data for the item that this data tip represents.
		 * Custom implementations of <code>IDataTipRenderer</code>
		 * may use this property to render additional information for
		 * the user.
		 */
		function get data():Object;
		
		/**
		 * @private
		 */
		function set data(value:Object):void;
	}
}