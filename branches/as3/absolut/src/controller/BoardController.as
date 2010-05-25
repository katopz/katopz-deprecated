package controller
{
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;

	import org.osflash.signals.Signal;

	public class BoardController
	{
		public static var mouseSignal:Signal = new Signal(MouseEvent);
		private static var _container:DisplayObjectContainer;

		private static var _instance:BoardController;

		public function BoardController(singletonEnforcer:SingletonEnforcer)
		{

		}

		public static function getInstance():BoardController
		{
			if (BoardController._instance == null)
				BoardController._instance = new BoardController(new SingletonEnforcer());

			return BoardController._instance;
		}

		public function initContainer(container:DisplayObjectContainer):void
		{
			_container = container;
			
			_container.addEventListener(MouseEvent.CLICK, function(event:MouseEvent):void
				{
					mouseSignal.dispatch(event);
				});
		}
	}
}

internal class SingletonEnforcer
{
}