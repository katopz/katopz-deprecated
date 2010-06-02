package application.view.components
{
	import application.model.CrystalDataProxy;
	import application.model.Rules;

	import com.greensock.TweenLite;
	import com.sleepydesign.display.SDSprite;

	import flash.events.MouseEvent;

	import org.osflash.signals.Signal;

	public class Board extends SDSprite
	{
		// signal
		public var moveSignal:Signal = new Signal();
		public var effectSignal:Signal = new Signal();
		public var gameoverSignal:Signal = new Signal();

		// status
		private const SELECT_FOCUS:String = "SELECT_FOCUS";
		private const SELECT_SWAP:String = "SELECT_SWAP";
		private var _status:String = SELECT_FOCUS;

		// view
		private var _canvas:SDSprite;

		// focus
		private var _focusCrystal:Crystal;
		private var _swapCrystal:Crystal;

		// interactive
		private var _enabled:Boolean;

		public function get enabled():Boolean
		{
			return _enabled;
		}

		public function set enabled(value:Boolean):void
		{
			_enabled = _canvas.mouseEnabled = _canvas.mouseChildren = value;
		}

		public function Board()
		{
			// canvas
			addChild(_canvas = new SDSprite());
		}

		public function initView(crystals:Vector.<Crystal>):void
		{
			for each (var _crystal:Crystal in crystals)
				_canvas.addChild(_crystal);

			addEventListener(MouseEvent.CLICK, onClick);
		}

		public function onClick(event:MouseEvent):void
		{
			// click on crystal
			if (event.target.parent is Crystal)
			{
				var _crystal:Crystal = event.target.parent;
				if (_crystal)
					setFocusCrystal(_crystal);
			}
		}

		private function setFocusCrystal(crystal:Crystal):void
		{
			// click on crystal
			if (crystal)
			{
				enabled = false;
				switch (_status)
				{
					case SELECT_FOCUS:

						// click on old crystal
						crystal.focus = !crystal.focus;

						// mark as focus
						_focusCrystal = crystal;

						// wait for next click
						enabled = true;

						_status = SELECT_SWAP;

						break;

					case SELECT_SWAP:

						// click on old crystal
						if (_focusCrystal == crystal)
						{
							crystal.focus = !crystal.focus;
							_focusCrystal = null;
							_status = SELECT_FOCUS;
							enabled = true;
						}
						else
						{
							// rule #1 : nearby?
							if (!Rules.hasNeighbor(_focusCrystal.id, crystal.id))
							{
								// refocus
								_focusCrystal.focus = !_focusCrystal.focus;
								_status = SELECT_FOCUS;
								setFocusCrystal(crystal);
							}
							else
							{
								// click on other crystal
								crystal.focus = !crystal.focus;

								// already mark?
								if (_focusCrystal)
								{
									// will swap focus crystal with this one
									_swapCrystal = crystal;

									// swap both
									BoardEffect.showSwapEffect(_focusCrystal, _swapCrystal, onSwapComplete);
									CrystalDataProxy.swapByID(_focusCrystal.id, _swapCrystal.id);
								}
							}
						}
						break;
				}
			}
		}

		private function onSwapComplete():void
		{
			trace(" * Check");
			checkRule(CrystalDataProxy.isSameColorRemain());
		}

		private function checkRule(result:Boolean):void
		{
			if (result)
			{
				// good move
				trace(" ! Good move -> call effect -> refill");
				BoardEffect.doGoodEffect(effectSignal.dispatch);
			}
			else
			{
				// bad move
				trace(" ! Bad move -> swap -> next turn");
				BoardEffect.showSwapEffect(_focusCrystal, _swapCrystal, nextTurn);

				// swap back
				trace(" * Swap back");
				CrystalDataProxy.swapByID(_focusCrystal.id, _swapCrystal.id);
			}
		}

		public function refill(crystals:Vector.<Crystal>):void
		{
			trace(" * Refill");
			BoardEffect.onMoveComplete(crystals, onMoveEffectComplete);
		}

		private function onMoveEffectComplete():void
		{
			trace(" * Recheck");
			var result:Boolean = CrystalDataProxy.isSameColorRemain()
			if (result)
			{
				checkRule(result);
			}
			else
			{
				trace(" * Check for game over");
				if (!CrystalDataProxy.isOver())
					nextTurn();
				else
				{
					trace(" ! Game Over!");
					// TODO : send score -> app -> dialog
					gameoverSignal.dispatch();
				}
			}
		}

		private function nextTurn():void
		{
			trace(" ! nextTurn");

			// dispose
			_focusCrystal.focus = _swapCrystal.focus = false;
			_focusCrystal = _swapCrystal = null;

			// accept input
			enabled = true;
			_status = SELECT_FOCUS;
		}

		public function showHint(crystals:Vector.<Crystal>):void
		{
			if (_enabled)
				for each (var _crystal:Crystal in crystals)
					if (_crystal.isGoodToMove)
						TweenLite.to(_crystal, 0.25, {alpha:.1, onCompleteParams:[_crystal], onComplete:
								function (crystal:Crystal):void
							{
								TweenLite.to(crystal, 0.25, {alpha:1});
							}});
		}

		override public function destroy():void
		{
			removeEventListener(MouseEvent.CLICK, onClick);
			_focusCrystal = _swapCrystal = null;
			super.destroy();
		}
	}
}