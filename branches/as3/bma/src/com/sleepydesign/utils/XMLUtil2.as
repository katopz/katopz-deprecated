/**
* ...
* @author katopz@sleepydesign.com
* @version 0.1
*/

package com.sleepydesign.utils {
	
	import flash.xml.XMLDocument;
	import flash.xml.XMLNode;
	
	public class XMLUtil2 {
		
		public static function getNodeById(iXML:XML, iId:String):XML
		{
			
			var xmlDoc = new XMLDocument(iXML);
			var xml = new XML(String(xmlDoc.idMap[iId]));
			return xml;

		}
		
	}
	
}
