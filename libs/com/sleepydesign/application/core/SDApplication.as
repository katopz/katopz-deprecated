package com.sleepydesign.application.core
{
	import com.sleepydesign.application.data.SDApplicationData;
	import com.sleepydesign.core.SDContainer;
	import com.sleepydesign.core.SDLoader;
	import com.sleepydesign.core.SDSprite;
	import com.sleepydesign.utils.SystemUtil;
	import com.sleepydesign.utils.URLUtil;
	
	import flash.display.Stage;
	import flash.display.StageScaleMode;
	
    /**
	 * SleepyDesign Application : External | System | Group | Container | Element
	 * @author katopz
	 * 
	 * - FlashVars
	 * - External Interface
	 * - Got SystemLayer for alert, freeze, tooltip
	 * 
	 */
	public class SDApplication extends SDContainer
	{
 		public static var flashVars:Object;
		
		public static var system:SDSystem;
		public static var content:SDSprite;
		
		public var configURI:String = "config.xml";
		
		public static var loader:SDLoader;
        public static function getLoader() : SDLoader 
        {
            if ( loader == null ) loader = new SDLoader();
            return loader as SDLoader;
        }
        
		public static var instance : SDApplication;
        public static function getInstance() : SDApplication 
        {
            if ( instance == null ) instance = new SDApplication();
            return instance as SDApplication;
        }
        
        public static var currentStage : Stage;
        
        public static function getStage() : Stage
        {
            return currentStage;
        }
        
        public static function setStage(currentStage:Stage):void 
        {
            SDApplication.currentStage = currentStage;
        }        
        
        public function SDApplication(id:String="application", data:SDApplicationData=null)
		{
			super(id, data);
			
			if(!instance)
			{
				if(stage)
				{
					stage.scaleMode = StageScaleMode.NO_SCALE;
					currentStage = stage;
				}
				
				//scrollRect = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);		
	
				if (loaderInfo && loaderInfo.parameters)
				{
					flashVars = loaderInfo.parameters;
					configURI = flashVars["config"]?flashVars["config"]:configURI;
				}
				
				configURI = URLUtil.killCache(configURI, SystemUtil.isHTTP(this));
				
				instance = this;
				
				if(data && data.instance)
					instance = data.instance;
				
				if(!currentStage && data && data.stage)
					currentStage = data.stage;
				
				//content layer
				content = new SDSprite();
				this.addChild(content);
				
				//system layer
				system = new SDSystem("system", {container:this, stage:currentStage});
				
				//loader layer
				loader = data?new SDLoader(data.loader):new SDLoader();
				
				//system.parse({instance:this});
			}
		}
		
		/*
		public static function getContainerById(id:String):SDContainer
		{
			//return super.getContainerById(id);
			return SDContainer.getContainerById(id);
		}
		*/
	}
}

