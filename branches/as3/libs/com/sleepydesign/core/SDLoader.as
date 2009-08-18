package com.sleepydesign.core
{
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.BulkProgressEvent;
	
	import com.sleepydesign.application.core.SDApplication;
	import com.sleepydesign.events.SDEvent;
	import com.sleepydesign.text.SDTextField;
	import com.sleepydesign.utils.ObjectUtil;
	import com.sleepydesign.utils.StringUtil;
	import com.sleepydesign.utils.SystemUtil;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import gs.TweenMax;
	
    /**
	 * SleepyDesign Loader
	 * @author katopz
	 */
	public class SDLoader extends EventDispatcher
	{
		private var _percent			:Number;
		private var containers			:SDGroup;
		
		public static var engine		:BulkLoader;
		public var instance				:DisplayObject;
		
		public static var lastRequest	:*;
		
		public function SDLoader(displayObject:DisplayObject=null, align:String="c")
		{
			containers = new SDGroup();
			
			if(!displayObject)
			{
				// default case
				var txt:SDTextField = new SDTextField();
				create(txt, align);
			}else{
				create(displayObject, align);
			}
			
			if(!engine)
				engine = new BulkLoader("global");
		}	
		
		private function get percent():Number
		{
			return _percent;
		}
		
		private function set percent(value:Number):void
		{
			_percent = value;
			
			if(instance)
			{
				// default case
				if(instance is SDTextField)
				{
					SDTextField(instance).text = _percent+"%";
				}
			}
		}
		
		/*
		private function get target():Number
		{
			return _target;
		}
		
		private function set target(container:DisplayObjectContainer):void
		{
			//_percent = value;
			_targets.insert(container);
		}
		*/
		
		public function create(displayObject:DisplayObject, align:String="c"):void
		{
			instance = displayObject;
			
			// TODO : manager
			if(SDApplication.system)
			{
				SDApplication.system.addChild(instance);
			} else if(instance.stage){
				instance.stage.addChild(instance);
			}
			
			percent = 0;
			
			switch(align)
			{
				case "tl":
					instance.x = 0;
					instance.y = 0;
				break;
				case "c":
					if(instance.stage)
					{
						instance.x = instance.stage.stageWidth*.5;
						instance.y = instance.stage.stageHeight*.5;
					}
				break;
			}
			
			instance.alpha = 0;
			instance.visible = false;
			
			//trace("ApplicationDisplay:"+ApplicationDisplay.stage);
			//ApplicationDisplay.stage.addChild(txt);
			//instance.parent.addChild(instance);
			//parent.addChild(instance);
		}
		
		public function add(uri:String, data:*=null, method:String=URLRequestMethod.POST, dataFormat:String = null):EventDispatcher
		{
			if(!uri)return null;
			
			var _loadItem:EventDispatcher;
			
			// local test?
			if(!SystemUtil.isHTTP(SDApplication.getInstance()))
			{
				uri = StringUtil.replace(uri, "serverside", "localside");
			}
            
            if(data && data.toString().length>0)
            {
	            trace(" * Send\t\t: "+uri);
	            
	            var request:URLRequest = new URLRequest(uri);
	            request.method = method;
	            
	            switch(dataFormat)
	            {
					case URLLoaderDataFormat.VARIABLES:
					default :
			            request.data = new URLVariables();
			            
			            for (var value:* in data)
			            {
			            	request.data[value] = data[value];
			            }
			            ObjectUtil.print(request.data);
					break;
			        case URLLoaderDataFormat.TEXT:
	          		case URLLoaderDataFormat.BINARY:
	            		request.data = data;
	            	break;
	            }
	            
	            trace(" * Request\t: "+ method +","+ dataFormat);
	            
	            lastRequest = request;
	            _loadItem = engine.add(request,{type:dataFormat});
            }
            else
            {
            	trace(" * Load\t\t: "+uri, dataFormat);
            	lastRequest = uri;
            	
            	if(dataFormat)
            	{
            		_loadItem = engine.add(uri,{type:dataFormat});
            	}else{
            		_loadItem = engine.add(uri);
            	}
            }
            
            return _loadItem["loader"];
		}
		
		public function load(uri:String, data:*=null, method:String=URLRequestMethod.POST, dataFormat:String = null):EventDispatcher
		{
			//uri = (uri is XMLList)?String(uri):uri;
			var _itemLoader:EventDispatcher = add(uri, data, method, dataFormat);
			start();
			return _itemLoader;
		}
		
		public function loadBinary(uri:String, data:*=null, method:String=URLRequestMethod.POST):EventDispatcher
		{
			var _itemLoader:EventDispatcher = add(uri, data, method, URLLoaderDataFormat.BINARY);
			start();
			return _itemLoader;
		}
		
		public function loadTo(container:DisplayObjectContainer, uri:String, data:*=null, method:String=URLRequestMethod.POST, dataFormat:String = null):void
		{
			containers.insert(container, uri);
			load(uri, data, method, dataFormat);
		}
		/*
		public function loadAs(_class:Class, uri:String, data:*=null, method:String=URLRequestMethod.POST, dataFormat:String = null):void
		{
			containers.insert(_class, uri);
			load(uri, data, method, dataFormat);
		}
		*/
		/*
		public function add(uri:String, method:URLRequestMethod=URLRequestMethod.GET):void
		{
			//trace(" + Queue	: "+uri);
			//uri = (uri is XMLList)?String(uri):uri;
			engine.add(uri);
		}
		*/
		public function start():void
		{
			trace(" * Start\t: "+engine._itemsTotal);
			percent = 0;
			//BUG//if(!engine.hasEventListener("progress"))
		    	engine.addEventListener("progress", onProgress, false, 0, true) ;
		    
		    //BUG//if(!engine.hasEventListener("complete"))
		    	engine.addEventListener("complete", onComplete);
			
			engine.start();
		}
		
		public function remove(uri:*):void
		{
			// trace(" - UnQueue	: "+uri);
			uri = (uri is XMLList)?String(uri):uri;
			engine.remove(uri);
		}
		
		public function unregister():void
		{
			//engine.removeEventListener("progress", onProgress);
		    //engine.removeEventListener("complete", onComplete);
		    //remove(uri);
		}
		
		private function onProgress(event:BulkProgressEvent):void
		{
			if(!instance)return;
			
			//trace(" ^ onProgress	: "+event.bytesLoaded,event.bytesTotal)
			_percent = 100*event.bytesLoaded/event.bytesTotal;
			percent = isNaN(_percent) ? 0:int(_percent);
			
			// remain
			if(_percent>0)
			{
				// not appear yet
				if(!instance.visible) 
					TweenMax.to(instance, 0.5, {autoAlpha:1});
			}else{
				TweenMax.to(instance, 0.5, {autoAlpha:0});
			}
			
			dispatchEvent(new SDEvent(SDEvent.PROGRESS, {loader:event.target, event:event, percent:percent}));
		}
		
		private function onComplete(event:ProgressEvent):void
		{
			//trace(event)
			trace(" ^ onComplete\t: "+BulkLoader(event.target).itemsLoaded+"/"+BulkLoader(event.target).itemsTotal);
			if(engine.itemsLoaded==engine.itemsTotal)
			{
				engine.removeEventListener("progress", onProgress);
				engine.removeEventListener("complete", onComplete);
			}
			
			//loadTo
			for(var uri:String in containers.childs)
			{
				if(isContent(uri))
				{
					if(containers.childs[uri] is DisplayObjectContainer)
					{
						var container:DisplayObjectContainer = containers.childs[uri];
						container.addChild(getContent(uri));
					}
					containers.remove(uri);
				}
			}
			/*
			//loadAs
			for each(var _class:Class in containers.childs)
			{
				if(isContent(uri))
				{
					_class = engine.g
					containers.remove(uri);
				}
			}
			*/
			dispatchEvent(new SDEvent(SDEvent.COMPLETE, {loader:event.target}));
			//unregister();
			
			//instance.visible = false;
			TweenMax.to(instance, 0.5, {autoAlpha:0});
		}
		
		public function getContent(uri:String, clearMemory : Boolean = true):*
		{
			// local test?
			if(!SystemUtil.isHTTP(SDApplication.getInstance()))
			{
				uri = StringUtil.replace(uri, "serverside", "localside");
			}
			//trace(" * getContent : "+uri);
			return engine.getContent(uri, clearMemory);
		}
		
		public static function getLastContent(clearMemory : Boolean = true):*
		{
			return engine.getContent(lastRequest, clearMemory);
		}
		
		public function isContent(uri:String):*
		{
			if(!uri) return null;
			
			// local test?
			if(!SystemUtil.isHTTP(SDApplication.getInstance()))
			{
				uri = StringUtil.replace(uri, "serverside", "localside");
			}
			//trace(" ! isContent : "+uri);
			return engine.getContent(uri, false);
		}
	}
}
