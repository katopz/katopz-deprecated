package com.sleepydesign.templates
{
	import com.sleepydesign.display.SDSprite;
	import com.sleepydesign.net.LoaderUtil;
	import com.sleepydesign.skins.Preloader;
	import com.sleepydesign.system.SystemUtil;
	
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;

	public class ApplicationTemplate extends SDSprite
	{
		protected var _title:String = "";
		protected var _configURI:String;

		protected var _xml:XML;

		protected var _systemLayer:SDSprite;
		protected var _contentLayer:SDSprite;

		// app
		protected var _stageWidth:Number = stage ? stage.stageWidth : NaN;
		protected var _stageHeight:Number = stage ? stage.stageHeight : NaN;

		protected var _screenRectangle:Rectangle;

		public function ApplicationTemplate()
		{
			super();
			
			_configURI = "config.xml";
			
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
			LoaderUtil.loaderClip = new Preloader(_systemLayer);
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
			_xml = new XML(event.target.data);

			onInitXML();
		}

		protected function onInitXML():void
		{
			// override me
		}

		// TODO:destroy
	}
}