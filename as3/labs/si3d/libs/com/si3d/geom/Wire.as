package com.si3d.geom
{
	import __AS3__.vec.Vector;

	import flash.display.*;
	import flash.geom.*;

	public class Wire
	{
		public var index:int, i0:int, i1:int;
		static private var _freeList:Vector.<Wire>=new Vector.<Wire>();

		static public function free(wire:Wire):void
		{
			_freeList.push(wire);
		}

		static public function alloc(index:int, i0:int, i1:int):Wire
		{
			var w:Wire=_freeList.pop() || new Wire();
			w.index=index;
			w.i0=i0;
			w.i1=i1;
			return w;
		}
	}
}