package application.model
{
	import application.ApplicationFacade;
	import application.view.components.Crystal;
	import application.view.components.CrystalStatus;
	
	import com.sleepydesign.system.DebugUtil;
	
	import flash.geom.Point;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;

	public class CrystalDataProxy extends Proxy implements IProxy
	{
		public static const NAME:String = "DataProxy";

		// status
		public var inGame:Boolean = false;

		//
		private static var _crystals:Vector.<Crystal>;

		public static function get crystals():Vector.<Crystal>
		{
			return _crystals;
		}

		// Constructor.
		public function CrystalDataProxy()
		{
			super(NAME);

			_crystals = new Vector.<Crystal>();

			for (var j:int = 0; j < Rules.ROW_SIZE; j++)
			{
				for (var i:int = 0; i < Rules.COL_SIZE; i++)
				{
					// init
					var _crystal:Crystal = new Crystal();
					_crystals.push(_crystal);
					_crystal.id = j * Rules.COL_SIZE + i;

					// position
					_crystal.x = i * _crystal.width;
					_crystal.y = j * _crystal.height;
				}
			}
		}

		public function userMove(sourceID:int, targetID:int):void //focusCrystal:Crystal, swapCrystal:Crystal):void
		{
			swapByID(sourceID, targetID);
			var _result:Boolean = isSameColorRemain();
			sendNotification(ApplicationFacade.USER_MOVE_DONE, _result);
			
			// bad move -> swap back
			if(!_result)
				swapByID(sourceID, targetID);
		}

		public function effectDone():void
		{
			//refill
			var _crystal:Crystal
			var _index:int = crystals.length;

			// from bottom to top
			while (--_index > -1)
			{
				_crystal = crystals[_index];

				// it's removed
				if (_crystal.status == CrystalStatus.REMOVED || _crystal.status == CrystalStatus.MOVE)
				{
					if (!_crystal.prevPoint)
						_crystal.prevPoint = new Point(_crystal.x, _crystal.y);

					// find top most to replace
					var _aboveCrystal:Crystal = CrystalDataProxy.getAboveCrystal(_index, Rules.COL_SIZE);
					if (_aboveCrystal)
					{
						// fall to bottom
						_aboveCrystal.status = CrystalStatus.MOVE;
						if (!_aboveCrystal.prevPoint)
							_aboveCrystal.prevPoint = new Point(_aboveCrystal.x, _aboveCrystal.y);

						_crystal.status = CrystalStatus.READY;

						CrystalDataProxy.swapPosition(_crystal, _aboveCrystal);
						CrystalDataProxy.swapByID(_crystal.id, _aboveCrystal.id);
					}
					else
					{
						// stable position wait for reveal
						_crystal.alpha = 1;
						_crystal.spin();

						_crystal.status = CrystalStatus.READY;
					}
				}
			}
			sendNotification(ApplicationFacade.REFILL_DONE, isSameColorRemain());
		}

		public function resetGame():void
		{
			shuffle(_crystals);
		}

		public function shuffle(crystals:Vector.<Crystal>):void
		{
			trace(" ! Shuffle");
			for each (var _crystal:Crystal in crystals)
			{
				_crystal.spin();
				_crystal.status = CrystalStatus.READY;
			}

			// Cheat -------------------------------------------------

			/*
			   var _k:int = 1;

			   _crystals[0].spin(0);
			   _crystals[8].spin(0);
			   _crystals[16].spin(1);
			   _crystals[24].spin(0);
			   _crystals[32].spin(0);
			   _crystals[40].spin(2);

			   var _i:int = 0;
			   var _j:int = 2;

			   _crystals[_i++ * Rules.COL_SIZE + _j].spin(0);
			   _crystals[_i++ * Rules.COL_SIZE + _j].spin(1);
			   _crystals[_i++ * Rules.COL_SIZE + _j].spin(0);
			   //_crystals[_i++ * config.COL_SIZE + _j].spin(0);


			   _crystals[8].spin(0);
			   _crystals[9].spin(0);
			   _crystals[11].spin(0);

			   _crystals[0].spin(0);
			   _crystals[1].spin(1);
			   _crystals[2].spin(5);
			   _crystals[3].spin(4);

			   _crystals[4].spin(0);
			   _crystals[5].spin(1);
			   _crystals[6].spin(0);
			   _crystals[7].spin(0);

			   var _k:int = 1;

			   _crystals[_k * 8 + 0].spin(5);
			   _crystals[_k * 8 + 1].spin(1);
			   _crystals[_k * 8 + 2].spin(2);
			   _crystals[_k * 8 + 3].spin(3);

			   _crystals[_k * 8 + 4].spin(1);
			   _crystals[_k * 8 + 5].spin(1);
			   _crystals[_k * 8 + 6].spin(0);
			   _crystals[_k * 8 + 7].spin(0);

			   _k = 2;

			   _crystals[_k * 8 + 0].spin(2);
			   _crystals[_k * 8 + 1].spin(2);
			   _crystals[_k * 8 + 2].spin(1);
			   _crystals[_k * 8 + 3].spin(3);

			   _crystals[_k * 8 + 4].spin(3);
			   _crystals[_k * 8 + 5].spin(1);
			   _crystals[_k * 8 + 6].spin(0);
			   _crystals[_k * 8 + 7].spin(0);
			 */

			// ------------------------------------------------- Cheat

			// still have good condition left
			if (Rules.isSameColorRemain(crystals))
				shuffle(crystals);

			// can't be play
			if (Rules.isOver(crystals))
				shuffle(crystals);
		}

		// select
		public function getCrystals():Vector.<Crystal>
		{
			return crystals;
		}

		public static function getAboveCrystal(index:int, size:uint):Crystal
		{
			while (((index -= size) >= 0) && (_crystals[index].status != CrystalStatus.READY))
			{
			}
			return index > -1 ? _crystals[index] : null;
		}

		public static function getPositionFromIndex(index:int, size:uint):Point
		{
			return new Point(int(index % size), int(index / size));
		}

		private static var _comboScore:uint = 0;
		private static var _totalScore:uint = 0;
		
		public static function isSameColorRemain():Boolean
		{
			var _result:Boolean = Rules.isSameColorRemain(_crystals);
			
			var _score:uint = 0;
			for each (var _crystal:Crystal in crystals)
				if(_crystal.status == CrystalStatus.TOBE_REMOVE)
					_score++;
			
			_totalScore = _totalScore + _score;
				
			if(_score > 0)
			{
				++_comboScore;
				DebugUtil.trace(" ! Score : " + _score);
				DebugUtil.trace(" ! Combo : " + _comboScore);
			}else{
				_comboScore = 0;
				DebugUtil.trace(" ! Total : " + _totalScore);
			}
			
			return _result;
		}

		public static function isOver():Boolean
		{
			return Rules.isOver(_crystals);
		}

		// modify
		public static function swapPosition(source:Crystal, target:Crystal):void
		{
			var _x:Number = source.x;
			source.x = target.x;
			target.x = _x;

			var _y:Number = source.y;
			source.y = target.y;
			target.y = _y;
		}

		public static function swapByID(srcID:int, targetID:int):void
		{
			var _crystal:Crystal = _crystals[targetID];
			_crystals[targetID] = _crystals[srcID];
			_crystals[srcID] = _crystal;

			var _status:String = _crystals[targetID].status;
			_crystals[targetID].status = _crystals[srcID].status;
			_crystals[srcID].status = _status;

			var _id:int = _crystals[targetID].id;
			_crystals[targetID].id = _crystals[srcID].id;
			_crystals[srcID].id = _id;
		}
	}
}