package com.sleepydesign.core
{
    import com.sleepydesign.events.SDEvent;
    import com.sleepydesign.utils.URLUtil;
    
    import flash.events.Event;
    import flash.net.FileFilter;
    import flash.net.FileReference;
    import flash.utils.ByteArray;
    import flash.utils.IExternalizable;
    
    /**
	 * _____________________________________________________
	 * 
	 * SleepyDesign System
	 * @author katopz
	 * _____________________________________________________
	 * 
	 */
	public class SDSystem extends SDContainer
	{
		public function SDSystem(id:String=null, raw:Object=null)
		{
			super(id, raw);
		}
		
		// ______________________________ Initialize ______________________________
		
		override public function init(raw:Object=null):void
		{
			if(!raw || !raw.container || !raw.stage)return;
			raw.stage.addChild(this);
		}
		
		// ______________________________ File ______________________________
		
		public function save(data:*, defaultFileName:String = null):void
		{
			var type:String = URLUtil.getType(defaultFileName);
			
			// TODO : save image
			
			//save AMF like Object
			var rawBytes:ByteArray = new ByteArray();
			IExternalizable(data).writeExternal(rawBytes);
			
			//rawBytes.writeBytes(data.);
			
			var fileReference:FileReference = new FileReference();
			fileReference["save"](rawBytes, defaultFileName);
		}
		
		public var file:FileReference;
		public function open():void
		{
			file = new FileReference();
			//typeFilter = [new FileFilter("Images (*.jpg, *.jpeg, *.gif, *.png)", "*.jpg;*.jpeg;*.gif;*.png")];
			
			var typeFilter:Array = [new FileFilter("Area Data (*.ara)", "*.ara")];
			file.addEventListener(Event.SELECT, openHandler);
			file.browse(typeFilter);
		}
		
		private function openHandler(event:Event):void 
	    {
	        file = FileReference(event.target);
	        trace(" ^ openHandler : " + file.name);
	        file.addEventListener(Event.COMPLETE, onLoadComplete);
	        file["load"]();
	    }
	    
	    private function onLoadComplete(event:Event):void
	    {   
	        trace(" ^ onLoadComplete : " + file["data"]);
	        dispatchEvent(new SDEvent(SDEvent.COMPLETE, file["data"]));
	    }
	}	
}