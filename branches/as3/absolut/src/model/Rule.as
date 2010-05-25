package model
{
	import controller.CrystalsController;

	import flash.geom.Point;

	import view.Crystal;

	public class Rule
	{
		public static function checkCol(crystals:Vector.<Crystal>):Boolean
		{
			var _result:Boolean = false;
			for (var j:int = 0; j < crystals.length; j += config.COL_SIZE)
			{
				// check col
				var _isSame:Boolean;
				var k:int = j;
				var _count:int = 0;

				// all in col
				while (k < j + config.COL_SIZE - 1)
				{
					_count = 0;
					var _currentIndex:uint = k;
					var _skinIndex:uint = crystals[k].skinIndex;

					// start skin index same as other skin index?
					while ((k < j + config.COL_SIZE - 1) && (_isSame = (_skinIndex == crystals[k + 1].skinIndex)))
					{
						if (_isSame)
						{
							// same more than 3
							if (++_count > 1)
							{
								// eliminate all in row
								for (var _index:int = _currentIndex; _index <= k + 1; _index++)
									crystals[_index].status = Crystal.STATUS_TOBE_REMOVE;
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

		public static function checkRow(crystals:Vector.<Crystal>):Boolean
		{
			var _result:Boolean = false;
			for (var j:int = 0; j < crystals.length; j++)
			{
				var _isSame:Boolean;
				var k:int = j;
				var _count:int = 0;

				var _skinIndex:uint = crystals[j].skinIndex;

				// start skin index same as other skin index?
				while ((k + config.COL_SIZE < config.ROW_SIZE * config.COL_SIZE) && (_isSame = (_skinIndex == crystals[k + config.COL_SIZE].skinIndex)))
				{
					if (_isSame) //&& crystals[k + config.COL_SIZE].status != Crystal.STATUS_TOBE_REMOVE)
					{
						// same more than 3
						if (++_count > 1)
						{
							// eliminate all in col
							var _position:Point = CrystalsController.getPositionFromIndex(j, config.COL_SIZE);
							for (var _index:int = _position.y; _index <= _position.y + _count; _index++)
								crystals[_position.x + _index * config.COL_SIZE].status = Crystal.STATUS_TOBE_REMOVE;

							_result = _result || true;
						}
						else
						{
							_result = _result || false;
						}
					}
					k += config.COL_SIZE;
				}
			}

			return _result;
		}
	}
}