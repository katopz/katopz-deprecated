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
		private var factorX:Number = 1;
		
		public function SDParallax(id:String=null, raw:Object=null)
		{
			super(id, raw);
		}
		
        // ______________________________ Initialize ______________________________
        
		override public function init(raw:Object=null):void
		{
			elements = new SDGroup(id+"_elements");
			instance = DisplayObjectContainer(raw.instance);
			x = raw.x?raw.x:0;
        	y = raw.y?raw.y:0;
        	factorX = raw.factorX?raw.factorX:1;
        	
			/*
			var innerChild:DisplayObjectContainer;
			var _numChildren:uint = 0;
			
			if(!raw)return;
			if(raw.instance)
			{
				instance = DisplayObjectContainer(raw.instance);
        		innerChild = instance;
        		_numChildren = innerChild.numChildren;
   			}
   			
        	x = raw.x?raw.x:0;
        	y = raw.y?raw.y:0; 
        	
        	elements = new SDGroup(id+"_elements");
        	
            while(_numChildren--)
            {
            	var _displayObject:DisplayObject = innerChild.getChildAt( _numChildren );
            	
            	// only named one
            	if(_displayObject is MovieClip)
	            	addItem(_displayObject);
            }
            */
            
            // mouse
            instance.addEventListener(MouseEvent.MOUSE_MOVE, onMouseIsMove);
		}
		
		public function addItem(displayObject:DisplayObject, depth:Number=0):void
		{
        	try{
        	var _name:String = displayObject.name;
        	var z:Number = depth;//?depth:10-uint(_name.split("_")[1]);
        	
        	var itemParallax:ItemParallax = new ItemParallax(displayObject);
        	
        	itemParallax.z = z;
        	
        	trace(" ! ItemParallax : "+ _name, itemParallax.z);
        	
        	// reg
        	elements.insert(itemParallax);
        	}catch(e:*){};
		}
		
		private function onMouseIsMove(event:MouseEvent):void
		{
			/*	
			var _x:Number = -(event.stageX - x);
			var _y:Number = -(event.stageY - y);
			
			for each(var itemParallax:ItemParallax in elements.childs)
			{
				var newX:Number = itemParallax._x+_x/itemParallax.z;//+ (_x - itemParallax._x)/itemParallax.z;
				var newY:Number = itemParallax._y+_y/itemParallax.z;
				
				newX = (event.stageX-newX)/2;
				newY = (event.stageY-newY)/2;
				
				//newX = newX*2;
				TweenMax.to(itemParallax, 0.5, {x:newX, y:newY});
			}
			*/
			var _x:Number = -(event.stageX - x);
			var _y:Number = -(event.stageY - y);
			for each(var itemParallax:ItemParallax in elements.childs)
			{
				//if(Math.abs(itemParallax._x - event.stageX)>100 || Math.abs(itemParallax._y - event.stageY)>100)
				{
					var newX:Number = itemParallax._x + (itemParallax._x - event.stageX)/10
					var newY:Number = itemParallax._y + (itemParallax._y - event.stageY)/10
				}
				
				if(Math.abs(itemParallax._x - event.stageX)<250 && Math.abs(itemParallax._y - event.stageY)<200)
				{
					TweenMax.to(itemParallax, 1, {x:newX, y:newY});
				}else{
					TweenMax.to(itemParallax, 1, {x:itemParallax._x, y:itemParallax._y});
				}
			}
		}
	}
}
	
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	
	internal class ItemParallax
	{
		public var _x:Number = 0;
		public var _y:Number = 0;
		
		public var z:Number = 0;
		
		private var instance:DisplayObject;
		
		public function ItemParallax(source:DisplayObject)
		{
			instance = source;
			
			_x = instance.x;
			_y = instance.y;
		}
		
		public function get x():Number
		{
			return instance.x;
		}
		
		public function set x(value:Number):void
		{
			instance.x = value;
		}
		
		public function get y():Number
		{
			return instance.y;
		}
		
		public function set y(value:Number):void
		{
			instance.y = value;
		}
	}