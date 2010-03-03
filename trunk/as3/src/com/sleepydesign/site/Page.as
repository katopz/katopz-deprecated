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
			//var _focus:String = StringUtil.getDefaultIfNull(_xml.@focus, "");
			var _xmlFocus:String = StringUtil.getDefaultIfNull(_xml.@focus, _xmlList_length>0?_xmlList[0].@id:"");
			
			
			var _pageData:PageData = new PageData(_xml);
			
			DebugUtil.trace("\n / [Page:" + _pageData.id + "]["+ _xmlFocus +"]["+ _focus +"]------------------------------- ");

			if (_pageData.src)
			{
				if(_pageData.layer != "" && !getChildByName(_pageData.layer) || _pageData.id == _focus.split("/")[0])
				{
					var _loader:Loader = LoaderUtil.queue(_pageData.src, onLoad, "asset");
					_loader.name = name + "-loader";
					addChild(_loader);
					
					_pageLoaders.push(_loader);
					DebugUtil.trace(" + loader : " + _loader.name);
				}
			}
			
			// got child? 
			if(_xmlList_length>0)
			{
				//_focus = _focus || String(_xmlList[0].@id)
				
				// not in offer list
				if(offerPaths && offerPaths.indexOf(_focus)==-1)
				{
					preferPaths = offerPaths.slice();
					preferPaths.push(_xmlList[0].@id);
					
					// reset
					//LoaderUtil.cancel();
					//_totalLoaded = 0;
					//_pageLoaders = [];
					
					trace(" ! prefer : " +preferPaths);
					return;
				}
			}

			//_pageLoaders = [];
			
			for (var i:int = _xmlList_length - 1; i >= 0; i--)
			{
				var _subPageData:PageData = new PageData(_xmlList[i]);
				var _focuses:Array = _focus.split("/");

				// unique page name
				if (!getChildByName(_pageData.id))
				{
					var _page:Page;
					var _subFocus:String = (_focuses[0] == _subPageData.id)?_focuses[_focuses.length-1]:"";
						
					if (_focuses[0] == _subPageData.id)// || _subPageData.layer != "") // || _pageData.pageID!="$body")
					{
						// it's got focus
						DebugUtil.trace("   + " + _subPageData.id);
						_page = new Page(this, _subPageData.xml, _subFocus);
						_page.name = _subPageData.id;
					}
					else if(_subPageData.layer != "" && !getChildByName(_subPageData.layer))
					{
						// layer
						DebugUtil.trace("   + " + _subPageData.id);
						_page = new Page(this, _subPageData.xml, _subFocus);
						_page.name = _subPageData.layer;
					}
				}

				/*
				   if (_focus.split("/")[0]==_pageData.id && _pageData.src)
				   {
				   if(!getChildByName(name+"-loader"))

				   var _loader:Loader = LoaderUtil.queue(_pageData.src, onLoad, "asset");
				   _loader.name = name+"-loader";
				   addChild(_loader);

				   _pageLoaders.push(_loader);
				   }
				 */
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
					_parent.addChild(event.target.content as DisplayObject);
					_parent.removeChild(event.target.loader);

					// bind
					_parent.content = event.target.content;
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
			
			for each(var loader:Loader in _pageLoaders)
				LoaderUtil.cancel(loader);
		}
	}
}