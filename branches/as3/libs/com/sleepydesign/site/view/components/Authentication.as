package com.sleepydesign.site.view.components
{
	import com.sleepydesign.core.SDMovieClip;
	import com.sleepydesign.events.SDEvent;
	import com.sleepydesign.site.model.vo.ContentVO;
	import com.sleepydesign.utils.XMLUtil;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
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
			//trace("\n ============== AuthenticationClip ==============");
			configURI = "serverside/authen.xml";
			super();
		}
		
		//hide all while load config
		override protected function onStage(event:Event=null):void
		{
			visible = false;
			/*
			var _numChildren:uint = numChildren;
            while(_numChildren--)
            {
                var _displayObject:DisplayObject = getChildAt( _numChildren );
                trace(_displayObject)
               _displayObject.visible = false;
            }
            */
		}
		
		override public function init(raw:Object=null):void
		{
			trace(" ! Authentication.init");
			// can be use session to select page to load later
			if(!stage)
				getConfig(configURI);
		}
		
		override protected function onGetContent(event:Event=null):void
		{
			visible = true;
			super.onGetContent(event);
			//trace("onGetContentonGetContentonGetContentonGetContentonGetContent");
			
			/*
			var xml:XML = XMLUtil.getXMLById(data.xml, "authen");
			var childContent:Content = Content(contents.findBy("authen"));
			childContent.addEventListener(SDEvent.DATA, onContentData);
			childContent.getData(xml.@data);
			*/
			
			// no result from init state
			if(!contents)return;
			
			for each(var _content:Content in contents.childs)
			{
				//trace("\n\n\n\n\n\n\n\n_content.id:"+_content.id);
				var xml:XML = XMLUtil.getXMLById(data.xml, _content.id);
				
				_content.addEventListener(SDEvent.DATA, onContentData);
				
				//auto data
				if(_content.id == "authen")
				{
					//SDMovieClip(_content.content).getChildByName("authenticationClip").visible = true;
					//_content.content.visible = true;
					//_content.show();
					
					//trace("datadatadata"+xml.@data);
					_content.getData(xml.@data);
				}
			}
		}
		
		/*
		override public function update(data:Object=null):void
		{
			//trace("//////////// Authentication.update ///////////");
			
			TweenMax.killTweensOf(authenClip);
			TweenMax.killTweensOf(logInClip);
			TweenMax.killTweensOf(logOutClip);
			
			authenClip.visible = false;
			logInClip.visible = false;
			logOutClip.visible = false;
			
			super.update(data);
		}
		*/
		// invoke after content.data is update by submit
		private function onContentData(event:SDEvent):void
		{
			//trace("//////////// Authentication.onContentData ///////////");
			//event.target.removeEventListener(SDEvent.DATA, onContentData);
			//{vo:new ContentVO(xml.@id, content, xml)}
			var xml:XML = event.data.xml;
			update(new ContentVO(xml.@id, event.target.content, xml));
		}
		
		/*
		override protected function onGetContent(event:Event=null):void
		{
			trace("onGetContentonGetContentonGetContentonGetContentonGetContent");
			
			trace(XML(data.xml).toXMLString());
			
			if(!data || !data.xml || !StringUtil.isNull(data.xml))return;
			
			// create base content
			super.onGetContent(event);
			
			var xml:XML = XML(data.xml.content);
			
			var childContent:Content = Content(contents.findBy(String(xml.@id))); 
			
			trace("childContent:"+childContent);
			
			childContent.content.alpha = 0;
			TweenMax.to(childContent.content, .5, {autoAlpha:1});
			childContent.addEventListener(SDEvent.DATA, onContentData);
			
			switch(String(xml.@id))
			{
				case "authen":
					// DIRTY
					if(!StringUtil.isNull(xml.@data))
					{
						childContent.getData(xml.@data);
					}
					else if(!StringUtil.isNull(xml.@config))
					{
						childContent.getData(xml.@config);
					}
				break;
				case "logIn":
					//
				break;
				case "logOut":
					//
				break;
			}
			childContent.show();
		}
		*/
	}
	
	/*
		override protected function onGetContent(event:Event=null):void
		{
			// create base content
			super.onGetContent(event);
			
			var xml:XML = XML(data.xml.content);
			
			var childContent:Content = Content(contents.findBy(String(xml.@id))); 
			childContent.content.alpha = 0;
			TweenMax.to(childContent.content, .5, {autoAlpha:1});
			childContent.addEventListener(SDEvent.UPDATE, onContentData);
			
			switch(String(xml.@id))
			{
				case "authen":
					if(xml.@data)
						getConfig(xml.@data);
				break;
				case "logIn":
					//
				break;
				case "logOut":
				//
				break;
			}
		}
	*/
}