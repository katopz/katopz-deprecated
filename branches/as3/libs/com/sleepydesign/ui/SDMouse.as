package com.sleepydesign.ui
{
	import com.sleepydesign.application.core.SDApplication;
	import com.sleepydesign.core.SDObject;
	import com.sleepydesign.events.SDMouseEvent;
	
	import flash.display.InteractiveObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class SDMouse extends SDObject
	{
		private var target				:InteractiveObject;
		private var dragTarget			:*;
		private var lastMousePosition	:Point = new Point();
		
		public static var isMouseDown   :Boolean = false;
		
		public function SDMouse(target:InteractiveObject)
		{
			init({target:target});
		}
		
		override public function init(raw:Object=null):void
		{
			target = raw.target?raw.target:SDApplication.getStage();
			create();
		}
		
		override public function create(config:Object=null):void
		{
			target.addEventListener(MouseEvent.MOUSE_DOWN, onInnerMouse, false, 0, true);
			target.addEventListener(MouseEvent.MOUSE_UP, onInnerMouse, false, 0, true);
			
			target.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel, false, 0, true);
		}
		
		override public function destroy():void
		{
			target.removeEventListener(MouseEvent.MOUSE_DOWN, onInnerMouse);
			target.removeEventListener(MouseEvent.MOUSE_UP, onInnerMouse);
			target.removeEventListener(MouseEvent.MOUSE_MOVE, onInnerMouse);
			
			target.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
		}
		
		private function onInnerMouse( event:MouseEvent ):void
		{
			switch(event.type) 
			{
				case MouseEvent.MOUSE_DOWN:
					target["mouseChildren"] = true;
					isMouseDown = true;
					lastMousePosition.x = event.stageX;
					lastMousePosition.y = event.stageY;
					dragTarget = event.target;
					
					target.addEventListener(MouseEvent.MOUSE_MOVE, onInnerMouse, false, 0, true);
				break;
				
				case MouseEvent.MOUSE_UP:
					target["mouseChildren"] = true;
					isMouseDown = false;
					lastMousePosition.x = event.stageX;
					lastMousePosition.y = event.stageY;
					dragTarget = null;
					
					target.removeEventListener(MouseEvent.MOUSE_MOVE, onInnerMouse);
				break;
				case MouseEvent.MOUSE_MOVE:
					target["mouseChildren"] = false;
					if(isMouseDown && event.target == dragTarget &&  event.relatedObject == null)
					{
						var dx:Number = event.stageX - lastMousePosition.x;
						var dy:Number = event.stageY - lastMousePosition.y;
						var distance:Number = Point.distance(new Point(event.stageX, event.stageY), lastMousePosition);
						
						dispatchEvent(new SDMouseEvent(SDMouseEvent.MOUSE_DRAG, {target:dragTarget, dx:dx, dy:dy, distance:distance}, event));
						
						lastMousePosition.x = event.stageX;
						lastMousePosition.y = event.stageY;
					}
					
					/*
					if ( isMouseDown && (isCTRL || isSHIFT || isSPACE)) 
					{

						lastMousePosition.x = event.stageX;
						lastMousePosition.y = event.stageY;
						
						targetRotationY = lastRotationY - (lastMousePosition.x - event.stageX) *.5;
						targetRotationX = lastRotationX + (lastMousePosition.y - event.stageY) *.5;
					}
					*/	
				break;
			}
			dispatchEvent(event.clone());
		}
		
		private function onMouseWheel( event:MouseEvent ):void
		{
			dispatchEvent(event.clone());
		}
	}
}
