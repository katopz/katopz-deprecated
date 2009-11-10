/*
Copyright (c) 2007, Yahoo! Inc. All rights reserved.
Code licensed under the BSD License:
http://developer.yahoo.com/flash/license.html
*/
package com.yahoo.astra.fl.charts
{
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	import fl.events.ComponentEvent;
	
	/**
	 * Functionality common to most axes. Generally, an <code>Axis</code> object
	 * shouldn't be instantiated directly. Instead, a subclass with a concrete
	 * implementation should be used.
	 *
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9
	 * @author Josh Tynjala
	 */
	public class Axis extends UIComponent implements IAxis
	{
		
	//--------------------------------------
	//  Constructor
	//--------------------------------------
	
		/**
		 * Constructor.
		 */
		public function Axis()
		{
			super();
		}
		
	//--------------------------------------
	//  Variables and Properties
	//--------------------------------------
	
	//-- Children
	
		/**
		 * @private
		 * Storage for the plotArea property.
		 */
		private var _plotArea:IPlotArea;
	
		/**
		 * @copy com.yahoo.charts.IAxis#plotArea
	     */
		public function get plotArea():IPlotArea
		{
			return this._plotArea;
		}
		
		/**
		 * @private
		 */
		public function set plotArea(value:IPlotArea):void
		{
			if(this._plotArea != value)
			{
				this._plotArea = value;
				this.invalidate();
			}
		}
		
		/**
		 * @private
		 */
		protected var titleField:TextField;
		
	//-- General
		
		/**
		 * @private
		 * Storage for the orientation.
		 */
		private var _orientation:String = AxisOrientation.VERTICAL;
		
		/**
		 * @copy com.yahoo.charts.IAxis#orientation
		 */
		public function get orientation():String
		{
			return this._orientation;
		}
		
		/**
		 * @private
		 */
		public function set orientation(value:String):void
		{
			if(this._orientation != value)
			{
				this._orientation = value;
				this.invalidate();
			}
		}
		
		/**
		 * @private
		 * Storage for the reverse property.
		 */
		private var _reverse:Boolean = false;
		
		/**
		 * @copy com.yahoo.charts.IAxis#reverse
		 */
		public function get reverse():Boolean
		{
			return this._reverse;
		}
		
		/**
		 * @private
		 */
		public function set reverse(value:Boolean):void
		{
			if(this._reverse != value)
			{
				this._reverse = value;
				this.invalidate();
			}
		}
		
		/**
		 * @private
		 * Storage for the title property.
		 */
		private var _title:String = "";
		
		/**
		 * @copy com.yahoo.charts.IAxis#title
		 */
		public function get title():String
		{
			return this._title;
		}
		
		/**
		 * @private
		 */
		public function set title(value:String):void
		{
			if(this._title != value)
			{
				this._title = value;
				this.invalidate();
			}
		}
		
	//-- Bounds
		
		/**
		 * @private
		 * Storage for the contentBounds property.
		 */
		protected var _contentBounds:Rectangle = new Rectangle();
		
		/**
		 * @copy com.yahoo.charts.IAxis#contentBounds
		 */
		public function get contentBounds():Rectangle
		{
			return this._contentBounds;
		}
		
		/**
		 * @private
		 * Storage for the overflowEnabled property.
		 */
		private var _overflowEnabled:Boolean = false;
		
		/**
		 * @copy com.yahoo.charts.IAxis#overflowEnabled
		 */
		public function get overflowEnabled():Boolean
		{
			return this._overflowEnabled;
		}
		
		/**
		 * @private
		 */
		public function set overflowEnabled(value:Boolean):void
		{
			if(this._overflowEnabled != value)
			{
				this._overflowEnabled = value;
				this.invalidate();
			}
		}
		
		//-- Labels
		
		/**
		 * @private
		 * Storage for the labelFunction property.
		 */
		private var _labelFunction:Function;
		
		/**
		 * A function may be set to determine the text value of the labels.
		 *
		 * <pre>function labelFunction(value:Number):String</pre>
		 */
		public function get labelFunction():Function
		{
			return this._labelFunction;
		}
		
		/**
		 * @private
		 */
		public function set labelFunction(value:Function):void
		{
			if(this._labelFunction != value)
			{
				this._labelFunction = value;
				this.invalidate();
			}
		}
		
	//--------------------------------------
	//  Public Methods
	//--------------------------------------
		
		/**
		 * @copy com.yahoo.charts.IAxis#valueToLocal()
		 */
		public function valueToLocal(data:Object):Number
		{
			//To be overridden.
			return 0;
		}
		
		/**
		 * @copy com.yahoo.charts.IAxis#localToValue()
		 */
		public function localToValue(position:Number):Object
		{
			//To be overridden.
			return 0;
		}
		
		/**
		 * @copy com.yahoo.charts.IAxis#valueToLabel();
		 */
		public function valueToLabel(value:Object):String
		{
			var text:String = value.toString();
			if(this._labelFunction != null)
			{
				text = this._labelFunction(value);
			}
			if(text == null) text = "";
			return text;
		}
		
		/**
		 * @copy com.yahoo.charts.IAxis#updateScale()
		 */
		public function updateScale(data:Array):Array
		{
			return data;
		}
		
		/**
		 * @copy com.yahoo.charts.IAxis#updateBounds()
		 */
		public function updateBounds():void
		{
			var showTitle:Boolean = this.getStyleValue("showTitle") as Boolean;
			if(showTitle)
			{
				this.titleField.text = this.title;
			}
			else this.titleField.text = "";
			this.calculateContentBounds();
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
			
			this.titleField = new TextField();
			this.titleField.autoSize = TextFieldAutoSize.LEFT;
			this.addChild(this.titleField);
		}
		
		/**
		 * @private
		 */
		override protected function draw():void
		{
			super.draw();
			this.drawTitle();
		}
		
		/**
		 * @private
		 */
		protected function drawTitle():void
		{
			var showTitle:Boolean = this.getStyleValue("showTitle") as Boolean;
			if(showTitle)
			{
				var textFormat:TextFormat = this.getStyleValue("titleTextFormat") as TextFormat;
				this.titleField.defaultTextFormat = textFormat;
				this.titleField.text = this.title;
				this.titleField.embedFonts = this.orientation == AxisOrientation.VERTICAL;
				if(this.orientation == AxisOrientation.VERTICAL)
				{
					this.titleField.rotation = 90;
					this.titleField.x = this.titleField.width;
					this.titleField.y = this._contentBounds.y + (this._contentBounds.height - this.titleField.height) / 2;
				}
				else //horizontal
				{
					this.titleField.x = this._contentBounds.x + (this._contentBounds.width - this.titleField.width) / 2;
					this.titleField.y = this.height - this.titleField.height;
				}
			}
			else this.titleField.text = "";
			this.titleField.visible = showTitle;
		}
		
		/**
		 * Determines the rectangular bounds where data may be drawn within this axis.
		 */
		protected function calculateContentBounds():void
		{
			this._contentBounds = new Rectangle(0, 0, this.width, this.height);
			var showTitle:Boolean = this.getStyleValue("showTitle") as Boolean;
			if(!showTitle || !this.title) return;
			
			if(this.orientation == AxisOrientation.VERTICAL)
			{
				this._contentBounds.x += this.titleField.width;
				this._contentBounds.width -= this.titleField.width;
			}
			else
			{
				this._contentBounds.height -= this.titleField.height;
			}
		}
	
	}
}