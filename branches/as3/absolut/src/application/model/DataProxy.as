package application.model
{
	import application.ApplicationFacade;
	
	//import com.ericfeminella.collections.IMap;
	//import com.ericfeminella.collections.LocalPersistenceMap;
	
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
		
		// @tile - checks over user or AI tile.	
		private function isWinner(x:Number, y:Number, tile:Number):Number
		{
			// win condition
			return -1;
		}
		
		
		private function evaluatePosition(array:Array, tile:Number):Number
		{
			return -1;
		}
	}
}