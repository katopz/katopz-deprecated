package application.model
{
	import flash.geom.Point;

	import application.view.components.Crystal;

	public class CrystalProxy
	{
		public static function isNearby(focusID:int, swapID:int):Boolean
		{
			var _a:Point = getPositionFromIndex(focusID, ConfigProxy.COL_SIZE);
			var _b:Point = getPositionFromIndex(swapID, ConfigProxy.COL_SIZE);

			return (Math.abs(_a.x - _b.x) + Math.abs(_a.y - _b.y) <= 1);
		}

		public static function swapPositionByID(crystals:Vector.<Crystal>, srcID:int, targetID:int):void
		{
			var x:Number = crystals[targetID].x;
			crystals[targetID].x = crystals[srcID].x;
			crystals[srcID].x = x;

			var y:Number = crystals[targetID].y;
			crystals[targetID].y = crystals[srcID].y;
			crystals[srcID].y = y;
		}

		public static function swapByID(crystals:Vector.<Crystal>, srcID:int, targetID:int):void
		{
			var _crystal:Crystal = crystals[targetID];
			crystals[targetID] = crystals[srcID];
			crystals[srcID] = _crystal;

			var _status:String = crystals[targetID].status;
			crystals[targetID].status = crystals[srcID].status;
			crystals[srcID].status = _status;

			var _id:int = crystals[targetID].id;
			crystals[targetID].id = crystals[srcID].id;
			crystals[srcID].id = _id;
		}

		public static function getAboveCrystal(crystals:Vector.<Crystal>, index:int, size:uint):Crystal
		{
			while (((index -= size) >= 0) && (crystals[index].status != Crystal.STATUS_READY))
			{
			}
			return index > -1 ? crystals[index] : null;
		}

		public static function getPositionFromIndex(index:int, size:uint):Point
		{
			return new Point(int(index % size), int(index / size));
		}
	}
}