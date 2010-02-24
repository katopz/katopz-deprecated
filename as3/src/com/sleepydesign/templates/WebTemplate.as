package com.sleepydesign.templates
{
	import com.asual.SWFAddress;
	import com.asual.SWFAddressEvent;
	import com.sleepydesign.components.SDTree;
	import com.sleepydesign.events.TreeEvent;
	import com.sleepydesign.site.Site;
	import com.sleepydesign.utils.StringUtil;

	[SWF(backgroundColor="0xFFFFFF", frameRate="30", width="800", height="600")]
	public class WebTemplate extends ApplicationTemplate
	{
		protected var _site:Site;
		protected var _tree:SDTree;
		protected var isSiteMap:Boolean;

		public function WebTemplate()
		{

		}

		override protected function onInitXML():void
		{
			SWFAddress.addEventListener(SWFAddressEvent.INIT, onSWFAddressInit);
			SWFAddress.addEventListener(SWFAddressEvent.CHANGE, handleSWFAddress);

			if (isSiteMap)
				createSiteMap();
		}

		private function createSiteMap():void
		{
			_tree = new SDTree(_xml, true, true, true);
			_systemLayer.addChild(_tree);
			_tree.x = 10;
			_tree.y = 10;

			_tree.addEventListener(TreeEvent.CHANGE_NODE_FOCUS, onTreeChangeFocus);
		}

		private function onTreeChangeFocus(event:TreeEvent):void
		{
			var _path:String = String("/" + event.node.path).split("/$").join("/");
			if (SWFAddress.getPath() != _path)
				SWFAddress.setValue(_path);
		}

		private function onSWFAddressInit(e:SWFAddressEvent):void
		{
			_site = new Site(_contentLayer, _xml);
		}

		private function handleSWFAddress(e:SWFAddressEvent):void
		{
			for (var i:int = 0; i < e.pathNames.length; i++)
				_title += ' / ' + e.pathNames[i].substr(0, 1).toUpperCase() + e.pathNames[i].substr(1);

			SWFAddress.setTitle(_title);

			if (e.pathNames[0])
			{
				// focus from external
				setFocus(e.path);
			}
			else if (!StringUtil.isNull(_xml.@focus))
			{
				// focus from xml
				SWFAddress.setValue(String(_xml.@focus));
			}
		}

		private function setFocus(path:String):void
		{
			// tree
			if (_tree)
				_tree.setFocusByPath(path.split("/").join("/$"));

			// site
			_site.setFocusByPath(path);
		}

		// TODO:destroy
	}
}