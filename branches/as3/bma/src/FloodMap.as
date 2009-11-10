/**
* ...
* @author katopz@sleepydesign.com
* @version 0.1
*/

package {
	
	import com.sleepydesign.containers.Cursor;
	import flash.display.*
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import gs.TweenMax;
	import fl.events.SliderEvent;

	public class FloodMap extends Map{

		public function FloodMap(){
			
			contentParentName = "Flood"
			housesMovieClip = iHouses as MovieClip;
			
			init();
			
			setupWTF()
			
			var cursor:Cursor = new Cursor(this, iHouses.iMap);
			
			//test();
		}
		
		private function setupWTF()
		{
			addEventListener(MouseEvent.MOUSE_WHEEL, onWheel);
			iHouses.iMap.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
            iHouses.iMap.mouseEnabled = true;
            iHouses.iMap.useHandCursor = !true;
            iHouses.iMap.buttonMode = !true;
			iHouses.iMap.visible = true;
			
            iHouses.iMap.addEventListener(MouseEvent.MOUSE_UP, onDrop);
			addEventListener(MouseEvent.MOUSE_UP, onDrop);
			
			//vSlider.addEventListener(SliderEvent.CHANGE, onSlide);
			iChk.addEventListener(Event.CHANGE, onCheck);
		}
		
		private function onCheck(event:Event):void
		{
			isChk = !isChk;
			for (var i in houses)
			{
				houses[i].balloon.visible = isChk;
			}
		}
		
		private function onSlide(event:SliderEvent):void
		{
			iHouses.scaleX = iHouses.scaleY = event.value;
			redraw();
		}
		
		var x0;
		var y0;
		
		private function mouseDownHandler(event:MouseEvent):void
		{
			x0 = iMask.x+iMask.mouseX-iHouses.x
			y0 = iMask.y+iMask.mouseY-iHouses.y
			
			addEventListener(Event.ENTER_FRAME, onDrag);
		}
		
		private function onDrag(event:Event):void
		{
			if (iMask.hitTestPoint(mouseX, mouseY))
			{
				iHouses.x = mouseX - x0;
				iHouses.y = mouseY - y0;
			}else {
				onDrop();
			}
			redraw();
		}
		/*
		private function redraw():void
		{
			iHouses.x = mouseX - x0;
			iHouses.y = mouseY - y0
			
			if (iHouses.x < iMask.x-iHouses.width+iMask.width)
			{
				iHouses.x = iMask.x-iHouses.width+iMask.width
			}
			else if (iHouses.x > iMask.x)
			{
				iHouses.x = iMask.x
			}
			
			if (iHouses.y < iMask.y-iHouses.height+iMask.height)
			{
				iHouses.y = iMask.y-iHouses.height+iMask.height
			}
			else if (iHouses.y > iMask.y)
			{
				iHouses.y = iMask.y
			}
		}
		*/
		private function redraw():void
		{
			var iHouses_x:Number = iHouses.x - iHouses.width * .5;
			var iHouses_y:Number = iHouses.y - iHouses.height * .5;
			
			var iMask_x:Number = iMask.x - iMask.width * .5;
			var iMask_y:Number = iMask.y - iMask.height * .5;
			
			if (iHouses_x < iMask_x-iHouses.width+iMask.width)
			{
				iHouses_x = iMask_x-iHouses.width+iMask.width
			}
			else if (iHouses_x > iMask_x)
			{
				iHouses_x = iMask_x
			}
			
			if (iHouses_y < iMask_y-iHouses.height+iMask.height)
			{
				iHouses_y = iMask_y-iHouses.height+iMask.height
			}
			else if (iHouses_y > iMask_y)
			{
				iHouses_y = iMask_y
			}
			
			iHouses.x = iHouses_x + iHouses.width * .5;
			iHouses.y = iHouses_y + iHouses.height * .5;
		}
		
		private function onDrop(event:MouseEvent=null):void
		{
			removeEventListener(Event.ENTER_FRAME, onDrag);
		}
		
		private function onWheel(event:MouseEvent):void
		{
			stage.quality = "medium"
			//var oldW = iHouses.width;
			//var oldH = iHouses.height;
			
			//var factorX = iHouses.scaleX;
			//var factorY = iHouses.scaleY;
			
			iHouses.scaleX = iHouses.scaleY += event.delta * .05;
			
			if (iHouses.height < iMask.height)
			{
				iHouses.height = iMask.height
			}
			else if (iHouses.height > 3*iMask.height)
			{
				iHouses.height = 3*iMask.height
			}
			if (iHouses.width < iMask.width)
			{
				iHouses.width = iMask.width
			}
			else if (iHouses.width > 3*iMask.width)
			{
				iHouses.width = 3*iMask.width
			}
			
			if (iHouses.scaleX<0)
			{
				iHouses.scaleX = iMask.width/iHouses.width
			}
			if (iHouses.scaleY<0)
			{
				iHouses.scaleY = iMask.height/iHouses.height
			}
			
			for (var i in houses)
			{
				houses[i].balloon.scaleX = houses[i].balloon.scaleY = 1.5 + (1 - iHouses.scaleX);
				//if (iHouses.width < 3*iMask.width*.5)
				{
					houses[i].scaleX = houses[i].scaleY = houses[i].balloon.scaleX*.8
				}
			}
			
			//trace(iHouses.mouseX-_mouseX)
			//trace(iHouses.x,factorX / iHouses.scaleX )
			//iHouses.x = iMask.x - iHouses.width * (factorX / iHouses.scaleX);
			//trace("*"+iHouses.x )
			//iHouses.y = iMask.y - iHouses.height*factorY/iHouses.scaleY
			
			redraw();
			stage.quality = "high"
		}
	}
}