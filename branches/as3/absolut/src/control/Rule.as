package control
{
	import flash.geom.Point;

	import org.osflash.signals.Signal;

	import view.Crystal;

	public class Rule
	{
		public static var checkSignal:Signal = new Signal(Boolean /*result*/, Array /*board*/);

		public function Rule()
		{
		}

		/**
		 *
		 * Rule #1 : swap only nearby area.
		 *
		 * @param focusID
		 * @param swapID
		 * @param listener
		 *
		 */
		public static function isNearby(focusID:int, swapID:int):Boolean
		{
			var _a:Point = getPositionFromIndex(focusID, config.COL_SIZE);
			var _b:Point = getPositionFromIndex(swapID, config.COL_SIZE);

			return (Math.abs(_a.x - _b.x) + Math.abs(_a.y - _b.y) <= 1);
		}

		private static function getPositionFromIndex(index:uint, size:uint):Point
		{
			return new Point(int(index % size), int(index / size));
		}

		public static function check(focusID:int, swapID:int, boards:Array, listener:Function):void
		{
			checkSignal.addOnce(listener);

			var _result:Boolean;

			// TODO check good condition
			// good : remove col/row
			// bad : return old board

			var _length:int = boards.length;
			for (var _index:int = 0; _index < _length; _index++)
			{

			}

			_result = true;

			// result
			checkSignal.dispatch(_result, boards);
		}
	}
}