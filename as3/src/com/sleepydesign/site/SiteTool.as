package com.sleepydesign.site
{
	import com.sleepydesign.core.IDestroyable;
	import com.sleepydesign.events.RemovableEventDispatcher;
	import com.sleepydesign.net.LoaderUtil;
	import com.sleepydesign.system.DebugUtil;
	import com.sleepydesign.system.SystemUtil;
	import com.sleepydesign.utils.DisplayObjectUtil;
	import com.sleepydesign.utils.XMLUtil;
	
	import flash.display.DisplayObjectContainer;

	
	public class SiteTool extends RemovableEventDispatcher implements IDestroyable
	{
		private var _xml:XML;
		private var _container:DisplayObjectContainer;
		
		
		private var _currentPaths:Array = [];
		
		//private var _pageLoaders:Array; /*loaderVO*/
		private var _page:Page

		public function SiteTool(container:DisplayObjectContainer = null, xml:XML = null)
		{
			_container = container;
			_xml = xml;
			
			// root page
			_page = new Page(_container, _xml, _xml.@focus);
			_page.name= "site";
		}
		
		public function setFocusByPath(path:String):void
		{
			DebugUtil.trace(" ! setFocusByPath : " + path);
			
			var _paths:Array = path.split("/");
			if (_paths[0] == "")
				_paths.shift();

			var _basePage:Page = _page;
			
			/*
			var j:int = _basePage.numChildren;
			while (j--)
				trace("*"+_basePage.getChildAt(j).name);
			*/
				
			// not dirty yet
			Page.preferPaths = Page.offerPaths = _paths.slice();

			for (var i:int = 0; i < _paths.length; i++)
			{
				var _pathID:String = _paths[i];
				var _subPage:Page = _basePage.getChildByName(_pathID) as Page;
				
				// redirect
				if(Page.preferPaths != Page.offerPaths)
					continue;
				
				var _childIndex:int;
				
				// destroy last page if diff with old pages sequence
				if(_currentPaths.length>0 && _currentPaths[i] && _paths[i] != _currentPaths[i])
				{
					/*
					var j:int = _basePage.numChildren;
					while (j--)
						trace(_basePage.getChildAt(j).name);
					*/
					trace(" - remove Page : "+_currentPaths[i]);
					
					var _oldPage:Page = _basePage.getChildByName(_currentPaths[i]) as Page;
					_childIndex = _oldPage.parent.getChildIndex(_oldPage);
					
					DisplayObjectUtil.removeChildren(_oldPage, true, true);
					_oldPage.destroy();
					_oldPage = null;
					
					SystemUtil.gc();
				}
				
				if(!_subPage)
				{
					trace(" + add Page : "+_pathID);
					
					// new page
					var _itemXML:XML = XMLUtil.getXMLById(_xml, _pathID);
					
					_subPage = new Page(_basePage, _itemXML, _paths.slice(1).join("/"));
					_subPage.name = _pathID;
					
					if(_childIndex>=0)
					{
						_basePage.removeChild(_subPage);
						_basePage.addChildAt(_subPage, _childIndex);
					}
				}
				
				// reparent
				_basePage = _subPage;
			}
			
			// keep for destroy chain later
			_currentPaths = _paths.slice();
			trace(" ! _currentPaths : " + _currentPaths);

			// wait for next turn if someone make it dirty
			if(Page.preferPaths == Page.offerPaths)
				LoaderUtil.start();
			else
				setFocusByPath(Page.preferPaths.join("/"));
		}
		
		// ____________________________________________ Destroy ____________________________________________

		override public function destroy():void
		{
			super.destroy();

			_currentPaths = null;
			_page = null;
		}
	}
}