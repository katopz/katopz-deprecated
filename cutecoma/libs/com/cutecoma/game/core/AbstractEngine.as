package com.cutecoma.game.core
{
	import com.sleepydesign.display.SDSprite;
	import com.sleepydesign.events.RemovableEventDispatcher;

	import flash.display.Sprite;
	import flash.events.Event;

	public class AbstractEngine extends RemovableEventDispatcher
	{
		protected var _container:Sprite;

		public function AbstractEngine():void
		{
			super();
		}

		public function start():void
		{
			if (!_container)
				_container = new SDSprite();

			_container.removeEventListener(Event.ENTER_FRAME, run);
			_container.addEventListener(Event.ENTER_FRAME, run);
		}

		public function stop():void
		{
			_container.removeEventListener(Event.ENTER_FRAME, run);
		}

		protected function run(event:Event = null):void
		{
			//
		}
	}
}
