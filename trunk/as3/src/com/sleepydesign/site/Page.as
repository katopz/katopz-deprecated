package com.sleepydesign.site
{
	import com.sleepydesign.display.SDSprite;
	import com.sleepydesign.net.LoaderUtil;
	import com.sleepydesign.system.DebugUtil;
	import com.sleepydesign.utils.StringUtil;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.events.Event;

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
			var _xmlFocus:String = StringUtil.getDefaultIfNull(_xml.@focus, (_xmlList_length > 0) ? _xmlList[0].@id : "");

			var _pageData:PageData = new PageData(_xml);

			DebugUtil.trace("\n / [Page:" + _pageData.id + "] ------------------------------- ");

			// got something to load?
			if (_pageData.src)
			{
				// default layer?
				if (_pageData.layer != "$layer" || !getChildByName(_pageData.layer))
				{
					var _loader:Loader = LoaderUtil.queue(_pageData.src, onLoad, "asset");
					_loader.name = name + "-loader";
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
				var _subPageData:PageData = new PageData(_xmlList[i]);
				var _focuses:Array = _focus.split("/");

				// unique page name
				if (!getChildByName(_pageData.id))
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
					try{_parent.mouseEnabled = _parent.content["mouseEnabled"];}catch (e:*){}
					try{_parent.mouseChildren = _parent.content["mouseChildren"];}catch (e:*){}
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
				}
			}
		}

		// ____________________________________________ Destroy ____________________________________________

		override public function destroy():void
		{
			super.destroy();

			content = null;
			_container = null;
			_xml = null;

			for each (var loader:Loader in _pageLoaders)
				LoaderUtil.cancel(loader);
		}
	}
}