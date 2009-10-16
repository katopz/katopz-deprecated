package com.sleepydesign.graphics.tools
{
	import flash.display.Sprite;
	import flash.geom.Point;

	public class Segment extends Sprite
	{
		public var anchor:Point;

		public var controlF:Point;
		public var controlB:Point;

		public function Segment(x:Number, y:Number, controlF:Point = null, controlB:Point = null)
		{
			this.anchor = new Point(x, y);
			
			this.controlF = controlF || new Point();
			this.controlB = controlB || new Point();
		}
	}
}