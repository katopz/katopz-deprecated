package application.view.components
{
	import application.model.CrystalDataProxy;

	import com.greensock.TweenLite;
	import com.sleepydesign.core.CommandManager;
	import com.sleepydesign.display.SDSprite;

	import flash.geom.Point;

	public class BoardEffect extends SDSprite
	{
		public static function get crystals():Vector.<Crystal>
		{
			return CrystalDataProxy._crystals;
		}

		public static function set crystals(value:Vector.<Crystal>):void
		{
			CrystalDataProxy._crystals = value;
		}

		public static function showSwapEffect(sourceCrystal:Crystal, targetCrystal:Crystal, callBack:Function):void
		{
			var _commandManager:CommandManager = new CommandManager(true);
			_commandManager.addCommand(new SwapCrystalEffect(sourceCrystal, targetCrystal));
			_commandManager.addCommand(new SwapCrystalEffect(targetCrystal, sourceCrystal));
			_commandManager.completeSignal.addOnce(callBack);
			_commandManager.start();
		}

		public static function doGoodEffect(callBack:Function):void
		{
			trace(" > Begin Effect");
			var _commandManager:CommandManager = new CommandManager(true);
			for each (var _crystal:Crystal in crystals)
				if (_crystal.status == CrystalStatus.TOBE_REMOVE)
					_commandManager.addCommand(new HideCrystalEffect(_crystal));
			_commandManager.completeSignal.addOnce(callBack);
			_commandManager.start();
		}
		
		private static var _fillEffect:CommandManager = new CommandManager(true);
		public static function onMoveComplete(callBack:Function):void
		{
			trace(" < End Refill");
			
			// begin effect
			_fillEffect.stop();
			_fillEffect.completeSignal.removeAll();
			
			for each (var _crystal:Crystal in crystals)
			{
				if (!_crystal.prevPoint)
					continue;
				
				_crystal.nextPoint = new Point(_crystal.x, _crystal.y);
				
				if (_crystal.prevPoint.y < _crystal.nextPoint.y)
				{
					// do effect only falling
					_crystal.x = _crystal.prevPoint.x;
					_crystal.y = _crystal.prevPoint.y;
					_fillEffect.addCommand(new MoveCrystalEffect(_crystal));
				}
				else if (_crystal.prevPoint)
				{
					// swap from bottom? make it higher
					_crystal.x = _crystal.nextPoint.x;
					_crystal.y = -_crystal.nextPoint.y - Crystal.SIZE;
					_fillEffect.addCommand(new MoveCrystalEffect(_crystal));
				}
			}
			
			_fillEffect.completeSignal.addOnce(callBack);
			_fillEffect.start();
		}
	}
}

import application.model.CrystalDataProxy;
import application.view.components.Crystal;
import application.view.components.CrystalStatus;

import com.greensock.TweenLite;
import com.sleepydesign.core.SDCommand;

import flash.geom.Point;

internal class HideCrystalEffect extends SDCommand
{
	private var _crystal:Crystal;

	public function HideCrystalEffect(crystal:Crystal)
	{
		_crystal = crystal;
	}

	override public function doCommand():void
	{
		TweenLite.to(_crystal, .25, {alpha: 0, onComplete: super.doCommand});
	}

	override public function command():void
	{
		_crystal.status = CrystalStatus.REMOVED;
	}
}

internal class SwapCrystalEffect extends SDCommand
{
	private var _position:Point;
	private var _focusCrystal:Crystal;

	public function SwapCrystalEffect(focusCrystal:Crystal, swapCrystal:Crystal)
	{
		_focusCrystal = focusCrystal;
		_position = new Point(swapCrystal.x, swapCrystal.y);
	}

	override public function doCommand():void
	{
		TweenLite.to(_focusCrystal, .5, {x: _position.x, y: _position.y, onComplete: super.doCommand});
	}

	override public function command():void
	{
		_focusCrystal.focus = false;
	}
}

internal class MoveCrystalEffect extends SDCommand
{
	private var _crystal:Crystal;

	public function MoveCrystalEffect(crystal:Crystal)
	{
		_crystal = crystal;
	}

	override public function doCommand():void
	{
		TweenLite.to(_crystal, 0.5 * 1000 / Math.abs(_crystal.nextPoint.y - _crystal.y) / Crystal.SIZE, {alpha:1, x:_crystal.nextPoint.x, y:_crystal.nextPoint.y, onComplete: super.doCommand});
	}

	override public function command():void
	{
		_crystal.prevPoint = _crystal.nextPoint = null;
	}
}