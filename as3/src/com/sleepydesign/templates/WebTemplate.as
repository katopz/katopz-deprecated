package com.sleepydesign.templates
{
	import com.asual.SWFAddress;
	import com.asual.SWFAddressEvent;
	import com.sleepydesign.components.SDTreeNode;
	import com.sleepydesign.data.DataProxy;
	import com.sleepydesign.site.NavigationProxy;
	import com.sleepydesign.site.SiteTool;
	import com.sleepydesign.system.DebugUtil;
	import com.sleepydesign.utils.StringUtil;

	public class WebTemplate extends ApplicationTemplate
	{
		protected var _flashvars:Object;

		public function get flashvars():Object
		{
			return _flashvars;
		}

		public function WebTemplate()
		{
			if (loaderInfo && loaderInfo.parameters)
			{
				DataProxy.setData(DataProxy.FLASH_VARS, loaderInfo.parameters);
				_flashvars = loaderInfo.parameters;
			}

			super();
			_configURI = "site.xml";
		}

		override protected function onInitXML():void
		{
			SWFAddress.addEventListener(SWFAddressEvent.INIT, onSWFAddressInit);
			SWFAddress.addEventListener(SWFAddressEvent.CHANGE, handleSWFAddress);

			createSiteMap();
		}

		override protected function onTreeChangeFocus(node:SDTreeNode):void
		{
			var _path:String = String("/" + node.path).split("/$").join("/");
			if (SWFAddress.getPath() != _path)
				SWFAddress.setValue(_path);
		}

		private function onSWFAddressInit(e:SWFAddressEvent):void
		{
			initNavigation();
		}

		override protected function initNavigation():void
		{
			var path:String = SWFAddress.getPath();
			DebugUtil.trace(" ! # : " + path);
			DebugUtil.trace(" ! xml.@focus : " + _xml.@focus);

			if (path.indexOf("/") == 0)
				path = path.substring(1);

			if (path != "")
				_xml.@focus = path;

			DebugUtil.trace(" ! focus : " + _xml.@focus);

			_site = new SiteTool(_contentLayer, _xml);
			NavigationProxy.signal.add(setFocus);
		}

		private function handleSWFAddress(e:SWFAddressEvent):void
		{
			for (var i:int = 0; i < e.pathNames.length; i++)
				_title += ' / ' + e.pathNames[i].substr(0, 1).toUpperCase() + e.pathNames[i].substr(1);

			//SWFAddress.setTitle(_title);

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

		// TODO:destroy
	}
}