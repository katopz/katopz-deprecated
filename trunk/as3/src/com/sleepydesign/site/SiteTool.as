package com.sleepydesign.site
{
	import com.sleepydesign.core.IDestroyable;
	import com.sleepydesign.events.RemovableEventDispatcher;
	import com.sleepydesign.system.DebugUtil;
	import com.sleepydesign.utils.StringUtil;
	
	import flash.display.DisplayObjectContainer;

	public class SiteTool extends RemovableEventDispatcher implements IDestroyable
	{
		private var _container:DisplayObjectContainer;
		private var _xml:XML;
		private var _eventHandler:Function;

		private var _loader:Object /*URLLoader, Loader*/;
		private var _data:Object /*SiteData*/;

		// ____________________________________________ Create ____________________________________________

		public function SiteTool(container:DisplayObjectContainer, xml:XML = null, eventHandler:Function = null)
		{
			_container = container;
			_xml = xml;
			_eventHandler = eventHandler || trace;

			DebugUtil.trace("\n / [Site] ------------------------------- ");

			var _xmlList:XMLList = _xml.children();
			var _xmlList_length:int = _xmlList.length();

			for (var i:uint = 0; i < _xmlList_length; i++)
			{
				var _itemXML:XML = _xmlList[i];
				var _name:String = String(_itemXML.name()).toLowerCase();
				var _containerID:String = StringUtil.getDefaultIfNull(_itemXML.@src, String(_itemXML.@id));

				DebugUtil.trace("   + " + _name + "\t: " + _containerID);

				switch (_name)
				{
					case "page":
						
						break;
				}
			}

			DebugUtil.trace(" ------------------------------- [Site] /\n");
		}

		// ____________________________________________ Destroy ____________________________________________

		override public function destroy():void
		{
			super.destroy();

			_container = null;
			_loader = null;
			_data = null;
			_eventHandler = null;
			_xml = null;
		}
	}
}