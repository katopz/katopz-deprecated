package com.sleepydesign.site
{
	import com.sleepydesign.core.IDestroyable;
	import com.sleepydesign.events.RemovableEventDispatcher;
	import com.sleepydesign.net.LoaderUtil;
	import com.sleepydesign.system.DebugUtil;
	import com.sleepydesign.utils.StringUtil;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;

	public class SiteTool extends RemovableEventDispatcher implements IDestroyable
	{
		private var _container:DisplayObjectContainer;
		private var _xml:XML;
		private var _eventHandler:Function;

		private var _loader:Object /*URLLoader, Loader*/;
		private var _data:Object /*SiteData*/;
		
		private var _pageURIs:Array /*URI*/;
		private var _pageLoaders:Array /*loaderVO*/;
		private var _loadNum:int = 0;

		// ____________________________________________ Create ____________________________________________

		public function SiteTool(container:DisplayObjectContainer, xml:XML = null, eventHandler:Function = null)
		{
			_container = container;
			_xml = xml;
			_eventHandler = eventHandler || trace;

			DebugUtil.trace("\n / [Site] ------------------------------- ");

			var _xmlList:XMLList = _xml.children();
			var _xmlList_length:int = _xmlList.length();
			var _focus:String = String(_xml.@focus);
			
			_pageURIs = [];
			_pageLoaders = [];

			for (var i:int = _xmlList_length-1; i >= 0; i--)
			{
				var _itemXML:XML = _xmlList[i];
				var _name:String = String(_itemXML.name()).toLowerCase();
				var _id:String = String(_itemXML.@id);
				var _layerID:String = StringUtil.getDefaultIfNull(_itemXML.@layer, "body");
				var _src:String = String(_itemXML.@src);

				DebugUtil.trace("   + " + _name + "\t: " + _id);
				
				var _layer:Sprite;
				
				switch (_name)
				{
					case "page":
					
						// create layer
						_layer = container.getChildByName(_layerID) as Sprite;
						if(!_layer)
						{
							_layer = _layer?_layer:new Sprite();
							_layer.name = _layerID;
							_container.addChild(_layer);
						}
						
						var _loader:Loader;		
						switch (_layerID)
						{
							// normal page
							case "body":
								// focus?
								if(_focus==_id)
								{
									_loader = LoaderUtil.loadAsset(_src, onLoad); 
									_layer.addChild(_loader);
									_pageURIs.push(_src);
									_pageLoaders.push(_loader);
								}
							break;
							default:
								_loader = LoaderUtil.loadAsset(_src, onLoad); 
								_layer.addChild(_loader);
								_pageURIs.push(_src);
								_pageLoaders.push(_loader);
							break;
						}
					break;
				}
			}

			DebugUtil.trace(" ------------------------------- [Site] /\n");
		}
		
		private function onLoad(event:Event):void
		{
			if(event.type=="complete")
			{
				event.target.loader.parent.addChild(event.target.content as DisplayObject);
				if(_pageLoaders.indexOf(event.target.loader)>-1)
				 _loadNum++;
				
				if(_loadNum==_pageLoaders.length)
					DebugUtil.trace("complete");
			}
		}

		// ____________________________________________ Destroy ____________________________________________

		override public function destroy():void
		{
			super.destroy();

			_container = null;
			_loader = null;
			_data = null;
			_eventHandler = null;
			_xml = null;
		}
	}
}