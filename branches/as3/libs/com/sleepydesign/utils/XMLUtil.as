package com.sleepydesign.utils 
{
	import flash.xml.XMLDocument;
	
	public class XMLUtil 
	{
		public static function getXMLById(xml:XML, id:String):XML
		{
			return new XML(String(new XMLDocument(xml).idMap[id]));
		}
		
		/*
		public static function isNull(value:*):Boolean
		{
			//if(value is XML)value = XML(value).toXMLString();
			return !StringUtil.validateString(String(value));
		}
		/*
		public static function getPathById(xml:XML, id:String):XML
		{
			if(!xml.childs)return null;
			var index:int = xml.childs.length;
			var foundNode:SDTreeNode;
			while(!foundNode && --index>=0)
			{
				if(xml.childs[index].id==id)
				{
					foundNode = xml.childs[index];
					trace( " ! Found : "+foundNode.id);
					return foundNode;
				}else {
					foundNode = getNodeById(xml.childs[index], id);
				}
			}
	        return foundNode;
		}
		*/
	}
}
