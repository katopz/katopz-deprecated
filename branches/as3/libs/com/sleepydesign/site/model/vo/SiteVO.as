package com.sleepydesign.site.model.vo
{
	import com.sleepydesign.core.SDGroup;
	
	public class SiteVO extends PageVO
	{
		protected var _foreground:ContentVO;
		protected var _background:ContentVO;
		
		public function SiteVO(xml:XML, path:String=null,  foreground:ContentVO=null, background:ContentVO=null)
		{
			super("site", null, xml, path);
		}
		
		public function get foreground():ContentVO
		{
			return _foreground;
		}
		
		public function get background():ContentVO
		{
			return _background;
		}
		
		public function set foreground(value:ContentVO):void
		{
			_foreground = value;
		}
		
		public function set background(value:ContentVO):void
		{
			_background = value;
		}
	}
}