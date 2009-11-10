/*
Copyright (c) 2007, Yahoo! Inc. All rights reserved.
Code licensed under the BSD License:
http://developer.yahoo.com/flash/license.html
*/
package com.yahoo.astra.fl.charts
{
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import fl.core.UIComponent;

	//--------------------------------------
	//  Styles
	//--------------------------------------
	
	/**
     * The padding that separates the border of the component from its contents,
     * in pixels.
     *
     * @default 6
     */
    [Style(name="contentPadding", type="Number")]

	/**
	 * The default renderer for mouse-over data tips.
	 *
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9
	 * @author Josh Tynjala
	 */
	public class DataTipRenderer extends UIComponent implements IDataTipRenderer
	{
		
	//--------------------------------------
	//  Class Variables
	//--------------------------------------
	
		/**
		 * @private
		 */
		private static var defaultStyles:Object =
			{
				contentPadding: 6,
				backgroundColor: 0xffffff,
				backgroundAlpha: 0.85,
				borderColor: 0x888a85
			};
		
	//--------------------------------------
	//  Class Methods
	//--------------------------------------
	
		/**
		 * @private
		 * @copy fl.core.UIComponent#getStyleDefinition()
		 */
		public static function getStyleDefinition():Object
		{
			return mergeStyles(defaultStyles, UIComponent.getStyleDefinition());
		}
		
	//--------------------------------------
	//  Constructor
	//--------------------------------------
	
		/**
		 * Constructor.
		 */
		public function DataTipRenderer()
		{
			super();
			this.mouseEnabled = false;
			this.mouseChildren = false;
		}
		
	//--------------------------------------
	//  Properties
	//--------------------------------------
		
		/**
		 * @private
		 */
		protected var label:TextField;
		
		/**
		 * @private
		 * Storage for the text property.
		 */
		private var _text:String = "";
		
		/**
		 * @copy com.yahoo.charts.IDataTipRenderer#text
		 */
		public function get text():String
		{
			return this._text;
		}
		
		/**
		 * @private
		 */
		public function set text(value:String):void
		{
			if(value == null) value = "";
			if(this._text != value)
			{
				this._text = value;
				this.invalidate();
			}
		}
		
		/**
		 * @private
		 * Storage for the data property.
		 */
		private var _data:Object;
		
		/**
		 * @copy com.yahoo.charts.IDataTipRenderer#data
		 */
		public function get data():Object
		{
			return this._data;
		}
		
		/**
		 * @private
		 */
		public function set data(value:Object):void
		{
			if(this._data != value)
			{
				this._data = value;
				this.invalidate();
			}
		}
		
	//--------------------------------------
	//  Protected Methods
	//--------------------------------------
	
		/**
		 * @private
		 */
		override protected function configUI():void
		{
			super.configUI();
			this.label = new TextField();
			this.label.autoSize = TextFieldAutoSize.LEFT;
			this.label.selectable = false;
			this.addChild(this.label);
		}
	
		/**
		 * @private
		 */
		override protected function draw():void
		{
			super.draw();
			
			var borderColor:uint = this.getStyleValue("borderColor") as uint;
			var backgroundColor:uint = this.getStyleValue("backgroundColor") as uint;
			var backgroundAlpha:Number = this.getStyleValue("backgroundAlpha") as Number;
			var contentPadding:Number = this.getStyleValue("contentPadding") as Number;
			var format:TextFormat = this.getStyleValue("textFormat") as TextFormat;
			
			this.label.defaultTextFormat = format;
			this.label.text = this.text;
			this.label.x = contentPadding;
			this.label.y = contentPadding;
			
			this.width = this.label.width + 2 * contentPadding;
			this.height = this.label.height + 2 * contentPadding;
			
			this.graphics.clear();
			this.graphics.lineStyle(1, borderColor, 1.0);
			this.graphics.beginFill(backgroundColor, backgroundAlpha);
			this.graphics.drawRect(0, 0, this.width, this.height);
			this.graphics.endFill();
		}
	
	}
}