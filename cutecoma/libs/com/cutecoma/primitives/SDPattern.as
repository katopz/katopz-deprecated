package com.cutecoma.primitives
{
	import com.sleepydesign.utils.GraphicUtil;
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.geom.Rectangle;
	
    /**
	 * SleepyDesign Pattern
	 * @author katopz
	 */
	public class SDPattern extends Shape
	{
		public function SDPattern(instance:DisplayObject, width:Number, height:Number)
		{
			var rectangle:Rectangle = instance.getRect(instance.parent);
			this.graphics.beginBitmapFill(GraphicUtil.getBitmapData(instance), null, true);
			this.graphics.drawRect(rectangle.x, rectangle.y, width, height);
			this.graphics.endFill();
		}
	}
}
