package com.cutecoma.game.core
{
	import away3dlite.animators.MovieMeshContainer3D;
	import away3dlite.core.base.Object3D;
	import away3dlite.events.Loader3DEvent;
	
	import com.cutecoma.game.data.CharacterData;
	import com.sleepydesign.events.RemovableEventDispatcher;
	
	import org.osflash.signals.Signal;
	
	public class Character extends RemovableEventDispatcher
	{
		private var data		:CharacterData;
		private var _model		:MovieMeshContainer3D;
		public function get model():MovieMeshContainer3D
		{
			return _model;
		}
		
		// TODO : get height from model boundingbox
		public var height:Number = 0;

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
			if(_model)
				_model.destroy();
			_model = event.target.handle as MovieMeshContainer3D;
			completeSignal.dispatch(_model);
		}
	}
}