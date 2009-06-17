package com.sleepydesign.components
{
	import com.sleepydesign.events.SDEvent;
	import com.sleepydesign.styles.SDStyle;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	
	public class SDScrollBar extends SDSlider
	{
		private var _scrollTarget:SDPanel;
		public var step:Number = 10;
		
		public function SDScrollBar(orientation:String = SDSlider.VERTICAL)
		{
			super(orientation);
		}
		
		override public function draw():void
        {
 			if(!_scrollTarget)return;
 			
         	var _size:Number;
        	if(_orientation == HORIZONTAL)
        	{
        		// auto align
        		this.x = 0;
        		this.y = _scrollTarget.height;
        		
        		// auto size
        		_size = Math.max(SDStyle.SIZE,_width * _scrollTarget.maskRectangle.width/_scrollTarget.contentRectangle.width);
        		setSize(_scrollTarget.maskRectangle.width, SDStyle.SIZE);
         		
        		// full bar -> disable?
        		visible = (_scrollTarget.maskRectangle.width<_scrollTarget.contentRectangle.width);
        		
        	}else{
        		// auto align
        		this.x = _scrollTarget.width;
        		this.y = 0;
        		
        		// auto size
        		_size = Math.max(SDStyle.SIZE,_height * _scrollTarget.maskRectangle.height/_scrollTarget.contentRectangle.height);
        		setSize(SDStyle.SIZE, _scrollTarget.maskRectangle.height);
        		
        		// full bar -> disable?
        		visible = (_scrollTarget.maskRectangle.height<_scrollTarget.contentRectangle.height);
        	}
        	
        	// draw
        	drawTrack();
        	drawHandle(_size);  
        	
        	super.draw();  	
        }
		
		override public function get visible():Boolean
		{
			if(_orientation == HORIZONTAL)
        	{
        		return Boolean(_scrollTarget.maskRectangle.width<_scrollTarget.contentRectangle.width);
        		
        	}else{
        		return Boolean(_scrollTarget.maskRectangle.height<_scrollTarget.contentRectangle.height);
        	}
		}
		
        private function onWheel( event:MouseEvent ):void
        {
		    if(_orientation == HORIZONTAL)
		    {
		    	// not scroll content for HORIZONTAL
		    	if(event.currentTarget == this)
		    	{
		    		value -= int(event.delta*step);
		    	}
		    }else{
		    	value -= int(event.delta*step);
		    }
        } 
        
        override protected function positionHandle():void
        {
        	super.positionHandle();
        	var gap:Number;
        	
        	if(_scrollTarget)
        	{
			    if(_orientation == HORIZONTAL)
			    {
			    	gap = Math.max(0,_scrollTarget.contentRectangle.width - _scrollTarget.maskRectangle.width);
		    		_scrollTarget.content.x = -value*gap/100;
			    }else{
			    	gap = Math.max(0,_scrollTarget.contentRectangle.height - _scrollTarget.maskRectangle.height);
			    	_scrollTarget.content.y = -value*gap/100;
			    } 
        	}
        }
        
        public function get scrollTarget():SDPanel
        {
        	return _scrollTarget;
        }
        
        public function set scrollTarget(panel:SDPanel):void
        {
        	// Remove event
        	panel.removeEventListener( SDEvent.RESIZE, function():void{draw()});
        	panel.removeEventListener( MouseEvent.MOUSE_WHEEL, onWheel);
        	removeEventListener( MouseEvent.MOUSE_WHEEL, onWheel);
			
        	// Setup
        	_scrollTarget = panel;
        	
        	// View
			draw();
        	
        	// Add event
        	panel.addEventListener( SDEvent.RESIZE, function():void{draw()}, false, 0, true);
        	panel.addEventListener( MouseEvent.MOUSE_WHEEL, onWheel, false, 0, true);;
        	addEventListener( MouseEvent.MOUSE_WHEEL, onWheel, false, 0, true);
        }
	}
}