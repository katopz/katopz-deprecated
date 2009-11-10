/*
Copyright (c) 2007, Yahoo! Inc. All rights reserved.
Code licensed under the BSD License:
http://developer.yahoo.com/flash/license.html
*/
package com.yahoo.astra.fl.charts.skins
{
	import fl.core.UIComponent;

	/**
	 * A skin shaped like a circle with a single color.
	 * 
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9
	 * @author Josh Tynjala
	 */
	public class CircleSkin extends UIComponent implements IProgrammaticSkin
	{
		
	//--------------------------------------
	//  Constructor
	//--------------------------------------
	
		/**
		 * Constructor.
		 */
		public function CircleSkin()
		{
			super();
		}
		
	//--------------------------------------
	//  Properties
	//--------------------------------------
		
		/**
		 * @private
		 * Storage for the fillColor property.
		 */
		private var _fillColor:uint = 0x000000;
		
		/**
		 * @copy com.yahoo.charts.skins.IProgrammaticSkin#fillColor
		 */
		public function get fillColor():uint
		{
			return this._fillColor;
		}
		
		/**
		 * @private
		 */
		public function set fillColor(value:uint):void
		{
			if(this._fillColor != value)
			{
				this._fillColor = value;
				this.invalidate();
			}
		}
		
	//--------------------------------------
	//  Protected Methods
	//--------------------------------------
	
		/**
		 * @private
		 */
		override protected function draw():void
		{
			super.draw();
			
			this.graphics.clear();
			
			if(this.width == 0 || this.height == 0) return;
			
			this.graphics.lineStyle(0, 0, 0);
			this.graphics.beginFill(this._fillColor, 1);
			this.graphics.drawCircle(this.width / 2, this.height / 2, Math.min(this.width, this.height) / 2);
			this.graphics.endFill();
		}
		
	}
}