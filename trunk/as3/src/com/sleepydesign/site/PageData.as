package com.sleepydesign.site
{
	import com.sleepydesign.utils.StringUtil;
	
	public class PageData
	{
		public var xml:XML;
		public var name:String;
		public var id:String;
		//public var pageID:String;
		public var src:String;
		public var layer:String;

		public function PageData(xml:XML = null)
		{
			if(!xml || xml.length()<= 0)
				return;
			
			this.xml = xml;
			this.id = String(xml.@id);
			this.name = String(xml.name()).toLowerCase();
			this.src = String(xml.@src);
			
			this.layer = StringUtil.getDefaultIfNull(xml.@layer, "");
		}
	}
}