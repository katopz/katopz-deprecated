package com.sleepydesign.draw
{
	import com.sleepydesign.core.SDContainer;
	import com.sleepydesign.core.SDGroup;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import gs.TweenMax;

	public class SDParallax extends SDContainer
	{
		private var instance:DisplayObjectContainer;
		
		public function SDParallax(id:String=null, raw:Object=null)
		{
			super(id, raw);
		}
		
        // ______________________________ Initialize ______________________________
        
		override public function init(raw:Object=null):void
		{
			instance = DisplayObjectContainer(raw.instance);
        	var innerChild:DisplayObjectContainer = instance;
        	var _numChildren:uint = innerChild.numChildren;
        	
        	x = raw.x;
        	y = raw.y; 
        	
        	elements = new SDGroup(id+"_elements");
        	
            while(_numChildren--)
            {
            	var _displayObject:DisplayObject = innerChild.getChildAt( _numChildren );
            	
            	// only named one
            	if(_displayObject is MovieClip)
            	{
	            	var _name:String = _displayObject.name;
	            	var z:uint = 10-uint(_name.split("_")[1]);
	            	
	            	var itemParallax:ItemParallax = new ItemParallax(_displayObject);
	            	
	            	itemParallax.z = z*25;
	            	
	            	trace(" ! ItemParallax : "+ _name, itemParallax.z);
	            	
	            	// reg
	            	elements.insert(itemParallax);
            	}
            }
            
            // mouse
            instance.addEventListener(MouseEvent.MOUSE_MOVE, onMouseIsMove);
		}
		
		private function onMouseIsMove(event:MouseEvent):void
		{
			var _x:Number = -(event.stageX - x);
			for each(var itemParallax:ItemParallax in elements.childs)
			{
				var newX:Number = itemParallax._x+_x/itemParallax.z;//+ (_x - itemParallax._x)/itemParallax.z;
				TweenMax.to(itemParallax, 0.5, {x:newX});
			}
		}
	}
}
	
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	
	internal class ItemParallax
	{
		public var _x:Number = 0;
		public var y:Number = 0;
		public var z:Number = 0;
		
		private var instance:DisplayObject;
		
		public function ItemParallax(source:DisplayObject)
		{
			instance = source;
			
			_x = instance.x;
			y = instance.y;
		}
		
		public function get x():Number
		{
			return instance.x;
		}
		
		public function set x(value:Number):void
		{
			instance.x = value;
		}
	}