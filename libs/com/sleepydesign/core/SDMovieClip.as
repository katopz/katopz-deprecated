package com.sleepydesign.core
{
    import com.sleepydesign.events.SDEvent;
    import com.sleepydesign.utils.DisplayObjectUtil;
    import com.sleepydesign.utils.ObjectUtil;
    import com.sleepydesign.utils.SystemUtil;
    
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.display.MovieClip;
    import flash.events.Event;
    import flash.events.IEventDispatcher;
    
    import gs.TweenLite;
    
    /**
	 * SleepyDesign MovieClip : destroyable, lazyplay, cloak
	 */
	dynamic public class SDMovieClip extends MovieClip implements IEventDispatcher, IDestroyable
	{
		private var _id	:String;
		public function get id():String
		{
			return _id;
		}
		
		public function set id(id:String):void
		{
			_id = id;
			SDContainer.getCollector().insert(this);
		}
		
		public var clip	:MovieClip;
		 
		public function SDMovieClip(id:String=null, source:MovieClip=null, xml:XML=null):void
		{
			super();
			
			// collector
			this.id = id?id:name;
			
			//var element:DisplayObject = SDContainer.getCollector().findBy(id);
			//trace("\n\n\nelement:"+element["id"]);
			
			// internal or exported for
			clip = source?source:this;
			
			trace(" ! SDMovieClip\t: "+id, clip, clip.visible);
			
			// if not export for SDMovieClip then use cloak mode
			if(source && source.parent && !stage)
			{
				DisplayObjectUtil.cloak(this, source);
			}else{
				//addChild(source);
			}
			
			clip.alpha = 1;
			this.alpha = 0;
			
			this.visible = clip.visible;
			clip.visible = true;
			
			init({id:id, source:source, xml:xml});
			
			addEventListener(Event.ADDED_TO_STAGE, onStage, false, 0, true);
			
			// Dependency call
			if(stage)
			{
				// hold there
				clip.stop();
				
				//show time?
				show();
			}
		}
		
        // ______________________________ Initialize ______________________________
        
		public function init(raw:Object=null):void
		{
			// build base elements
		}
		
		protected function onStage(event:Event=null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onStage);
		}	
		
		protected function ready():void
		{		
			/*
			trace(" / ------------------------------------------");
			
			for each(var label:FrameLabel in clip.currentLabels)
			{
				trace(" frame " + label.frame + ": " + label.name);
				// transition by frame label
				switch(label.name.toLowerCase())
				{
					case "show" :
						//
					break;
					case "ready" :
						// auto stop when ready
						clip.addFrameScript(label.frame, clip.stop);
					break;
					case "hide" :
						//
					break;
				}
			}
			
			// MovieClip : auto show
			clip.gotoAndPlay("show");
			TweenLite.to(content, .5, {autoAlpha:1});
			trace(" ------------------------------------------ /");
			*/
		}
		
		override public function getChildByName(name:String):DisplayObject
		{
			if(clip==this)
			{
				return super.getChildByName(name);
			}else{
				return clip.getChildByName(name);
			}
		}
		
        // use power of SDSprite
        override public function removeChild(child:DisplayObject):DisplayObject
        {
			if(!child)return null;
			
        	// stop Main TimeLine
        	this.stop();
        	clip.stop();
        	
        	// got some child to kill
        	if(child is DisplayObjectContainer)
        	{
	        	var innerChild:DisplayObjectContainer = DisplayObjectContainer(child);
	        	if(innerChild.numChildren>0)
	        	{
		        	// move to trash
		        	var trash:SDSprite = new SDSprite();
		        	
		        	//trace(" ! Trash : "+innerChild.numChildren);
		            while(innerChild.numChildren>0)
		            {
		                var _child:DisplayObject = innerChild.getChildAt( innerChild.numChildren-1 );
		               trash.addChild(_child);
		            }
		            
		            // and clean
		        	trash.destroy();
		        	trash = null;
	        	}
        	}
        	
        	// Remove
        	if(child.parent && child != this)
        	{
        		super.removeChild(child);
        		
        		// Got own suicide plane
        		if(child is IDestroyable)IDestroyable(child).destroy();        		
        	}
        	        	
        	if(child.mask)
        		child.mask = null;
        	
        	// Kill
        	child = null;
        	
        	return null;
        }
        
        /*
        override public function addChild(displayObject:DisplayObject):DisplayObject
        {
        	SDContainer.getCollector().insert(displayObject);
        	return super.addChild(displayObject);
        }
        */
        /*
        override public function removeChild(displayObject:DisplayObject):DisplayObject
        {
        	var innerChild:DisplayObjectContainer = DisplayObjectContainer(displayObject);
        	
        	trace(" ! Trash : "+innerChild.numChildren);
        	  	
        	if(innerChild.numChildren<=0)return null;
        	
        	//SDContainer.getCollector().remove(innerChild);
        	
        	return super.removeChild(displayObject);
        }
        */
		// ______________________________ Transfrom ______________________________
		
		public function hide(transition:Object = null):void 
		{
			TweenLite.to(this, .5, ObjectUtil.merge(transition, { autoAlpha: 0 }));
			
			if(clip.currentLabels.length>1)
			{
				clip.gotoAndPlay("hide");
				clip.addEventListener(Event.ENTER_FRAME, onHide, false,0, true);
			}	
		}
		
		public function show(transition:Object = null):void 
		{
			TweenLite.to(this, .5, ObjectUtil.merge(transition, { autoAlpha: 1 }));
			
			if(clip.currentLabels.length>1)
			{
				clip.gotoAndPlay("show");
				clip.addEventListener(Event.ENTER_FRAME, onShow, false,0, true);
			} else if(clip.totalFrames>1){
				clip.gotoAndPlay(1);
			}
		}
		
		protected function onShow(event:Event=null):void
		{
			if(clip.currentLabel=="ready" || clip.currentFrame >= clip.totalFrames)
			{
				trace(" ! Ready : "+DisplayObjectUtil.toString(this));
				clip.stop();
				clip.removeEventListener(Event.ENTER_FRAME, onShow);
				
				ready();
				
				// tell my mom (Content) to do something, i'm ready!
				dispatchEvent(new SDEvent(SDEvent.READY, {content:this}));
			}
		}
		
		protected function onHide(event:Event=null):void
		{
			if(clip.currentLabel!="hide" || clip.currentFrame>= clip.totalFrames)
			{
				clip.stop();
				clip.removeEventListener(Event.ENTER_FRAME, onHide);
				removeChild(clip);
				clip = null;
			}
		}
		/*
		// Event Garbage Collector : Use weak referrence http://www.onflex.org/ted/2008/09/useweakreferencesboolean-false.php
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = true):void
		{
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
        override public function removeChild(displayObject:DisplayObject):DisplayObject
        {
        	stop();
        	SDSprite(this).removeChild(this);
        	return null;
        }
        
        override public function gotoAndPlay(frame:Object, scene:String=null):void
        {
        	try{
        		super.gotoAndPlay(frame, scene);
        	}catch(e:*){
        		trace(e);
        	}
        }
        */
        
		// ______________________________ Destroy ______________________________
		
		public function destroy():void
		{
			removeChild(this);

			// Garbage Collecter
			SystemUtil.gc();
		}

		public function kill(... lists):void
		{
			if (lists[0] is Array)
				lists = lists[0];

			// Self Destruction
			if (lists.length == 0)
			{
				destroy();
			}
			else
			{
				for each (var child:*in lists)
				{
					if (child is DisplayObject)
						removeChild(child);
					child = null;
				}

				// Garbage Collecter
				SystemUtil.gc();
			}
		}
	}	
}