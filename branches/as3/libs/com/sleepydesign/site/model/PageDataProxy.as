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
            super( NAME, {} );
            
            // sniff all page data event
            //Page.addEventListener(SDEvent.UPDATE, onDataChange);
        }
        
		public function updateData(data:*):void
		{
			// data is on the line
			onDataChange(new SDEvent(SDEvent.DATA, data));
		}
		
		private function onDataChange(event:SDEvent):void
		{
			trace(" ^ onDataChange\t: "+event);
			sendNotification( ApplicationFacade.DATA_CHANGED, event );
		}
    }
}