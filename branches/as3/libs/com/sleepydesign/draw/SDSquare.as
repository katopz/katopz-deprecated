package com.sleepydesign.draw
{
	import flash.display.Sprite;

	/**
	 * SleepyDesign Square
	 * @author katopz
	 */
	public class SDSquare extends Sprite
	{
		private var _width:Number;
		private var _height:Number;
		private var _color:uint;
		private var _alpha:Number;
		private var _thickness:Number;
		private var _lineColor:uint;
		private var _align:String;
		
		public function get color():uint
		{
			return _color;
		}
		
		public function SDSquare(width:Number=10, height:Number=10, color:uint=0x000000,alpha:Number=1, thickness:Number=0, lineColor:uint=0x000000, align:String = "tl")
		{
			_width = width;
			_height = height;
			_color = color;
			_alpha = alpha;
			_thickness = thickness;
			_lineColor = lineColor;
			_align = align;
			
			draw();
		}
		
		public function draw():void
		{
			graphics.clear();
			graphics.beginFill(_color, _alpha);
			
			if(_thickness>0)
			{
				graphics.lineStyle(_thickness, _lineColor);
			}
			
			switch(_align.toLowerCase()) 
			{
				case "tl":
					graphics.drawRect(0, 0, _width, _height);
				break;
				default :
					graphics.drawRect(-_width*.5, -_height*.5, _width, _height);
				break;
			}
		}
		
		public function setSize(width:Number, height:Number):void
		{
			_width = width;
			_height = height;
			draw();
		}
	}
}
