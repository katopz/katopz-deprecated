package com.sleepydesign.core
{
    import com.sleepydesign.events.SDEvent;
    import com.sleepydesign.utils.ObjectUtil;
    
    import flash.display.DisplayObject;
    import flash.events.Event;
    
    import gs.TweenMax;
    
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
		//public var group : SDGroup;
		
		protected var _data : *;
		protected var _config : *;
		
		private static var collector:SDGroup;
        public static function getCollector() : SDGroup 
        {
            if ( collector == null ) collector = new SDGroup("DisplayObjectCollector");
            return collector as SDGroup;
        }
        
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
        
		//public static var numContainer:uint;
		
		/*
		// Singleton
		public static var instance : SDContainer;
        public static function getInstance() : SDContainer
        {
            if ( instance == null ) instance = new SDContainer();
            return instance as SDContainer;
        }
		*/
		
		public function get id():String
		{
			return _id;
		}
		
		public function set id(id:String):void
		{
			getCollector().remove(this);
			
			_id = id;
			
			/*
			if(!collector)
			{
				collector = new SDGroup("DisplayObject");
			}
			*/
			
			getCollector().insert(this);
		}
		
		/**
		 * SleepyDesign Container
		 */		
		public function SDContainer(id:String=null, raw:Object=null)
		{
			super();
			/*
			if (stage && SDApplication.getStage()!= stage)
			{
				SDApplication.setStage(stage);
			}		
			*/	
			/*
			// self service
			if (stage && SDApplication.getStage()!= stage)
			{
				new SDApplication("application", {container:this, stage:stage});
			}
			*/
			
			//instance = this;
			
			//if(!numContainer)numContainer=0;
			
			// collector
			this.id = id?id:name;
			
			//var element:DisplayObject = SDContainer.getCollector().findBy(id);
			//trace("\n\n\nelement:"+element["id"]);

			/*
			else{
				this.id = String(++numContainer);
			}
			*/
			
			init(raw);
			
			/*
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
			*/
			
			if(!hasEventListener(Event.ADDED_TO_STAGE))
				addEventListener(Event.ADDED_TO_STAGE, onStage, false, 0, true);
		}
		
        // ______________________________ Initialize ______________________________
        
		public function init(raw:Object=null):void
		{
			// initialize logical elements
		}
		
		protected function onStage(event:Event=null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onStage);
		}
		
		// ______________________________ Parse ______________________________
		
		/**
		 * Parse Strategy
		 * - Provide default data if external data not exist 
		 * - Serialize external data from config collector
		 * 
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
		 * 
		 */		
		public function create(config:Object=null):void
		{
			// create : config -> elements
			config = this._config = config?config:this._config;
			//_config = this._config = ObjectUtil.merge(_config, this._config);
		}
		
        override public function removeChild(displayObject:DisplayObject):DisplayObject
        {
        	//TweenMax.killTweensOf(displayObject);
        	//if(displayObject is SDContainer && displayObject["id"])
        	if(!displayObject)return null;
        	collector.remove(displayObject);
        	super.removeChild(displayObject);
        	displayObject = null;
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
			
			// remove from global collector
			if(collector)
				collector.remove(this);
		}
		
		// ______________________________ Update ____________________________
		
		// update dynamic content
		public function update(_data:Object=null):void
		{
			// data is update somewhere
			if(_data && this._data != _data)
			{
				_data = this._data = _data?_data:this._data;
				dispatchEvent(new SDEvent(SDEvent.UPDATE));
			}
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