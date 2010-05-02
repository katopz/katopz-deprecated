package com.cutecoma.game.core
{
    import com.sleepydesign.core.IObject3D;
   
	public class SDModel implements IObject3D
	{
		public var type:String;
		public var instance:*;//IAnimatable
		
		public function SDModel()
		{
			
		}
		
		public function play(action:String):void
		{
			try{
				instance.play(action)
			}catch(e:*){};
		}
		
		public function toString(): String
		{
			return String(this);
		}
	}
}