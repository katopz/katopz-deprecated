package com.cutecoma.playground.viewer
{
	import away3dlite.animators.MovieMeshContainer3D;
	import away3dlite.core.utils.Debug;
	import away3dlite.events.Loader3DEvent;
	import away3dlite.loaders.Loader3D;
	import away3dlite.loaders.MDJ;
	import away3dlite.primitives.BoundingBox;
	import away3dlite.templates.BasicTemplate;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	
	/**
	 * 
	 * TODO : make it more friendly.
	 *  
	 * @author katopz
	 * 
	 */
	public class CharacterViewer extends BasicTemplate
	{
		protected var _model:MovieMeshContainer3D;
		private var _boundingBox:BoundingBox;
		
		override protected function onInit():void
		{
			// better view angle
			camera.y = -500;
			camera.lookAt(new Vector3D());
			
			// debug
			Debug.active = true;
			
			// parser
			var _mdj:MDJ = new MDJ();
			_mdj.meshPath = "../../";
			_mdj.texturePath = "../../";
			
			// load it
			var _loader3D:Loader3D = new Loader3D();
			_loader3D.addEventListener(Loader3DEvent.LOAD_SUCCESS, onSuccess);
			_loader3D.loadGeometry("user.mdj", _mdj);
			scene.addChild(_loader3D);
			
			stage.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		private function onSuccess(event:Loader3DEvent):void
		{
			_model = event.target.handle as MovieMeshContainer3D;
			_model.play("talk");
			
			view.addChild(_model.canvas = new Sprite);
			_model.canvas.alpha = .1;
			
			scene.addChild(_boundingBox = new BoundingBox(_model, 1));
		}
		
		private function onClick(event:Event):void
		{
			if (!_model)
				return;
			
			if (_model.currentLabel != "talk")
				_model.play("talk");
			else
				_model.play("walk");
		}
		
		override protected function onPreRender():void
		{
			scene.rotationX++;
			if(_model)
				_model.rotationY+=5;
		}
	}
}