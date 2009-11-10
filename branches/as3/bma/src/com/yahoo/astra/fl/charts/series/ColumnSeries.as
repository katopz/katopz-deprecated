/*
Copyright (c) 2007, Yahoo! Inc. All rights reserved.
Code licensed under the BSD License:
http://developer.yahoo.com/flash/license.html
*/
package com.yahoo.astra.fl.charts.series
{
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import fl.core.UIComponent;
	import com.yahoo.astra.fl.charts.*;
	import com.yahoo.astra.fl.charts.skins.RectangleSkin;
	import com.yahoo.astra.fl.charts.skins.IProgrammaticSkin;

	/**
	 * Renders data points as a series of vertical columns.
	 * 
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9
	 * @author Josh Tynjala
	 */
	public class ColumnSeries extends CartesianSeries
	{
		
	//--------------------------------------
	//  Class Variables
	//--------------------------------------
	
		/**
		 * @private
		 */
		private static var defaultStyles:Object =
			{
				markerSkin: RectangleSkin
			};
	
		/**
		 * @private
		 * Holds an array of ColumnSeries objects for each plot area in which they appear.
		 */
		private static var seriesInPlotAreas:Dictionary = new Dictionary();
		
	//--------------------------------------
	//  Class Methods
	//--------------------------------------
	
		/**
		 * @private
		 * When a column series is added to a IPlotArea, it should be registered with that IPlotArea.
		 * This allows it to determine proper positioning since column positions depend on other columns.
		 */
		private static function registerSeries(plotArea:IPlotArea, series:ColumnSeries):void
		{
			var columns:Array = seriesInPlotAreas[plotArea];
			if(!columns)
			{
				columns = [];
				seriesInPlotAreas[plotArea] = columns;
			}
			
			columns.push(series);
		}
		
		/**
		 * @private
		 * When a column series is removed from its parent IPlotArea, it should be unregistered.
		 */
		private static function unregisterSeries(plotArea:IPlotArea, series:ColumnSeries):void
		{
			var columns:Array = seriesInPlotAreas[plotArea];
			if(columns)
			{
				var index:int = columns.indexOf(series);
				if(index >= 0) columns.splice(index, 1);
			}
		}
		
		/**
		 * @private
		 * Returns the number of ColumnSeries objects appearing in a particular IPlotArea.
		 * This value may be used to determine the position of the series.
		 */
		private static function getSeriesCount(plotArea:IPlotArea):int
		{
			var columns:Array = seriesInPlotAreas[plotArea];
			if(columns) return columns.length;
			return 0;
		}
		
		/**
		 * @private
		 * Returns the index of a ColumnSeries within a plot area.
		 * This value may be used to determine the position of the series.
		 */
		private static function seriesToIndex(plotArea:IPlotArea, series:ColumnSeries):int
		{
			var columns:Array = seriesInPlotAreas[plotArea];
			if(columns)
			{
				return columns.indexOf(series);
			}
			return -1;
		}
		
		/**
		 * @private
		 * Returns the ColumnSeries at the specified index within a plot area.
		 */
		private static function indexToSeries(plotArea:IPlotArea, index:int):ColumnSeries
		{
			var columns:Array = seriesInPlotAreas[plotArea];
			if(columns)
			{
				return columns[index];
			}
			
			return null;
		}
			
		/**
		 * @copy fl.core.UIComponent#getStyleDefinition()
		 */
		public static function getStyleDefinition():Object
		{
			return defaultStyles;
		}
		
		
	//--------------------------------------
	//  Constructor
	//--------------------------------------
	
		/**
		 * Constructor.
		 */
		public function ColumnSeries(data:Object = null)
		{
			super(data);
		}
		
	//--------------------------------------
	//  Properties
	//--------------------------------------
	
		/**
		 * @private
		 */
		override public function set plotArea(value:IPlotArea):void
		{
			if(this.plotArea != value)
			{
				if(this.plotArea) unregisterSeries(this.plotArea, this);
				super.plotArea = value;
				if(this.plotArea)
				{
					if(!(this.plotArea is CartesianChart))
					{
						throw new Error("Objects of type ColumnSeries may only be added to a CartesianChart.");
					}
					registerSeries(this.plotArea, this);
				}
			}
		}
		
	//--------------------------------------
	//  Public Methods
	//--------------------------------------
	
		/**
		 * @copy com.yahoo.charts.ISeries#clone()
		 */
		override public function clone():ISeries
		{
			var series:ColumnSeries = new ColumnSeries();
			if(this.dataProvider is Array)
			{
				//copy the array rather than pass it by reference
				series.dataProvider = (this.dataProvider as Array).concat();
			}
			else if(this.dataProvider is XMLList)
			{
				series.dataProvider = (this.dataProvider as XMLList).copy();
			}
			series.displayName = this.displayName;
			series.horizontalField = this.horizontalField;
			series.verticalField = this.verticalField;
			
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
			super.draw();
			
			this.graphics.clear();
			
			//if we don't have data, let's get out of here
			if(!this.dataProvider) return;
			
			this.graphics.lineStyle(1, 0x0000ff);
			
			var cartesianChart:CartesianChart = this.plotArea as CartesianChart;
			
			//grab the axes
			var valueAxis:NumericAxis = cartesianChart.verticalAxis as NumericAxis;
			var categoryAxis:CategoryAxis = cartesianChart.horizontalAxis as CategoryAxis;
			if(!categoryAxis)
			{
				throw new Error("To use a ColumnSeries object, the horizontal axis of the chart it appears within must be a CategoryAxis.");
			}
			
			//variables we need in the loop (and shouldn't look up a gazillion times)
			var originPosition:Number = valueAxis.valueToLocal(valueAxis.origin);
			var columnCount:int = getSeriesCount(this.plotArea);
			var seriesIndex:int = seriesToIndex(this.plotArea, this);
			var markerSize:Number = this.getStyleValue("markerSize") as Number;
			var fillColor:uint = this.getStyleValue("fillColor") as uint;
			var maximumMarkerSize:Number = (this.width / categoryAxis.categoryNames.length) / columnCount;
			markerSize = Math.min(maximumMarkerSize, markerSize);
			
			var itemCount:int = this.length;
			for(var i:int = 0; i < itemCount; i++)
			{
				var item:Object = this.dataProvider[i];
				var position:Point = cartesianChart.dataToLocal(item, this);
				
				var marker:DisplayObject = this.markers[i] as DisplayObject;
				marker.width = markerSize;
				//the x position is offset from the center to accomodate multiple columns.
				marker.x = position.x - (marker.width * columnCount / 2) + marker.width * seriesIndex; //markers should be the same width
				marker.y = position.y;
				
				// if we have a bad position, don't display the marker
				marker.visible = !isNaN(position.x) && !isNaN(position.y);
				
				var calculatedHeight:Number = originPosition - marker.y;
				if(calculatedHeight < 0)
				{
					calculatedHeight = Math.abs(calculatedHeight);
					marker.y = originPosition;
				}
				marker.height = calculatedHeight;
				
				if(marker is IProgrammaticSkin)
				{
					(marker as IProgrammaticSkin).fillColor = fillColor;
				}
				
				if(marker is UIComponent) 
				{
					(marker as UIComponent).drawNow();
				}
			}
		}
		
	}
}