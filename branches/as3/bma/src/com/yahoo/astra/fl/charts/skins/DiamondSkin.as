/*
Copyright (c) 2007, Yahoo! Inc. All rights reserved.
Code licensed under the BSD License:
http://developer.yahoo.com/flash/license.html
*/
package com.yahoo.astra.fl.charts.skins
{
	import fl.core.UIComponent;

	/**
	 * A skin shaped like a diamond with a single color.
	 * 
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9
	 * @author Josh Tynjala
	 */
	public class DiamondSkin extends UIComponent implements IProgrammaticSkin
	{
		
	//--------------------------------------
	//  Constructor
	//--------------------------------------
	
		/**
		 * Constructor.
		 */
		public function DiamondSkin()
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
			
			var w:Number = 2 * this.width / 3;
			var h:Number = 2 * this.height / 3;
			
			this.graphics.moveTo(0, h);
			this.graphics.lineTo(w, 0);
			this.graphics.lineTo(2 * w, h);
			this.graphics.lineTo(w, 2 * h);
			this.graphics.lineTo(0, h);
			this.graphics.endFill();
		}
		
	}
}