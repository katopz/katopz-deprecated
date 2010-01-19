package com.sleepydesign.ui
{
	import com.sleepydesign.events.MouseUIEvent;
	import com.sleepydesign.events.RemovableEventDispatcher;
	
	import flash.display.InteractiveObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class MouseUI extends RemovableEventDispatcher
	{
		private var _target:InteractiveObject;
		private var _dragTarget:*;

		private var _lastPosition:Point = new Point();

		public static var isMouseDown:Boolean = false;

		public function MouseUI(target:InteractiveObject)
		{
			_target = target;
			create();
		}

		public function create():void
		{
			_target.addEventListener(MouseEvent.MOUSE_DOWN, onMouseHandler);
			_target.addEventListener(MouseEvent.MOUSE_UP, onMouseHandler);
			_target.addEventListener(MouseEvent.ROLL_OUT, onMouseHandler);
			_target.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
		}

		override public function destroy():void
		{
			super.destroy();
			
			/*
			_target.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseHandler);
			_target.removeEventListener(MouseEvent.MOUSE_UP, onMouseHandler);
			_target.removeEventListener(MouseEvent.MOUSE_OUT, onMouseHandler);
			_target.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);

			_target.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseHandler);
			*/

			_target = null;
			_dragTarget = null;
			_lastPosition = null;
		}

		private function onMouseHandler(event:MouseEvent):void
		{
			switch (event.type)
			{
				case MouseEvent.MOUSE_DOWN:
					_target["mouseChildren"] = true;
					isMouseDown = true;
					_lastPosition.x = event.stageX;
					_lastPosition.y = event.stageY;
					_dragTarget = event.target;

					_target.addEventListener(MouseEvent.MOUSE_MOVE, onMouseHandler, false, 0, true);
					break;
				case MouseEvent.ROLL_OUT:
				case MouseEvent.MOUSE_UP:
					_target["mouseChildren"] = true;
					isMouseDown = false;
					_lastPosition.x = event.stageX;
					_lastPosition.y = event.stageY;
					_dragTarget = null;

					_target.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseHandler);
					dispatchEvent(new MouseUIEvent(MouseUIEvent.MOUSE_DROP, {target: _dragTarget, dx: dx, dy: dy, distance: distance}, event));
					break;
				case MouseEvent.MOUSE_MOVE:
					_target["mouseChildren"] = false;
					if (isMouseDown)// && event.target == _dragTarget && event.relatedObject == null)
					{
						var dx:Number = event.stageX - _lastPosition.x;
						var dy:Number = event.stageY - _lastPosition.y;
						var distance:Number = Point.distance(new Point(event.stageX, event.stageY), _lastPosition);

						dispatchEvent(new MouseUIEvent(MouseUIEvent.MOUSE_DRAG, {target: _dragTarget, dx: dx, dy: dy, distance: distance}, event));

						_lastPosition.x = event.stageX;
						_lastPosition.y = event.stageY;
					}

					/*
					   if ( isMouseDown && (isCTRL || isSHIFT || isSPACE))
					   {
					   _lastPosition.x = event.stageX;
					   _lastPosition.y = event.stageY;

					   _targetRotationY = lastRotationY - (_lastPosition.x - event.stageX) *.5;
					   _targetRotationX = lastRotationX + (_lastPosition.y - event.stageY) *.5;
					   }
					 */
					break;
			}
			dispatchEvent(event.clone());
		}

		private function onMouseWheel(event:MouseEvent):void
		{
			dispatchEvent(event.clone());
		}
	}
}