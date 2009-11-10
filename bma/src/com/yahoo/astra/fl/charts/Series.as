/*
Copyright (c) 2007, Yahoo! Inc. All rights reserved.
Code licensed under the BSD License:
http://developer.yahoo.com/flash/license.html
*/
package com.yahoo.astra.fl.charts
{
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import fl.core.UIComponent;
	import com.yahoo.astra.fl.charts.events.ChartEvent;
	import com.yahoo.astra.fl.charts.skins.IProgrammaticSkin;
		
	//--------------------------------------
	//  Styles
	//--------------------------------------
	
	/**
     * The color of the markers in this series.
     *
     * @default 0xff8800
     */
    [Style(name="fillColor", type="uint")]

	/**
     * The base width, in pixels, of the markers in this series. If the width and
     * height have different values at initialization. The mark will be drawn at
     * the same ratio when resized.
     *
     * @default 8
     */
    [Style(name="markerSize", type="Number")]

	/**
     * Name of the class to use as the skin for the markers in this series.
     *
     * @default CircleSkin
     */
    [Style(name="markerSkin", type="Class")]

	/**
	 * Functionality common to most series. Generally, a <code>Series</code> object
	 * shouldn't be instantiated directly. Instead, a subclass with a concrete
	 * implementation should be used.
	 *
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9
	 * @author Josh Tynjala
	 */
	public class Series extends UIComponent implements ISeries
	{
		
	//--------------------------------------
	//  Class Variables
	//--------------------------------------
		
		/**
		 * @private
		 */
		private static var defaultStyles:Object =
			{
				markerSkin: UIComponent, //an empty component
				fillColor: 0xff8800,
				markerSize: 8
			};
		
	//--------------------------------------
	//  Class Methods
	//--------------------------------------
	
		/**
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
		public function Series(dataProvider:Object = null)
		{
			super();
			this._dataProvider = dataProvider;
		}
		
	//--------------------------------------
	//  Properties
	//--------------------------------------
		
		/**
		 * @private
		 */
		protected var markers:Array = [];
		
		/**
		 * @private
		 * Storage for the plotArea property.
		 */
		private var _plotArea:IPlotArea;
		
		/**
		 * @copy com.yahoo.charts.ISeries#plotArea
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
			this._plotArea = value;
		}
		
		/**
		 * @private
		 * Storage for the data property.
		 */
		private var _dataProvider:Object;
		
		/**
		 * @copy com.yahoo.charts.ISeries#data
		 */
		public function get dataProvider():Object
		{
			return this._dataProvider;
		}
		
		/**
		 * @private
		 */
		public function set dataProvider(value:Object):void
		{
			if(this._dataProvider != value)
			{
				//if we get XML data and it isn't an XMLList,
				//ignore the root tag
				if(value is XML && !(value is XMLList))
				{
					value = value.elements();
				}
				this._dataProvider = value;
				this.dispatchEvent(new Event("dataChange"));
			}
		}
		
		/**
		 * @private
		 * Storage for the displayName property.
		 */
		private var _displayName:String;
		
		/**
		 * @copy com.yahoo.charts.ISeries#data
		 */
		public function get displayName():String
		{
			return this._displayName;
		}
		
		/**
		 * @private
		 */
		public function set displayName(value:String):void
		{
			if(this._displayName != value)
			{
				this._displayName = value;
				this.invalidate();
			}
		}
		
		/**
		 * @copy com.yahoo.charts.ISeries#length
		 */
		public function get length():int
		{
			if(this._dataProvider is Array)
			{
				return (this._dataProvider as Array).length;
			}
			else if(this._dataProvider is XMLList)
			{
				return (this._dataProvider as XMLList).length();
			}
			
			return 0;
		}
		
	//--------------------------------------
	//  Public Methods
	//--------------------------------------
		
		/**
		 * @copy com.yahoo.charts.ISeries#clone()
		 */
		public function clone():ISeries
		{
			var series:Series = new Series();
			series.dataProvider = this.dataProvider;
			series.displayName = this.displayName;
			return series;
		}
		
	//--------------------------------------
	//  Protected Methods
	//--------------------------------------
		
		/**
		 * @private
		 */
		override protected function draw():void
		{
			try{
			super.draw();
			
			var itemCount:int = this.length;
			var difference:int = itemCount - this.markers.length;
			if(difference > 0)
			{
				for(var i:int = 0; i < difference; i++)
				{
					var skinClass:Object = this.getStyleValue("markerSkin");
					var marker:DisplayObject = this.getDisplayObjectInstance(skinClass);
					if(marker is InteractiveObject)
					{
						(marker as InteractiveObject).doubleClickEnabled = true;
					}
					marker.addEventListener(MouseEvent.ROLL_OVER, markerRollOverHandler, false, 0, true);
					marker.addEventListener(MouseEvent.ROLL_OUT, markerRollOutHandler, false, 0, true);
					marker.addEventListener(MouseEvent.CLICK, markerClickHandler, false, 0, true);
					marker.addEventListener(MouseEvent.DOUBLE_CLICK, markerDoubleClickHandler, false, 0, true);
					this.addChild(marker);
					this.markers.push(marker);
				}
			}
			else if(difference < 0)
			{
				difference = Math.abs(difference);
				for(i = 0; i < difference; i++)
				{
					marker = this.markers.pop() as DisplayObject;
					marker.removeEventListener(MouseEvent.ROLL_OVER, markerRollOverHandler);
					marker.removeEventListener(MouseEvent.ROLL_OUT, markerRollOutHandler);
					marker.removeEventListener(MouseEvent.CLICK, markerClickHandler);
					marker.removeEventListener(MouseEvent.DOUBLE_CLICK, markerDoubleClickHandler);
					this.removeChild(marker);
				}
			}
			}catch (e:*) {
				
			}
		}
		
		/**
		 * @private
		 * Notify the parent chart that the user's mouse is over a marker.
		 */
		protected function markerRollOverHandler(event:MouseEvent):void
		{
			var marker:DisplayObject = event.target as DisplayObject;
			var index:int = this.markers.indexOf(marker);
			var item:Object = this.dataProvider[index];
			var rollOver:ChartEvent = new ChartEvent(ChartEvent.ITEM_ROLL_OVER, index, item, marker, this);
			this.dispatchEvent(rollOver);
		}
		
		/**
		 * @private
		 * Notify the parent chart that the user's mouse has left a marker.
		 */
		protected function markerRollOutHandler(event:MouseEvent):void
		{
			var marker:DisplayObject = event.target as DisplayObject;
			var index:int = this.markers.indexOf(marker);
			var item:Object = this.dataProvider[index];
			var rollOut:ChartEvent = new ChartEvent(ChartEvent.ITEM_ROLL_OUT, index, item, marker, this);
			this.dispatchEvent(rollOut);
		}
		
		/**
		 * @private
		 * Notify the parent chart that the user has clicked a marker.
		 */
		protected function markerClickHandler(event:MouseEvent):void
		{
			var marker:DisplayObject = event.target as DisplayObject;
			var index:int = this.markers.indexOf(marker);
			var item:Object = this.dataProvider[index];
			var click:ChartEvent = new ChartEvent(ChartEvent.ITEM_CLICK, index, item, marker, this);
			this.dispatchEvent(click);
		}
		
		/**
		 * @private
		 * Notify the parent chart that the user has double-clicked a marker.
		 */
		protected function markerDoubleClickHandler(event:MouseEvent):void
		{
			var marker:DisplayObject = event.target as DisplayObject;
			var index:int = this.markers.indexOf(marker);
			var item:Object = this.dataProvider[index];
			var doubleClick:ChartEvent = new ChartEvent(ChartEvent.ITEM_DOUBLE_CLICK, index, item, marker, this);
			this.dispatchEvent(doubleClick);
		}
		
	}
}