package com.codeazur.as3swf.tags
{
	import com.codeazur.as3swf.SWFData;
	import com.codeazur.as3swf.data.SWFSymbol;
	
	public class TagSymbolClass extends Tag implements ITag
	{
		public static const TYPE:uint = 76;
		
		protected var _symbols:Vector.<SWFSymbol>;
		
		public function TagSymbolClass() {
			_symbols = new Vector.<SWFSymbol>();
		}
		
		public function get symbols():Vector.<SWFSymbol> { return _symbols; }
		
		public function parse(data:SWFData, length:uint, version:uint):void {
			var numSymbols:uint = data.readUI16();
			for (var i:uint = 0; i < numSymbols; i++) {
				_symbols.push(data.readSYMBOL());
			}
		}

		override public function get type():uint { return TYPE; }
		override public function get name():String { return "SymbolClass"; }
		override public function get version():uint { return 9; } // educated guess (not specified in SWF10 spec)
		
		public function toString():String {
			return String(_symbols);
		}
	}
}
