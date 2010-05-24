package control
{
	import flash.geom.Point;
	
	import view.Crystal;

	public class Rule
	{
		//public static var checkSignal:Signal = new Signal(Boolean /*result*/, Vector.<Crystal>);

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

		public static function swapPositionByID(crystals:Vector.<Crystal>, srcID:int, targetID:int):void
		{
			//trace("pos : " + srcID + "->" + targetID);

			var x:Number = crystals[targetID].x;
			crystals[targetID].x = crystals[srcID].x;
			crystals[srcID].x = x;

			var y:Number = crystals[targetID].y;
			crystals[targetID].y = crystals[srcID].y;
			crystals[srcID].y = y;
		}

		public static function swapByID(crystals:Vector.<Crystal>, srcID:int, targetID:int):void
		{
			//trace("swap : " + srcID + "->" + targetID);

			var _crystal:Crystal = crystals[targetID];
			crystals[targetID] = crystals[srcID];
			crystals[srcID] = _crystal;

			var _status:String = crystals[targetID].status;
			crystals[targetID].status = crystals[srcID].status;
			crystals[srcID].status = _status;

			/*
			   var _swapID:int = crystals[targetID].swapID;
			   crystals[targetID].swapID = crystals[srcID].swapID;
			   crystals[srcID].swapID = _swapID;

			   var _skinIndex:uint = crystals[targetID].skinIndex;
			   crystals[targetID].skinIndex = crystals[srcID].skinIndex;
			   crystals[srcID].skinIndex = _skinIndex;
			 */

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

		public static function checkCol(crystals:Vector.<Crystal>):Boolean
		{
			var _resultCol:Boolean = false;
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
						/*
						   same color more than 3 time
						   [0] [1] [2] [3] [4] [5] [6] [7]
						   [a] [a] [a] [b] [c] [d] [e] [f]
						   [a] [b] [c] [d] [e] [f] [f] [f]
						 */

						if (_isSame)
						{
							// more than 3?
							_count++;

							// same more than 3
							if (_count > 1)
							{
								// eliminate all in row
								for (var _index:int = _currentIndex; _index <= k + 1; _index++)
								{
									crystals[_index].status = Crystal.STATUS_TOBE_REMOVE;
										//trace(" ! col remove : " + _index);
								}
								_resultCol = _resultCol || true;
							}
							else
							{
								_resultCol = _resultCol || false;
							}
						}
						k++;
					}
					k++;
				}
			}
			
			// result
			//checkSignal.dispatch(_resultCol || _resultRow, crystals);
			return _resultCol;
		}
		
		public static function checkRow(crystals:Vector.<Crystal>):Boolean
		{
			//checkSignal.addOnce(listener);
				var _resultRow:Boolean = false;

				// all in col
				for (var j:int = 0; j < crystals.length; j++)
				{
					var _isSame:Boolean;
					var k:int = j;
					var _count:int = 0;

					var _skinIndex:uint = crystals[j].skinIndex;

					// start skin index same as other skin index?
					while ((k + config.COL_SIZE < config.ROW_SIZE * config.COL_SIZE) && (_isSame = (_skinIndex == crystals[k + config.COL_SIZE].skinIndex)))
					{
						if (_isSame && crystals[k + config.COL_SIZE].status != Crystal.STATUS_TOBE_REMOVE)
						{
							// more than 3?
							_count++;
						
							// same more than 3
							if (_count > 1)
							{
								// eliminate all in col
								var _position:Point = getPositionFromIndex(j, config.COL_SIZE);
								//for (var _index:int = j; _index <= (_position.y+_count)*config.COL_SIZE; _index += config.COL_SIZE)
								for (var _index:int = _position.y; _index<=_position.y+_count;_index++)
								{
									crystals[_position.x + _index*config.COL_SIZE].status = Crystal.STATUS_TOBE_REMOVE;
									//trace(" ! remove : " + (_position.x + _index*config.COL_SIZE));
								}
								
								_resultRow = _resultRow || true;
							}
							else
							{
								_resultRow = _resultRow || false;
							}
						}
						k += config.COL_SIZE;
					}
				}
			
			trace("_result:" + _resultRow);
			
			// result
			return _resultRow;
		}
	}
}