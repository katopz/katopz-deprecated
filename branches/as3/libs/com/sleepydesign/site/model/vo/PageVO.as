package com.sleepydesign.site.model.vo
{
	import flash.display.DisplayObject;
	
	public class PageVO extends ContentVO
	{
		// TODO : TypeArray : ContentVO
		//protected var _contents:SDGroup;
		public var path:String;
		
		public function PageVO( id:String=null, source:DisplayObject=null, xml:XML=null, path:String=null)
		{
			super(id, source, xml);
			this.path = path;
			//_contents = contents?contents:new SDGroup();
		}
		/*
		public function get contents():SDGroup
		{
			return _contents;
		}
		
		public function set contents(value:SDGroup):void
		{
			contents = value;
		}
		*/
	}
}