package
{
	import com.greensock.TweenLite;
	import com.sleepydesign.display.SDSprite;
	
	import control.Rule;
	
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import view.Crystal;

	/**
	 * TODO
	 *
	 * - add row score rule
	 * - test deep fall
	 * - recheck combo
	 * - add real score
	 *
	 * @author katopz
	 */
	[SWF(backgroundColor="#FFFFFF", frameRate="30", width="800", height="600")]
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
/*
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
			_canvas.addEventListener(MouseEvent.CLICK, onClick);

			// debug
			stage.addEventListener(KeyboardEvent.KEY_DOWN, shuffle);
		}

		private function shuffle(e:* = null):void
		{
			trace(" ! Shuffle");
			var _length:int = _crystals.length;
			for (var _index:int = 0; _index < _length; _index++)
			{
				var _crystal:Crystal = _crystals[_index];
				_crystal.spin();
				_crystal.status = Crystal.STATUS_READY;
			}
			
			var _i:int = 0;
			var _j:int = 2;
			
			_crystals[_i++*config.COL_SIZE + _j].spin(0);
			_crystals[_i++*config.COL_SIZE + _j].spin(1);
			_crystals[_i++*config.COL_SIZE + _j].spin(0);
			_crystals[_i++*config.COL_SIZE + _j].spin(0);

			onShuffleComplete(Rule.checkCol(_crystals) || Rule.checkRow(_crystals));
		}

		private function onShuffleComplete(result:Boolean):void
		{
			if (result)
				shuffle();
		}

		private function onClick(event:MouseEvent):void
		{
			// click on crystal
			if(event.target.parent is Crystal)
			{
				//freeze
				freeze();
	
				var _crystal:Crystal = event.target.parent;
				if (_crystal)
					focusCrystal(_crystal);
			}
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
						
						// click on old crystal
						if(_focusCrystal == _crystal)
						{
							unfreeze();
							return;
						}

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
				Rule.swapByID(_crystals, _focusCrystal.id, _swapCrystal.id);

				trace(" > Begin Check condition...");
				//Rule.check(_crystals, onCheckComplete);
				onCheckComplete(Rule.checkCol(_crystals) || Rule.checkRow(_crystals));
			}
		}

		private function onCheckComplete(result:Boolean):void
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

				// swap back
				Rule.swapByID(_crystals, _focusCrystal.id, _swapCrystal.id);
			}
		}

		private function doGoodEffect():void
		{
			trace(" > Begin Effect");
			var _length:int = _crystals.length;
			for (var _index:int = 0; _index < _length; _index++)
			{
				var _crystal:Crystal = _crystals[_index];
				if (_crystal.status == Crystal.STATUS_TOBE_REMOVE)
				{
					TweenLite.to(_crystal, .25, {alpha: 0, onComplete: onGoodMoveComplete, onCompleteParams: [_crystal]});
				}
			}
		}

		private function onGoodMoveComplete(crystal:Crystal):void
		{
			// mark as done
			crystal.status = Crystal.STATUS_REMOVED;

			// all clean?
			var _length:int = _crystals.length;
			while (--_length > -1 && (_crystals[_length].status != Crystal.STATUS_TOBE_REMOVE))
			{
				//
			}
			if (_length > -1)
				return;

			trace(" < End Effect");
			refill();
		}

		private function refill():void
		{
			trace(" > Begin Refill");

			var _topCrystals:Vector.<Crystal> = new Vector.<Crystal>(config.COL_SIZE, true);
			var _position:Point;

			var _index:int = _crystals.length;
			// from bottom to top
			while (--_index > -1)
			{
				var _crystal:Crystal = _crystals[_index];
				// it's removed
				if (_crystal.status == Crystal.STATUS_REMOVED || _crystal.status == Crystal.STATUS_FALL)
				{
					// find top most to replace
					var _aboveCrystal:Crystal = Rule.getAboveCrystal(_crystals, _index, config.COL_SIZE);
					if (_aboveCrystal)
					{
						// got something on top

						// fall to bottom
						_crystal.swapID = _aboveCrystal.id;
						_aboveCrystal.status = Crystal.STATUS_FALL;

						//TweenLite.to(_aboveCrystal, .25, {x: _crystal.x, y: _crystal.y, onComplete: onRefillComplete, onCompleteParams: [_aboveCrystal]});

						//trace("fall:" + _crystal.id + "->" + _aboveCrystal.id);

						onRefillComplete(_crystal);

							// fall from top
							//_crystal.status = Crystal.STATUS_FALL;

							// move to top for pooling
						/*
						   _position = Rule.getPositionFromIndex(_index, config.COL_SIZE);
						   if(!_topCrystals[_position.x])
						   _topCrystals[_position.x] = _crystal;
						 */

					}
					else
					{
						// nothing on top, get top most from stock
						_crystal.alpha = 1;
						_crystal.spin();
						_crystal.status = Crystal.STATUS_READY;
						_crystal.swapID = -1;
						
						onRefillComplete(_crystal);

						/*
						   _position = Rule.getPositionFromIndex(_index, config.COL_SIZE);
						   _aboveCrystal = _topCrystals[_position.x];

						   trace(_aboveCrystal.id);

						   trace("*fall:"+_crystal.id+"->"+_aboveCrystal.id);
						   _aboveCrystal.y = _crystal.y-config.CYSTAL_SIZE;
						   _crystal.status = Crystal.STATUS_FALL;
						   var _x:Number = _crystal.x;
						   var _y:Number = _crystal.y;
						   TweenLite.to(_aboveCrystal, .25, {alpha:1, x: _x, y: _y, onComplete: onRefillComplete, onCompleteParams: [_aboveCrystal]});

						   // real swap
						   //Rule.swapByID(_crystals, _crystal.id, _aboveCrystal.id);


						   _topCrystals[_position.x] = null;

						   // to swap
						   _aboveCrystal.swapID = _crystal.id;

						   _aboveCrystal.spin();
						 */
					}
				}
			}
		}

		private function onRefillComplete(crystal:Crystal):void
		{
			// mark as done
			crystal.status = Crystal.STATUS_READY;

			// real swap
			if (crystal.swapID != -1)
			{
				Rule.swapPositionByID(_crystals, crystal.id, crystal.swapID);
				Rule.swapByID(_crystals, crystal.id, crystal.swapID);

				crystal.swapID = -1;
			}

			// all clean?
			var _length:int = _crystals.length;
			while (--_length > -1 && (_crystals[_length].status == Crystal.STATUS_READY))
			{
				//
			}
			if (_length > -1)
				return;

			trace(" < End Refill");

			trace(" > Begin Recheck");
			//Rule.check(_crystals, onCheckComplete);
			
			reCheck(Rule.checkCol(_crystals) || Rule.checkRow(_crystals));
		}

		private function reCheck(result:Boolean):void
		{
			if(result)
			{
				onCheckComplete(result);
			}
			else
			{
				trace(" < End ReCheck");
				nextTurn();
			}
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

			// dispose
			_focusCrystal = null;
			_swapCrystal = null;

			// accept inpt
			unfreeze();
			_status = SELECT_FOCUS;
		}
	}
}