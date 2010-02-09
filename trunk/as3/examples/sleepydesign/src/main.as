package
{
	import com.sleepydesign.components.Tree;
	import com.sleepydesign.display.SDSprite;
	import com.sleepydesign.events.SWFAddressEvent;
	import com.sleepydesign.events.TreeEvent;
	import com.sleepydesign.net.LoaderUtil;
	import com.sleepydesign.site.SWFAddress;
	import com.sleepydesign.site.SiteTool;
	import com.sleepydesign.utils.StringUtil;
	
	import flash.display.DisplayObject;
	import flash.events.Event;

	[SWF(backgroundColor="0xFFFFFF", frameRate="30", width="800", height="600")]
	public class main extends SDSprite
	{
		private var _xml:XML;
		private var _content:DisplayObject;
		private var _siteTool:SiteTool
		private var _tree:Tree;
		
		public function main()
		{
			// get external config
			LoaderUtil.loadXML("site.xml", onXMLLoad)
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
			
			_tree = new Tree(xml, true, true, true);
			addChild(_tree);
			_tree.x = 10;
			_tree.y = 10;
			
			_tree.addEventListener(TreeEvent.CHANGE_NODE_FOCUS, onTreeChangeFocus);
		}

		private function onTreeChangeFocus(event:TreeEvent):void
		{
			var _path:String = String("/"+event.node.path).split("/$").join("/");
			if(SWFAddress.getPath()!=_path)
				SWFAddress.setValue(_path);
		}
		
		private function onSWFAddressInit(e:SWFAddressEvent):void
		{
			_siteTool = new SiteTool(this, _xml);
		}
		
		private function handleSWFAddress(e:SWFAddressEvent):void
		{
			var title:String = 'Website';
			for (var i:int = 0; i < e.pathNames.length; i++)
				title += ' / ' + e.pathNames[i].substr(0, 1).toUpperCase() + e.pathNames[i].substr(1);
			
			SWFAddress.setTitle(title);
			
			if(e.pathNames[0])
			{
				// focus from external
				setFocus(e.path);
			}else if(!StringUtil.isNull(_xml.@focus)){
				// focus from xml
				SWFAddress.setValue(String(_xml.@focus));
			}
		}
		
		private function setFocus(path:String):void
		{
			// tree
			_tree.setFocusByPath(path.split("/").join("/$"));
			
			// site
			_siteTool.setFocusByPath(path);
		}
	}
}