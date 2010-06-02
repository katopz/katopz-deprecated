package application.view.components
{
	import application.model.CrystalDataProxy;
	import application.model.Rules;

	import com.greensock.TweenLite;
	import com.sleepydesign.core.CommandManager;
	import com.sleepydesign.display.SDSprite;

	import flash.events.MouseEvent;
	import flash.geom.Point;

	import org.osflash.signals.Signal;

	public class Board extends SDSprite
	{
		// signal
		public var moveSignal:Signal = new Signal();
		public var effectSignal:Signal = new Signal();

		// status
		private const SELECT_FOCUS:String = "SELECT_FOCUS";
		private const SELECT_SWAP:String = "SELECT_SWAP";
		private var _status:String = SELECT_FOCUS;

		// view
		private var _canvas:SDSprite;

		// focus
		private var _focusCrystal:Crystal;

		public function get focusCrystal():Crystal
		{
			return _focusCrystal;
		}

		private var _swapCrystal:Crystal;

		public function get swapCrystal():Crystal
		{
			return _swapCrystal;
		}

		/*
		   public function get crystals():Vector.<Crystal>
		   {
		   return CrystalDataProxy._crystals;
		   }

		   public function set crystals(value:Vector.<Crystal>):void
		   {
		   CrystalDataProxy._crystals = value;
		   }
		 */

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

		public function init(crystals:Vector.<Crystal>):void
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
								}
							}
						}
						break;
				}
			}
		}

		private function onSwapComplete():void
		{
			trace(" ! onSwapComplete");
			CrystalDataProxy.swapByID(_focusCrystal.id, _swapCrystal.id);

			trace(" > Begin Check condition...");
			checkRule(CrystalDataProxy.isSameColorRemain());
		}

		private function checkRule(result:Boolean):void
		{
			trace(" < End Check condition...");
			if (result)
			{
				// good move
				trace(" * Call good effect");
				BoardEffect.doGoodEffect(onGoodMoveComplete);
			}
			else
			{
				// bad move
				trace(" ! Bad move");
				BoardEffect.showSwapEffect(_focusCrystal, _swapCrystal, onBadMoveComplete);

				// swap back
				CrystalDataProxy.swapByID(_focusCrystal.id, _swapCrystal.id);
			}
		}

		private function onGoodMoveComplete():void
		{
			trace(" < End Effect");
			//refill();
			effectSignal.dispatch();
		}

		public function refill(crystals:Vector.<Crystal>):void
		{
			trace(" > Begin Refill");

			BoardEffect.onMoveComplete(onMoveEffectComplete);
		}

		private function onMoveEffectComplete():void
		{
			trace(" > Begin Recheck");
			reCheck(CrystalDataProxy.isSameColorRemain());
		}

		private function reCheck(result:Boolean):void
		{
			if (result)
			{
				checkRule(result);
			}
			else
			{
				trace(" < End ReCheck");
				trace(" > Begin Game over check");
				if (!CrystalDataProxy.isOver())
				{
					trace(" < End Game over check");
					nextTurn();
				}
				else
				{
					trace(" < Game Over!");
				}
			}
		}

		private function onBadMoveComplete():void
		{
			nextTurn();
		}

		private function nextTurn():void
		{
			trace(" ! nextTurn");

			// dispose
			_focusCrystal = _swapCrystal = null;

			// accept inpt
			enabled = true;
			_status = SELECT_FOCUS;
		}

		override public function destroy():void
		{
			removeEventListener(MouseEvent.CLICK, onClick);
			_focusCrystal = _swapCrystal = null;
			super.destroy();
		}
	}
}