package application.model
{
	import application.view.components.Crystal;
	import application.view.components.CrystalStatus;
	
	import flash.geom.Point;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;

	public class DataProxy extends Proxy implements IProxy
	{
		public static const NAME:String = "DataProxy";

		public var inGame:Boolean = false;

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
		public function DataProxy()
		{
			super(NAME);

		/*
		   map = new LocalPersistenceMap("storage", "/");

		   if ( !map.containsKey("level") )
		   {
		   map.put("level", DataProxy.NORMAL);
		   map.put("soundState", true);
		   }

		   this.level = map.getValue("level");
		   this.soundState = map.getValue("soundState");

		   // Fill default arrays.
		   for ( var i:Number = 0; i < boardSize; i++ )
		   {
		   movesArray[i] = [];
		   userArray[i] = [];
		   AIArray[i] = [];

		   for ( var j:Number = 0; j < boardSize; j++ )
		   {
		   if ( i == this.centerTile && j == this.centerTile )
		   {
		   movesArray[i][j] = -1;
		   AIArray[i][j] = -1;
		   }
		   else
		   {
		   movesArray[i][j] = 0;
		   AIArray[i][j] = 0;
		   }
		   userArray[i][j] = 0;
		   }
		   }
		 */
		}

		public function userMove(x:Number, y:Number):void
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

		public function resetGame():void
		{
			//
		}

		private function evaluatePosition(array:Array, tile:Number):Number
		{
			return -1;
		}

		public static function hasNeighbour(focusID:int, swapID:int):Boolean
		{
			var _a:Point = getPositionFromIndex(focusID, Rules.COL_SIZE);
			var _b:Point = getPositionFromIndex(swapID, Rules.COL_SIZE);

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
			while (((index -= size) >= 0) && (crystals[index].status != CrystalStatus.READY))
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