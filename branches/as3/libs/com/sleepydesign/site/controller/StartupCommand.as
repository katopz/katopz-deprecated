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
package com.sleepydesign.site.controller
{
    import com.sleepydesign.site.model.PageDataProxy;
    import com.sleepydesign.site.model.SWFAddressProxy;
    import com.sleepydesign.site.model.SiteDataProxy;
    import com.sleepydesign.site.view.ApplicationMediator;
    
    import flash.display.Sprite;
    
    import org.puremvc.as3.interfaces.ICommand;
    import org.puremvc.as3.interfaces.INotification;
    import org.puremvc.as3.patterns.command.SimpleCommand;

    public class StartupCommand extends SimpleCommand implements ICommand
    {
        override public function execute( note:INotification ) : void    
        {
        	/**
			 * Get the View Components for the Mediators from the app,
         	 * which passed a reference to itself on the notification.
         	 */
	    	var container:Sprite = note.getBody() as Sprite;
            facade.registerMediator( new ApplicationMediator( container ) );
            
			/**
			 * Initializes a SiteDataProxy instance for loading site
			 * data via xml.
			 */
			facade.registerProxy( new SiteDataProxy() );
			
			/**
			 * Initializes a SWFAddressProxy instance
			 */
			facade.registerProxy( new SWFAddressProxy() );
			
			/**
			 * Initializes a PageDataProxy instance
			 */
			facade.registerProxy( new PageDataProxy() );
        }
    }
}