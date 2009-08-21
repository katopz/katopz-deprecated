package com.sleepydesign.site.view.components
{
	import com.sleepydesign.application.core.SDSystem;
	import com.sleepydesign.events.SDEvent;
	import com.sleepydesign.site.model.vo.ContentVO;
	import com.sleepydesign.utils.StringUtil;
	import com.sleepydesign.utils.XMLUtil;
	
	import flash.events.Event;
	import flash.system.System;
	import flash.utils.*;

	/* ---------------------------------------------------------------

	   + [Page::Authentication]
	   + AuthenClip
	   + LogInClip :: Form
	   + LogOutClip

	 --------------------------------------------------------------- */

	public class Authentication extends Page
	{
		public function Authentication()
		{
			super();
			visible = false;
		}

		override public function init(raw:Object = null):void
		{
			trace(" ! Authentication.init : "+ _data);
			
            if (_data && _data.xml && String(_data.xml.@config).length > 0)
            {
				trace(" ! Custom configURI : " + configURI);
				configURI = String(_data.xml.@config);
            }else{
            	configURI = "authen.xml";
            }
			
			// can be use session to select page to load later
			if (!stage)
			{
				getConfig(configURI);
			}else{
				
			}
		}

		override protected function onGetContent(event:Event = null):void
		{
			
			super.onGetContent(event);

			// no result from init state
			if (!contents)
				return;

			for each (var _content:Content in contents.childs)
			{
				var xml:XML = XMLUtil.getXMLById(_data.xml, _content.id);
				_content.removeEventListener(SDEvent.DATA, onContentData);
				_content.addEventListener(SDEvent.DATA, onContentData);

				//auto data
				if (_content.id == "authen")
					_content.getData(xml.@data);
			}
			
			visible = true;
		}

		// invoke after content.data is update by submit
		private function onContentData(event:SDEvent):void
		{
			var xml:XML = event.data.xml;
			update(new ContentVO(xml.@id, event.target.content, xml));
			
			if(!StringUtil.isNull(xml.@session))
			{
				trace(" ! Session : "+xml.@session);
				SDSystem.data.session = String(xml.@session);
			}
			
			/*
			switch(event)
			{
				default :
					trace() 
				break;
			}
			*/
		}
	}
}