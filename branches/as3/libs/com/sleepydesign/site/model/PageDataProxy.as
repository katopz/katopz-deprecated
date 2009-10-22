package com.sleepydesign.site.model
{
    import com.sleepydesign.events.SDEvent;
    import com.sleepydesign.site.ApplicationFacade;
    import com.sleepydesign.site.view.components.Page;
    
    import org.puremvc.as3.interfaces.IProxy;
    import org.puremvc.as3.patterns.proxy.Proxy;

    public class PageDataProxy extends Proxy implements IProxy
    {
        public static const NAME:String = "PageDataProxy";
		
        public function PageDataProxy( )
        {
        	/**
        	 * Here, we initialize SpriteDataProxy with a var named "data" 
        	 * of type Object(), a built-in property of the Proxy class. 
        	 * This var will be used for storing data retrieved from the xml document.
        	 */
            super( NAME, {} );
            
            Page.addEventListener(SDEvent.UPDATE, onDataChange);
        }
        
		public function updateData(data:*):void
		{
			
		}
		
		private function onDataChange(event:SDEvent):void
		{
			trace(" ^ onDataChange\t: "+event);
			sendNotification( ApplicationFacade.DATA_CHANGED, event );
		}
    }
}