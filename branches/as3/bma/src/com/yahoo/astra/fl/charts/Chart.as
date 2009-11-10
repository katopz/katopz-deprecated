/*
Copyright (c) 2007, Yahoo! Inc. All rights reserved.
Code licensed under the BSD License:
http://developer.yahoo.com/flash/license.html
*/
package com.yahoo.astra.fl.charts
{
	import flash.accessibility.AccessibilityProperties;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.getDefinitionByName;
	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	import com.yahoo.astra.fl.charts.events.ChartEvent;
	import com.yahoo.astra.fl.charts.series.LineSeries;
	import com.yahoo.astra.fl.charts.skins.IProgrammaticSkin;
	import com.yahoo.astra.fl.charts.skins.RectangleSkin;
		
	//--------------------------------------
	//  Styles
	//--------------------------------------
	
	/**
     * The padding that separates the border of the component from its contents,
     * in pixels.
     *
     * @default 10
     */
    [Style(name="contentPadding", type="Number")]
	
	/**
     * Name of the class to use as the skin for the background and border of the
     * component.
     *
     * @default com.yahoo.charts.skins.RectangleSkin
     */
    [Style(name="backgroundSkin", type="Class")]
	
	/**
     * If the background skin is an IProgrammatic skin, use this value for its fill color.
     *
     * @default 0xffffff
     */
    [Style(name="backgroundColor", type="uint")]
	
	/**
     * An Array containing the default colors for each series. These colors are
     * used for markers in most cases, but they may apply to lines, fills, or
     * other graphical items.
     *
     * @default [0x729fcf, 0xfcaf3e, 0x73d216, 0xfce94f, 0xad7fa8, 0x3465a4]
     */
    [Style(name="seriesColors", type="Array")]
	
	/**
     * The default size of the markers in pixels. The actual drawn size of the
     * markers could end up being different in some cases. For example, bar charts
     * and column charts display markers side-by-side, and a chart may need to make
     * the bars or columns smaller to fit within the required region.
     *
     * @default [10]
     */
    [Style(name="seriesMarkerSizes", type="Number")]
	
	/**
     * An Array containing the default skin classes for each series. These classes
     * are used to instantiate the marker skins. The values may be fully-qualified
     * package and class strings or a reference to the classes themselves.
     *
     * @default null (keeps the default for each series type)
     */
    [Style(name="seriesMarkerSkins", type="Array")]
	
	/**
	 * The TextFormat object to use to render data tips.
     *
     * @default TextFormat("_sans", 11, 0x000000, false, false, false, '', '', TextFormatAlign.LEFT, 0, 0, 0, 0)
     */
    [Style(name="dataTipTextFormat", type="TextFormat")]
	
	/**
	 * If the datatip's background skin alpha is customizable, it will use this value.
     *
     * @default 0.85
     */
    [Style(name="dataTipBackgroundAlpha", type="Number")]
	
	/**
	 * If the datatip's background skin color is customizable, it will use this value.
     *
     * @default 0xffffff
     */
    [Style(name="dataTipBackgroundColor", type="uint")]
	
	/**
	 * If the datatip's border skin color is customizable, it will use this value.
     *
     * @default 0x888a85
     */
    [Style(name="dataTipBorderColor", type="uint")]
	
	/**
	 * If the datatip's content padding is customizable, it will use this value.
	 * The padding that separates the border of the component from its contents,
     * in pixels.
     *
     * @default 6
     */
    [Style(name="dataTipContentPadding", type="Number")]

	/**
	 * Functionality common to most charts. Generally, a <code>Chart</code> object
	 * shouldn't be instantiated directly. Instead, a subclass with a concrete
	 * implementation should be used. That subclass generally should implement the
	 * <code>IPlotArea</code> interface.
	 *
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9
	 * @author Josh Tynjala
	 */
	public class Chart extends UIComponent
	{
		
	//--------------------------------------
	//  Class Variables
	//--------------------------------------
	
		/**
		 * @private
		 */
		private static var defaultStyles:Object =
			{
				seriesMarkerSizes: [10],
				seriesColors: [0x729fcf, 0xfcaf3e, 0x73d216, 0xfce94f, 0xad7fa8, 0x3465a4],
				contentPadding: 10,
				backgroundSkin: RectangleSkin,
				backgroundColor: 0xffffff,
				dataTipBackgroundAlpha: 0.85,
				dataTipBackgroundColor: 0xffffff,
				dataTipBorderColor: 0x888a85,
				dataTipContentPadding: 6,
				dataTipTextFormat: new TextFormat("_sans", 11, 0x000000, false, false, false, '', '', TextFormatAlign.LEFT, 0, 0, 0, 0)
			};
		
		/**
		 * @private
		 */
		private static const SERIES_STYLES:Object =
			{
				fillColor: "seriesColors",
				markerSize: "seriesMarkerSizes",
				markerSkin: "seriesMarkerSkins"
			};
		
		private static const DATA_TIP_STYLES:Object =
			{
				backgroundAlpha: "dataTipBackgroundAlpha",
				backgroundColor: "dataTipBackgroundColor",
				borderColor: "dataTipBorderColor",
				contentPadding: "dataTipContentPadding",
				textFormat: "dataTipTextFormat"
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
		public function Chart()
		{
			super();
			this.accessibilityProperties = new AccessibilityProperties();
			this.accessibilityProperties.forceSimple = true;
			this.accessibilityProperties.description = "Chart";
		}
		
	//--------------------------------------
	//  Variables and Properties
	//--------------------------------------
		
		/**
		 * @private
		 * The display object representing the chart background.
		 */
		protected var background:DisplayObject;
		
		/**
		 * @private
		 * The area where series are drawn.
		 */
		protected var content:Sprite;
		
		/**
		 * @private
		 * The mouse over data tip that displays information about an item on the chart.
		 */
		protected var dataTip:DisplayObject;
		
		/**
		 * @private
		 * Storage for the contentBounds property.
		 */
		protected var _contentBounds:Rectangle = new Rectangle();
	
		/**
		 * @copy com.yahoo.charts.IPlotArea#contentBounds
		 */
		public function get contentBounds():Rectangle
		{
			return this._contentBounds;
		}
		
		/**
		 * @private
		 * Storage for the data property. Saves a copy of the unmodified data.
		 */
		private var _dataProvider:Object;
		
		/**
		 * @private
		 * Modified version of the stored data.
		 */
		protected var series:Array = [];
		
		[Inspectable(type=Array)]
		/**
		 * The data the chart displays.
		 */
		public function get dataProvider():Object
		{
			return this.series;
		}
		
		/**
		 * @private
		 */
		public function set dataProvider(value:Object):void
		{
			if(this._dataProvider != value)
			{
				this._dataProvider = value;
				this.invalidate();
			}
		}
		
		/**
		 * @private
		 * Storage for the defaultSeriesType property.
		 */
		private var _defaultSeriesType:Class = LineSeries;
		
		/**
		 * When data is encountered where an ISeries is expected, it will be converted
		 * to this default type. Accepts either a Class or a String referencing a class.
		 */
		public function get defaultSeriesType():Object
		{
			return this._defaultSeriesType;
		}
		
		/**
		 * @private
		 */
		public function set defaultSeriesType(value:Object):void
		{
			if(!value) return;
			var classDefinition:Class = null;
			if(value is Class)
			{
				classDefinition = value as Class;
			}
			else
			{
				// borrowed from fl.core.UIComponent#getDisplayObjectInstance()
				try
				{
					classDefinition = getDefinitionByName(value.toString()) as Class;
				}
				catch(e:Error)
				{
					try
					{
						classDefinition = this.loaderInfo.applicationDomain.getDefinition(value.toString()) as Class;
					}
					catch (e:Error)
					{
						// Nothing
					}
				}
			}
			
			this._defaultSeriesType = classDefinition;
			//no need to redraw.
			//if the series have already been created, the user probably wanted it that way.
			//we have no way to tell if the user chose a particular series' type or not anyway.
		}
		
		/**
		 * @private
		 * Storage for the dataTipFunction property.
		 */
		private var _dataTipFunction:Function = defaultDataTipFunction;
		
		/**
		 * If defined, the chart will call the input function to determine the
		 * text displayed in the chart's data tip. The function uses the following
		 * signature:
		 *
		 * <p><code>function dataTipFunction(item:Object, index:int, series:ISeries):String</code></p>
		 */
		public function get dataTipFunction():Function
		{
			return this._dataTipFunction;
		}
		
		/**
		 * @private
		 */
		public function set dataTipFunction(value:Function):void
		{
			this._dataTipFunction = value;
		}
		
	//--------------------------------------
	//  Protected Methods
	//--------------------------------------
	
		/**
		 * @private
		 */
		override protected function configUI():void
		{
			super.width = 400;
			super.height = 300;
			
			super.configUI();
			
			this.content = new Sprite();
			this.addChild(this.content);
			
			this.dataTip = new DataTipRenderer();
			this.dataTip.visible = false;
			this.addChild(this.dataTip);
		}
	
		/**
		 * @private
		 */
		override protected function draw():void
		{
			var backgroundInvalid:Boolean = this.isInvalid("backgroundSkin");
			
			super.draw();
			
			this.refreshSeries();
			
			//update the background if needed
			if(backgroundInvalid)
			{
				if(this.background) this.removeChild(this.background);
				var skinClass:Object = this.getStyleValue("backgroundSkin");
				this.background = getDisplayObjectInstance(skinClass);
				this.addChildAt(this.background, 0);
			}
			this.background.width = this.width;
			this.background.height = this.height;
			
			//set the background color for programmatic skins
			if(this.background is IProgrammaticSkin)
			{
				var fillColor:uint = this.getStyleValue("backgroundColor") as uint;
				(this.background as IProgrammaticSkin).fillColor = fillColor;
			}
			
			//force the background to redraw if it is a UIComponent
			if(this.background is UIComponent)
			{
				(this.background as UIComponent).drawNow();
			}
			
		}
	
		/**
		 * Analyzes the input data and smartly converts it to the correct ISeries type
		 * required for drawing. Adds new ISeries objects to the display list and removes
		 * unused series objects that no longer need to be drawn.
		 */
		protected function refreshSeries():void
		{
			var modifiedData:Object = this._dataProvider;
			
			//loop through each series and convert it to the correct data type
			if(modifiedData is Array)
			{
				var arrayData:Array = modifiedData as Array;
				var seriesCount:int = arrayData.length;
				for(var i:int = 0; i < seriesCount; i++)
				{
					var currentItem:Object = arrayData[i];
					if(currentItem is Array || currentItem is XMLList)
					{
						var itemSeries:ISeries = new this.defaultSeriesType();
						itemSeries.dataProvider = currentItem;
						arrayData[i] = itemSeries;
					}
					else if(!(currentItem is ISeries))
					{
						modifiedData = new this.defaultSeriesType(arrayData);
						break;
					}
				}
			}
			
			//attempt to turn a string into XML
			if(modifiedData is String)
			{
				try
				{
					modifiedData = new XML(modifiedData);
				}
				catch(error:Error)
				{
					//this isn't a valid xml string, so ignore it
					return;
				}
			}
			
			//we need an XMLList, so get the elements
			if(modifiedData is XML)
			{
				modifiedData = (modifiedData as XML).elements();
			}
			
			//convert the XMLList to a series
			if(modifiedData is XMLList)
			{
				modifiedData = new this.defaultSeriesType(modifiedData);
			}
		
			//we should have an ISeries object by now, so put it in an Array
			if(modifiedData is ISeries)
			{
				//if the main data is a series, put it in an array
				modifiedData = [modifiedData];
			}
			
			//if it's not an array, we have bad data, so ignore it
			if(!(modifiedData is Array)) return;
			
			arrayData = modifiedData as Array;
			
			seriesCount = this.series.length;
			for(i = 0; i < seriesCount; i++)
			{
				var currentSeries:ISeries = this.series[i] as ISeries;
				if(arrayData.indexOf(currentSeries) < 0)
				{
					//if the series no longer exists, remove it from the display list and stop listening to it
					this.content.removeChild(DisplayObject(currentSeries));
					currentSeries.removeEventListener("dataChange", seriesDataChangeHandler);
					currentSeries.removeEventListener(ChartEvent.ITEM_ROLL_OVER, chartItemRollOver);
					currentSeries.removeEventListener(ChartEvent.ITEM_ROLL_OUT, chartItemRollOut);
					currentSeries.plotArea = null;
				}
			}
			
			//rebuild the series Array
			this.series = [];
			seriesCount = arrayData.length;
			for(i = 0; i < seriesCount; i++)
			{
				currentSeries = arrayData[i] as ISeries;
				this.series.push(currentSeries);
				if(!this.contains(DisplayObject(currentSeries)))
				{
					//if this is a new series, add it to the display list and listen for events
					currentSeries.addEventListener("dataChange", seriesDataChangeHandler, false, 0, true);
					currentSeries.addEventListener(ChartEvent.ITEM_ROLL_OVER, chartItemRollOver, false, 0, true);
					currentSeries.addEventListener(ChartEvent.ITEM_ROLL_OUT, chartItemRollOut, false, 0, true);
					this.content.addChild(DisplayObject(currentSeries));
					
					//subclasses of chart must implement IPlotArea!
					currentSeries.plotArea = this as IPlotArea;
				}
				
				//make sure the series are displayed in the correct order
				this.content.setChildIndex(DisplayObject(currentSeries), this.content.numChildren - 1);
				
				//update the series styles
				this.copyStylesToSeries(currentSeries, SERIES_STYLES);
			}
		}
		
		/**
		 * @private
		 * Tranfers the chart's styles to the ISeries components it contains. These styles
		 * must be of the type Array, and the series index determines the index of the value
		 * to use from that Array. If the chart contains more ISeries components than there
		 * are values in the Array, the indices are reused starting from zero.
		 */
		protected function copyStylesToSeries(child:ISeries, styleMap:Object):void
		{
			var index:int = this.series.indexOf(child);
			var childComponent:UIComponent = child as UIComponent;
			for(var n:String in styleMap)
			{
				var styleValues:Array = this.getStyleValue(styleMap[n]) as Array;
				//if it doesn't exist, ignore it and go with the defaults for this series
				if(!styleValues) continue;
				
				childComponent.setStyle(n, styleValues[index % styleValues.length])
			}
		}
		
		/**
		 * @private
		 */
		protected function defaultDataTipFunction(item:Object, index:int, series:ISeries):String
		{
			if(series.displayName)
			{
				return series.displayName;
			}
			return "";
		}
		
		/**
		 * @private
		 * Display the data tip when the user moves the mouse over a chart marker.
		 */
		protected function chartItemRollOver(event:ChartEvent):void
		{
			var dataTipText:String = "";
			if(this.dataTipFunction != null)
			{
				dataTipText = this.dataTipFunction(event.item, event.index, event.series);
			}
			
			this.setChildIndex(this.dataTip, this.numChildren - 1);
			
			var dataTipRenderer:IDataTipRenderer = this.dataTip as IDataTipRenderer;
			dataTipRenderer.text = dataTipText;
			dataTipRenderer.data = event.item;
			
			if(this.dataTip is UIComponent)
			{
				var dataTipAsComponent:UIComponent = this.dataTip as UIComponent;
				//pass in the styles
				this.copyStylesToChild(dataTipAsComponent, DATA_TIP_STYLES);
			
				dataTipAsComponent.drawNow();
			}
			
			var position:Point = this.mousePositionToDataTipPosition();
			this.dataTip.x = position.x;
			this.dataTip.y = position.y;
			this.dataTip.visible = true;
			
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE, stageMouseMoveHandler);
		}
		
		/**
		 * @private
		 * Hide the data tip when the user moves the mouse off a chart marker.
		 */
		protected function chartItemRollOut(event:ChartEvent):void
		{
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, stageMouseMoveHandler);
			this.dataTip.visible = false;
		}
		
	//--------------------------------------
	//  Private Methods
	//--------------------------------------
		
		/**
		 * @private
		 * The plot area needs to redraw the axes if series data changes.
		 */
		private function seriesDataChangeHandler(event:Event):void
		{
			this.invalidate();
		}
		
		/**
		 * @private
		 * Make the data tip follow the mouse.
		 */
		private function stageMouseMoveHandler(event:MouseEvent):void
		{
			var position:Point = this.mousePositionToDataTipPosition();
			this.dataTip.x = position.x;
			this.dataTip.y = position.y;
		}
		
		/**
		 * @private
		 * Determines the position for the data tip based on the mouse position
		 * and the bounds of the chart. Attempts to keep the data tip within the
		 * chart bounds so that it isn't hidden by any other display objects.
		 */
		private function mousePositionToDataTipPosition():Point
		{
			var position:Point = new Point();
			position.x = this.mouseX + 2;
			position.x = Math.min(this.width - this.dataTip.width, position.x);
			position.y = this.mouseY - this.dataTip.height - 2;
			position.y = Math.max(0, position.y);
			return position;
		}
	
	}
}
