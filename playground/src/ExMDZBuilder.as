package
{
	import away3dlite.animators.BonesAnimator;
	import away3dlite.animators.MovieMesh;
	import away3dlite.builders.MDZBuilder;
	import away3dlite.core.base.Object3D;
	import away3dlite.core.utils.Debug;
	import away3dlite.events.Loader3DEvent;
	import away3dlite.loaders.Collada;
	import away3dlite.loaders.Loader3D;
	import away3dlite.loaders.data.AnimationData;
	import away3dlite.templates.BasicTemplate;
	
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	import flash.net.FileReference;
	import flash.utils.*;

	[SWF(backgroundColor="#CCCCCC", frameRate="30", width="800", height="600")]
	/**
	 * Example : MDZ build from DAE and save as MDZ.
	 * @author katopz
	 */	
	public class ExMDZBuilder extends BasicTemplate
	{
		private var _bonesAnimator:BonesAnimator;
		private var _mdzBuilder:MDZBuilder;
		private var _meshes:Vector.<MovieMesh>;
		
		private var _id:String = "4";
		private var _sex:String = "man";

		override protected function onInit():void
		{
			title = "Click to save |";
			
			// better view angle
			camera.y = -500;
			camera.lookAt(new Vector3D());

			// some collada with animation
			var _collada:Collada = new Collada();
			
			//man
			//_collada.scaling = 1/0.394;
			//woman
			if(_sex=="woman")
			{
				_collada.scaling = 1/2.54;
				//_collada.scaling = 1/2.146;
				//_collada.scaling = 1/2.7;
			}
			
			_collada.bothsides = false;

			// load target model
			var _loader3D:Loader3D = new Loader3D();
			_loader3D.loadGeometry("chars/"+_sex+"/model_"+_id+".dae", _collada);
			_loader3D.addEventListener(Loader3DEvent.LOAD_SUCCESS, onSuccess);
		}

		private function onSuccess(event:Loader3DEvent):void
		{
			Debug.active = true;
			
			// preview
			var _model:Object3D = event.target.handle;
			scene.addChild(_model);
			_model.x = 100;

			// test animation
			try{
				_bonesAnimator = _model.animationLibrary.getAnimation("default").animation as BonesAnimator;
			}catch (e:*){}

			// build as MD2
			_mdzBuilder = new MDZBuilder();
			
			// add custom frame label
			var _animationDatas:Vector.<AnimationData> = new Vector.<AnimationData>(2, true);
			
			// define talk
			_animationDatas[0] = new AnimationData();
			_animationDatas[0].name = "talk";
			_animationDatas[0].start = 10;
			_animationDatas[0].end = 60;
			
			// define walk
			_animationDatas[1] = new AnimationData();
			_animationDatas[1].name = "walk";
			_animationDatas[1].start = 65;
			_animationDatas[1].end = 89;
			
			//woman
			if(_sex=="woman")
			{
				_animationDatas[0].end = 59;
				_animationDatas[1].start = 60;
			}

			// convert to meshes
			_meshes = _mdzBuilder.convert(_model, _animationDatas, 24);

			// bring it on one by one
			for each (var _mesh:MovieMesh in _meshes)
			{
				// add to scene
				scene.addChild(_mesh);
				
				// and play it
				_mesh.play("talk");
			}
			
			// click to save
			stage.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		private function onClick(event:MouseEvent):void
		{
			// save all as .mdz file
			new FileReference().save(_mdzBuilder.getMDZ(_meshes).byteArray, "model_" +_id + ".mdz");
		}

		override protected function onPreRender():void
		{
			// update the collada animation
			//if (_bonesAnimator)
			//	_bonesAnimator.update(getTimer() / 1000);

			// show time
			scene.rotationY++;
		}
	}
}