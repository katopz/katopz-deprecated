﻿package com.codeazur.as3swf.data
{
	import com.codeazur.as3swf.SWFData;
	
	public class SWFSymbol
	{
		public var tagId:uint;
		public var name:String;
		
		public function SWFSymbol(data:SWFData = null) {
			if (data != null) {
				parse(data);
			}
		}

		public function parse(data:SWFData):void {
			tagId = data.readUI16();
			name = data.readString();
		}
		
		public function toString():String {
			return name;
		}
	}
}
