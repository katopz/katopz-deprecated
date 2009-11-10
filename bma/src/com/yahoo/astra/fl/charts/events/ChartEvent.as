/*
Copyright (c) 2007, Yahoo! Inc. All rights reserved.
Code licensed under the BSD License:
http://developer.yahoo.com/flash/license.html
*/
package com.yahoo.astra.fl.charts.events
{
	import flash.events.Event;
	import flash.display.DisplayObject;
	import com.yahoo.astra.fl.charts.ISeries;

	/**
	 * Events related to items appearing in a chart.
	 * 
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9
	 * @author Josh Tynjala
	 */
	public class ChartEvent extends Event
	{
		
	//--------------------------------------
	//  Static Constants
	//--------------------------------------
	
		/**
		 * 
		 */
		public static const ITEM_ROLL_OVER:String = "chartItemRollOver";
		
		/**
		 * 
		 */
		public static const ITEM_ROLL_OUT:String = "chartItemRollOut";
		
		/**
		 * 
		 */
		public static const ITEM_CLICK:String = "chartItemClick";
		
		/**
		 * 
		 */
		public static const ITEM_DOUBLE_CLICK:String = "chartItemDoubleClick";
		
	//--------------------------------------
	//  Constructor
	//--------------------------------------
	
		/**
		 * Constructor.
		 */
		public function ChartEvent(type:String, index:int, item:Object, relatedObject:DisplayObject, series:ISeries)
		{
			super(type, true, false);
			this.index = index;
			this.item = item;
			this.relatedObject = relatedObject;
			this.series = series;
		}
		
	//--------------------------------------
	//  Properties
	//--------------------------------------
	
		/**
		 * @private
		 */
		private var _index:int;
		
		/**
		 * The series index for the item related to this event.
		 */
		public function get index():int
		{
			return this._index;
		}
		
		/**
		 * @private
		 */
		public function set index(value:int):void
		{
			this._index = value;
		}
	
		/**
		 * @private
		 */
		private var _item:Object;
		
		/**
		 * The data for the item related to this event.
		 */
		public function get item():Object
		{
			return this._item;
		}
		
		/**
		 * @private
		 */
		public function set item(value:Object):void
		{
			this._item = value;
		}
	
		/**
		 * @private
		 */
		private var _relatedObject:DisplayObject;
		
		/**
		 * The DisplayObject representing the item on the chart.
		 */
		public function get relatedObject():DisplayObject
		{
			return this._relatedObject;
		}
		
		/**
		 * @private
		 */
		public function set relatedObject(value:DisplayObject):void
		{
			this._relatedObject = value;
		}
	
		/**
		 * @private
		 */
		private var _series:ISeries;
		
		/**
		 * The ISeries containing the item on the chart.
		 */
		public function get series():ISeries
		{
			return this._series;
		}
		
		/**
		 * @private
		 */
		public function set series(value:ISeries):void
		{
			this._series = value;
		}
		
	//--------------------------------------
	//  Public Methods
	//--------------------------------------
		
		/**
		 * @private
		 */
		override public function clone():Event
		{
			var event:ChartEvent = new ChartEvent(this.type, this.index, this.item, this.relatedObject, this.series);
			return event;
		}
	}
}