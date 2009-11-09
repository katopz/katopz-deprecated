package com.sleepydesign.utils
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.ContextMenuEvent;
	import flash.events.EventDispatcher;
	import flash.external.ExternalInterface;
	import flash.net.LocalConnection;
	import flash.system.Capabilities;
	import flash.system.System;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
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
        	
		public static function addContext(container:DisplayObjectContainer, label:String, eventHandler:Function=null):void
		{
			var _oldItems:Array = container.contextMenu?container.contextMenu.customItems.concat():[];
			var _contextMenu:ContextMenu = container.contextMenu = new ContextMenu();
			_contextMenu.hideBuiltInItems();
			
			_contextMenu.customItems = _contextMenu.customItems.concat(_oldItems);
			
			var item:ContextMenuItem = new ContextMenuItem(label);
            _contextMenu.customItems.push(item);
            
            if(eventHandler is Function)
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
    }
}
