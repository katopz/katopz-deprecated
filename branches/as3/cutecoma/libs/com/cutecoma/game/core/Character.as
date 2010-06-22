package com.cutecoma.game.core
{
	import away3dlite.animators.MovieMesh;
	import away3dlite.animators.MovieMeshContainer3D;
	import away3dlite.events.Loader3DEvent;
	import away3dlite.loaders.Loader3D;
	import away3dlite.loaders.MDJ;
	
	import com.cutecoma.game.data.CharacterData;
	import com.cutecoma.game.events.PlayerEvent;
	import com.sleepydesign.core.SDGroup;
	import com.sleepydesign.events.RemovableEventDispatcher;
	
	import org.osflash.signals.Signal;
	
	public class Character extends AbstractCharacter
	{
		private var data		:CharacterData;
		
		//public var instance		:DisplayObject3D;
		//public var model		:DisplayObject3D;
		
		//public var type			:String;
		//public var height		:Number=0;	
		
		public var completeSignal:Signal = new Signal(MovieMeshContainer3D);
		
		public function Character(id:String=null)
		{
			super();
			//instance = new DisplayObject3D();
		}
		
		// ______________________________ Create ______________________________
		
		public function create(config:Object=null):void
		{
			// try get character.model from object pool
			var _characters:Characters = Characters.getInstance();
			_characters.getModel(config.src, onGetModel);
			
			//DEV//
			//instance.addChild(model.instance);
			//model.instance.addEventListener(SDEvent.COMPLETE, onModelComplete);
			//model.instance.addEventListener(PlayerEvent.ANIMATIONS_COMPLETE, onAnimationComplete);
		}
		
		/*
		private function onModelComplete(event:SDEvent):void
		{
			//instance.height = event.target.boundingBox().max.y;
			dispatchEvent(new SDEvent(SDEvent.COMPLETE));
		}
		*/
		
		private function onGetModel(event:Loader3DEvent):void
		{
			//trace("onAnimationComplete#2");
			var _model:MovieMeshContainer3D = event.target.handle as MovieMeshContainer3D;
			completeSignal.dispatch(_model);
		}
	}
}