package com.cutecoma.game.core
{
	import com.sleepydesign.core.IObject3D;
	
	public class Clip3D implements IObject3D
	{
		public var instance:*;
		
		public function Clip3D()
		{
			//
		}
		
		public function toString(): String
		{
			return String(this);
		}
		
		/*
		public function play(clip:String):void
		{
			switch (type)
			{
				case "md2":
					
					MD2(instance).play();
					
					break;
				case "dae":
					
					DAE(instance).play();
					
					break;
			}
		}
		
		public function stop():void
		{
			
		}
		*/
	}
}