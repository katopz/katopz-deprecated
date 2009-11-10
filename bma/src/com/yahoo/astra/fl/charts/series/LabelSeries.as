/*
Copyright (c) 2007, Yahoo! Inc. All rights reserved.
Code licensed under the BSD License:
http://developer.yahoo.com/flash/license.html
*/
package com.yahoo.astra.fl.charts.series
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import fl.core.UIComponent;
	import com.yahoo.astra.fl.charts.*;
	import com.yahoo.astra.fl.charts.skins.CircleSkin;
	import com.yahoo.astra.fl.charts.skins.IProgrammaticSkin;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	/**
     * The weight, in pixels, of the line drawn between points in this series.
     *
     * @default 3
     */
    [Style(name="lineWeight", type="Number")]
    
	/**
	 * Renders data points as a series of connected line segments.
	 * 
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9
	 * @author Josh Tynjala
	 */
	public class LabelSeries extends CartesianSeries
	{
		
	//--------------------------------------
	//  Class Variables
	//--------------------------------------
		
		/**
		 * @private
		 */
		private static var defaultStyles:Object =
			{
				markerSkin: CircleSkin,
				lineWeight: 3
			};
		
	//--------------------------------------
	//  Class Methods
	//--------------------------------------
	
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
		 *  Constructor.
		 */
		public function LabelSeries(data:Object = null)
		{
			super(data);
		}
		
	//--------------------------------------
	//  Public Methods
	//--------------------------------------
	
		/**
		 * @copy com.yahoo.charts.ISeries#clone()
		 */
		override public function clone():ISeries
		{
			var series:LabelSeries = new LabelSeries();
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
		
		private function addLabel(iString:String):TextField
		{
			super.configUI();
			var label = new TextField();
			label.autoSize = TextFieldAutoSize.LEFT;
			label.selectable = false;
			label.text = iString;
			this.addChild(label);
			return label
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
			
			if(!this.dataProvider) return;
			
			var markerSize:Number = this.getStyleValue("markerSize") as Number;
			var lineWeight:int = this.getStyleValue("lineWeight") as int;
			var fillColor:uint = this.getStyleValue("fillColor") as uint;
			this.graphics.lineStyle(lineWeight, fillColor);
			
			var lastPosition:Point;
			var lastPointInvalid:Boolean = true;
			
			//used to determine if the data must be drawn
			var seriesBounds:Rectangle = new Rectangle(0, 0, this.width, this.height);
			
			var itemCount:int = this.length;
			for(var i:int = 0; i < itemCount; i++)
			{
				var item:Object = this.dataProvider[i];
				var position:Point = this.plotArea.dataToLocal(item, this);
				var verticalValue:Object = this.plotArea.getVerticalValue(item, this);
				
				var marker:DisplayObject = this.markers[i] as DisplayObject;
				var ratio:Number = marker.width / marker.height;
				if(isNaN(ratio)) ratio = 1;
				marker.height = markerSize;
				marker.width = marker.height * ratio;
				marker.x = position.x - marker.width / 2;
				marker.y = position.y - marker.height / 2;
				
				if(marker is IProgrammaticSkin)
				{
					(marker as IProgrammaticSkin).fillColor = fillColor;
				}
				
				if(marker is UIComponent) 
				{
					(marker as UIComponent).drawNow();
				}
				
				// if we have a bad position, don't display the marker
				marker.visible = !isNaN(position.x) && !isNaN(position.y);
				
				//if the position is valid, move or draw as needed
				if(marker.visible)
				{
					//if the last position is not valid, simply move to the new position
					if(!lastPosition || isNaN(lastPosition.x) || isNaN(lastPosition.y))
					{
						this.graphics.moveTo(position.x, position.y);
					}
					else //current and last position are both valid
					{
						var minX:Number = Math.min(lastPosition.x, position.x);
						var maxX:Number = Math.max(lastPosition.x, position.x);
						var minY:Number = Math.min(lastPosition.y, position.y);
						var maxY:Number = Math.max(lastPosition.y, position.y);
						var lineBounds:Rectangle = new Rectangle(minX, minY, maxX - minX, maxY - minY);
						
						//if line between the last point and this point is within
						//the series bounds, draw it, otherwise, only move to the new point.
						if(lineBounds.intersects(seriesBounds))
						{
							//this.graphics.lineTo(position.x, position.y);
						}
						else {
							this.graphics.moveTo(position.x, position.y);	
						}
							
						var label = addLabel(String(Number(verticalValue)))
						
						label.scaleX = label.scaleY=.73
						
						label.x = position.x-label.width*.5
						label.y = position.y - 16						
							
					}
					
					

					
					
				}
				lastPosition = position;
				
			}
		}
		
	}
}
