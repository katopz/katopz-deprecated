/**
 * PureMVC Flash/AS3 page demo
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
    import com.sleepydesign.site.model.PageDataProxy;
    import com.sleepydesign.site.view.components.Page;
    import com.sleepydesign.utils.ObjectUtil;
    
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.mediator.Mediator;
    
    public class PageMediator extends Mediator implements IMediator
    {
        // Cannonical name of the Mediator
        public static const NAME:String = "PageMediator";
        private var _pageDataProxy:PageDataProxy;
		
        public function PageMediator( viewComponent:Object ) 
        {
            super( NAME, viewComponent );
    		
			// Retrieve reference to PageDataProxy
			_pageDataProxy = facade.retrieveProxy( PageDataProxy.NAME ) as PageDataProxy;
			var data:Object = _pageDataProxy.getData();
			
			//trace("do something with this data!");
			//ObjectUtil.print(data);
        }
		
		/**
		 * Lists the SECTION_CHANGED notification as an 
		 * event of interest as we want to update the page content
		 * whenever a SECTION_CHANGED event occurrs
		 */
        override public function listNotificationInterests():Array 
        {
            return [ApplicationFacade.DATA_CHANGED];
        }
		
        override public function handleNotification( note:INotification ):void 
        {
        	switch ( note.getName() ) {
                /**
                * Handles the SECTION_CHANGED Notification event by passing the 
                * value of note.getBody() cast as a String to the update() method
                */
                case ApplicationFacade.DATA_CHANGED:
					update( note.getBody() as String );
                  	break;
            }
        }
        
        /**
        * Retrieves relevant data for the id passed in @param id and sends it
        * along to the page instance using the update() method
        */
        private function update( data:* ):void
        {
        	page.update( data );
        }
                
        /**
		 * Retrieves the viewComponent and casting it to type Page
		 */   
        protected function get page():Page
        {
            return viewComponent as Page;
        }
    }
}