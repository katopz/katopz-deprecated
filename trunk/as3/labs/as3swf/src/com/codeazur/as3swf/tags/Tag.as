package com.codeazur.as3swf.tags
{
	public class Tag
	{
		protected var _type:uint;
		
		public function Tag() {}
		
		public function get type():uint { return _type; }
		public function get name():String { return "????"; }
		public function get version():uint { return 0; }
		public function get level():uint { return 1; }
		
		protected function toStringMain():String {
			return type + ":" + name;
		}
	}
}
