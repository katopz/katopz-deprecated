package com.sleepydesign.utils
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.external.ExternalInterface;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.LocalConnection;
	import flash.system.Capabilities;
	import flash.system.System;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.IExternalizable;
	
    public class SystemUtil extends EventDispatcher
    {
        // Garbage collector
        public static function gc() : void
        {
            try
            {
                if(int(version[0])<10)
                {
	                // Flash Player 9
	                new LocalConnection().connect("foo");
	                new LocalConnection().connect("foo");
                }else{
                	// Flash Player 10
        			System["gc"]();
                }
            }
            catch (e:*)
            {
            	//void
            }
        }
        
        public static function version() : Array
        {
        	return String(Capabilities.version.split(" ")[1]).split(",");
        }
        
        // Current memory
		public static function get memory() : Number
		{
			// faster? 1000/1024 = .0000009765625;
			//Number((System.totalMemory / 1048576).toFixed(3));
			return Number((System.totalMemory*.0000009765625).toFixed(3));
		}
        
		public static function addContext2(container:DisplayObjectContainer, label:String, eventHandler:Function):void
		{
			var _contextMenu:ContextMenu = container.contextMenu = new ContextMenu();
			_contextMenu.hideBuiltInItems();
			
			var item:ContextMenuItem = new ContextMenuItem(label);
            _contextMenu.customItems.push(item);
            item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, eventHandler);
		}
		
		public static function addContext(container:DisplayObjectContainer, label:String, eventHandler:Function):void
		{
			var _contextMenu:ContextMenu = container.contextMenu = new ContextMenu();
			//_contextMenu.hideBuiltInItems();
			
			var item:ContextMenuItem = new ContextMenuItem(label);
            _contextMenu.customItems.push(item);
            item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, eventHandler);
		}
		
        // StandAlone or Browser
        public static function isBrowser():Boolean
        {
        	return Capabilities.playerType != "StandAlone" && Capabilities.playerType != "External";
        }
        
		public static function isHTTP(location:DisplayObject):Boolean 
		{
			if(location && location.loaderInfo && location.loaderInfo.url)
			{
				return location.loaderInfo.url.substr(0, 4) == 'http';
			}else{
				return false;
			}
		}
        
        // Browser with ExternalInterface there?
        public static function isExternal():Boolean
        {
        	return ExternalInterface.available && isBrowser();
        }
        
        public static function alert(msg:String):void
        {
        	if(isBrowser())
        	{
        		URLUtil.getURL("javascript:alert('"+msg+"');void(0);","_self");
        	}else{
        		trace("\n ! Alert : " + msg + "\n");
        	}
        }
        
        public static function listenJS(functionName:String, callBack:Function):void
        {
        	if (isExternal())
        	{
        		ExternalInterface.marshallExceptions = true;
        		ExternalInterface.addCallback(functionName, callBack);
        	}
        }
        
        public static function callJS(functionName:String, argument:String=""):Boolean
        {
			var isDone:Boolean = false;
			if (isExternal())
			{
				ExternalInterface.marshallExceptions = true;
               	
               	try
               	{
	               	ExternalInterface.call(functionName, argument);
	               	isDone = true;
	          	}
	           	catch(e:Error)
	           	{
	           		isDone = false;
	           		trace(e);
    			}
			}
			
			return isDone;
        }
        
		// ______________________________ File ______________________________

		public static function save(data:*, defaultFileName:String = "undefined"):void
		{
			//var type:String = URLUtil.getType(defaultFileName);

			// TODO : save image

			//save AMF like Object
			var rawBytes:ByteArray = new ByteArray();
			if(data is IExternalizable)
			{
				IExternalizable(data).writeExternal(rawBytes);
			}else{
				rawBytes = data;
			}

			//rawBytes.writeBytes(data.);

			var fileReference:FileReference = new FileReference();
			fileReference["save"](rawBytes, defaultFileName);
		}

		public static function open(fileTypes:Array = null, openHandler:Function=null, selectHandler:Function=null):FileReference
		{
			fileTypes = fileTypes ? fileTypes : ["*.jpg", "*.jpeg", "*.gif", "*.png"];
			SystemUtil.functions["selectHandler"] = selectHandler;
			SystemUtil.functions["openHandler"] = openHandler;
			
			var file:FileReference = new FileReference();
			//typeFilter = [new FileFilter("Images (*.jpg, *.jpeg, *.gif, *.png)", "*.jpg;*.jpeg;*.gif;*.png")];

			var typeFilter:Array = [new FileFilter(fileTypes.join(",").toString(), fileTypes.join(";").toString())];
			file.addEventListener(Event.SELECT, function selectHandler(event:Event):void
			{
				file = FileReference(event.target);
				trace(" ^ selectHandler : " + file.name);
				openFileName = file.name;
				if(SystemUtil.functions["openHandler"])
				{
					file.addEventListener(Event.COMPLETE, openHandler);
				}
				file["load"]();
			});
			file.browse(typeFilter);
			
			return file;
		}
		
		public static var functions:Dictionary = new Dictionary(true); 
		
		public static var openFileName:String; 
		public static var file:FileReference;
		
		/*
		private static function selectHandler(event:Event):void
		{
			file = FileReference(event.target);
			trace(" ^ selectHandler : " + file.name);
			openFileName = file.name;
			file.addEventListener(Event.COMPLETE, onLoadComplete);
			file["load"]();
		}

		private static function onLoadComplete(event:Event):void
		{
			trace(" ^ onLoadComplete : " + file["data"]);
			file.removeEventListener(Event.COMPLETE, onLoadComplete);
			dispatchEvent(new SDEvent(SDEvent.COMPLETE, file["data"]));
		}
		*/
    }
}
