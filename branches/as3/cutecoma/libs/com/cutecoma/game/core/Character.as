package com.cutecoma.game.core
{
	import away3dlite.animators.MovieMeshContainer3D;
	import away3dlite.events.Loader3DEvent;
	import away3dlite.loaders.Loader3D;
	import away3dlite.loaders.MDJ;
	
	import com.cutecoma.game.data.CharacterData;
	import com.sleepydesign.events.RemovableEventDispatcher;
	import com.sleepydesign.system.DebugUtil;
	
	import org.osflash.signals.Signal;

	public class Character extends RemovableEventDispatcher
	{
		// TODO : read from config <chars path="../../">
		public var serverPath:String = "../../";
		
		private var data		:CharacterData;
		private var _model		:MovieMeshContainer3D;
		public function get model():MovieMeshContainer3D
		{
			return _model;
		}
		
		// TODO : get height from model boundingbox
		public var height:Number = 0;
		
		public var completeSignal:Signal = new Signal(MovieMeshContainer3D);
		
		public function Character(id:String=null)
		{
			
		}
		
		public function create(config:Object):void
		{
			var _mdj:MDJ = new MDJ();
			_mdj.meshPath = _mdj.texturePath = serverPath;
			
			var _loader3D:Loader3D = new Loader3D();
			_loader3D.addEventListener(Loader3DEvent.LOAD_SUCCESS, onModelComplete);
			_loader3D.loadGeometry(config.src, _mdj);
		}
		private function onModelComplete(event:Loader3DEvent):void
		{
			DebugUtil.trace(" ! Character Complete");
			if(_model)
				_model.destroy();
			_model = event.target.handle as MovieMeshContainer3D;
			
			completeSignal.dispatch(_model);
		}
	}
}