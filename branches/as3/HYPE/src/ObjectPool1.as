/***********************************************

   HYPE
   http://hype.joshuadavis.com
   developed by Branden Hall and Joshua Davis.

 ************************************************/
package
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;

	import hype.extended.behavior.VariableVibration;
	import hype.extended.trigger.ExitShapeTrigger;
	import hype.framework.core.ObjectPool;
	import hype.framework.core.TimeType;
	import hype.framework.display.BitmapCanvas;
	import hype.framework.rhythm.SimpleRhythm;
	import net.hires.debug.Stats;

	[SWF(backgroundColor="#000000",frameRate="30",quality="MEDIUM",width="800",height="600")]
	public class ObjectPool1 extends Sprite
	{
		public function ObjectPool1()
		{
			var myExitShape:MyExitShape = new MyExitShape();
			addChild(myExitShape);

			var myWidth:Number = stage.stageWidth;
			var myHeight:Number = stage.stageHeight;

			var clipCanvas:BitmapCanvas = new BitmapCanvas(myWidth, myHeight);
			addChild(clipCanvas);

			var clipContainer:Sprite = new Sprite();

			var pool:ObjectPool = new ObjectPool(MyCircle, 200);

			function addNextClip(myRhythm:SimpleRhythm):void
			{
				pool.request();
			}

			var rhythm:SimpleRhythm = new SimpleRhythm(addNextClip);
			rhythm.start(TimeType.TIME, 1);

			pool.onRequestObject = function(clip:DisplayObject):void
			{
				clip.x = myWidth / 2;
				clip.y = myHeight / 2;
				clip.scaleX = clip.scaleY = 0.05 + (Math.floor(Math.random() * 3) * 0.3);

				// target Object, property, spring, ease, vibrationRange

				var xVibration:VariableVibration = new VariableVibration(clip, "x", 0.99, 0.05, 20);
				var yVibration:VariableVibration = new VariableVibration(clip, "y", 0.99, 0.05, 20);
				xVibration.start();
				yVibration.start();

				// exit callback function, target Object, shape, shapeFlag

				var exitTrigger:ExitShapeTrigger = new ExitShapeTrigger(onExitShape, clip, myExitShape, true);
				exitTrigger.start();

				clipContainer.addChild(clip);
			}

			function onExitShape(clip:DisplayObject):void
			{
				pool.release(clip);
				clipContainer.removeChild(clip);
			}

			clipCanvas.startCapture(clipContainer, false);

			var stats:Stats = new Stats();
			addChild(stats);
		}
	}
}

import flash.display.Sprite;

internal class MyCircle extends Sprite
{
	public function MyCircle()
	{
		graphics.beginFill(0xFF0000 * Math.random(), .8);
		graphics.drawCircle(0, 0, 10);
		graphics.endFill();
	}
}

internal class MyExitShape extends Sprite
{
	public function MyExitShape()
	{
		graphics.beginFill(0x003300);
		graphics.drawRect(800 / 2 - 320 / 2, 600 / 2 - 240 / 2, 320, 240);
		graphics.endFill();
	}
}