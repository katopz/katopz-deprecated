package com.sleepydesign.templates
{
	import com.sleepydesign.components.SDTree;
	import com.sleepydesign.display.SDSprite;
	import com.sleepydesign.events.SWFAddressEvent;
	import com.sleepydesign.events.TreeEvent;
	import com.sleepydesign.net.LoaderUtil;
	import com.sleepydesign.site.SWFAddress;
	import com.sleepydesign.site.SiteTool;
	import com.sleepydesign.utils.StringUtil;
	
	import flash.events.Event;

	[SWF(backgroundColor="0xFFFFFF", frameRate="30", width="800", height="600")]
	public class WebTemplate extends SDSprite
	{
		protected var _title:String = "";
		protected var _configURI:String = "site.xml";
		
		private var _xml:XML;
		
		private var _systemLayer:SDSprite;
		private var _contentLayer:SDSprite;
		
		private var _siteTool:SiteTool;
		private var _tree:SDTree;

		public function WebTemplate()
		{
			//layer
			addChild(_contentLayer = new SDSprite);
			addChild(_systemLayer = new SDSprite);
			
			addEventListener(Event.ADDED_TO_STAGE, onStage);
		}

		private function onStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onStage);
			init();
		}

		private function init():void
		{
			// get external config
			LoaderUtil.loadXML(_configURI, onXMLLoad);
		}

		private function onXMLLoad(event:Event):void
		{
			if (event.type != "complete")
				return;
			_xml = new XML(event.target.data);
			createSite(_xml);
		}

		private function createSite(xml:XML):void
		{
			SWFAddress.addEventListener(SWFAddressEvent.INIT, onSWFAddressInit);
			SWFAddress.addEventListener(SWFAddressEvent.CHANGE, handleSWFAddress);
		}
		
		private function createSiteMap():void
		{
			_tree = new SDTree(_xml, true, true, true);
			_systemLayer.addChild(_tree);
			_tree.x = 10;
			_tree.y = 10;

			_tree.addEventListener(TreeEvent.CHANGE_NODE_FOCUS, onTreeChangeFocus);
		}

		private function onTreeChangeFocus(event:TreeEvent):void
		{
			var _path:String = String("/" + event.node.path).split("/$").join("/");
			if (SWFAddress.getPath() != _path)
				SWFAddress.setValue(_path);
		}

		private function onSWFAddressInit(e:SWFAddressEvent):void
		{
			_siteTool = new SiteTool(_contentLayer, _xml);
		}

		private function handleSWFAddress(e:SWFAddressEvent):void
		{
			for (var i:int = 0; i < e.pathNames.length; i++)
				_title += ' / ' + e.pathNames[i].substr(0, 1).toUpperCase() + e.pathNames[i].substr(1);

			SWFAddress.setTitle(_title);

			if (e.pathNames[0])
			{
				// focus from external
				setFocus(e.path);
			}
			else if (!StringUtil.isNull(_xml.@focus))
			{
				// focus from xml
				SWFAddress.setValue(String(_xml.@focus));
			}
		}

		private function setFocus(path:String):void
		{
			// tree
			if(_tree)
				_tree.setFocusByPath(path.split("/").join("/$"));

			// site
			_siteTool.setFocusByPath(path);
		}
		
		// TODO:destroy
	}
}