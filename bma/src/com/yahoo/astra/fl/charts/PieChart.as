/*
Copyright (c) 2007, Yahoo! Inc. All rights reserved.
Code licensed under the BSD License:
http://developer.yahoo.com/flash/license.html
*/
package com.yahoo.astra.fl.charts
{
	import flash.geom.Rectangle;
	import fl.core.UIComponent;
	import com.yahoo.astra.fl.charts.series.PieSeries;
	
	/**
	 * A chart that displays its data points with pie-like wedges.
	 * 
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9
	 * @author Josh Tynjala
	 */
	public class PieChart extends Chart implements ICategoryChart
	{
		
	//--------------------------------------
	//  Class Variables
	//--------------------------------------
		
		/**
		 * @private
		 */
		private static var defaultStyles:Object = 
			{
				seriesColors: [ [0xfcaf3e, 0x73d216, 0x729fcf, 0xfce94f, 0xad7fa8, 0x3465a4],
					[0x3465a4, 0xad7fa8, 0xfce94f, 0x729fcf, 0x73d216, 0xfcaf3e] ]
			};
		
		/**
		 * @private
		 * The chart styles that correspond to styles on each series.
		 */
		private static const PIE_SERIES_STYLES:Object = 
			{
				fillColors: "seriesColors"
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
			return mergeStyles(defaultStyles, Chart.getStyleDefinition());
		}
		
	//--------------------------------------
	//  Constructor
	//--------------------------------------
	
		/**
		 * Constructor.
		 */
		public function PieChart()
		{
			super();
			this.defaultSeriesType = PieSeries;
		}
		
	//--------------------------------------
	//  Properties
	//--------------------------------------
		
		/**
		 * @private
		 * Storage for the dataField property.
		 */
		//private var _dataField:String;
		
		/**
		 * The field used to access data for this series.
		 */
		/*public function get dataField():String
		{
			return this._dataField;
		}*/
		
		/**
		 * @private
		 */
		/*public function set dataField(value:String):void
		{
			if(this._dataField != value)
			{
				this._dataField = value;
				this.invalidate();
			}
		}*/
		
		/**
		 * @private
		 * Storage for the categoryNames property.
		 */
		private var _categoryNames:Array;
		
		[Inspectable]
		/**
		 * The names of the categories displayed on the category axis. If the
		 * chart does not have a category axis, this value will be ignored.
		 */
		public function get categoryNames():Array
		{
			return this._categoryNames;
		}
		
		/**
		 * @private
		 */
		public function set categoryNames(value:Array):void
		{
			if(this._categoryNames != value)
			{
				this._categoryNames = value;
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
			
			var contentPadding:Number = this.getStyleValue("contentPadding") as Number;
			var seriesWidth:Number = this.width - 2 * contentPadding;
			var seriesHeight:Number = this.height - 2 * contentPadding;
			
			this.content.x = this.content.y = contentPadding;
			
			var seriesCount:int = this.series.length;
			for(var i:int = 0; i < seriesCount; i++)
			{
				var series:UIComponent = this.series[i] as UIComponent;
				
				//if a pie chart contains more than one series, each additional series should be
				//a little bit smaller so that they can all be visible to the viewer.				
				series.width = seriesWidth - i * seriesWidth / seriesCount;
				series.height = seriesHeight - i * seriesHeight / seriesCount;
				
				//reposition the series based on the calculated dimensions
				series.x = (seriesWidth - series.width) / 2;
				series.y = (seriesHeight - series.height) / 2;
				series.drawNow();
			}
		}
		
		/**
		 * @private
		 */
		override protected function defaultDataTipFunction(item:Object, index:int, series:ISeries):String
		{
			var text:String = super.defaultDataTipFunction(item, index, series);
			if(text.length > 0) text += "\n";
			
			if(!isNaN(Number(item)))
			{
				text += item + "\n";
				if(this.categoryNames && this.categoryNames.length > index)
				{
					text += this.categoryNames[index];
				}
				else
				{
					text += index;
				}
			}
			return text;
		}
		
	}
}