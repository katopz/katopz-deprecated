package com.sleepydesign.site
{
	import com.sleepydesign.net.LoaderUtil;
	import com.sleepydesign.system.DebugUtil;

	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;

	public class Site extends Page
	{
		public function Site(container:DisplayObjectContainer = null, xml:XML = null)
		{
			super(container, xml);
		}

		override public function parseXML(_xml:XML):void
		{
			if (!_xml || _xml.children().length() <= 0)
				return;

			var _xmlList:XMLList = _xml.children();
			var _xmlList_length:int = _xmlList.length();
			var _focus:String = String(_xml.@focus);
			var _pageData:PageData = new PageData(_xml);

			DebugUtil.trace("\n / [Site:" + _pageData.id + "] ------------------------------- ");

			_pageLoaders = [];
			
			if (_pageData.src)
			{
				var _loader:Loader = LoaderUtil.queue(_pageData.src, onLoad, "asset");
				_loader.name = name + "-loader";
				addChild(_loader);
				_pageLoaders.push(_loader);
			}

			for (var i:int = _xmlList_length - 1; i >= 0; i--)
			{
				var _subPageData:PageData = new PageData(_xmlList[i]);

				// unique page name
				if (!getChildByName(_subPageData.id))
				{
					if (_subPageData.layer != "") // || _pageData.pageID!="$body")
					{
						DebugUtil.trace("   + " + _subPageData.id);
						var _page:Page = new Page(this, _subPageData.xml);
						_page.name = _subPageData.id;
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

			DebugUtil.trace(" ------------------------------- [Site] /\n");
		}
	}
}