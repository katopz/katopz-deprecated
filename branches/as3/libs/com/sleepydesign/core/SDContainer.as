package com.sleepydesign.core
{
    import com.sleepydesign.events.SDEvent;
    import com.sleepydesign.utils.ObjectUtil;
    
    import flash.display.DisplayObject;
    import flash.events.Event;
    
    import com.greensock.TweenMax;
    
    /**
	 * SleepyDesign Container
	 * - id
	 * - data
	 * - config
	 * - elements
	 * 
	 * @author katopz
	 */
	public class SDContainer extends SDSprite
	{
		protected var _id : String;
		protected var _data : *;
		protected var _config : *;

        protected var elements:SDGroup;
        
        public function addElement(element:*, id:String=null):*
        {
        	if(!elements)elements = new SDGroup(_id+"_Elements");
        	elements.insert(element, id);
        	return element;
        }
        
        public function removeElement(element:*, id:String=null):void
        {
        	if(!elements)return;
        	elements.remove(element, id);
        }
        
		public function getElementById(id:String=null):*
        {
        	if(!elements)return;
        	return elements.findBy(id);
        }
        
		public function get id():String
		{
			return _id;
		}
		
		public function set id(id:String):void
		{
			_id = id;
		}
		
		public static var instance : SDContainer;
        public static function getInstance() : SDContainer
        {
            if ( instance == null ) instance = new SDContainer();
            return instance as SDContainer;
        }
        
		/**
		 * SleepyDesign Container
		 */		
		public function SDContainer(id:String=null)
		{
			super();
			
			if ( instance == null )
				instance = this;
			
			this.id = id?id:name;

			if(!hasEventListener(Event.ADDED_TO_STAGE))
				addEventListener(Event.ADDED_TO_STAGE, onStage, false, 0, true);
		}
		
		protected function onStage(event:Event=null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onStage);
			init();
		}
		
        // ______________________________ Initialize ______________________________
        
		protected function init():void
		{
			// initialize
		}
		
		// ______________________________ Parse ______________________________
		
		/**
		 * Parse Strategy
		 * - Provide default data if external data not exist 
		 * - Serialize external data from config collector
		 */
		public function parse(raw:Object=null):void
		{
			// parse : raw -> config
		}
		
		// ______________________________ Create ______________________________
		
		/**
		 * Create Strategy
		 * - Automatic create/load while init time
		 * - Manual create while runtime
		 * - Manage visibility/depth/garbage collected
		 */		
		public function create(config:Object=null):void
		{
			// create : config -> elements
			config = this._config = config?config:this._config;
		}
		
        override public function removeChild(displayObject:DisplayObject):DisplayObject
        {
        	if(!displayObject)return null;
        	super.removeChild(displayObject);
        	return null;
        }
        
		// ______________________________ Destroy ______________________________
		
		// soft reset
		public function dispose():void
		{
			
		}
		
		// self destruction
		override public function destroy():void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onStage);
				
			_data = null;
			_config = null;
			
			if(elements)
			{
				elements.destroy();
				elements = null;
			}
			
			removeChild(this);
		}
		
		// kill bill
		override public function kill(...lists):void
		{
			if(lists[0] is Array)
				lists = lists[0];
			
			// Self Destruction
			if(lists.length==0)
			{
				destroy();
			}
			else
			{
				// register as element? bye bye
				if(elements)
				{
					for each(var child:* in lists)
						removeElement(child);
				}
			}
			
			super.kill(lists);
		}
		
		// ______________________________ Render ____________________________
		
		// suppose to call after update data
		public function draw():void
		{
			// force redraw view
			dispatchEvent(new SDEvent(SDEvent.DRAW));
		}
		
		// ______________________________ Transfrom ______________________________
		
		public function hide(transition:Object = null):void 
		{
			TweenMax.to(this, 1, ObjectUtil.merge(transition, { autoAlpha: 0 }));
		}
		
		public function show(transition:Object = null):void 
		{
			TweenMax.to(this, 1, ObjectUtil.merge(transition, { autoAlpha: 1 }));
		}
	}	
}