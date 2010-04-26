package com.sleepydesign.system
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.events.ContextMenuEvent;
	import flash.external.ExternalInterface;
	import flash.net.LocalConnection;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.system.Capabilities;
	import flash.system.System;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;

	public class SystemUtil
	{
		public static function getFlashVars(stage:Stage):*
		{
			if (stage.loaderInfo && stage.loaderInfo.parameters)
			{
				return stage.loaderInfo.parameters;
			}
			return null;
		}

		// Garbage collector
		public static function gc():void
		{
			try
			{
				if (int(version[0]) < 10)
				{
					// Flash Player 9
					new LocalConnection().connect("foo");
					new LocalConnection().connect("foo");
				}
				else
				{
					// Flash Player 10
					System["gc"]();
				}
			}
			catch (e:*)
			{
				//void
			}
		}

		public static function version():Array
		{
			return String(Capabilities.version.split(" ")[1]).split(",");
		}

		// Current memory
		public static function get memory():Number
		{
			// faster? 1000/1024 = .0000009765625;
			//Number((System.totalMemory / 1048576).toFixed(3));
			return Number((System.totalMemory * .0000009765625).toFixed(3));
		}

		public static function addContext(container:DisplayObjectContainer, label:String, eventHandler:Function = null, separatorBefore:Boolean = false, enabled:Boolean = true, visible:Boolean = true):void
		{
			var _oldItems:Array = container.contextMenu ? container.contextMenu.customItems.concat() : [];
			var _contextMenu:ContextMenu = container.contextMenu = new ContextMenu();
			_contextMenu.hideBuiltInItems();

			_contextMenu.customItems = _contextMenu.customItems.concat(_oldItems);

			var item:ContextMenuItem = new ContextMenuItem(label, separatorBefore, enabled, visible);
			_contextMenu.customItems.push(item);

			if (eventHandler is Function)
				item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, eventHandler);
		}

		// StandAlone or Browser
		public static function isBrowser():Boolean
		{
			return Capabilities.playerType != "StandAlone" && Capabilities.playerType != "External";
		}

		public static function isHTTP(location:DisplayObject):Boolean
		{
			if (location && location.loaderInfo && location.loaderInfo.url)
			{
				return location.loaderInfo.url.substr(0, 4) == 'http';
			}
			else
			{
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
			if (isBrowser())
			{
				navigateToURL(new URLRequest("javascript:alert('" + msg + "');void(0);"), "_self");
			}
			else
			{
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

		public static function callJS(functionName:String, argument:* = null):Boolean
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
				catch (e:Error)
				{
					isDone = false;
					trace(e);
				}
			}

			return isDone;
		}

		public static function doCommand(uri:String, caller:* = null):void
		{
			var src:Array = uri.split(":")
			var protocal:String = src[0];
			var functionString:String = uri.substring(1 + uri.indexOf(":"));
			var functionName:String = functionString.split("(")[0];
			var argumentString:String = functionString.substring(1 + functionString.indexOf("("), functionString.lastIndexOf(")"))
			var argumentArray:Array = argumentString.split(",");
			var argument:Object;
			var _args:Array = [];
			for each(var arg:String in argumentArray)
			{
				
				//TODO : RegExp
				if ((arg.indexOf("'") == 0) && (arg.lastIndexOf("'") == arg.length - 1))
				{
					//string
					argument = arg.substring(1, arg.length - 1);
				}
				else if ((arg.indexOf('"') == 0) && (arg.lastIndexOf('"') == arg.length - 1))
				{
					//string
					argument = arg.substring(1, arg.length - 1);
				}
				else
				{
					//number
					argument = int(arg);
				}
				_args.push(argument);
			}

			switch (protocal)
			{
				case "as":
					if (argumentString.length > 0)
					{
						//custom::[functionName](argument);
						caller[functionName].apply(caller, _args);
					}
					else
					{
						//custom::[functionName]();
						caller[functionName].apply(caller);
					}
					break;

				case "js":
					var isExternal:Boolean = false;
					if (argumentString.length > 0)
					{
						isExternal = callJS(functionName, _args.toString());
					}
					else
					{
						isExternal = callJS(functionName);
					}

					break;
				case "https":
				case "http":
					navigateToURL(new URLRequest(String(uri)), "_self");
					break;
			}
		}
	}
}
