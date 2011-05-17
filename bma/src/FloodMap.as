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
		}
		
		private function setupWTF()
		{
			addEventListener(MouseEvent.MOUSE_WHEEL, onWheel);
			iHouses.iMap.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
            iHouses.iMap.mouseEnabled = true;
            iHouses.iMap.useHandCursor = !true;
            iHouses.iMap.buttonMode = !true;
			iHouses.iMap.visible = true;
			iHouses.cacheAsBitmap = true;
			
            iHouses.iMap.addEventListener(MouseEvent.MOUSE_UP, onDrop);
			addEventListener(MouseEvent.MOUSE_UP, onDrop);
			
			//vSlider.addEventListener(SliderEvent.CHANGE, onSlide);
			
			iChk.selected = false;
			onCheck();
			iChk.addEventListener(Event.CHANGE, onCheck);
		}
		
		private function onCheck(event:Event=null):void
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
		
		private function onWheel(event:MouseEvent=null):void
		{
			stage.quality = "medium";
			iHouses.cacheAsBitmap = false;
			//var oldW = iHouses.width;
			//var oldH = iHouses.height;
			
			//var factorX = iHouses.scaleX;
			//var factorY = iHouses.scaleY;
			if(event)
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
			
			var _hScale:Number = 1.2/iHouses.scaleX;
			for each(var house:MovieClip in houses)
			{
				house.balloon.scaleX = house.balloon.scaleY = _hScale;
				//if (iHouses.width < 3*iMask.width*.5)
				
				var _fScale:Number = (-_hScale+1.2)/5.5;
				//if(_hScale<0.5)_hScale=.5;
				
				// 1.2 -> 0.4
				// 1.2-1.2 -> 0.4-1.2 (-0.8)
				// 0 -> -0.8
				// 0/-1 -> -0.8/-1
				// 0/1.5 -> 0.8/3
				// 0 -> 0.26
				house.scaleX = house.scaleY = _hScale+_fScale;
				
				house.balloon.y = house.balloon.extra.y+iHouses.scaleX*2.8;
			}
			trace(house.scaleX)
			redraw();
			TweenMax.to(this, 0.5, { onComplete: speedup} )
		}
		
		private function speedup():void
		{
			stage.quality = "high";
			iHouses.cacheAsBitmap = true;
		}
		
		public override function setup(xml) 
		{
			onWheel();
		}
	}
}