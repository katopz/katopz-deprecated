package com.sleepydesign.site
{
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
	
	public class Site extends Page
	{
		private var _loader:Object; /*URLLoader, Loader*/
		private var _data:Object; /*SiteData*/

		private var _totalLoaded:int = 0;
		private var _currentPaths:Array = [];

		public function Site(container:DisplayObjectContainer = null, xml:XML = null)
		{
			super(container, xml);
		}
		
		override public function parseXML(_xml:XML):void
		{
			var _xmlList:XMLList = _xml.children();
			var _xmlList_length:int = _xmlList.length();
			var _focus:String = String(_xml.@focus);
			
			if(_xmlList_length<=0)
				return;
			
			DebugUtil.trace("\n / [Site] ------------------------------- ");

			_pageLoaders = [];

			for (var i:int = _xmlList_length - 1; i >= 0; i--)
			{
				var _itemXML:XML = _xmlList[i];
				var _name:String = String(_itemXML.name()).toLowerCase();
				var _id:String = String(_itemXML.@id);
				var _pageID:String = StringUtil.getDefaultIfNull(_itemXML.@layer, "$body");
				var _src:String = String(_itemXML.@src);

				switch (_name)
				{
					case "page":
						// unique page name
						if(!this.getChildByName(_pageID))
						{
							DebugUtil.trace("   + " + _name + "\t: " + _pageID);
							var _page:Page = new Page();
							_page.name = _pageID;
							this.addChild(_page);
						}
						
						switch (_pageID)
						{
							case "$body":
								//
							break;
							default:
								// fg, bg
								var _loader:Loader = LoaderUtil.queue(_src, onLoad, "asset");
								_page.addChild(_loader);
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

		public function setFocusByPath(path:String):void
		{
			var _pageID:String = "$body";

			// destroy
			var _basePage:Page = this.getChildByName(_pageID) as Page;
			var _index:int = this.getChildIndex(_basePage);
			
			var _paths:Array = path.split("/");
			if (_paths[0] == "")
				_paths.shift();

			for(var i:int=0;i<_paths.length;i++)
			{
				var _pathID:String = _paths[i];
				var _page:Page = _basePage.getChildByName(_pathID) as Page;
				
				// destroy last page if diff with old pages sequence
				if(_currentPaths.length>0 && _currentPaths[i] && _paths[i] != _currentPaths[i])
				{
					/*
					var j:int = _basePage.numChildren;
					while (j--)
						trace(_basePage.getChildAt(j).name);
					*/
					var _oldPage:Page = _basePage.getChildByName(_currentPaths[i]) as Page;
					DisplayObjectUtil.removeChildren(_oldPage, true, true);
					_oldPage.destroy();
					_oldPage = null;
					
					SystemUtil.gc();
				}
				
				if(!_page)
				{
					// new page
					var _itemXML:XML = XMLUtil.getXMLById(_xml, _pathID);
					
					_page = new Page(_basePage);
					_page.name = _pathID;
					_page.parseXML(_itemXML);
					
					//trace(" add page: "+_pathID);

					var _src:String = _itemXML.@src;
					if (_src)
					{
						var _loader:Loader = LoaderUtil.queue(_src, onLoad, "asset");
						_loader.name = _pathID+"-loader";
						_page.addChild(_loader);
	
						_pageLoaders.push(_loader);
					}
				}
				
				// reparent
				_basePage = _page;
			}
			
			// keep for destroy chain later
			_currentPaths = _paths.slice();

			LoaderUtil.start();
		}
		
		// ____________________________________________ Destroy ____________________________________________

		override public function destroy():void
		{
			super.destroy();

			_loader = null;
			_data = null;
			_currentPaths = null;
		}
	}
}