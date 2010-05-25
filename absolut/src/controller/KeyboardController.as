package controller
{
	import flash.display.DisplayObjectContainer;
	import flash.events.KeyboardEvent;

	import org.osflash.signals.Signal;

	public class KeyboardController
	{
		public static var keySignal:Signal = new Signal(KeyboardEvent);
		private static var _container:DisplayObjectContainer;

		private static var _instance:KeyboardController;

		public function KeyboardController(singletonEnforcer:SingletonEnforcer)
		{

		}

		public static function getInstance():KeyboardController
		{
			if (KeyboardController._instance == null)
				KeyboardController._instance = new KeyboardController(new SingletonEnforcer());

			return KeyboardController._instance;
		}

		public function initContainer(container:DisplayObjectContainer):void
		{
			_container = container;
			
			_container.addEventListener(KeyboardEvent.KEY_DOWN, function(event:KeyboardEvent):void
				{
					keySignal.dispatch(event)
				});
		}
	}
}

internal class SingletonEnforcer
{
}