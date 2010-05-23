package
{
	import com.greensock.TweenLite;
	import com.sleepydesign.display.SDSprite;

	import control.Rule;

	import flash.display.Sprite;
	import flash.events.MouseEvent;

	import view.Crystal;

	public class main extends Sprite
	{
		// status
		private const SELECT_FOCUS:String = "SELECT_FOCUS";
		private const SELECT_SWAP:String = "SELECT_SWAP";
		private var _status:String = SELECT_FOCUS;

		// view
		private var _canvas:SDSprite;

		// focus
		private var _focusCrystal:Crystal;
		private var _swapCrystal:Crystal;

		private var _crystals:Array;

		public function main()
		{
			// canvas
			addChild(_canvas = new SDSprite());

			_crystals = [];

			for (var i:int = 0; i < config.COL_SIZE; i++)
			{
				for (var j:int = 0; j < config.ROW_SIZE; j++)
				{
					// init
					var _crystal:Crystal = new Crystal();
					_canvas.addChild(_crystal);
					_crystals.push(_crystal);
					_crystal.id = i * config.COL_SIZE + j;

					// position
					_crystal.x = i * _crystal.width;
					_crystal.y = j * _crystal.height;

					// texture
					_crystal.spin();
				}
			}

			_canvas.addEventListener(MouseEvent.CLICK, onClick);
		}

		private function onClick(event:MouseEvent):void
		{
			//freeze
			freeze();

			// click on crystal
			var _crystal:Crystal = event.target.parent;
			if (_crystal)
				focusCrystal(_crystal);
		}

		private function focusCrystal(_crystal:Crystal):void
		{
			// click on crystal
			if (_crystal)
			{
				switch (_status)
				{
					case SELECT_FOCUS:

						// click on old crystal
						_crystal.focus = !_crystal.focus;

						// mark as focus
						_focusCrystal = _crystal;

						// wait for next click
						unfreeze();
						_status = SELECT_SWAP;

						break;

					case SELECT_SWAP:

						// rule #1 : nearby?
						if (!Rule.isNearby(_focusCrystal.id, _crystal.id))
						{
							// refocus
							_focusCrystal.focus = !_focusCrystal.focus;
							_status = SELECT_FOCUS;
							focusCrystal(_crystal);
						}
						else
						{
							// click on other crystal
							_crystal.focus = !_crystal.focus;

							// already mark?
							if (_focusCrystal)
							{
								// will swap focus crystal with this one
								_swapCrystal = _crystal;

								// swap both
								TweenLite.to(_focusCrystal, .5, {x: _swapCrystal.x, y: _swapCrystal.y, onComplete: onSwapComplete, onCompleteParams: [_focusCrystal]});
								TweenLite.to(_swapCrystal, .5, {x: _focusCrystal.x, y: _focusCrystal.y, onComplete: onSwapComplete, onCompleteParams: [_swapCrystal]});
							}
						}

						break;
				}
			}
		}

		private function onSwapComplete(crystal:Crystal):void
		{
			// remove focus
			if (crystal)
				crystal.focus = false;

			// swap complete
			if (!_focusCrystal.focus && !_swapCrystal.focus)
			{
				trace(" ! onSwapComplete");
				trace(" > Begin Check condition...");
				Rule.check(_focusCrystal.id, _swapCrystal.id, _crystals, onCheckComplete);
			}
		}

		private function onCheckComplete(result:Boolean, crystals:Array):void
		{
			trace(" < End Check condition...");
			if (result)
			{
				// good move
				trace(" ! Good move");

				trace(" * Call effect");

				trace(" * Effect done");

				// done
				onGoodMoveComplete();
			}
			else
			{
				// bad move
				trace(" ! Bad move");
				TweenLite.to(_focusCrystal, .5, {x: _swapCrystal.x, y: _swapCrystal.y, onComplete: onBadMoveComplete, onCompleteParams: [_focusCrystal]});
				TweenLite.to(_swapCrystal, .5, {x: _focusCrystal.x, y: _focusCrystal.y, onComplete: onBadMoveComplete, onCompleteParams: [_swapCrystal]});
			}
		}

		private function onGoodMoveComplete():void
		{
			trace(" ! onGoodMoveComplete");

			// dispose
			_focusCrystal = null;
			_swapCrystal = null;

			nextTurn();
		}

		private function onBadMoveComplete(crystal:Crystal):void
		{
			// dispose
			if (crystal == _focusCrystal)
				_focusCrystal = null;

			if (crystal == _swapCrystal)
				_swapCrystal = null;

			// swap complete
			if (!_focusCrystal && !_swapCrystal)
			{
				trace(" ! onBadMoveComplete");
				nextTurn();
			}
		}

		private function freeze():void
		{
			trace(" ! freeze");
			_canvas.mouseEnabled = false;
			_canvas.mouseChildren = false;
		}

		private function unfreeze():void
		{
			trace(" ! unfreeze");
			_canvas.mouseEnabled = true;
			_canvas.mouseChildren = true;
		}

		private function nextTurn():void
		{
			trace(" ! nextTurn");
			unfreeze();
			_status = SELECT_FOCUS;
		}
	}
}