/*
Copyright (c) 2007, Yahoo! Inc. All rights reserved.
Code licensed under the BSD License:
http://developer.yahoo.com/flash/license.html
*/
package com.yahoo.astra.fl.charts
{
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.ColorTransform;
	import flash.events.Event;
	import flash.display.DisplayObject;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import fl.core.UIComponent;
	import fl.core.InvalidationType;
	import com.yahoo.astra.fl.charts.series.CartesianSeries;
	
	//--------------------------------------
	//  Styles
	//--------------------------------------
	
	//-- Vertical Axis

	/**
	 * The line weight, in pixels, for the vertical axis.
	 *
	 * @default 1
	 */
	[Style(name="verticalAxisWeight", type="int")]

	/**
	 * The line color for the vertical axis.
	 *
	 * @default #888a85
	 */
	[Style(name="verticalAxisColor", type="uint")]

	/**
	 * If the vertical axis has major or minor units, and snapToUnits is true,
	 * the labels, ticks, gridlines, and other objects will snap to the nearest
	 * major or minor unit, respectively.
	 *
	 * @default true
	 */
	[Style(name="verticalAxisSnapToUnits", type="Boolean")]

    //-- Labels - Vertical Axis

	/**
	 * If true, labels will be displayed on the vertical axis.
	 *
	 * @default true
	 */
	[Style(name="showVerticalAxisLabels", type="Boolean")]

	/**
	 * If true, labels that overlap previously drawn labels on the vertical axis will be hidden.
	 *
	 * @default true
	 */
	[Style(name="hideVerticalAxisOverlappingLabels", type="Boolean")]

	/**
	 * The distance, in pixels, between a label and the vertical axis.
	 *
	 * @default 2
	 */
	[Style(name="verticalAxisLabelDistance", type="Number")]

    //-- Grid Lines - Vertical Axis

	/**
	 * If true, grid lines will be displayed on the vertical axis.
	 *
	 * @default false
	 */
	[Style(name="showVerticalAxisGridLines", type="Boolean")]

	/**
	 * The line weight, in pixels, for the grid lines on the vertical axis.
	 *
	 * @default 1
	 */
	[Style(name="verticalAxisGridLineWeight", type="int")]

	/**
	 * The line color for the grid lines on the vertical axis.
	 *
	 * @default #babdb6
	 */
	[Style(name="verticalAxisGridLineColor", type="uint")]

    //-- Minor Grid Lines - Vertical Axis

	/**
	 * If true, minor grid lines will be displayed on the vertical axis.
	 *
	 * @default false
	 */
	[Style(name="showVerticalAxisMinorGridLines", type="Boolean")]

	/**
	 * The line weight, in pixels, for the minor grid lines on the vertical axis.
	 *
	 * @default 1
	 */
	[Style(name="verticalAxisMinorGridLineWeight", type="int")]

	/**
	 * The line color for the minor grid lines on the vertical axis.
	 *
	 * @default #eeeeec
	 */
	[Style(name="verticalAxisMinorGridLineColor", type="uint")]

	//-- Ticks - Vertical Axis

	/**
	 * If true, ticks will be displayed on the vertical axis.
	 *
	 * @default true
	 */
	[Style(name="showVerticalAxisTicks", type="Boolean")]

	/**
	 * The line weight, in pixels, for the ticks on the vertical axis.
	 *
	 * @default 1
	 */
	[Style(name="verticalAxisTickWeight", type="int")]

	/**
	 * The line color for the ticks on the vertical axis.
	 *
	 * @default #888a85
	 */
	[Style(name="verticalAxisTickColor", type="uint")]

	/**
	 * The length, in pixels, of the ticks on the vertical axis.
	 *
	 * @default 4
	 */
	[Style(name="verticalAxisTickLength", type="Number")]
	
	/**
	 * The position of the ticks on the vertical axis.
	 *
	 * @default "cross"
	 * @see com.yahoo.charts.TickPosition
	 */
	[Style(name="verticalAxisTickPosition", type="String")]

    //-- Minor ticks - Vertical Axis

	/**
	 * If true, ticks will be displayed on the vertical axis at minor positions.
	 *
	 * @default true
	 */
	[Style(name="showVerticalAxisMinorTicks", type="Boolean")]
	
	/**
	 * The line weight, in pixels, for the minor ticks on the vertical axis.
	 *
	 * @default 1
	 */
	[Style(name="verticalAxisMinorTickWeight", type="int")]

	/**
	 * The line color for the minor ticks on the vertical axis.
	 *
	 * @default #888a85
	 */
	[Style(name="verticalAxisMinorTickColor", type="uint")]

	/**
	 * The length of the minor ticks on the vertical axis.
	 *
	 * @default 3
	 */
	[Style(name="verticalAxisMinorTickLength", type="Number")]
	
	/**
	 * The position of the minor ticks on the vertical axis.
	 *
	 * @default "outside"
	 * @see com.yahoo.charts.TickPosition
	 */
	[Style(name="verticalAxisMinorTickPosition", type="String")]
	
	//-- Title - Vertical Axis
	
	/**
	 * If true, the vertical axis title will be displayed.
	 *
	 * @default 2
	 */
	[Style(name="showVerticalAxisTitle", type="Boolean")]
	
	/**
	 * The TextFormat object to use to render the vertical axis title label.
     *
     * @default TextFormat("_sans", 11, 0x000000, false, false, false, '', '', TextFormatAlign.LEFT, 0, 0, 0, 0)
	 */
	[Style(name="verticalAxisTitleTextFormat", type="TextFormat")]
	
	//-- Horizontal Axis

	/**
	 * The line weight, in pixels, for the horizontal axis.
	 *
	 * @default 1
	 */
	[Style(name="horizontalAxisWeight", type="int")]

	/**
	 * The line color for the horizontal axis.
	 *
	 * @default #888a85
	 */
	[Style(name="horizontalAxisColor", type="uint")]

	/**
	 * If the horizontal axis has major or minor units, and snapToUnits is true,
	 * the labels, ticks, gridlines, and other objects will snap to the nearest
	 * major or minor unit, respectively.
	 *
	 * @default true
	 */
	[Style(name="horizontalAxisSnapToUnits", type="Boolean")]

    //-- Labels - Horizontal Axis

	/**
	 * If true, labels will be displayed on the horizontal axis.
	 *
	 * @default true
	 */
	[Style(name="showHorizontalAxisLabels", type="Boolean")]

	/**
	 * If true, labels that overlap previously drawn labels on the horizontal axis will be hidden.
	 *
	 * @default true
	 */
	[Style(name="hideHorizontalAxisOverlappingLabels", type="Boolean")]

	/**
	 * The distance, in pixels, between a label and the horizontal axis.
	 *
	 * @default 2
	 */
	[Style(name="horizontalAxisLabelDistance", type="Number")]

    //-- Grid Lines - Horizontal Axis

	/**
	 * If true, grid lines will be displayed on the horizontal axis.
	 *
	 * @default false
	 */
	[Style(name="showHorizontalAxisGridLines", type="Boolean")]

	/**
	 * The line weight, in pixels, for the grid lines on the horizontal axis.
	 *
	 * @default 1
	 */
	[Style(name="horizontalAxisGridLineWeight", type="int")]

	/**
	 * The line color for the grid lines on the horizontal axis.
	 *
	 * @default #babdb6
	 */
	[Style(name="horizontalAxisGridLineColor", type="uint")]

    //-- Minor Grid Lines - Horizontal Axis

	/**
	 * If true, minor grid lines will be displayed on the horizontal axis.
	 *
	 * @default false
	 */
	[Style(name="showHorizontalAxisMinorGridLines", type="Boolean")]

	/**
	 * The line weight, in pixels, for the minor grid lines on the horizontal axis.
	 *
	 * @default 1
	 */
	[Style(name="horizontalAxisMinorGridLineWeight", type="int")]

	/**
	 * The line color for the minor grid lines on the horizontal axis.
	 *
	 * @default #eeeeec
	 */
	[Style(name="horizontalAxisMinorGridLineColor", type="uint")]

	//-- Ticks - Horizontal Axis

	/**
	 * If true, ticks will be displayed on the horizontal axis.
	 *
	 * @default true
	 */
	[Style(name="showHorizontalAxisTicks", type="Boolean")]

	/**
	 * The line weight, in pixels, for the ticks on the horizontal axis.
	 *
	 * @default 1
	 */
	[Style(name="horizontalAxisTickWeight", type="int")]

	/**
	 * The line color for the ticks on the horizontal axis.
	 *
	 * @default #888a85
	 */
	[Style(name="horizontalAxisTickColor", type="uint")]

	/**
	 * The length, in pixels, of the ticks on the horizontal axis.
	 *
	 * @default 4
	 */
	[Style(name="horizontalAxisTickLength", type="Number")]
	
	/**
	 * The position of the ticks on the horizontal axis.
	 *
	 * @default "cross"
	 * @see com.yahoo.charts.TickPosition
	 */
	[Style(name="horizontalAxisTickPosition", type="String")]

    //-- Minor ticks - Horizontal Axis

	/**
	 * If true, ticks will be displayed on the horizontal axis at minor positions.
	 *
	 * @default true
	 */
	[Style(name="showHorizontalAxisMinorTicks", type="Boolean")]
	
	/**
	 * The line weight, in pixels, for the minor ticks on the horizontal axis.
	 *
	 * @default 1
	 */
	[Style(name="horizontalAxisMinorTickWeight", type="int")]

	/**
	 * The line color for the minor ticks on the horizontal axis.
	 *
	 * @default #888a85
	 */
	[Style(name="horizontalAxisMinorTickColor", type="uint")]

	/**
	 * The length of the minor ticks on the horizontal axis.
	 *
	 * @default 3
	 */
	[Style(name="horizontalAxisMinorTickLength", type="Number")]
	
	/**
	 * The position of the minor ticks on the horizontal axis.
	 *
	 * @default "outside"
	 * @see com.yahoo.charts.TickPosition
	 */
	[Style(name="horizontalAxisMinorTickPosition", type="String")]
	
	//-- Title - Horizontal Axis
	
	/**
	 * If true, the horizontal axis title will be displayed.
	 *
	 * @default 2
	 */
	[Style(name="showHorizontalAxisTitle", type="Boolean")]
	
	/**
	 * The TextFormat object to use to render the horizontal axis title label.
     *
     * @default TextFormat("_sans", 11, 0x000000, false, false, false, '', '', TextFormatAlign.LEFT, 0, 0, 0, 0)
	 */
	[Style(name="horizontalAxisTitleTextFormat", type="TextFormat")]
	
	/**
	 * A chart based on the cartesian coordinate system (x, y).
	 *
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9
	 * @author Josh Tynjala
	 */
	public class CartesianChart extends Chart implements IPlotArea, ICategoryChart
	{
		
	//--------------------------------------
	//  Class Variables
	//--------------------------------------
	
		/**
		 * @private
		 */
		private static var defaultStyles:Object =
			{
				//axis
				horizontalAxisSnapToUnits: true,
				horizontalAxisWeight: 1,
				horizontalAxisColor: 0x888a85,
				
				//title
				showHorizontalAxisTitle: true,
				horizontalAxisTitleTextFormat: new TextFormat("_sans", 11, 0x000000, false, false, false, "", "", TextFormatAlign.LEFT, 0, 0, 0, 0),
				
				//labels
				showHorizontalAxisLabels: true,
				horizontalAxisLabelDistance: 2,
				hideHorizontalAxisOverlappingLabels: false,
				
				//grid lines
				horizontalAxisGridLineWeight: 1,
				horizontalAxisGridLineColor: 0xbabdb6,
				showHorizontalAxisGridLines: false,
				horizontalAxisMinorGridLineWeight: 1,
				horizontalAxisMinorGridLineColor: 0xeeeeec,
				showHorizontalAxisMinorGridLines: false,
				
				//ticks
				showHorizontalAxisTicks: false,
				horizontalAxisTickWeight: 1,
				horizontalAxisTickColor: 0x888a85,
				horizontalAxisTickLength: 4,
				horizontalAxisTickPosition: "cross",
				showHorizontalAxisMinorTicks: false,
				horizontalAxisMinorTickWeight: 1,
				horizontalAxisMinorTickColor: 0x888a85,
				horizontalAxisMinorTickLength: 3,
				horizontalAxisMinorTickPosition: "outside",
				
				//axis
				verticalAxisSnapToUnits: true,
				verticalAxisWeight: 1,
				verticalAxisColor: 0x888a85,
				
				//title
				showVerticalAxisTitle: true,
				verticalAxisTitleTextFormat: new TextFormat("_sans", 11, 0x000000, false, false, false, "", "", TextFormatAlign.LEFT, 0, 0, 0, 0),
				
				//labels
				showVerticalAxisLabels: true,
				verticalAxisLabelDistance: 2,
				hideVerticalAxisOverlappingLabels: false,
				
				//grid lines
				showVerticalAxisGridLines: true,
				verticalAxisGridLineWeight: 1,
				verticalAxisGridLineColor: 0xbabdb6,
				verticalAxisMinorGridLineWeight: 1,
				verticalAxisMinorGridLineColor: 0xeeeeec,
				showVerticalAxisMinorGridLines: false,
				
				//ticks
				showVerticalAxisTicks: true,
				verticalAxisTickWeight: 1,
				verticalAxisTickColor: 0x888a85,
				verticalAxisTickLength: 4,
				verticalAxisTickPosition: "cross",
				showVerticalAxisMinorTicks: true,
				verticalAxisMinorTickWeight: 1,
				verticalAxisMinorTickColor: 0x888a85,
				verticalAxisMinorTickLength: 3,
				verticalAxisMinorTickPosition: "outside"
			};
		
		/**
		 * @private
		 * The chart styles that correspond to styles on the horizontal axis.
		 */
		private static const HORIZONTAL_AXIS_STYLES:Object =
			{
				snapToUnits: "horizontalAxisSnapToUnits",
				axisWeight: "horizontalAxisWeight",
				axisColor: "horizontalAxisColor",
				textFormat: "textFormat",
				showTitle: "showHorizontalAxisTitle",
				titleTextFormat: "horizontalAxisTitleTextFormat",
				labelDistance: "horizontalAxisLabelDistance",
				showLabels: "showHorizontalAxisLabels",
				hideOverlappingLabels: "hideHorizontalAxisOverlappingLabels",
				gridLineWeight: "horizontalAxisGridLineWeight",
				gridLineColor: "horizontalAxisGridLineColor",
				showGridLines: "showHorizontalAxisGridLines",
				minorGridLineWeight: "horizontalAxisMinorGridLineWeight",
				minorGridLineColor: "horizontalAxisMinorGridLineColor",
				showMinorGridLines: "showHorizontalAxisMinorGridLines",
				tickWeight: "horizontalAxisTickWeight",
				tickColor: "horizontalAxisTickColor",
				tickLength: "horizontalAxisTickLength",
				tickPosition: "horizontalAxisTickPosition",
				showTicks: "showHorizontalAxisTicks",
				minorTickWeight: "horizontalAxisMinorTickWeight",
				minorTickColor: "horizontalAxisMinorTickColor",
				minorTickLength: "horizontalAxisMinorTickLength",
				minorTickPosition: "horizontalAxisMinorTickPosition",
				showMinorTicks: "showHorizontalAxisMinorTicks"
			};
		
		/**
		 * @private
		 * The chart styles that correspond to styles on the vertical axis.
		 */
		private static const VERTICAL_AXIS_STYLES:Object =
			{
				snapToUnits: "verticalAxisSnapToUnits",
				axisWeight: "verticalAxisWeight",
				axisColor: "verticalAxisColor",
				textFormat: "textFormat",
				showTitle: "showVerticalAxisTitle",
				titleTextFormat: "verticalAxisTitleTextFormat",
				labelDistance: "verticalAxisLabelDistance",
				showLabels: "showVerticalAxisLabels",
				hideOverlappingLabels: "hideVerticalAxisOverlappingLabels",
				gridLineWeight: "verticalAxisGridLineWeight",
				gridLineColor: "verticalAxisGridLineColor",
				showGridLines: "showVerticalAxisGridLines",
				minorGridLineWeight: "verticalAxisMinorGridLineWeight",
				minorGridLineColor: "verticalAxisMinorGridLineColor",
				showMinorGridLines: "showVerticalAxisMinorGridLines",
				tickWeight: "verticalAxisTickWeight",
				tickColor: "verticalAxisTickColor",
				tickLength: "verticalAxisTickLength",
				tickPosition: "verticalAxisTickPosition",
				showTicks: "showVerticalAxisTicks",
				minorTickWeight: "verticalAxisMinorTickWeight",
				minorTickColor: "verticalAxisMinorTickColor",
				minorTickLength: "verticalAxisMinorTickLength",
				minorTickPosition: "verticalAxisMinorTickPosition",
				showMinorTicks: "showVerticalAxisMinorTicks"
			};
		
	//--------------------------------------
	//  Class Methods
	//--------------------------------------
	
		/**
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
		public function CartesianChart()
		{
			super();
		}
		
	//--------------------------------------
	//  Properties
	//--------------------------------------
		
		/**
		 * @private
		 */
		protected var horizontalGridLines:Sprite;
		
		/**
		 * @private
		 */
		protected var horizontalMinorGridLines:Sprite;
		
		/**
		 * @private
		 */
		protected var verticalGridLines:Sprite;
		
		/**
		 * @private
		 */
		protected var verticalMinorGridLines:Sprite;
		
		/**
		 * @private
		 * Storage for the horizontalAxis property.
		 */
		private var _horizontalAxis:IAxis;
		
		/**
		 * The axis representing the horizontal range.
		 */
		public function get horizontalAxis():IAxis
		{
			return this._horizontalAxis;
		}
		
		/**
		 * @private
		 */
		public function set horizontalAxis(axis:IAxis):void
		{
			if(this._horizontalAxis != axis)
			{
				//remove the old horizontal axis and any related grid lines
				if(this._horizontalAxis)
				{
					if(this.horizontalGridLines)
					{
						this.removeChild(this.horizontalGridLines);
						this.horizontalGridLines = null;
					}
						
					if(this.horizontalMinorGridLines)
					{
						this.removeChild(this.horizontalMinorGridLines);
						this.horizontalMinorGridLines = null;
					}
					this.removeChild(DisplayObject(this._horizontalAxis));
				}
				this._horizontalAxis = axis;
				
				if(this._horizontalAxis)
				{
					this._horizontalAxis.plotArea = this;
					this._horizontalAxis.orientation = AxisOrientation.HORIZONTAL;
				
					var horizontalAxis:UIComponent = this._horizontalAxis as UIComponent;
					if(horizontalAxis.hasOwnProperty("gridLines"))
					{
						this.horizontalGridLines = new Sprite();
						this.horizontalGridLines.mouseEnabled = false;
						this.addChild(this.horizontalGridLines);
						horizontalAxis["gridLines"] = this.horizontalGridLines;
					}
					
					if(horizontalAxis.hasOwnProperty("minorGridLines"))
					{
						this.horizontalMinorGridLines = new Sprite();
						this.horizontalMinorGridLines.mouseEnabled = false;
						this.addChild(this.horizontalMinorGridLines);
						horizontalAxis["minorGridLines"] = this.horizontalMinorGridLines;
					}
					this.addChild(horizontalAxis);
				}
				
				this.invalidate();
			}
		}
		
		/**
		 * @private
		 * Storage for the verticalAxis property.
		 */
		private var _verticalAxis:IAxis;
		
		/**
		 * The axis representing the vertical range.
		 */
		public function get verticalAxis():IAxis
		{
			return this._verticalAxis;
		}
		
		/**
		 * @private
		 */
		public function set verticalAxis(axis:IAxis):void
		{
			if(this._verticalAxis != axis)
			{
				if(this._verticalAxis)
				{
					if(this.verticalGridLines)
					{
						this.removeChild(this.verticalGridLines);
						this.verticalGridLines = null;
					}
						
					if(this.verticalMinorGridLines)
					{
						this.removeChild(this.verticalMinorGridLines);
						this.verticalMinorGridLines = null;
					}

					this.removeChild(DisplayObject(this._verticalAxis))
				}
				this._verticalAxis = axis;
				this._verticalAxis.plotArea = this;
				this._verticalAxis.orientation = AxisOrientation.VERTICAL;
				
				if(this._verticalAxis)
				{
					var verticalAxis:UIComponent = this._verticalAxis as UIComponent;
					
					if(verticalAxis.hasOwnProperty("gridLines"))
					{
						this.verticalGridLines = new Sprite();
						this.verticalGridLines.mouseEnabled = false;
						this.addChild(this.verticalGridLines);
						verticalAxis["gridLines"] = this.verticalGridLines;
					}
					if(verticalAxis.hasOwnProperty("minorGridLines"))
					{
						this.verticalMinorGridLines = new Sprite();
						this.verticalMinorGridLines.mouseEnabled = false;
						this.addChild(this.verticalMinorGridLines);
						verticalAxis["minorGridLines"] = this.verticalMinorGridLines;
					}
					this.addChild(verticalAxis);
				}
				
				this.invalidate();
			}
		}
	
	//-- Data
		
		/**
		 * @private
		 * Storage for the horizontalField property.
		 */
		private var _horizontalField:String = "category";
		
		[Inspectable(defaultValue="category",verbose=1)]
		/**
		 * If the items displayed on the chart are complex objects, the horizontalField string
		 * defines the property to access when determining the x value.
		 */
		public function get horizontalField():String
		{
			return this._horizontalField;
		}
		
		/**
		 * @private
		 */
		public function set horizontalField(value:String):void
		{
			if(this._horizontalField != value)
			{
				this._horizontalField = value;
				this.invalidate();
			}
		}
		
		/**
		 * @private
		 * Storage for the verticalField property.
		 */
		private var _verticalField:String = "value";
		
		[Inspectable(defaultValue="value",verbose=1)]
		/**
		 * If the items displayed on the chart are complex objects, the verticalField string
		 * defines the property to access when determining the y value.
		 */
		public function get verticalField():String
		{
			return this._verticalField;
		}
		
		/**
		 * @private
		 */
		public function set verticalField(value:String):void
		{
			if(this._verticalField != value)
			{
				this._verticalField = value;
				this.invalidate();
			}
		}
		
	//-- Titles
		
		/**
		 * @private
		 * Storage for the horizontalAxisTitle property.
		 */
		private var _horizontalAxisTitle:String = "";
		
		[Inspectable(defaultValue="")]
		/**
		 * The title text displayed on the horizontal axis.
		 */
		public function get horizontalAxisTitle():String
		{
			return this._horizontalAxisTitle;
		}
		
		/**
		 * @private
		 */
		public function set horizontalAxisTitle(value:String):void
		{
			if(this._horizontalAxisTitle != value)
			{
				this._horizontalAxisTitle = value;
				this.invalidate();
			}
		}
		
		/**
		 * @private
		 * Storage for the verticalAxisTitle property.
		 */
		private var _verticalAxisTitle:String = "";
		
		[Inspectable(defaultValue="")]
		/**
		 * The title text displayed on the horizontal axis.
		 */
		public function get verticalAxisTitle():String
		{
			return this._verticalAxisTitle;
		}
		
		/**
		 * @private
		 */
		public function set verticalAxisTitle(value:String):void
		{
			if(this._verticalAxisTitle != value)
			{
				this._verticalAxisTitle = value;
				this.invalidate();
			}
		}
		
	//-- Category names
		
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
		
		/**
		 * @private
		 * Storage for the overflowEnabled property.
		 */
		private var _overflowEnabled:Boolean = false;
		
		[Inspectable(defaultValue=false,verbose=1)]
		/**
		 * If false, which is the default, the axes will be resized to fit within the defined
		 * bounds of the plot area. However, if set to true, the axes themselves will grow to
		 * fit the plot area bounds and the labels and other items that normally cause the
		 * resize will be drawn outside.
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
		
	//--------------------------------------
	//  Public Methods
	//--------------------------------------
	
		/**
		 * @copy com.yahoo.charts.IPlotArea@axisToField()
		 */
		public function axisToField(axis:IAxis):String
		{
			if(axis == this.horizontalAxis) return this.horizontalField;
			else if(axis == this.verticalAxis) return this.verticalField;
			return null;
		}
		
		/**
		 * @copy com.yahoo.charts.IPlotArea@axisAndSeriesToField()
		 */
		public function axisAndSeriesToField(axis:IAxis, series:ISeries):String
		{
			var cartesianSeries:CartesianSeries = series as CartesianSeries;
			var field:String = this.axisToField(axis);
			if(axis.orientation == AxisOrientation.VERTICAL && cartesianSeries.verticalField)
			{
				field = cartesianSeries.verticalField;
			}
			else if(axis.orientation == AxisOrientation.HORIZONTAL && cartesianSeries.horizontalField)
			{
				field = cartesianSeries.horizontalField;
			}
			
			return field;
		}
		
		/**
		 * @copy com.yahoo.charts.IPlotArea@fieldToAxis()
		 */
		public function fieldToAxis(field:String):IAxis
		{
			if(field == this.horizontalField) return this.horizontalAxis;
			else if(field == this.verticalField) return this.verticalAxis;
			return null;
		}
	
		/**
		 * Returns the index within this plot area of the input ISeries object.
		 *
		 * @param series	a series that is displayed in this plot area.
		 * @return			the index of the input series
		 */
		public function seriesToIndex(series:ISeries):int
		{
			return this.series.indexOf(series);
		}
		
		/**
		 * Returns the ISeries object at the specified index.
		 *
		 * @param index		the index of the series to return
		 * @return			the series that appears at the input index or null if out of bounds
		 */
		public function indexToSeries(index:int):ISeries
		{
			if(index < 0 || index >= this.series.length) return null;
			return this.series[index];
		}
	
		/**
		 * @copy com.yahoo.charts.IPlotArea#dataToLocal()
		 */
		public function dataToLocal(data:Object, series:ISeries):Point
		{
			var horizontalField:String = this.axisAndSeriesToField(this.horizontalAxis, series);
			var horizontalValue:Object = data[horizontalField];
			var xPosition:Number = this._horizontalAxis.valueToLocal(horizontalValue);
			
			var verticalField:String = this.axisAndSeriesToField(this.verticalAxis, series);
			var verticalValue:Object = data[verticalField];
			var yPosition:Number = this._verticalAxis.valueToLocal(verticalValue);
			
			return new Point(xPosition, yPosition);
		}
		
		public function getVerticalValue(data:Object, series:ISeries):Object
		{
			var horizontalField:String = this.axisAndSeriesToField(this.horizontalAxis, series);
			var horizontalValue:Object = data[horizontalField];
			var xPosition:Number = this._horizontalAxis.valueToLocal(horizontalValue);
			
			var verticalField:String = this.axisAndSeriesToField(this.verticalAxis, series);
			var verticalValue:Object = data[verticalField];
			var yPosition:Number = this._verticalAxis.valueToLocal(verticalValue);
			
			return verticalValue;
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
			
			this.drawAxes();
			
			//the series display objects are dependant on the axes, so all series redraws must
			//happen after the axes have redrawn
			this.drawSeries();
		}
		
		/**
		 * @private
		 * Make sure no numeric points exist. Convert to objects compatible with the axes.
		 */
		override protected function refreshSeries():void
		{
			super.refreshSeries();
			
			var numericAxis:IAxis = this.horizontalAxis;
			var otherAxis:IAxis = this.verticalAxis;
			if(this.verticalAxis is NumericAxis)
			{
				numericAxis = this.verticalAxis;
				otherAxis = this.horizontalAxis;
			}
						
			var seriesCount:int = this.series.length;
			for(var i:int = 0; i < seriesCount; i++)
			{
				var currentSeries:ISeries = this.series[i] as ISeries;
				
				var numericField:String = this.axisAndSeriesToField(numericAxis, currentSeries);
				var otherField:String = this.axisAndSeriesToField(otherAxis, currentSeries);
				
				var seriesLength:int = currentSeries.length;
				for(var j:int = 0; j < seriesLength; j++)
				{
					var item:Object = currentSeries.dataProvider[j];
					if(!isNaN(Number(item)))
					{
						//if we only have a number, then it is safe to convert
						//to a default type for a category chart.
						//if it's not a number, then the user is expected to update
						//the x and y fields so that the plot area knows how to handle it.
						var point:Object = {};
						point[numericField] = item;
						point[otherField] = j; //we assume it's a category axis
						currentSeries.dataProvider[j] = point;
					}
				}
			}
		}
	
		/**
		 * @private
		 * Positions and updates the series objects.
		 */
		protected function drawSeries():void
		{
			var contentPadding:Number = this.getStyleValue("contentPadding") as Number;
			var seriesWidth:Number = this._contentBounds.width;
			var seriesHeight:Number = this._contentBounds.height;
			
			var contentScrollRect:Rectangle = new Rectangle(0, 0, seriesWidth, seriesHeight);
			this.content.x = contentPadding + this._contentBounds.x;
			this.content.y = contentPadding + this._contentBounds.y;
			this.content.scrollRect = contentScrollRect;
			
			var seriesCount:int = this.series.length;
			for(var i:int = 0; i < seriesCount; i++)
			{
				var series:UIComponent = this.series[i] as UIComponent;
				series.width = seriesWidth;
				series.height = seriesHeight;
				series.drawNow();
			}
		}
		
		/**
		 * @private
		 * Positions and sizes the axes based on their edge metrics.
		 */
		protected function drawAxes():void
		{
			var contentPadding:Number = this.getStyleValue("contentPadding") as Number;
			var axisWidth:Number = this.width - (2 * contentPadding);
			var axisHeight:Number = this.height - (2 * contentPadding);
			
			var horizontalAxis:UIComponent = this._horizontalAxis as UIComponent;
			horizontalAxis.move(contentPadding, contentPadding);
			horizontalAxis.width = axisWidth;
			horizontalAxis.height = axisHeight;
			this._horizontalAxis.overflowEnabled = this.overflowEnabled;
			this._horizontalAxis.title = this.horizontalAxisTitle;
			this.setChildIndex(horizontalAxis, this.numChildren - 1);
			if(horizontalAxis is CategoryAxis && this._categoryNames && this._categoryNames.length > 0)
			{
				(this.horizontalAxis as CategoryAxis).categoryNames = this._categoryNames;
			}
			this.copyStylesToChild(horizontalAxis, CartesianChart.HORIZONTAL_AXIS_STYLES);
						
			var verticalAxis:UIComponent = this._verticalAxis as UIComponent;
			verticalAxis.move(contentPadding, contentPadding);
			verticalAxis.width = axisWidth;
			verticalAxis.height = axisHeight;
			this._verticalAxis.overflowEnabled = this.overflowEnabled;
			this._verticalAxis.title = this.verticalAxisTitle;
			this.setChildIndex(verticalAxis, this.numChildren - 1);
			if(verticalAxis is CategoryAxis && this._categoryNames && this._categoryNames.length > 0)
			{
				(this.verticalAxis as CategoryAxis).categoryNames = this._categoryNames;
			}
			this.copyStylesToChild(verticalAxis, CartesianChart.VERTICAL_AXIS_STYLES);
			
			this.updateAxisScalesAndBounds();
			
			this.drawGridLines();
				
			//force the redraw now so that we get the correct series positioning
			horizontalAxis.drawNow();
			verticalAxis.drawNow();
		}
		
		/**
		 * @private
		 * Determines the axis scales, and positions the axes based on their
		 * <code>contentBounds</code> properties.
		 */
		protected function updateAxisScalesAndBounds():void
		{
			var limitedData:Array = [];
			var seriesCount:int = this.series.length;
			for(var i:int = 0; i < seriesCount; i++)
			{
				limitedData.push(this.series[i].clone());
			}
			
			//when the scale is updated on each axis, the data set may change.
			//update the axis scales until the data stabilizes.
			do
			{
				var oldData:Array = limitedData;
				limitedData = this._horizontalAxis.updateScale(limitedData);
				limitedData = this._verticalAxis.updateScale(limitedData);
			}
			while(!this.dataSetsAreEqual(oldData, limitedData))
			
			//update the bounds twice to catch all changes
			this.calculateContentBounds();
			this.calculateContentBounds();
		}
		
		/**
		 * @private
		 * Combine the content bounds to determine the series positioning.
		 */
		protected function calculateContentBounds():void
		{
			this.horizontalAxis.updateBounds();
			this.verticalAxis.updateBounds();
			
			var contentPadding:Number = this.getStyleValue("contentPadding") as Number;
			var axisWidth:Number = this.width - (2 * contentPadding);
			var axisHeight:Number = this.height - (2 * contentPadding);
			
			var horizontalAxis:UIComponent = this._horizontalAxis as UIComponent;
			var verticalAxis:UIComponent = this._verticalAxis as UIComponent;
			
			var horizontalBounds:Rectangle = this._horizontalAxis.contentBounds;
			var verticalBounds:Rectangle = this._verticalAxis.contentBounds;
			
			this._contentBounds = new Rectangle();
		
			this._contentBounds.x = Math.max(horizontalBounds.x, verticalBounds.x);
			this._contentBounds.y = Math.max(horizontalBounds.y, verticalBounds.y);
			this._contentBounds.width = Math.min(horizontalBounds.width, verticalBounds.width);
			this._contentBounds.height = Math.min(horizontalBounds.height, verticalBounds.height);
			
			var hRight:Number = horizontalAxis.width - horizontalBounds.width - horizontalBounds.x;
			var hBottom:Number = horizontalAxis.height - horizontalBounds.height - horizontalBounds.y;
			var vRight:Number = verticalAxis.width - verticalBounds.width - verticalBounds.x;
			var vBottom:Number = verticalAxis.height - verticalBounds.height - verticalBounds.y;
			
			horizontalAxis.x = contentPadding + this._contentBounds.x - horizontalBounds.x;
			horizontalAxis.y = contentPadding + this._contentBounds.y - horizontalBounds.y;
			horizontalAxis.width = axisWidth - Math.max(0, vRight - hRight) - (this._contentBounds.x - horizontalBounds.x);
			horizontalAxis.height = axisHeight - Math.max(0, vBottom - hBottom) - (this._contentBounds.y - horizontalBounds.y);
			
			verticalAxis.x = contentPadding + this._contentBounds.x - verticalBounds.x;
			verticalAxis.y = contentPadding + this._contentBounds.y - verticalBounds.y;
			verticalAxis.width = axisWidth - Math.max(0, hRight - vRight) - (this._contentBounds.x - verticalBounds.x);
			verticalAxis.height = axisHeight - Math.max(0, hBottom - vBottom) - (this._contentBounds.y - verticalBounds.y);
		}
		
		/**
		 * @private
		 * Draws the axis grid lines, if they exist.
		 */
		protected function drawGridLines():void
		{
			var contentPadding:Number = this.getStyleValue("contentPadding") as Number;
			var horizontalAxis:UIComponent = this._horizontalAxis as UIComponent;
			var verticalAxis:UIComponent = this._verticalAxis as UIComponent;
			
			var index:int = 0;
			if(this.background) index++;
			
			//add and update the grid lines
			if(horizontalAxis.hasOwnProperty("minorGridLines") && this.horizontalMinorGridLines)
			{
				this.setChildIndex(this.horizontalMinorGridLines, index++);
				this.horizontalMinorGridLines.x = contentPadding + this.contentBounds.x;
				this.horizontalMinorGridLines.y = contentPadding + this.contentBounds.y;
			}
			
			if(verticalAxis.hasOwnProperty("minorGridLines") && this.verticalMinorGridLines)
			{
				this.setChildIndex(this.verticalMinorGridLines, index++);
				this.verticalMinorGridLines.x = contentPadding + this.contentBounds.x;
				this.verticalMinorGridLines.y = contentPadding + this.contentBounds.y;
			}
			
			if(horizontalAxis.hasOwnProperty("gridLines") && this.horizontalGridLines)
			{
				this.setChildIndex(this.horizontalGridLines, index++);
				this.horizontalGridLines.x = contentPadding + this.contentBounds.x;
				this.horizontalGridLines.y = contentPadding + this.contentBounds.y;
			}
			
			if(verticalAxis.hasOwnProperty("gridLines") && this.verticalGridLines)
			{
				this.setChildIndex(this.verticalGridLines, index++);
				this.verticalGridLines.x = contentPadding + this.contentBounds.x;
				this.verticalGridLines.y = contentPadding + this.contentBounds.y;
			}
		}
		
		/**
		 * @private
		 * Creates the default axes. Without user intervention, the x-axis is a category
		 * axis and the y-axis is a numeric axis.
		 */
		override protected function configUI():void
		{
			super.configUI();
			
			//by default, the x axis is for categories. other types of charts will need
			//to override this if they need a numeric or other type of axis
			if(!this.horizontalAxis)
			{
				var categoryAxis:CategoryAxis = new CategoryAxis();
				this.horizontalAxis = categoryAxis;
			}
			
			if(!this.verticalAxis)
			{
				var numericAxis:NumericAxis = new NumericAxis();
				//invert the labels on the y-axis so that the minimum value is at the bottom
				numericAxis.reverse = true;
				this.verticalAxis = numericAxis;
			}
		}
		
		/**
		 * @private
		 * Determines the text that will appear on the data tip.
		 */
		override protected function defaultDataTipFunction(item:Object, index:int, series:ISeries):String
		{
			var text:String = super.defaultDataTipFunction(item, index, series);
			if(text.length > 0) text += "\n";
			
			//if we have a category axis, display the category
			var categoryAxis:CategoryAxis = this.verticalAxis as CategoryAxis;
			var otherAxis:IAxis = this.horizontalAxis;
			if(!categoryAxis)
			{
				categoryAxis = this.horizontalAxis as CategoryAxis;
				otherAxis = this.verticalAxis;
			}
			if(categoryAxis)
			{
				//if we have a category field, use that value
				/*var categoryField:String = this.axisAndSeriesToField(categoryAxis, series);
				if(item.hasOwnProperty(categoryField))
				{
					text += item[categoryField];
				}
				//worse case, use the index
				else text += index;*/
				text += categoryAxis.valueToLabel(index) + "\n";
				
				var otherField:String = this.axisAndSeriesToField(otherAxis, series);
				if(item.hasOwnProperty(otherField))
				{
					text += otherAxis.valueToLabel(item[otherField]);
				}
			}
			else
			{
				var verticalField:String = this.axisAndSeriesToField(this.verticalAxis, series);
				var horizontalField:String = this.axisAndSeriesToField(this.horizontalAxis, series);
				if(item.hasOwnProperty(verticalField))
				{
					//text += item[verticalField] + "\n";
					text += verticalAxis.valueToLabel(item[verticalField]) + "\n";
				}
				if(item.hasOwnProperty(horizontalField))
				{
					//text += item[horizontalField] + "\n";
					text += horizontalAxis.valueToLabel(item[horizontalField]) + "\n";
				}
				
			}
			return text;
		}
		
	//--------------------------------------
	//  Private Methods
	//--------------------------------------
	
		/**
		 * @private
		 * Checks to see if two data sets contain the same set of ISeries objects.
		 */
		private function dataSetsAreEqual(data1:Array, data2:Array):Boolean
		{
			//quick check to see if the length is equal
			if(data1.length != data2.length) return false;
			
			var seriesCount:int = data1.length;
			for(var i:int = 0; i < seriesCount; i++)
			{
				var series1:ISeries = data1[i];
				var series2:ISeries = data2[i];
				
				//quick check to see if the length is equal
				if(series1.length != series2.length) return false;
				
				var seriesLength:int = series1.length;
				for(var j:int = 0; j < seriesLength; j++)
				{
					var item1:Object = series1.dataProvider[j];
					var item2:Object = series2.dataProvider[j];
					if(item1 != item2) return false;
				}
			}
			return true;
		}
	}
}
