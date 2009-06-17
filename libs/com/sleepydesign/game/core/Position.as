package com.sleepydesign.game.core
{
	public class Position extends Object
	{
		public var x:Number;
		public var y:Number;
		public var z:Number;
		
		public function Position( x:Number=0, y:Number=0, z:Number=0) 
		{
			this.x = x;
			this.y = y;
			this.z = z;
		}
		
        public static function parse(raw:*=null):Position
        {
			if(!raw)return new Position();
			return new Position(raw.x, raw.y, raw.z);
        }
		
        public function clone():Position
        {
			return new Position(x, y, z);
        }
		
		public function toObject(fix:uint = 2):Object 
		{
			return { x:Number(x.toFixed(fix)), y:Number(y.toFixed(fix)), z:Number(z.toFixed(fix)) };
		}
		
		public function toString(): String
		{
			return "[Position] : " + x.toFixed(2) + "," + y.toFixed(2)  + "," + z.toFixed(2);
		}	
	}
}