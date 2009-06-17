package com.sleepydesign.site.model.vo
{
	import com.sleepydesign.utils.StringUtil;
	
	public class ContentVO
	{
		// Internal use for referrence
		protected var _id:String;
		
		/*
		// For Navigation, Tracking 
		protected var _label:String;
		*/
		
		// Content source : clip, asset, jpg, swf, xml
		protected var _source:*;
		
		// xml for this content
		public var xml:XML;
		
		public var focus:String;
		
		public var destroyable:Boolean = true;
		
		public var autoplay:Boolean = true;
		
		/**
		 * A custom  object for storing Section node data
		 */
		public function ContentVO( id:String=null, source:*=null, xml:XML=null )
		{
			_id = id;
			//_label = label?label:id;
			if(!xml)
			{
				_source = source?source:null;
			}else{
				_source = source?source:xml.@src;
				autoplay = Boolean(StringUtil.isNull(xml.@autoplay)?true:String(xml.@autoplay)=="true");
			}
			this.xml = xml;
			
			focus = (xml && xml.@focus)?xml.@focus:null;
		}
		
		// For application 
		public function get id():String
		{
			return _id;
		}
		/*
		// Navigation label
		public function get label():String
		{
			return _label;
		}
		*/
		// External
		public function get source():*
		{
			return _source;
		}
		/*
		// Elements
		public function get xml():XML
		{
			return _xml;
		}
		/*
		// Sub focus
		public function get focus():String
		{
			return _focus;
		}	
		*/
        public function toString() : String
        {
            var string:String = "[ContentVO] id : "+ _id + ", source : " + _source;
            if(xml)
            {
            	//string += ", xml : \n / [XML] ------------------\n" + xml.toXMLString()+ "\n ------------------ [XML] /";
            	string += ", xml : " + xml.@id;
            }
            return string;
        }
	}
}