package com.sleepydesign.game.core
{
	import com.sleepydesign.core.SDObject;
	import com.sleepydesign.events.SDEvent;
	import com.sleepydesign.game.data.CharacterData;
	import com.sleepydesign.game.player.AbstractCharacter;
	
	import org.papervision3d.objects.DisplayObject3D;

	public class Model extends DisplayObject3D
	{
		public var type			:String;
		public var height		:Number=0;	
		
		public function Model()
		{
			//
		}
	}
}