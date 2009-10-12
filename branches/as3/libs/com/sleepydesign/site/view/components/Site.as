package com.sleepydesign.site.view.components
{
	import com.sleepydesign.site.ApplicationFacade;
	import com.sleepydesign.site.model.vo.PageVO;
	
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
			
			// ___________________________ background layer ___________________________
			
			background = new Page("background");
			this.addChild(background);
			
			// ___________________________ body layer ___________________________
			
			// body
			content = new Page("site-body");
			this.addChild(content);
			
			// ___________________________ foreground layer ___________________________
			
			foreground = new Page("foreground");
			this.addChild(foreground);
			
			// navigation
			navigation = new Navigation("navigation");
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
			
			// config pass by SiteDataProxy
			
			if(config.foreground)
				foreground.update(config.foreground);
			
			if(config.background)
				background.update(config.background);
		}
		
		// ______________________________ Update ____________________________
		
		override public function update(data:Object=null):void
		{
			if(!data)return;
			
			//Navigation.queuePaths = ApplicationFacade.focusPath.split("/");
			Navigation.queuePaths = data.path.split("/");
			trace(" ! Queue\t: "+Navigation.queuePaths);
			
			//super.update(data);
			Page(content).update(PageVO(data));
		}
		
		// ______________________________ Element ____________________________
		
		public static function getPathById(id:String):String
		{
			//XMLUtil.getPathById(getInstance().config.xml, id);
			return getInstance().navigation.getPathById(id);
		}
	}
}