/*
Copyright (c) 2007, Yahoo! Inc. All rights reserved.
Code licensed under the BSD License:
http://developer.yahoo.com/flash/license.html
*/
package com.yahoo.astra.fl.charts.series
{
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Point;
	import com.yahoo.astra.fl.charts.Series;
	import com.yahoo.astra.fl.charts.ISeries;
		
	//--------------------------------------
	//  Styles
	//--------------------------------------

	/**
     * The colors of the markers in this series.
     *
     * @default [0x729fcf, 0xfcaf3e, 0x73d216, 0xfce94f, 0xad7fa8, 0x3465a4]
     */
    [Style(name="fillColors", type="Array")]
    
	/**
	 * Renders data points as a series of pie-like wedges.
	 * 
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9
	 * @author Josh Tynjala
	 */
	public class PieSeries extends Series
	{
		
	//--------------------------------------
	//  Class Variables
	//--------------------------------------
		
		/**
		 * @private
		 */
		private static var defaultStyles:Object = 
			{	
				fillColors: [0x729fcf, 0xfcaf3e, 0x73d216, 0xfce94f, 0xad7fa8, 0x3465a4]
			};
		
	//--------------------------------------
	//  Class Methods
	//--------------------------------------
	
		/**
		 * @copy fl.core.UIComponent#getStyleDefinition()
		 */
		public static function getStyleDefinition():Object
		{
			return mergeStyles(defaultStyles, Series.getStyleDefinition());
		}
		
	//--------------------------------------
	//  Constructor
	//--------------------------------------
	
		/**
		 * Constructor.
		 */
		public function PieSeries(data:Object = null)
		{
			super(data);
		}
		
	//--------------------------------------
	//  Properties
	//--------------------------------------
		
		/**
		 * @private
		 * Storage for the dataField property.
		 */
		private var _dataField:String;
		
		/**
		 * The field used to access data for this series.
		 */
		public function get dataField():String
		{
			return this._dataField;
		}
		
		/**
		 * @private
		 */
		public function set dataField(value:String):void
		{
			if(this._dataField != value)
			{
				this._dataField = value;
				this.dispatchEvent(new Event("dataChange"));
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
			var series:PieSeries = new PieSeries();
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
			
			var totalValue:Number = 0;
			var dataCount:int = this.dataProvider.length;
			for(var i:int = 0; i < dataCount; i++)
			{
				totalValue += this.dataProvider[i] as Number;
			}
			
			var totalAngle:Number = 0;
			var halfWidth:Number = this.width / 2;
			var halfHeight:Number = this.height / 2;
			var radius:Number = Math.min(halfWidth, halfHeight);
			var fillColors:Array = this.getStyleValue("fillColors") as Array;
			for(i = 0; i < dataCount; i++)
			{
				var marker:Sprite = this.markers[i] as Sprite;
				var item:Object = this.dataProvider[i];
				var value:Number = Number(item);
				if(isNaN(value) && this.dataField)
				{
					value = item[this.dataField];
				}
				var angle:Number = 360 * (value / totalValue);
				marker.graphics.beginFill(fillColors[i % fillColors.length]);
				this.drawWedge(marker, halfWidth, halfHeight, totalAngle, angle, radius);
				marker.graphics.endFill();
				totalAngle += angle;
			}
		}
		
	//--------------------------------------
	//  Private Methods
	//--------------------------------------
		
		/**
		 * @private
		 * Modified version of mc.drawWedge prototype by Ric Ewing (ric@formequalsfunction.com) - version 1.3 - 6.12.2002
		 * Thanks to: Robert Penner, Eric Mueller and Michael Hurwicz for their contributions.
		 * Source: http://www.adobe.com/devnet/flash/articles/adv_draw_methods.html
		 * 
		 * @param x				x component of the wedge's center point
		 * @param y				y component of the wedge's center point
		 * @param startAngle	starting angle in degrees
		 * @param arc			sweep of the wedge. Negative values draw clockwise.
		 * @param radius		radius of wedge. If [optional] yRadius is defined, then radius is the x radius.
		 * @param yRadius		[optional] y radius for wedge.
		 */
		private function drawWedge(target:Sprite, x:Number, y:Number, startAngle:Number, arc:Number, radius:Number, yRadius:Number = NaN):void
		{
			// move to x,y position
			target.graphics.moveTo(x, y);
			
			// if yRadius is undefined, yRadius = radius
			if(isNaN(yRadius))
			{
				yRadius = radius;
			}
			
			// limit sweep to reasonable numbers
			if(Math.abs(arc) > 360)
			{
				arc = 360;
			}
			
			// Flash uses 8 segments per circle, to match that, we draw in a maximum
			// of 45 degree segments. First we calculate how many segments are needed
			// for our arc.
			var segs:int = Math.ceil(Math.abs(arc) / 45);
			
			// Now calculate the sweep of each segment.
			var segAngle:Number = arc / segs;
			
			// The math requires radians rather than degrees. To convert from degrees
			// use the formula (degrees/180)*Math.PI to get radians.
			var theta:Number = -(segAngle / 180) * Math.PI;
			
			// convert angle startAngle to radians
			var angle:Number = -(startAngle / 180) * Math.PI;
			
			// draw the curve in segments no larger than 45 degrees.
			if(segs > 0)
			{
				// draw a line from the center to the start of the curve
				var ax:Number = x + Math.cos(startAngle / 180 * Math.PI) * radius;
				var ay:Number = y + Math.sin(-startAngle / 180 * Math.PI) * yRadius;
				target.graphics.lineTo(ax, ay);
				
				// Loop for drawing curve segments
				for(var i:int = 0; i < segs; i++)
				{
					angle += theta;
					var angleMid:Number = angle - (theta / 2);
					var bx:Number = x + Math.cos(angle) * radius;
					var by:Number = y + Math.sin(angle) * yRadius;
					var cx:Number = x + Math.cos(angleMid) * (radius / Math.cos(theta / 2));
					var cy:Number = y + Math.sin(angleMid) * (yRadius / Math.cos(theta / 2));
					target.graphics.curveTo(cx, cy, bx, by);
				}
				// close the wedge by drawing a line to the center
				target.graphics.lineTo(x, y);
			}
		}
		
	}
}