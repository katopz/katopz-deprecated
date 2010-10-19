package com.sleepydesign.templates
{
	import com.asual.SWFAddress;
	import com.asual.SWFAddressEvent;
	import com.sleepydesign.data.DataProxy;
	import com.sleepydesign.events.TreeEvent;
	import com.sleepydesign.site.NavigationProxy;
	import com.sleepydesign.site.SiteTool;
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

		override protected function onTreeChangeFocus(event:TreeEvent):void
		{
			var _path:String = String("/" + event.node.path).split("/$").join("/");
			if (SWFAddress.getPath() != _path)
				SWFAddress.setValue(_path);
		}

		private function onSWFAddressInit(e:SWFAddressEvent):void
		{
			initNavigation();
		}
		
		override protected function initNavigation():void
		{
			var _focus:String = SWFAddress.getPath();
			trace(" ! path : " + _focus);
			trace(" ! xml.@focus : " + _xml.@focus);
			
			if(_focus!="/")
				_xml.@focus = _focus;
			
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