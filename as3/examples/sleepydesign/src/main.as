package
{
	import com.sleepydesign.components.Tree;
	import com.sleepydesign.display.SDSprite;
	import com.sleepydesign.events.TreeEvent;
	import com.sleepydesign.net.LoaderUtil;
	import com.sleepydesign.site.SWFAddress;
	import com.sleepydesign.site.SWFAddressEvent;
	import com.sleepydesign.site.SiteTool;
	import com.sleepydesign.system.SystemUtil;
	import com.sleepydesign.utils.StringUtil;
	import com.sleepydesign.utils.XMLUtil;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Stage;
	import flash.events.Event;

	public class main extends SDSprite
	{
		private var _xml:XML;
		private var _content:DisplayObject;
		private var _loader:Loader;
		
		public function main()
		{
			// get external config
			LoaderUtil.loadXML("config.xml", function(event:Event):void
			{
				if (event.type != "complete")
					return;
				createSite(_xml = event.target.data);
			});
		}

		private function createSite(xml:XML):void
		{
			var _siteTool:SiteTool = new SiteTool(this, xml);
			
			SWFAddress.addEventListener(SWFAddressEvent.CHANGE, handleSWFAddress);
			
			var _tree:Tree = new Tree(xml, true, true, true);
			addChild(_tree);
			_tree.x = 100;
			_tree.y = 100;
			
			_tree.addEventListener(TreeEvent.CHANGE_NODE_FOCUS, onTreeChangeFocus);
		}

		private function onTreeChangeFocus(event:TreeEvent):void
		{
			var _path:String = event.node.path.substring(1);
			SWFAddress.setValue(_path);
		}
		
		private function handleSWFAddress(e:SWFAddressEvent):void
		{
			var title:String = 'Website';
			for (var i:int = 0; i < e.pathNames.length; i++)
				title += ' / ' + e.pathNames[i].substr(0, 1).toUpperCase() + e.pathNames[i].substr(1);
			
			SWFAddress.setTitle(title);
			
			setFocus(e.pathNames[0]);
		}
		
		private function setFocus(path:String):void
		{
			var _pageXML:XML = XMLUtil.getXMLById(_xml, path);
			
			if(!StringUtil.isNull(_pageXML.@src))
				_loader = LoaderUtil.loadAsset(_pageXML.@src, onContentLoad);
		}
		
		private function onContentLoad(event:Event):void
		{
			if(event.type=="complete")
			{
				if(_content)
				{
					removeChild(_content);
					_content = null;
					_loader = null;
					SystemUtil.gc();
				}
				
				_content = event.target.content;
				addChild(_content);
			}
		}
	}
}