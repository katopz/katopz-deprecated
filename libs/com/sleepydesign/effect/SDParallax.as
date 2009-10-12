package com.sleepydesign.effect
{
	import com.sleepydesign.core.SDGroup;
	import com.sleepydesign.site.view.components.Site;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import com.greensock.TweenMax;

	public class SDParallax
	{
		private var instance:Sprite;
		public var elements:SDGroup;
		
		private var x:Number;
		public var factorX:Number = 1;
		
		public function SDParallax(instance:Sprite, xPos:Number)
		{
			this.instance = instance;
			elements = new SDGroup("SDParallax_elements");
			
			x = xPos/2;
			
            // event
            if(instance.stage)
            {
            	instance.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseIsMove);
            }else{
            	Site.getInstance().stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseIsMove);
            }	
		}
		
		public function addItem(displayObject:Sprite, depth:Number=NaN):void
		{
        	try{
	        	var _name:String = displayObject.name;
	        	var z:Number = depth?depth:Number(_name.split("_")[1]);
	        	trace(z,_name.split("_")[1]);
	        	
	        	var parallaxItem:ParallaxItem = new ParallaxItem(displayObject, z);
	        	
	        	trace(" ! ParallaxItem : "+ _name, parallaxItem.z);
	        	
	        	// reg
	        	elements.insert(parallaxItem);
        	}catch(e:*){trace(e)};
		}
		
		private function onMouseIsMove(event:MouseEvent):void
		{
			//0->1000
			var _x:Number = -(event.stageX - x);
			for each(var parallaxItem:ParallaxItem in elements.childs)
			{
				var newX:Number = parallaxItem._x+_x/parallaxItem.z*factorX;//+ (_x - parallaxItem._x)/parallaxItem.z;
				TweenMax.to(parallaxItem, 0.5, {x:newX});
			}
		}
	}
}