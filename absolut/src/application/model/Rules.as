package application.model
{
	import application.view.components.Crystal;
	import application.view.components.CrystalStatus;
	
	import flash.geom.Point;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;

	public class Rules extends Proxy implements IProxy
	{
		public static var COL_SIZE:uint = 8;
		public static var ROW_SIZE:uint = 8;

		public static function hasNeighbor(focusID:int, swapID:int):Boolean
		{
			var _a:Point = CrystalDataProxy.getPositionFromIndex(focusID, COL_SIZE);
			var _b:Point = CrystalDataProxy.getPositionFromIndex(swapID, COL_SIZE);

			return (Math.abs(_a.x - _b.x) + Math.abs(_a.y - _b.y) <= 1);
		}

		public static function checkSame(crystals:Vector.<Crystal>):Boolean
		{
			var _result:Boolean = checkCol(crystals);
			return checkRow(crystals) || _result;
		}

		public static function isOver(_crystals:Vector.<Crystal>):Boolean
		{
			var _result:Boolean = false;
			var j:int;
			// try up
			/*
			var _crystals_length:int = _crystals.length;
			for (j = COL_SIZE; j < _crystals_length; j++)
			{
				var _crystal:Crystal = _crystals[j];
				var _swapCrystal:Crystal = _crystals[j - COL_SIZE];

				CrystalDataProxy.swapByID(_crystals, _crystal.id, _swapCrystal.id);

				// chk /a
				if (checkCol(_crystals, true) || checkRow(_crystals, true))
				{
					// swap back anyway
					CrystalDataProxy.swapByID(_crystals, _crystal.id, _swapCrystal.id);
					_crystal.alpha = .25;
					return false;
				}
				else
				{
					// swap back
					CrystalDataProxy.swapByID(_crystals, _crystal.id, _swapCrystal.id);
				}
			}
			*/
			
			/*
			// try down
			var _crystals_length:int = _crystals.length;
			for (j = 0; j < _crystals_length - ROW_SIZE; j++)
			{
				var _crystal:Crystal = _crystals[j];
				var _swapCrystal:Crystal = _crystals[j + COL_SIZE];
				
				CrystalDataProxy.swapByID(_crystals, _crystal.id, _swapCrystal.id);
				
				// chk /a
				if (checkCol(_crystals, true) || checkRow(_crystals, true))
				{
					// swap back anyway
					CrystalDataProxy.swapByID(_crystals, _crystal.id, _swapCrystal.id);
					_crystal.alpha = .25;
					return false;
				}
				else
				{
					// swap back
					CrystalDataProxy.swapByID(_crystals, _crystal.id, _swapCrystal.id);
				}
			}
			*/
			
			/*
			// try left
			var _crystals_length:int = _crystals.length;
			for (j = 1; j < _crystals_length; j++)
			{
				var _crystal:Crystal = _crystals[j];
				var _swapCrystal:Crystal = _crystals[j - 1];
				
				CrystalDataProxy.swapByID(_crystals, _crystal.id, _swapCrystal.id);
				
				// chk /a
				if (checkCol(_crystals, true) || checkRow(_crystals, true))
				{
					// swap back anyway
					CrystalDataProxy.swapByID(_crystals, _crystal.id, _swapCrystal.id);
					_crystal.alpha = .25;
					return false;
				}
				else
				{
					// swap back
					CrystalDataProxy.swapByID(_crystals, _crystal.id, _swapCrystal.id);
				}
			}
			*/

			// try left/right
			var _crystals_length:int = _crystals.length;
			var _crystal:Crystal;
			var _swapCrystal:Crystal;
			
			for (j = 0; j < _crystals_length; j++)
			{
				// right : ignore next one = new line
				if(j==0 || (j>0 && (j+1)%COL_SIZE!=0))
				{
					_crystal = _crystals[j];
					_swapCrystal = _crystals[j + 1];
					if(!isSwapAndOver(_crystals, _crystal.id, _swapCrystal.id))
					{
						_crystal.alpha = .25;
						return false;
					}
				}
				
				// left : ignore prev one = above line
				if(j%COL_SIZE!=0)
				{
					_crystal = _crystals[j];
					_swapCrystal = _crystals[j - 1];
					
					if(!isSwapAndOver(_crystals, _crystal.id, _swapCrystal.id))
					{
						_crystal.alpha = .25;
						return false;
					}
				}
			}

			return true;
		}
		
		public static function isSwapAndOver(_crystals:Vector.<Crystal>, _crystalID:int, _swapCrystaID:int):Boolean
		{
			CrystalDataProxy.swapByID(_crystals,  _crystalID, _swapCrystaID);
			
			// chk /a
			if (checkCol(_crystals, true) || checkRow(_crystals, true))
			{
				// swap back anyway
				CrystalDataProxy.swapByID(_crystals, _crystalID, _swapCrystaID);
				return false;
			}
			else
			{
				// swap back
				CrystalDataProxy.swapByID(_crystals, _crystalID, _swapCrystaID);
				return true;
			}
		}

		public static function checkCol(crystals:Vector.<Crystal>, isJustCheck:Boolean = false):Boolean
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
								if(!isJustCheck)
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

		public static function checkRow(crystals:Vector.<Crystal>, isJustCheck:Boolean = false):Boolean
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
							if(!isJustCheck)
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