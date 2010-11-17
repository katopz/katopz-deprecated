package com.sleepydesign.site
{
	import com.sleepydesign.utils.StringUtil;

	import flash.display.Sprite;
	import flash.utils.Dictionary;

	public class PageData
	{
		public var xml:XML;
		public var name:String;
		public var id:String;
		//public var pageID:String;
		public var src:String;

		public var layer:String;

		//public var depth:int;

		public var vars:Dictionary;

		public function PageData(xml:XML = null)
		{
			if (!xml || xml.length() <= 0)
				return;

			this.xml = xml;
			this.id = String(xml.@id);
			this.name = String(xml.name()).toLowerCase();
			this.src = String(xml.@src);
			this.layer = StringUtil.getDefaultIfNull(xml.@layer, "$layer");
			//this.depth = int(StringUtil.getDefaultIfNull(xml.@depth, "-1"));

			for each (var child:XML in xml.children())
			{
				if (child.name() != "vars")
					continue;

				if (!vars)
					vars = new Dictionary();

				vars[String(child.@id)] = String(child.@value);
			}
		}
	}
}