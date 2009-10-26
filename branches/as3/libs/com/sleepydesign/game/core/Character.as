package com.sleepydesign.game.core
{
	import com.sleepydesign.events.SDEvent;
	import com.sleepydesign.game.data.CharacterData;
	import com.sleepydesign.game.events.PlayerEvent;
	
	import org.papervision3d.objects.DisplayObject3D;
	
	public class Character extends AbstractCharacter
	{
		private var data		:CharacterData;
		
		public var instance		:DisplayObject3D;
		//public var model		:DisplayObject3D;
		
		//public var type			:String;
		//public var height		:Number=0;	
		
		public function Character(id:String=null)
		{
			super();
			instance = new DisplayObject3D();
		}
		
		// ______________________________ Create ______________________________
		
		override public function create(config:Object=null):void
		{
			// try get character.model from object pool
			model = Characters.getInstance().getModel(config.src);
			instance.addChild(model.instance);
			model.instance.addEventListener(SDEvent.COMPLETE, onModelComplete);
			model.instance.addEventListener(PlayerEvent.ANIMATIONS_COMPLETE, onAnimationComplete);
		}
		
		private function onModelComplete(event:SDEvent):void
		{
			//instance.height = event.target.boundingBox().max.y;
			dispatchEvent(new SDEvent(SDEvent.COMPLETE));
		}
		
		private function onAnimationComplete(event:*):void
		{
			trace("onAnimationComplete#2");
			dispatchEvent(event.clone());
		}
	}
}