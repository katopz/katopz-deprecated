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
package com.sleepydesign.site
{
    import com.sleepydesign.site.controller.AddressChangeCommand;
    import com.sleepydesign.site.controller.DataChangeCommand;
    import com.sleepydesign.site.controller.StartupCommand;
    
    import org.puremvc.as3.interfaces.IFacade;
    import org.puremvc.as3.patterns.facade.Facade;
    
    public class ApplicationFacade extends Facade implements IFacade
    {
        // Notification name constants
        public static const STARTUP:String  		= "startup";
        public static const INITIALIZE_SITE:String  = "initializeSite";
        public static const SECTION_CHANGED:String  = "sectionChanged";
        
        public static const DATA_CHANGED:String  = "dataChanged";
         
        public static var focusPath:String;

        public static function getInstance() : ApplicationFacade 
        {
            if ( instance == null ) instance = new ApplicationFacade();
            return instance as ApplicationFacade;
        }

        /**
         * register StartupCommand with the Controller 
         */
        override protected function initializeController() : void 
        {
            super.initializeController(); 
            /**
            * By registering StartupCommand with the STARTUP event, you're 
            * telling the framework that the StartupCommand is interested 
            * in listening for a STARTUP notification event. The Controller 
            * will add StartupCommand to its commandMap array and retrieve 
            * it when a Notification is dispatched.
            */
            registerCommand( STARTUP, StartupCommand );
            
            /**
            * registering AddressChangeCommand
            */
            registerCommand(SECTION_CHANGED, AddressChangeCommand);
            
            // sniff all data change
            registerCommand(DATA_CHANGED, DataChangeCommand);
        }
        
        public function startup( container:Object ):void
        {
        	/**
        	 * Sending this notification will cause the execute() method in 
        	 * StartupCommand to be called as it's registered as a listener
        	 * of the STARTUP event.
        	 */
        	sendNotification( STARTUP, container );
        }
    }
}