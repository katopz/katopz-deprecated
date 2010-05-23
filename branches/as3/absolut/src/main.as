package
{
	import com.greensock.TweenLite;
	import com.sleepydesign.display.SDSprite;
	
	import control.Rule;
	
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
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

		private var _crystals:Vector.<Crystal>;

		public function main()
		{
			// canvas
			addChild(_canvas = new SDSprite());

			_crystals = new Vector.<Crystal>();

			for (var j:int = 0; j < config.ROW_SIZE; j++)
			{
				for (var i:int = 0; i < config.COL_SIZE; i++)
				{
					// init
					var _crystal:Crystal = new Crystal();
					_canvas.addChild(_crystal);
					_crystals.push(_crystal);
					_crystal.id = j * config.COL_SIZE + i;

					// position
					_crystal.x = i * _crystal.width;
					_crystal.y = j * _crystal.height;
				}
			}

			shuffle();

			_crystals[0].spin(0);
			_crystals[1].spin(1);
			_crystals[2].spin(2);
			_crystals[3].spin(3);

			_crystals[4].spin(0);
			_crystals[5].spin(1);
			_crystals[6].spin(2);
			_crystals[7].spin(3);

			var _k:int = 2;

			_crystals[_k * 8 + 0].spin(0);
			_crystals[_k * 8 + 1].spin(1);
			_crystals[_k * 8 + 2].spin(0);
			_crystals[_k * 8 + 3].spin(0);

			_crystals[_k * 8 + 4].spin(1);
			_crystals[_k * 8 + 5].spin(2);
			_crystals[_k * 8 + 6].spin(3);
			_crystals[_k * 8 + 6].spin(4);

			_canvas.addEventListener(MouseEvent.CLICK, onClick);

			// debug
			stage.addEventListener(KeyboardEvent.KEY_DOWN, shuffle);
		}

		private function shuffle(e:* = null):void
		{
			var _length:int = _crystals.length;
			for (var _index:int = 0; _index < _length; _index++)
			{
				var _crystal:Crystal = _crystals[_index];
				_crystal.spin();
			}

			Rule.check(_crystals, onShuffleComplete);
		}

		private function onShuffleComplete(result:Boolean, crystals:Vector.<Crystal>):void
		{
			if (result)
				shuffle();
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

				// swap
				var _crystal:Crystal = _crystals[_swapCrystal.id];
				_crystals[_swapCrystal.id] = _crystals[_focusCrystal.id];
				_crystals[_focusCrystal.id] = _crystal;

				trace(" > Begin Check condition...");
				Rule.check(_crystals, onCheckComplete);
			}
		}

		private function onCheckComplete(result:Boolean, crystals:Vector.<Crystal>):void
		{
			trace(" < End Check condition...");
			if (result)
			{
				// good move
				trace(" * Call good effect");
				doGoodEffect();
			}
			else
			{
				// bad move
				trace(" ! Bad move");
				TweenLite.to(_focusCrystal, .5, {x: _swapCrystal.x, y: _swapCrystal.y, onComplete: onBadMoveComplete, onCompleteParams: [_focusCrystal]});
				TweenLite.to(_swapCrystal, .5, {x: _focusCrystal.x, y: _focusCrystal.y, onComplete: onBadMoveComplete, onCompleteParams: [_swapCrystal]});
			}
		}

		private function doGoodEffect():void
		{
			var _length:int = _crystals.length;
			for (var _index:int = 0; _index < _length; _index++)
			{
				// TODO add effect
				var _crystal:Crystal = _crystals[_index];
				if (_crystal.status == Crystal.STATUS_TOBE_REMOVE)
					TweenLite.to(_crystal, .25, {alpha:0, onComplete: onGoodMoveComplete, onCompleteParams: [_crystals[_index]]});
			}
			trace(" * Effect done");
		}

		private function onGoodMoveComplete(crystal:Crystal):void
		{
			// mark as done
			crystal.status = Crystal.STATUS_REMOVED;
			
			// all clean?
			var _length:int = _crystals.length;
			while(--_length>-1 && (_crystals[_length].status != Crystal.STATUS_TOBE_REMOVE))
			{
				//
			}
			if(_length > -1)
				return;
			
			trace(" ! onGoodMoveComplete");
			
			trace(" * falling down");

			trace(" * Recheck until all ready");

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