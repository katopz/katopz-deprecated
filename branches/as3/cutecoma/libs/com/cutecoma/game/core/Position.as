package com.cutecoma.game.core
{
	import flash.geom.Vector3D;

	public class Position extends Vector3D
	{
		public function Position(x:Number = 0, y:Number = 0, z:Number = 0)
		{
			super(x, y, z);
		}

		public static function parse(raw:* = null):Position
		{
			if (!raw)
				return new Position();
			return new Position(raw.x, raw.y, raw.z);
		}

		public function copy():Position
		{
			return new Position(x, y, z);
		}
		
		public static function getVector3D(raw:*):Vector3D
		{
			return new Vector3D(raw.x || 0, raw.y || 0, raw.z || 0);
		}

		public function toObject(fix:uint = 2):Object
		{
			return {x:Number(x.toFixed(fix)), y:Number(y.toFixed(fix)), z:Number(z.toFixed(fix))};
		}

		override public function toString():String
		{
			return "[Position] : " + x.toFixed(2) + "," + y.toFixed(2) + "," + z.toFixed(2);
		}
	}
}