package com.sleepydesign.site.view.components
{
	import com.sleepydesign.site.model.vo.PageVO;
	
	import flash.display.Sprite;
	
	/* ---------------------------------------------------------------
	
	[Site] act like a root node
	
		+ [Navigation]
		
		+ [ForeGround]
		
		+ [Body]
		
		+ [BackGround]
	
	--------------------------------------------------------------- */
	
	/**
	 * TODO : extends group
	 */
	public class Site extends Content
	{
		public var navigation:Navigation;
		
		public var foreground:Page;
		
		public var background:Page;
		
		public var data:*;
		
		// Site Singleton
		private static var instance : Site;
        public static function getInstance() : Site 
        {
            if ( instance == null ) instance = new Site();
            return instance as Site;
        }
        
        public function get config():Object
        {
        	return _config;
        }
        
        // TODO : site vo
		public function Site()
		{
			instance = this;
			super("site");
			
			//data = new Sprite();
			
			// ___________________________ background layer ___________________________
			
			background = new Page("background");
			background.mouseEnabled = false;
			this.addChild(background);
			
			// ___________________________ body layer ___________________________
			
			// body
			content = new Page("site-body");
			this.addChild(content);
			
			// ___________________________ foreground layer ___________________________
			
			foreground = new Page("foreground");
			foreground.mouseEnabled = false;
			this.addChild(foreground);
			
			// navigation
			navigation = Navigation.getInstance();
			this.addChild(navigation);
		}
		
		override public function parse(raw:Object=null):void
		{
			create(raw);
		}
		
		// ______________________________ Create ______________________________
		
		override public function create(config:Object=null):void
		{
			super.create(config);
			
			if(config.foreground)
				foreground.update(config.foreground);
			
			if(config.background)
				background.update(config.background);
		}
		
		// ______________________________ Update ____________________________
		
		override public function update(data:Object=null):void
		{
			if(!data)return;
			
			Navigation.queuePaths = data.path.split("/");
			
			Page(content).update(PageVO(data));
		}
		
		// ______________________________ Element ____________________________
		
		public static function getPathById(id:String):String
		{
			return getInstance().navigation.getPathById(id);
		}
	}
}