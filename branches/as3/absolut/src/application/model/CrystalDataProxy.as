package application.model
{
	import application.view.components.Crystal;
	import application.view.components.CrystalStatus;
	
	import flash.geom.Point;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class CrystalDataProxy extends Proxy implements IProxy
	{
		public static const NAME:String = "DataProxy";
		
		// status
		public var inGame:Boolean = false;
		
		//
		public static var _crystals:Vector.<Crystal>;
		
		// Level.
		/*
		public function get level():Number
		{
		return _level;
		}
		
		public function set level(value:Number):void
		{
		if ( value <= 3 && value >= 1 )
		{
		_level = value;
		map.put("level", value);
		}
		else
		{
		trace("Wrong value.");
		}
		}
		*/
		/*
		// soundState.
		public function get soundState():Boolean
		{
		return _soundState;
		}
		
		public function set soundState(value:Boolean):void
		{
		_soundState = value;
		sendNotification(ApplicationFacade.SOUND_CHANGE, value);
		map.put("soundState", value);
		}
		*/
		
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
					//_canvas.addChild(_crystal);
					_crystals.push(_crystal);
					_crystal.id = j * Rules.COL_SIZE + i;
					
					// position
					_crystal.x = i * _crystal.width;
					_crystal.y = j * _crystal.height;
				}
			}
		}
		
		public function userMove(_focusCrystal:Crystal, _swapCrystal:Crystal):void
		{
			// move data
			
			// check win condition
			/*
			if ( isWinner(x, y, userTile) == winningMove )
			{
			inGame = false;
			sendNotification( ApplicationFacade.GAME_OVER, wrapWinCoordinates(userTile) );
			resetGame();
			}
			*/
		}
		
		public function userMoveDone():void
		{
			trace("TODO : check for gameover condition");
		}
		
		public function resetGame():void
		{
			shuffle(_crystals);
		}
		
		public function shuffle(crystals:Vector.<Crystal>):void
		{
			trace(" ! Shuffle");
			for each (var _crystal:Crystal in _crystals)
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
			
			if (Rules.isSameColorRemain(crystals))
				shuffle(crystals);
		}
		
		// select
		public static function getAboveCrystal(crystals:Vector.<Crystal>, index:int, size:uint):Crystal
		{
			while (((index -= size) >= 0) && (crystals[index].status != CrystalStatus.READY))
			{
			}
			return index > -1 ? crystals[index] : null;
		}
		
		public static function getPositionFromIndex(index:int, size:uint):Point
		{
			return new Point(int(index % size), int(index / size));
		}
		
		// modify
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
	}
}