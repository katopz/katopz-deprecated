package com.sleepydesign.utils
{
	import flash.display.DisplayObject;
	import flash.external.ExternalInterface;
	import flash.net.LocalConnection;
	import flash.system.Capabilities;
	import flash.system.System;

    public class SystemUtil
    {
        // Garbage collector
        public static function gc() : void
        {
            try
            {
                if(int(version[0])<10)
                {
	                // Flash Player 9
	                new LocalConnection().connect("foo");
	                new LocalConnection().connect("foo");
                }else{
                	// Flash Player 10
        			System["gc"]();
                }
            }
            catch (e:*)
            {
            	//void
            }
        }
        
        public static function version() : Array
        {
        	return String(Capabilities.version.split(" ")[1]).split(",");
        }
        
        // Current memory
		public static function get memory() : Number
		{
			// faster? 1000/1024 = .0000009765625;
			//Number((System.totalMemory / 1048576).toFixed(3));
			return Number((System.totalMemory*.0000009765625).toFixed(3));
		}
        
        // StandAlone or Browser
        public static function isBowser():Boolean
        {
        	return Capabilities.playerType != "StandAlone" && Capabilities.playerType != "External";
        }
        
		public static function isHTTP(location:DisplayObject):Boolean 
		{
			if(location && location.loaderInfo && location.loaderInfo.url)
			{
				return location.loaderInfo.url.substr(0, 4) == 'http';
			}else{
				return false;
			}
		}
        
        // Browser with ExternalInterface there?
        public static function isExternal():Boolean
        {
        	return ExternalInterface.available && isBowser();
        }
        
        public static function alert(msg:String):void
        {
        	if(isBowser())
        	{
        		URLUtil.getURL("javascript:alert('"+msg+"');void(0);","_self");
        	}else{
        		trace("\n ! Alert : " + msg + "\n");
        	}
        }
    }
}
