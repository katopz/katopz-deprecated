/**
* @author katopz@sleepydesign.com
* @version 0.1
*/

package com.sleepydesign.containers
{
	
	import com.sleepydesign.site.Content;
	import flash.display.*;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	
	public class Cursor extends Object
	{
		private var target:Sprite;
		
		private var cursor		:Content;
		private var cursor_grab	:Content;
		
		private var isGrab		:Boolean = false;
		
		public function Cursor(iParent:Sprite, iTarget:Sprite)
		{
			cursor = new Content(iParent);
			cursor.load("hand.png");
			cursor.visible = false;
			cursor.mouseEnabled = false;
			
			cursor_grab = new Content(iParent);
			cursor_grab.load("hand_grab.png");
			cursor_grab.visible = false;
			cursor_grab.mouseEnabled = false;
			
			target = iTarget;
			
			target.addEventListener(MouseEvent.MOUSE_MOVE, redrawCursor);
			target.addEventListener(MouseEvent.MOUSE_OUT, removeCursor);
			target.addEventListener(MouseEvent.MOUSE_DOWN, onGrab);
			target.addEventListener(MouseEvent.MOUSE_UP, onUnGrab);
		}
		
		private function onGrab(event:MouseEvent):void
		{
			isGrab = true;
			redrawCursor(event);
		}
		
		private function onUnGrab(event:MouseEvent):void
		{
			isGrab = false;
			redrawCursor(event);
		}
		
		private function removeCursor(event:MouseEvent):void
		{
			Mouse.show();
			cursor.visible = false;
			cursor_grab.visible = false;
		}
		
		private function redrawCursor(event:MouseEvent):void
		{
			Mouse.hide();
			
			if (isGrab)
			{
				cursor.visible = false;
				cursor_grab.visible = true;
				cursor_grab.x = event.stageX;// -cursor_grab.width * .5;
				cursor_grab.y = event.stageY;// -cursor_grab.height * .5;
			}else {
				cursor.visible = true;
				cursor_grab.visible = false;
				cursor.x = event.stageX;// -cursor.width * .5;
				cursor.y = event.stageY;// -cursor.height * .5;
			}
		}
	}
}
