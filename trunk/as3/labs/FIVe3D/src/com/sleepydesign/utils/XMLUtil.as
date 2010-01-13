package com.sleepydesign.utils
{
	import flash.xml.XMLDocument;

	public class XMLUtil
	{
		public static function getXMLById(xml:XML, id:String):XML
		{
			return new XML(String(new XMLDocument(xml).idMap[id]));
		}
	}
}