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
    import com.sleepydesign.core.SDApplication;
    import com.sleepydesign.core.SDLoader;
    import com.sleepydesign.events.SDEvent;
    import com.sleepydesign.site.ApplicationFacade;
    import com.sleepydesign.site.model.vo.ContentVO;
    import com.sleepydesign.site.model.vo.SiteVO;
    import com.sleepydesign.site.view.components.Navigation;
    
    import org.puremvc.as3.interfaces.IProxy;
    import org.puremvc.as3.patterns.proxy.Proxy;

    public class SiteDataProxy extends Proxy implements IProxy
    {
        public static const NAME:String = "SpriteDataProxy";
       // public var navIDs:Array;
		//public var defaultPath:String;
		
        public function SiteDataProxy( )
        {
        	/**
        	 * Here, we initialize SpriteDataProxy with a var named "data" 
        	 * of type Object(), a built-in property of the Proxy class. 
        	 * This var will be used for storing data retrieved from the xml document.
        	 */
            super( NAME, {} );
            
            SDApplication.loader.addEventListener( SDEvent.COMPLETE, onDataLoaded, false, 0, true);
            SDApplication.loader.load(SDApplication.getInstance().configURI);
        }
		
		private function onDataLoaded( event:SDEvent ):void
		{
			SDApplication.loader.removeEventListener( SDEvent.COMPLETE, onDataLoaded );
			 
			var xml:XML = new XML( SDLoader(event.target).getContent(SDApplication.getInstance().configURI) );
			XML.ignoreWhitespace = true;
			XML.ignoreComments = true;
			
			data = parse(xml);
			
			// default focus from SWFAddress
			trace(" ! SWFAddress\t: "+Navigation.defaultPath);
			
			// focus from xml
			ApplicationFacade.focusPath = Navigation.defaultPath?Navigation.defaultPath:SiteVO(data).focus;
			//ApplicationFacade.currrentPath = ApplicationFacade.focusPath;
			
			//ApplicationFacade.currentSection = ApplicationFacade.currentSection?ApplicationFacade.currentSection:ApplicationFacade.currrentPath.split("/")[0];
			
			trace(" ! Focus\t: "+ApplicationFacade.focusPath);
			
			//trace(" ! Paths	: "+ApplicationFacade.currrentPath);
			//trace(" ! Section	: "+ApplicationFacade.currentSection);
			
			/**
			 * When SiteDataProxy is done loading and parsing data, it 
			 * sends an INITIALIZE_SITE notification back to the framework.
			 */
			sendNotification( ApplicationFacade.INITIALIZE_SITE );
		}
		
		/* current traverse only main nav!!! need to create site map data here and send to mediator */ 
		private function parse( xml:XML ):Object
		{
			//var contents:SDGroup = new SDGroup("site");
			var data:SiteVO = new SiteVO(xml);
			//trace(data.contents)
			//var content:XMLList = xml.content;
			//navIDs = [];
			
			
			var xmlList:XMLList = data.xml.children();
			for ( var i:uint=0; i< xmlList.length(); i++ ) 
			{
				var contentXML:XML = xmlList[i];
				var type:String = String(contentXML.@type?contentXML.@type:"page").toLowerCase();
				
				switch(type)
				{
					// top layer
					case "foreground":
						data.foreground = new ContentVO(contentXML.@id, null, contentXML);
					break;
					// bottom layer
					case "background":
						data.background = new ContentVO(contentXML.@id, null, contentXML);
					break;
					// content(s) layer
					default:
						//var id:String = contentXML.@id;
						//navIDs.push(id);
						
						//default 1st child page
						if(!data.focus)data.focus = contentXML.@id;
						
						//data.contents.insert(new ContentVO(contentXML.@id, contentXML ));
					break;
				}
			}
			return data;
		}
    }
}