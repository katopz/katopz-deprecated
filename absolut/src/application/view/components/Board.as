package application.view.components
{
	import application.model.ConfigProxy;
	import application.model.CrystalProxy;
	import application.model.RuleProxy;
	
	import com.greensock.TweenLite;
	import com.sleepydesign.display.SDSprite;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import org.osflash.signals.Signal;

	public class Board extends SDSprite
	{
		// signal
		public var initSignal:Signal = new Signal();
		
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

		public function Board()
		{
			addEventListener(Event.ADDED_TO_STAGE, onStage, false, 0, true);
		}

		private function onStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onStage);
			init();
		}
		
		private function init():void
		{
			// canvas
			addChild(_canvas = new SDSprite());
			
			_crystals = new Vector.<Crystal>();
			
			for (var j:int = 0; j < ConfigProxy.ROW_SIZE; j++)
			{
				for (var i:int = 0; i < ConfigProxy.COL_SIZE; i++)
				{
					// init
					var _crystal:Crystal = new Crystal();
					_canvas.addChild(_crystal);
					_crystals.push(_crystal);
					_crystal.id = j * ConfigProxy.COL_SIZE + i;
					
					// position
					_crystal.x = i * _crystal.width;
					_crystal.y = j * _crystal.height;
				}
			}
			
			shuffle();
			
			addEventListener(MouseEvent.CLICK, onClick);
			
			initSignal.dispatch();
		}
		
		public function shuffle(e:* = null):void
		{
			trace(" ! Shuffle");
			var _length:int = _crystals.length;
			for (var _index:int = 0; _index < _length; _index++)
			{
				var _crystal:Crystal = _crystals[_index];
				_crystal.spin();
				_crystal.status = Crystal.STATUS_READY;
			}
			
			// Cheat -------------------------------------------------
			var _i:int = 0;
			var _j:int = 2;

			_crystals[_i++ * ConfigProxy.COL_SIZE + _j].spin(0);
			_crystals[_i++ * ConfigProxy.COL_SIZE + _j].spin(1);
			_crystals[_i++ * ConfigProxy.COL_SIZE + _j].spin(0);
			//_crystals[_i++ * config.COL_SIZE + _j].spin(0);
			
			_crystals[8].spin(0);
			_crystals[9].spin(0);
			_crystals[11].spin(0);
			
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
			
			// ------------------------------------------------- Cheat

			if(RuleProxy.checkSame(_crystals))
				shuffle();
		}

		public function onClick(event:MouseEvent):void
		{
			// click on crystal
			if (event.target.parent is Crystal)
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
						if (_focusCrystal == _crystal)
						{
							_crystal.focus = !_crystal.focus;
							_focusCrystal = null;
							_status = SELECT_FOCUS;
							unfreeze();
							return;
						}

						// rule #1 : nearby?
						if (!CrystalProxy.isNearby(_focusCrystal.id, _crystal.id))
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
				CrystalProxy.swapByID(_crystals, _focusCrystal.id, _swapCrystal.id);

				trace(" > Begin Check condition...");
				//Rule.check(_crystals, onCheckComplete);
				onCheckComplete(RuleProxy.checkSame(_crystals));
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
				CrystalProxy.swapByID(_crystals, _focusCrystal.id, _swapCrystal.id);
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

			var _topCrystals:Vector.<Crystal> = new Vector.<Crystal>(ConfigProxy.COL_SIZE, true);
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
					var _aboveCrystal:Crystal = CrystalProxy.getAboveCrystal(_crystals, _index, ConfigProxy.COL_SIZE);
					if (_aboveCrystal)
					{
						// fall to bottom
						_crystal.swapID = _aboveCrystal.id;
						_aboveCrystal.status = Crystal.STATUS_FALL;

						onRefillComplete(_crystal);
					}
					else
					{
						// nothing on top, get top most from stock
						_crystal.alpha = 1;
						_crystal.spin();
						_crystal.status = Crystal.STATUS_READY;
						_crystal.swapID = -1;

						onRefillComplete(_crystal);
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
				CrystalProxy.swapPositionByID(_crystals, crystal.id, crystal.swapID);
				CrystalProxy.swapByID(_crystals, crystal.id, crystal.swapID);

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
			reCheck(RuleProxy.checkSame(_crystals));
		}

		private function reCheck(result:Boolean):void
		{
			if (result)
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