package com.sleepydesign.core
{
	import com.sleepydesign.utils.StringUtil;
	
	/*
		<link id="linkID" src="somewhere.html" target="_blank"/>
	*/
	public class SDLink
	{
		public var id:String;
		public var source:*;
		public var target:String = "_blank";
		public var xml:XML;
		
		// link can be xml or string
		public function SDLink(link:*, target:String="_blank")
		{
			if(link is XML)
			{
				this.id = xml.@id;
				this.source = xml.@src;
				this.target = StringUtil.isNull(xml.@target)?target:xml.@target;
				this.xml = xml;
			}
			else if(link is String)
			{
				this.id = String(link);
				this.source = link;
				this.target = target
			}
			else
			{
				//throw error
			}
		}
	}
}