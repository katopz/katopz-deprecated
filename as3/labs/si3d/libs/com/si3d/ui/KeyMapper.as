package com.si3d.ui
{
	import __AS3__.vec.Vector;

	import com.si3d.*;

	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.geom.*;

	public class KeyMapper
	{
		public var flag:int=0;
		private var _mask:Vector.<int>=new Vector.<int>(256, true);

		function KeyMapper(stage:Stage):void
		{
			stage.addEventListener("keyDown", function(e:KeyboardEvent):void
				{
					flag|=_mask[e.keyCode];
				});
			stage.addEventListener("keyUp", function(e:KeyboardEvent):void
				{
					flag&=~(_mask[e.keyCode]);
				});
		}

		public function map(bit:int, ... args):KeyMapper
		{
			for (var i:int=0; i < args.length; ++i)
			{
				_mask[args[i]]=1 << bit;
			}
			return this;
		}
	}
}