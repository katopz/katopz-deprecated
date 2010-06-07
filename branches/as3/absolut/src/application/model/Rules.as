package application.model
{
	import application.view.components.Crystal;
	import application.view.components.CrystalStatus;
	
	import flash.geom.Point;

	public class Rules
	{
		public static var COL_SIZE:uint = 8;
		public static var ROW_SIZE:uint = 8;

		public static function hasNeighbor(focusID:int, swapID:int):Boolean
		{
			var _a:Point = CrystalDataProxy.getPositionFromIndex(focusID, COL_SIZE);
			var _b:Point = CrystalDataProxy.getPositionFromIndex(swapID, COL_SIZE);

			return (Math.abs(_a.x - _b.x) + Math.abs(_a.y - _b.y) <= 1);
		}

		public static function isSameColorRemain(crystals:Vector.<Crystal>):Boolean
		{
			var _result:Boolean = checkCol(crystals);
			return checkRow(crystals) || _result;
		}

		public static function isOver(_crystals:Vector.<Crystal>):Boolean
		{
			var _result:Boolean = false;
			var _crystals_length:int = _crystals.length;
			var _crystal:Crystal;
			var _swapCrystal:Crystal;
			var i:int;

			for (i = 0; i < _crystals_length; i++)
				_crystals[i].isGoodToMove = false;

			for (i = 0; i < _crystals_length; i++)
			{
				_crystal = _crystals[i];

				// right : ignore next one = new line
				if (i == 0 || (i > 0 && (i + 1) % COL_SIZE != 0))
				{
					_swapCrystal = _crystals[i + 1];
					if (!isSwapAndOver(_crystals, _crystal.id, _swapCrystal.id))
					{
						_crystal.isGoodToMove = _swapCrystal.isGoodToMove = true;
						return false;
					}
				}

				// left : ignore prev one = above line
				if (i % COL_SIZE != 0)
				{
					_swapCrystal = _crystals[i - 1];

					if (!isSwapAndOver(_crystals, _crystal.id, _swapCrystal.id))
					{
						_crystal.isGoodToMove = _swapCrystal.isGoodToMove = true;
						return false;
					}
				}

				// up : ignore top line
				if (i > COL_SIZE)
				{
					_swapCrystal = _crystals[i - COL_SIZE];

					if (!isSwapAndOver(_crystals, _crystal.id, _swapCrystal.id))
					{
						_crystal.isGoodToMove = _swapCrystal.isGoodToMove = true;
						return false;
					}
				}

				// down : ignore last line
				if (i < COL_SIZE)
				{
					_swapCrystal = _crystals[i + COL_SIZE];

					if (!isSwapAndOver(_crystals, _crystal.id, _swapCrystal.id))
					{
						_crystal.isGoodToMove = _swapCrystal.isGoodToMove = true;
						return false;
					}
				}
			}

			return true;
		}

		private static function isSwapAndOver(_crystals:Vector.<Crystal>, _crystalID:int, _swapCrystaID:int):Boolean
		{
			CrystalDataProxy.swapByID(_crystalID, _swapCrystaID);

			// chk /a
			if (checkCol(_crystals, true) || checkRow(_crystals, true))
			{
				// swap back anyway
				CrystalDataProxy.swapByID(_crystalID, _swapCrystaID);
				return false;
			}
			else
			{
				// swap back
				CrystalDataProxy.swapByID(_crystalID, _swapCrystaID);
				return true;
			}
		}

		private static function checkCol(crystals:Vector.<Crystal>, isJustCheck:Boolean = false):Boolean
		{
			var _result:Boolean = false;
			var _crystals_length:int = crystals.length;
			for (var j:int = 0; j < _crystals_length; j += COL_SIZE)
			{
				// check col
				var _isSame:Boolean;
				var k:int = j;
				var _count:int = 0;

				// all in col
				while (k < j + COL_SIZE - 1)
				{
					_count = 0;
					var _currentIndex:uint = k;
					var _skinIndex:uint = crystals[k].skinIndex;

					// start skin index same as other skin index?
					while ((k < j + COL_SIZE - 1) && (_isSame = (_skinIndex == crystals[k + 1].skinIndex)))
					{
						if (_isSame)
						{
							// same more than 3
							if (++_count > 1)
							{
								// eliminate all in row
								if (!isJustCheck)
									for (var _index:int = _currentIndex; _index <= k + 1; _index++)
										crystals[_index].status = CrystalStatus.TOBE_REMOVE;
								_result = _result || true;
							}
							else
							{
								_result = _result || false;
							}
						}
						k++;
					}
					k++;
				}
			}

			return _result;
		}

		private static function checkRow(crystals:Vector.<Crystal>, isJustCheck:Boolean = false):Boolean
		{
			var _result:Boolean = false;
			for (var j:int = 0; j < crystals.length; j++)
			{
				var _isSame:Boolean;
				var k:int = j;
				var _count:int = 0;

				var _skinIndex:uint = crystals[j].skinIndex;

				// start skin index same as other skin index?
				while ((k + COL_SIZE < ROW_SIZE * COL_SIZE) && (_isSame = (_skinIndex == crystals[k + COL_SIZE].skinIndex)))
				{
					if (_isSame) //&& crystals[k + config.COL_SIZE].status != Crystal.STATUS_TOBE_REMOVE)
					{
						// same more than 3
						if (++_count > 1)
						{
							// eliminate all in col
							var _position:Point = CrystalDataProxy.getPositionFromIndex(j, COL_SIZE);
							if (!isJustCheck)
								for (var _index:int = _position.y; _index <= _position.y + _count; _index++)
									crystals[_position.x + _index * COL_SIZE].status = CrystalStatus.TOBE_REMOVE;

							_result = _result || true;
						}
						else
						{
							_result = _result || false;
						}
					}
					k += COL_SIZE;
				}
			}

			return _result;
		}
	}
}