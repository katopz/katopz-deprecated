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

	public class Characters extends RemovableEventDispatcher
	{
		private var lists:SDGroup;
		
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
		
		public function getModel(id:String=null):MovieMeshContainer3D
		{
			var model:MovieMeshContainer3D = new MovieMeshContainer3D();
			var data:CharacterData = lists.getItemByID(id);
			data.model = model;
			
			var _mdj:MDJ = new MDJ();
			//data.fps
			_mdj.scaling = data.scale;
			
			var _loader3D:Loader3D = new Loader3D();
			_loader3D.addEventListener(Loader3DEvent.LOAD_SUCCESS, onModelComplete);
			_loader3D.loadGeometry(data.source, _mdj);
			
			//model.instance = _loader3D;
			
			//model.type = data.type;
			
			return model;
		}
		
		private function onModelComplete(event:Loader3DEvent):void
		{
			trace("onModelComplete");
			//dispatchEvent(new SDEvent(SDEvent.COMPLETE));
		}
	}
}