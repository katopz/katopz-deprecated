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
    import com.sleepydesign.events.SDEvent;
    import com.sleepydesign.site.ApplicationFacade;
    import com.sleepydesign.site.model.*;
    import com.sleepydesign.site.view.components.Navigation;
    
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.mediator.Mediator;
    
    public class NavigationMediator extends Mediator implements IMediator
    {
        // Cannonical name of the Mediator
        public static const NAME:String = "NavMediator";
        private var _siteDataProxy:SiteDataProxy;
        //public static var currentSection:String;

        public function NavigationMediator( viewComponent:Object ) 
        {
            super( NAME, viewComponent );
    		
			// Retrieve reference to SiteDataProxy
			_siteDataProxy = facade.retrieveProxy( SiteDataProxy.NAME ) as SiteDataProxy;
			
			/**
			 * register NavMediator as a listener of the NAV_BUTTON_PRESSED event
			 * dispatched by the nav movieclip instance
			 */
			nav.addEventListener(SDEvent.CHANGE_FOCUS, onNavButtonPressed, false, 0, true );
			
			/**
			 * retrieve data from SiteDataProxy and pass that information
			 * to the nav instance to initialize nav buttons
			 */
			nav.parse( {data:_siteDataProxy.getData()})//, navIDs:_siteDataProxy.navIDs} );
			
			// create time
			nav.create();
        }
        
        /**
		 * Lists the SECTION_CHANGED notification as an 
		 * event of interest as we want to update the nav content
		 * whenever a SECTION_CHANGED event occurrs
		 */
        override public function listNotificationInterests():Array 
        {
            return [ 
            		ApplicationFacade.SECTION_CHANGED
                   ];
        }
		
        override public function handleNotification( note:INotification ):void 
        {
        	switch ( note.getName() ) 
        	{
                case ApplicationFacade.SECTION_CHANGED:
	                /**
	                 * calls the update() method in the nav instance passing
	                 * in the section id by casting the note.getBody() value to String
	                 */
					nav.setSectionByPath( note.getBody() as String );
                  	break;
            } 
        }
        
        /**
         * Responds to the NavButtonPressed Event dispatched 
         * by the nav instance and translates it to a Notification and 
         * sends it to the PureMVC framework
         */
 		private function onNavButtonPressed( evt:SDEvent ):void
 		{
 			//trace("------------------------------------------------");
 			trace(" ^ onNavButtonPressed : "+evt.data.path);
 			navTo(evt.data.path);
 		}
 		
 		//private var currrentPath:String;
 		
 		private function navTo( path:String ):void
 		{
 			var paths:Array = path.split("/");
 			//trace(" ! "+ApplicationFacade.currentSection,"==", paths[paths.length-1])
 			//if ( ApplicationFacade.currentSection != paths[paths.length-1])
 			//trace(ApplicationFacade.focusPath)
 			if ( ApplicationFacade.focusPath!= path) 
 			{
 				ApplicationFacade.focusPath = path;
 				//ApplicationFacade.currentSection = paths.shift();
 				//trace(" ! currentSection : "+ApplicationFacade.currentSection);
	 			sendNotification( ApplicationFacade.SECTION_CHANGED, path );
	 		}
	 		/*
	 		else if(ApplicationFacade.currentSection!=paths[paths.length-1])
	 		{
	 			trace("not finish all path yet!");
	 			// TODO : recusive call
	 			paths.shift();
	 			navTo(paths.join("/"));
	 			//sendNotification( ApplicationFacade.SECTION_CHANGED, ApplicationFacade.currentSection );
	 		}
	 		*/
 		}
        
        /**
		 * Retrieves the viewComponent and casting it to type MainNav
		 */   
        protected function get nav():Navigation
        {
            return viewComponent as Navigation;
        }
    }
}