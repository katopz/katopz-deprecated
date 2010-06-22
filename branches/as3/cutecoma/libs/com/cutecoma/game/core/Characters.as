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
	import com.sleepydesign.system.DebugUtil;
	
	import org.osflash.signals.Signal;
	
	/**
	 * Act like models pooling.
	 * 
	 * @author katopz
	 * 
	 */
	public class Characters extends RemovableEventDispatcher
	{
		private var lists:SDGroup;
		
		// TODO : read from config <chars path="../../">
		public var serverPath:String = "../../";
		
		//public var completeSignal:Signal = new Signal(MovieMeshContainer3D);
		
		private static var instance:Characters;
		public static function getInstance():Characters
		{
			if (instance == null)
				instance=new Characters();
			return instance as Characters;
		}
		
		public function Characters()
		{
			instance = this;
			super();
		}

		public function addCharacter(data:CharacterData):void
		{
			if(!lists)lists = new SDGroup();
			lists.addItem(data, data.id);
		}
		
		public function getModel(src:String, eventHandler:Function):void
		{
			var model:MovieMeshContainer3D = new MovieMeshContainer3D();
			
			// pooling here?
			//var data:CharacterData = lists.getItemByID(src);
			//data.model = model;
			// if cached
			//eventHandler(model);
			
			var _mdj:MDJ = new MDJ();
			_mdj.path = serverPath;
				
			//data.fps
			//_mdj.scaling = data.scale;
			
			var _loader3D:Loader3D = new Loader3D();
			_loader3D.addEventListener(Loader3DEvent.LOAD_SUCCESS, eventHandler);
			_loader3D.addEventListener(Loader3DEvent.LOAD_SUCCESS, onModelComplete);
			_loader3D.loadGeometry(src, _mdj);
			
			DebugUtil.trace(src);
			
			//model.instance = _loader3D;
			
			//model.type = data.type;
		}
		
		private function onModelComplete(event:Loader3DEvent):void
		{
			trace("onModelComplete");
		}
		/*
		private function onModelComplete(event:Loader3DEvent):void
		{
			trace("onModelComplete");
			//dispatchEvent(new SDEvent(SDEvent.COMPLETE));
			var _model:MovieMeshContainer3D = event.target.handle as MovieMeshContainer3D;
			completeSignal.dispatch(_model);
		}
		*/
	}
}