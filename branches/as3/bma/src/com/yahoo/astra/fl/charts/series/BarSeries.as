/*
Copyright (c) 2007, Yahoo! Inc. All rights reserved.
Code licensed under the BSD License:
http://developer.yahoo.com/flash/license.html
*/
package com.yahoo.astra.fl.charts.series
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import fl.core.UIComponent;
	import com.yahoo.astra.fl.charts.*;
	import com.yahoo.astra.fl.charts.skins.RectangleSkin;
	import com.yahoo.astra.fl.charts.skins.IProgrammaticSkin;

	/**
	 * Renders data points as a series of horizontal bars.
	 * 
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9
	 * @author Josh Tynjala
	 */
	public class BarSeries extends CartesianSeries
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
		 * When a BarSeries is added to a IPlotArea, it should be registered with that IPlotArea.
		 * This allows it to determine proper positioning since bar positions depend on other bars.
		 */
		private static function registerSeries(plotArea:IPlotArea, series:BarSeries):void
		{
			var bars:Array = seriesInPlotAreas[plotArea];
			if(!bars)
			{
				bars = [];
				seriesInPlotAreas[plotArea] = bars;
			}
			
			bars.push(series);
		}
		
		/**
		 * @private
		 * When a BarSeries is removed from its parent IPlotArea, it should be unregistered.
		 */
		private static function unregisterSeries(plotArea:IPlotArea, series:BarSeries):void
		{
			var bars:Array = seriesInPlotAreas[plotArea];
			if(bars)
			{
				var index:int = bars.indexOf(series);
				if(index >= 0) bars.splice(index, 1);
			}
		}
		
		/**
		 * @private
		 * Returns the number of BarSeries objects appearing in a particular IPlotArea.
		 * This value may be used to determine the position of the series.
		 */
		private static function getSeriesCount(plotArea:IPlotArea):int
		{
			var bars:Array = seriesInPlotAreas[plotArea];
			if(bars) return bars.length;
			return 0;
		}
		
		/**
		 * @private
		 * Returns the index of a BarSeries within an IPlotArea.
		 * This value may be used to determine the position of the series.
		 */
		private static function seriesToIndex(plotArea:IPlotArea, series:BarSeries):int
		{
			var bars:Array = seriesInPlotAreas[plotArea];
			if(bars)
			{
				return bars.indexOf(series);
			}
			return -1;
		}
		
		/**
		 * @private
		 * Returns the BarSeries at the specified index within an IPlotArea.
		 */
		private static function indexToSeries(plotArea:IPlotArea, index:int):BarSeries
		{
			var bars:Array = seriesInPlotAreas[plotArea];
			if(bars)
			{
				return bars[index];
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
		public function BarSeries(data:Object = null)
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
						throw new Error("Objects of type BarSeries may only be added to a CartesianChart.");
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
			var series:BarSeries = new BarSeries();
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
			
			//we know our chart is a cartesian chart. if it isn't we'll have thrown an error!
			var cartesianChart:CartesianChart = this.plotArea as CartesianChart;
			
			//detect the axes (one must be numeric)
			var numericAxis:NumericAxis = cartesianChart.horizontalAxis as NumericAxis;
			var categoryAxis:CategoryAxis = cartesianChart.verticalAxis as CategoryAxis;
			if(!categoryAxis)
			{
				throw new Error("To use a BarSeries object, the vertical axis of the chart it appears within must be a CategoryAxis.");
			}
			
			//variables we need in the loop (and shouldn't look up a gazillion times)
			var originPosition:Number = numericAxis.valueToLocal(numericAxis.origin);
			var barCount:int = getSeriesCount(this.plotArea);
			var seriesIndex:int = seriesToIndex(this.plotArea, this);
			var markerSize:Number = this.getStyleValue("markerSize") as Number;
			var fillColor:uint = this.getStyleValue("fillColor") as uint;
			var maximumMarkerSize:Number = this.height / categoryAxis.categoryNames.length / barCount;
			markerSize = Math.min(maximumMarkerSize, markerSize);
			
			var itemCount:int = this.length;
			for(var i:int = 0; i < itemCount; i++)
			{
				var item:Object = this.dataProvider[i];
				
				var position:Point = cartesianChart.dataToLocal(item, this);
				
				var marker:DisplayObject = this.markers[i] as DisplayObject;
				marker.height = markerSize;
				marker.x = position.x;
				//the y position is offset from the center to accomodate multiple bars.
				marker.y = position.y - (marker.height * barCount / 2) + marker.height * seriesIndex; //markers should be the same height
				
				// if we have a bad position, don't display the marker
				marker.visible = !isNaN(position.x) && !isNaN(position.y);
				
				var calculatedWidth:Number = originPosition - marker.x;
				if(calculatedWidth < 0)
				{
					calculatedWidth = Math.abs(calculatedWidth);
					marker.x = originPosition;
				}
				marker.width = calculatedWidth;
				
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