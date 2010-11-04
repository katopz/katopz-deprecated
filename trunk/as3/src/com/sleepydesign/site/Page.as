package com.sleepydesign.site
{
	import com.sleepydesign.core.IDestroyable;
	import com.sleepydesign.display.SDSprite;
	import com.sleepydesign.net.LoaderUtil;
	import com.sleepydesign.system.DebugUtil;
	import com.sleepydesign.utils.StringUtil;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.utils.Dictionary;

	public class Page extends SDSprite
	{
		public var content:DisplayObject;

		protected var _xml:XML;
		protected var _container:DisplayObjectContainer;

		protected var _focus:String;

		public function set focus(value:String):void
		{
			_focus = value;
		}

		public static var _pageLoaders:Array = []; /*loaderVO*/
		public static var _totalLoaded:int = 0;

		//path dirty occur by focus or restrict redirect
		public static var offerPaths:Array;
		public static var preferPaths:Array;
		
		private var _visible:Boolean = true;

		private var _data:PageData;

		public function get data():PageData
		{
			return _data;
		}

		public function Page(container:DisplayObjectContainer = null, xml:XML = null, focus:String = "")
		{
			_container = container;
			_xml = xml;
			_focus = focus;

			if (_container)
				_container.addChild(this);

			if (_xml)
				parseXML(_xml);
		}

		public function parseXML(_xml:XML):void
		{
			if (!_xml)
				return;

			var _xmlList:XMLList = _xml.children();
			var _xmlList_length:int = _xmlList.length();
			var _xmlFocus:String;
			
			// only page tag
			if(_xmlList[0] && _xmlList[0].name()=="page")
				_xmlFocus = StringUtil.getDefaultIfNull(_xml.@focus, (_xmlList_length > 0) ? _xmlList[0].@id : "");
			else
				_xmlFocus = StringUtil.getDefaultIfNull(_xmlFocus, "");

			_data = new PageData(_xml);
			_visible = Boolean(_xml.@visible!="false");

			DebugUtil.trace("\n / [Page:" + _data.id ,_visible, "] ------------------------------- ");

			// got something to load?
			if (_data.src)
			{
				// default layer?
				if (_data.layer != "$layer" || !getChildByName(_data.layer))
				{
					var _loader:Loader = LoaderUtil.queue(_data.src, onLoad, "asset");
					_xml.name = name + "-loader";
					addChild(_loader);

					_pageLoaders.push(_loader);
					DebugUtil.trace(" + loader : " + _loader.name);
				}
			}

			// got child? 
			if (_xmlList_length > 0)
			{
				_focus = _focus || _xmlFocus;

				// not in offer list
				if (offerPaths && offerPaths.join("/").indexOf(_focus) == -1)
				{
					preferPaths = offerPaths.slice();
					preferPaths.push(_xmlFocus);

					DebugUtil.trace(" ! prefer : " + preferPaths);
					return;
				}
			}

			for (var i:int = _xmlList_length - 1; i >= 0; i--)
			{
				// only page tag
				if(_xmlList[i].name()!="page")
					continue;
				
				var _subPageData:PageData = new PageData(_xmlList[i]);
				var _focuses:Array = _focus.split("/");

				// unique page name
				if (!getChildByName(_data.id))
				{
					var _page:Page;
					var _subFocuses:Array = _focuses.concat();
					_subFocuses.shift();

					if (_focuses[0] == _subPageData.id)
					{
						// it's got focus
						DebugUtil.trace("   + " + _subPageData.id);
						_page = new Page(this, _subPageData.xml, _subFocuses.join("/"));
						_page.name = _subPageData.id;
					}
					else if (_subPageData.layer != "$layer" && !getChildByName(_subPageData.layer))
					{
						// layer
						DebugUtil.trace("   + " + _subPageData.id);
						_page = new Page(this, _subPageData.xml, _subFocuses.join("/"));
						_page.name = _subPageData.layer;
					}
				}
			}

			DebugUtil.trace(" ------------------------------- [Page] /\n");
		}

		protected function onLoad(event:Event):void
		{
			if (event.type == "complete")
			{
				var _parent:Page = event.target.loader.parent as Page;
				if (_parent)
				{
					// reparent
					//_parent.addChild(event.target.content as DisplayObject);
					//_parent.removeChild(event.target.loader);

					// bind
					_parent.content = event.target.content;

					// inherit from content
					/*
					try
					{
						_parent.mouseEnabled = _parent.content["mouseEnabled"];
					}
					catch (e:*)
					{
					}
					try
					{
						_parent.mouseChildren = _parent.content["mouseChildren"];
					}
					catch (e:*)
					{
					}
					*/
					
					visible = _visible;
				}

				if (_pageLoaders.indexOf(event.target.loader) > -1)
					_totalLoaded++;

				DebugUtil.trace(" ! onLoad [" + _totalLoaded + "/" + _pageLoaders.length + "] : " + event.target.url.split("/").pop());

				if (_totalLoaded == _pageLoaders.length)
				{
					DebugUtil.trace(" ! Complete : " + _totalLoaded + "/" + _pageLoaders.length);

					// reset
					_totalLoaded = 0;
					_pageLoaders = [];
				}else{
					LoaderUtil.showLoader();
				}
			}
		}

		// ____________________________________________ Destroy ____________________________________________

		override public function destroy():void
		{
			super.destroy();

			if (content is IDestroyable)
				IDestroyable(content).destroy();

			content = null;
			_container = null;
			_xml = null;
			
			_data.vars = null;
			_data = null;

			for each (var loader:Loader in _pageLoaders)
				LoaderUtil.cancel(loader);
		}
	}
}