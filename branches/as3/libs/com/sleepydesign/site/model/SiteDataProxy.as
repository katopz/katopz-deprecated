/*
 PureMVC AS3 / Flash Demo - HelloFlash
 By Cliff Hall <clifford.hall@puremvc.org>
 Copyright(c) 2007-08, Some rights reserved.
 * 
 * Modify by Todsaporn Banjerdkit <katopz@sleepydesign.com>
 * Under a Creative Commons Attribution 3.0 Thailand License.
 * 
 */
package com.sleepydesign.site.model
{
    import com.sleepydesign.application.core.SDApplication;
    import com.sleepydesign.core.SDLoader;
    import com.sleepydesign.site.ApplicationFacade;
    import com.sleepydesign.site.model.vo.ContentVO;
    import com.sleepydesign.site.model.vo.SiteVO;
    import com.sleepydesign.site.view.components.Navigation;
    import com.sleepydesign.utils.LoaderUtil;
    
    import flash.events.Event;
    
    import org.puremvc.as3.interfaces.IProxy;
    import org.puremvc.as3.patterns.proxy.Proxy;

    public class SiteDataProxy extends Proxy implements IProxy
    {
        public static const NAME:String = "SpriteDataProxy";
		
        public function SiteDataProxy( )
        {
        	/**
        	 * Here, we initialize SpriteDataProxy with a var named "data" 
        	 * of type Object(), a built-in property of the Proxy class. 
        	 * This var will be used for storing data retrieved from the xml document.
        	 */
            super( NAME, {} );
            
            LoaderUtil.loadXML(SDApplication.configURI, onDataHandler);
        }
		
		private function onDataHandler( event:Event ):void
		{
			if(event.type!="complete")return;
			
			var xml:XML = event.target["data"];
			XML.ignoreWhitespace = true;
			XML.ignoreComments = true;
			
			if(xml.length()<=0)return;
			
			data = parse(xml);
			
			// default focus from SWFAddress
			trace(" ! SWFAddress\t: "+Navigation.defaultPath);
			
			// focus from xml
			ApplicationFacade.focusPath = Navigation.defaultPath?Navigation.defaultPath:SiteVO(data).focus;
			
			trace(" ! XML Focus\t: "+ApplicationFacade.focusPath);
			
			/**
			 * When SiteDataProxy is done loading and parsing data, it 
			 * sends an INITIALIZE_SITE notification back to the framework.
			 */
			sendNotification( ApplicationFacade.INITIALIZE_SITE );
		}
		
		/* current traverse only main nav!!! need to create site map data here and send to mediator */ 
		private function parse( xml:XML ):Object
		{
			var siteVO:SiteVO = new SiteVO(xml);
			
			var xmlList:XMLList = xml.children();
			for ( var i:uint=0; i< xmlList.length(); i++ ) 
			{
				var contentXML:XML = xmlList[i];
				var type:String = String(contentXML.@type?contentXML.@type:"page").toLowerCase();
				
				switch(type)
				{
					// top layer
					case "foreground":
						siteVO.foreground = new ContentVO(contentXML.@id, null, contentXML);
					break;
					// bottom layer
					case "background":
						siteVO.background = new ContentVO(contentXML.@id, null, contentXML);
					break;
					// content(s) layer
					default:
						//default 1st child page
						if(!siteVO.focus)
							siteVO.focus = contentXML.@id;
					break;
				}
			}
			return siteVO;
		}
    }
}