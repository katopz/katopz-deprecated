/*
Copyright (c) 2007, Yahoo! Inc. All rights reserved.
Code licensed under the BSD License:
http://developer.yahoo.com/flash/license.html
*/
package com.yahoo.astra.fl.charts
{
	import com.yahoo.astra.fl.charts.series.BarSeries;
	
	/**
	 * A chart that displays its data points with horizontal bars.
	 * 
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9
	 * @author Josh Tynjala
	 */
	public class BarChart extends CartesianChart
	{
		
	//--------------------------------------
	//  Class Variables
	//--------------------------------------
		
		/**
		 * @private
		 */
		private static var defaultStyles:Object = 
			{	
				showHorizontalAxisGridLines: true,
				showHorizontalAxisTicks: true,
				showHorizontalAxisMinorTicks: true,
				showVerticalAxisGridLines: false,
				showVerticalAxisTicks: false,
				showVerticalAxisMinorTicks: false,
				seriesMarkerSizes: [18] //make the markers a bit wider than other charts
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
			return mergeStyles(defaultStyles, CartesianChart.getStyleDefinition());
		}
		
	//--------------------------------------
	//  Constructor
	//--------------------------------------
	
		/**
		 * Constructor.
		 */
		public function BarChart()
		{
			super();
			this.defaultSeriesType = BarSeries;
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
			
			var numericAxis:NumericAxis = new NumericAxis();
			this.horizontalAxis = numericAxis;
			
			var categoryAxis:CategoryAxis = new CategoryAxis();
			this.verticalAxis = categoryAxis;
		}
	}
}
