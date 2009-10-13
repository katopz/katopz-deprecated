/*
 Copyright (c) 2008 AllFlashWebsite.com
 All rights reserved.
 
 Some code compiled from forum:
 http://forums.puremvc.org/index.php?PHPSESSID=a0b1441c9f879cef0256b86ddc30fe29&topic=286.msg1104#msg1104

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is furnished
 to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
 INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
 PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
 OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

 @ignore
 * 
 * Modify by Todsaporn Banjerdkit <katopz@sleepydesign.com>
 * Under a Creative Commons Attribution 3.0 Thailand License.
 * 
 */
 
package com.sleepydesign.site.model
{
	import com.asual.swfaddress.SWFAddress;
	import com.asual.swfaddress.SWFAddressEvent;
	import com.sleepydesign.site.ApplicationFacade;
	import com.sleepydesign.site.view.components.Navigation;
	import com.sleepydesign.utils.SWFAddressUtil;
	
	import flash.external.ExternalInterface;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
    public class SWFAddressProxy extends Proxy implements IProxy
    {
        public static const NAME:String = 'SWFAddressProxy';
		public static var isInit:Boolean = false; 
		
        public function SWFAddressProxy( )
        {
            super( NAME, Number(0) );
			SWFAddress.addEventListener(SWFAddressEvent.INIT, onAddressInit);
        }
		
		public function requestURI(uri:String):void
		{
			if(uri.length<1)return;
			trace(" * SWFAddressProxy.requestURI : "+uri);
			if (ExternalInterface.available && SWFAddressProxy.isInit) 
			{
				SWFAddress.setValue(uri);
			} else {
				trace(" ! No ExternalInterface");
				setTargetURI( SWFAddressUtil.segmentURI("/"+uri) );
				//setTargetURI( uri );
			}
		}
		
		public function setTitle(title:String):void
		{
			SWFAddress.setTitle(title);
		}
		
		private function onAddressInit(e:SWFAddressEvent):void
		{
			trace(" ^ onAddressInit\t: "+e.value);
			
			isInit = true;
			
			SWFAddress.removeEventListener(SWFAddressEvent.INIT, onAddressInit);
			
			trace(" ! currrentPath\t: " +Navigation.currrentPath);
			trace(" ! focusPath\t: " +ApplicationFacade.focusPath);
			
			// "/" -> mean no focus then better luck in 1st child in xml
			var defaultPath:String = SWFAddressUtil.segmentURI(e.value).join("/");
			Navigation.defaultPath = (defaultPath.length>0)?defaultPath:null;
			
			trace(" ! defaultPath\t: " +Navigation.defaultPath);
			
			if(ApplicationFacade.focusPath!=Navigation.defaultPath)
			{
				if(!Navigation.defaultPath)
					requestURI(ApplicationFacade.focusPath);
			}
			
			SWFAddress.addEventListener(SWFAddressEvent.CHANGE, onAddressChange);
		}
		
		private function onAddressChange(e:SWFAddressEvent):void
		{
			trace(" ^ onAddressChange\t: "+e.value);
			
			setTargetURI( SWFAddressUtil.segmentURI(e.value) );
			
			/*
			var arr:Array = e.value.split("/");
			arr.shift();
			setTargetURI( arr.join("/") );
			*/
		}
		
		//private function setTargetURI(currentSection:String):void
		private function setTargetURI(uriSegments:Array):void
		{
			// DIRTY
			var currrentPath:String = uriSegments.join("/");
			trace(" ! currrentPath\t: " +Navigation.currrentPath + " -> "+(currrentPath?currrentPath:""));
			if(Navigation.currrentPath && currrentPath.length>0 && Navigation.currrentPath!=currrentPath)
			{
				//Navigation.currrentPath = currrentPath;
				trace(" * SWFAddressProxy.setTargetURI\t: "+currrentPath);
				sendNotification( ApplicationFacade.SECTION_CHANGED, currrentPath );
			}
		}
     }
}