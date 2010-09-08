package com.sleepydesign.templates
{
	import com.sleepydesign.components.SDTree;
	import com.sleepydesign.display.SDSprite;
	import com.sleepydesign.events.TreeEvent;
	import com.sleepydesign.net.LoaderUtil;
	import com.sleepydesign.site.NavigationTool;
	import com.sleepydesign.site.SiteTool;
	import com.sleepydesign.skins.Preloader;
	import com.sleepydesign.system.DebugUtil;
	import com.sleepydesign.system.SystemUtil;
	
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	public class ApplicationTemplate extends SDSprite
	{
		protected var _title:String = "";
		protected var _configURI:String;

		protected var _xml:XML;
		
		protected static var _globalXML:XML;
		public static function getXML():XML
		{
			return _globalXML;
		}

		protected var _systemLayer:SDSprite;

		public function get systemLayer():SDSprite
		{
			return _systemLayer;
		}

		protected var _contentLayer:SDSprite;

		// app
		protected var _stageWidth:Number = stage ? stage.stageWidth : NaN;
		protected var _stageHeight:Number = stage ? stage.stageHeight : NaN;

		protected var _screenRectangle:Rectangle;

		public function get screenRectangle():Rectangle
		{
			return _screenRectangle;
		}
		
		public static var _instance:ApplicationTemplate;
		
		public static function getInstance():ApplicationTemplate
		{
			return _instance;
		}
		
		//nav
		protected var _site:SiteTool;
		protected var _tree:SDTree;
		protected var _isSiteMap:Boolean;
		
		public var path:String;

		public function ApplicationTemplate()
		{
			if(!_instance)
				_instance = this;
			
			super();
			
			_configURI = "app.xml";
			
			if (!_screenRectangle)
				_screenRectangle = new Rectangle(0, 0, _stageWidth, _stageHeight);
			else
				scrollRect = new Rectangle(0, 0, _screenRectangle.width, _screenRectangle.height);
			
			addEventListener(Event.ADDED_TO_STAGE, onStage);
		}

		protected function onStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onStage);
			
			initStage();
			initLayer();
			initLoader();
			initSystem();
			
			onInit();
		}

		protected function initLayer():void
		{
			addChild(_contentLayer = new SDSprite).name = "$content";
			addChild(_systemLayer = new SDSprite).name = "$system";
		}

		protected function initStage():void
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
		}

		protected function initLoader():void
		{
			// skin loader
			LoaderUtil.loaderClip = new Preloader(_systemLayer, _screenRectangle);
		}

		protected function initSystem():void
		{
			// get external config
			LoaderUtil.loadXML(SystemUtil.isBrowser() ? _configURI + "?cache=" + new Date().valueOf() : _configURI, onXMLLoad);
		}

		protected function onXMLLoad(event:Event):void
		{
			if (event.type != "complete")
				return;
			_globalXML = _xml = new XML(event.target.data);

			onInitXML();
		}

		protected function onInitXML():void
		{
			createSiteMap();
			initNavigation();
			setFocus(path);
		}
		
		protected function onInit():void
		{
			// override me
		}
		
		protected function initNavigation():void
		{
			DebugUtil.trace(" ! xml.@focus : " + _xml.@focus);
			
			_site = new SiteTool(_contentLayer, _xml);
			NavigationTool.signal.add(setFocus);
			
			NavigationTool.setFocusByPath(path = String(_xml.@focus));
		}
		
		protected function createSiteMap():void
		{
			_tree = new SDTree(_xml, true, true, true);
			_systemLayer.addChild(_tree);
			_tree.x = 10;
			_tree.y = 10;
			_tree.visible = _isSiteMap;
			
			_tree.addEventListener(TreeEvent.CHANGE_NODE_FOCUS, onTreeChangeFocus);
		}
		
		protected function onTreeChangeFocus(event:TreeEvent):void
		{
			var _path:String = String("/" + event.node.path).split("/$").join("/");
			if (path != _path)
			{
				path = _path;
				setFocus(_path);
			}
		}
		
		protected function setFocus(path:String):void
		{
			if(path.indexOf("/")!=0)
				path = "/"+path;
			
			// tree
			if (_tree)
				_tree.setFocusByPath(path.split("/").join("/$"));
			
			// site
			_site.setFocusByPath(path);
		}

		// TODO:destroy
	}
}