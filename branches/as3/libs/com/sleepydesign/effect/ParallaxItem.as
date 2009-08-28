package com.sleepydesign.effect
{
	import flash.display.Sprite;

	
	public class ParallaxItem
	{
		public var _x:Number = 0;
		public var _y:Number = 0;
		
		public var z:Number = 0;
		
		private var instance:Sprite;
		
		public function ParallaxItem(source:Sprite, z:Number)
		{
			instance = source;
			
			_x = instance.x;
			_y = instance.y;
			
			this.z = (z==0)?1:z;
			
			try{
				instance.mouseEnabled = false;
				instance.mouseChildren = false;
				instance.tabEnabled = false;
				instance.tabChildren = false;
			}catch(e:*){trace(e)};
		}
		
		public function get x():Number
		{
			return instance.x;
		}
		
		public function set x(value:Number):void
		{
			instance.x = value;
		}
		
		public function get y():Number
		{
			return instance.y;
		}
		
		public function set y(value:Number):void
		{
			instance.y = value;
		}
	}
}