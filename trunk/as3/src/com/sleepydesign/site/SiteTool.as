package com.sleepydesign.site
{
	import com.sleepydesign.core.IDestroyable;
	import com.sleepydesign.display.SDSprite;
	import com.sleepydesign.events.RemovableEventDispatcher;
	import com.sleepydesign.net.LoaderUtil;
	import com.sleepydesign.system.DebugUtil;
	import com.sleepydesign.system.SystemUtil;
	import com.sleepydesign.utils.DisplayObjectUtil;
	import com.sleepydesign.utils.StringUtil;
	import com.sleepydesign.utils.XMLUtil;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
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
				
				var _layer:SDSprite;
				
				switch (_name)
				{
					case "page":
					
						_layer = createLayer(_layerID);
						
						var _loader:Loader;
						switch (_layerID)
						{
							// normal page
							case "body":
								// focus?
								/*
								if(_focus==_id)
								{
									_loader = LoaderUtil.loadAsset(_src, onLoad); 
									_layer.addChild(_loader);
									_pageURIs.push(_src);
									_pageLoaders.push(_loader);
								}
								*/
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
		
		private function createLayer(_layerID:String):SDSprite
		{
			// create layer
			var _layer:SDSprite = _container.getChildByName(_layerID) as SDSprite;
			if(!_layer)
			{
				_layer = _layer?_layer:new SDSprite();
				_layer.name = _layerID;
				_container.addChild(_layer);
			}
			
			return _layer;
		}
		
		private function onLoad(event:Event):void
		{
			if(event.type=="complete")
			{
				if(event.target.loader.parent)
					event.target.loader.parent.addChild(event.target.content as DisplayObject);
				
				if(_pageLoaders.indexOf(event.target.loader)>-1)
				 _loadNum++;
				
				if(_loadNum==_pageLoaders.length)
					DebugUtil.trace("complete");
			}
		}
		
		public function setFocusByPath(path:String):void
		{
			var _layerID:String = "body";
			
			// destroy
			var _bodyLayer:SDSprite = _container.getChildByName(_layerID) as SDSprite;
			if(_bodyLayer)
			{
				DisplayObjectUtil.removeChildren(_bodyLayer, true, true);
				_bodyLayer.destroy();
				_bodyLayer = null;
				
				SystemUtil.gc();
			}
			
			// create
			_bodyLayer = createLayer(_layerID);
			
			var _layer:SDSprite;
			var _paths:Array = path.split("/");
			if(_paths[0]=="")
				_paths.shift();
			
			_pageURIs = [];
			_pageLoaders = [];
			
			for each(var _path:String in _paths)
			{
				_layer = createLayer(_path);
				
				if(_bodyLayer == _layer)
					continue;
				
				_bodyLayer.addChild(_layer);
				
				var _src:String = XMLUtil.getXMLById(_xml, _path).@src;
				if(_src)
				{
					var _loader:Loader = LoaderUtil.loadAsset(_src, onLoad); 
					_layer.addChild(_loader);
					
					_pageURIs.push(_src);
					_pageLoaders.push(_loader);
				}
				
				// reparent
				_bodyLayer = _layer;
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