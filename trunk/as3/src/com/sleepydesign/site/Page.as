package com.sleepydesign.site
{
	import com.sleepydesign.display.SDSprite;
	import com.sleepydesign.system.DebugUtil;
	import com.sleepydesign.utils.StringUtil;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	public class Page extends SDSprite
	{
		public var content:DisplayObject;

		protected var _xml:XML;
		protected var _container:DisplayObjectContainer;
		protected var _pageLoaders:Array; /*loaderVO*/

		public function Page(container:DisplayObjectContainer = null, xml:XML = null)
		{
			_container = container;
			_xml = xml;
			
			if (_container)
			{
				_container.addChild(this);
				parseXML(_xml);
			}
		}

		public function parseXML(_xml:XML):void
		{
			if(!_xml || _xml.children().length()<= 0)
				return;
				
			var _xmlList:XMLList = _xml.children();
			var _xmlList_length:int = _xmlList.length();
			var _focus:String = String(_xml.@focus);

			DebugUtil.trace("\n / [Page] ------------------------------- ");

			_pageLoaders = [];

			for (var i:int = _xmlList_length - 1; i >= 0; i--)
			{
				var _itemXML:XML = _xmlList[i];
				var _name:String = String(_itemXML.name()).toLowerCase();
				var _id:String = String(_itemXML.@id);
				var _pageID:String = StringUtil.getDefaultIfNull(_itemXML.@layer, "$body");
				var _src:String = String(_itemXML.@src);

				DebugUtil.trace("   + " + _name + "\t: " + _id);
			}

			DebugUtil.trace(" ------------------------------- [Page] /\n");
		}

		// ____________________________________________ Destroy ____________________________________________

		override public function destroy():void
		{
			super.destroy();

			_container = null;
			_xml = null;
		}
	}
}