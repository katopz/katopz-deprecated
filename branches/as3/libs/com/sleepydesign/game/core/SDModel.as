package com.sleepydesign.game.core
{
    import com.sleepydesign.core.SDObject3D;
   
	public class SDModel extends SDObject3D
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
	}
}