/**
 * PureMVC Flash/AS3 site demo
 * Copyright (c) 2008 Yee Peng Chia <peng@hubflanger.com>
 * 
 * This work is licensed under a Creative Commons Attribution 3.0 United States License.
 * Some Rights Reserved.
 * 
 * Modify by Todsaporn Banjerdkit <katopz@sleepydesign.com>
 * Under a Creative Commons Attribution 3.0 Thailand License.
 * 
 */
package com.sleepydesign.site.view
{
    import com.sleepydesign.site.ApplicationFacade;
    import com.sleepydesign.site.model.*;
    import com.sleepydesign.site.model.vo.PageVO;
    import com.sleepydesign.site.view.components.Site;
    import com.sleepydesign.utils.XMLUtil;
    
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.mediator.Mediator;
    
    public class SiteMediator extends Mediator implements IMediator
    {
        // Cannonical name of the Mediator
        public static const NAME:String = "SiteMediator";
        private var _siteDataProxy:SiteDataProxy;

        public function SiteMediator( viewComponent:Object ) 
        {
            super( NAME, viewComponent );
    
			// Retrieve reference to SiteDataProxy
			_siteDataProxy = facade.retrieveProxy( SiteDataProxy.NAME ) as SiteDataProxy;
			
			// SiteVO
			var data:Object = _siteDataProxy.getData();
			
			// preload base elements
			site.parse( data );
        }
		
		/**
		 * Lists the SECTION_CHANGED notification as an 
		 * event of interest as we want to update the site content
		 * whenever a SECTION_CHANGED event occurrs
		 */
        override public function listNotificationInterests():Array 
        {
            return [ApplicationFacade.SECTION_CHANGED];
        }
		
        override public function handleNotification( note:INotification ):void 
        {
        	switch ( note.getName() ) {
                /**
                * Handles the SECTION_CHANGED Notification event by passing the 
                * value of note.getBody() cast as a String to the update() method
                */
                case ApplicationFacade.SECTION_CHANGED:
					update( note.getBody() as String );
                  	break;
            }
        }
        
        /**
        * Retrieves relevant data for the id passed in @param id and sends it
        * along to the site instance using the update() method
        */
        private function update( path:String ):void
        {
        	path = path?path:"";
        	//var id:String = path.split("/").shift();
        	trace(" ^ "+this+".update\t: "+path);
        	var paths:Array = path.split("/");
         	var xml:XML = XMLUtil.getXMLById(XML(Site.getInstance().config.xml), paths.shift());
        	var vo:PageVO = new PageVO(xml.@id, null, xml, path);       	
        	
        	/*
        	var baseXML:XML = XMLUtil.getXMLById(XML(Site.getInstance().config.xml), paths.shift());
        	var pageXML:XML = pageXML.normalize()
        	for each(var id:String in paths)
        	{
        		trace("vo:"+id);
        		xml.appendChild(XMLUtil.getXMLById(xml,id));
        	}
        	*/
        	

        	
        	/*
        	var paths:Array = path.split("/")
        	var contentVOs:Array=[];
        	for each(var id:String in paths)
        	{
        		trace("vo:"+id);
        		var xml:XML = XMLUtil.getXMLById(XML(Site.getInstance().config.xml),id);
        		var vo:PageVO = new PageVO(xml.@id, xml);
        		contentVOs.push(vo);
        	}
        	*/
        	//var data:SiteVO = SiteVO(_siteDataProxy.getData());
        	
        	// TODO : optimize this
        	//var vo:ContentVO = ContentVO(data.contents.findBy( id ));
        	////var xml:XML = XMLUtil.getXMLById(XML(Site.getInstance().config.xml),id);
        	////var vo:PageVO = new PageVO(xml.@id, xml);
        	
        	//navSources
        	//var asset:XMLList = vo.asset;
        	
        	// parse asset
        	site.update( vo );
        	
        }
                
        /**
		 * Retrieves the viewComponent and casting it to type Site
		 */   
        protected function get site():Site
        {
            return viewComponent as Site;
        }
    }
}