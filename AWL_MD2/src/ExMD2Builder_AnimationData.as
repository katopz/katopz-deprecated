package
{
	import away3dlite.animators.BonesAnimator;
	import away3dlite.animators.MovieMesh;
	import away3dlite.builders.MD2Builder;
	import away3dlite.core.base.Object3D;
	import away3dlite.core.utils.Debug;
	import away3dlite.events.Loader3DEvent;
	import away3dlite.loaders.Collada;
	import away3dlite.loaders.Loader3D;
	import away3dlite.loaders.data.AnimationData;
	import away3dlite.materials.BitmapFileMaterial;
	import away3dlite.templates.BasicTemplate;
	
	import flash.geom.Vector3D;
	import flash.net.FileReference;
	import flash.utils.*;

	[SWF(backgroundColor="#CCCCCC", frameRate="30", width="800", height="600")]
	/**
	 * Example : MD2Builder with AnimationData
	 * @author katopz
	 */	
	public class ExMD2Builder_AnimationData extends BasicTemplate
	{
		private var _bonesAnimator:BonesAnimator;
		private var _md2Builder:MD2Builder;
		private var _md2MovieMesh:MovieMesh;

		override protected function onInit():void
		{
			// behide the scene
			Debug.active = true;

			// better view angle
			camera.y = -500;
			camera.lookAt(new Vector3D());

			// some collada with animation
			var _collada:Collada = new Collada();
			_collada.scaling = 5;

			// load target model
			var _loader3D:Loader3D = new Loader3D();
			_loader3D.loadGeometry("assets/30_box_smooth_translate.dae", _collada);
			_loader3D.addEventListener(Loader3DEvent.LOAD_SUCCESS, onSuccess);
		}

		private function onSuccess(event:Loader3DEvent):void
		{
			// preview
			var _model:Object3D = event.target.handle;
			scene.addChild(_model);
			_model.x = 100;

			// test animation
			try{
				_bonesAnimator = _model.animationLibrary.getAnimation("default").animation as BonesAnimator;
			}catch (e:*){}

			// build as MD2
			_md2Builder = new MD2Builder();
			_md2Builder.scaling = 5;
			_md2Builder.material = new BitmapFileMaterial("assets/yellow.jpg");

			// add custom frame label
			var _animationDatas:Vector.<AnimationData> = new Vector.<AnimationData>(2, true);
			
			// define left e.g : left000, left001, left002, ...., left032  
			_animationDatas[0] = new AnimationData();
			_animationDatas[0].name = "left";
			_animationDatas[0].start = 0;
			_animationDatas[0].end = 32;
			
			// define right e.g : right000, right001, right002, ...., right032
			_animationDatas[1] = new AnimationData();
			_animationDatas[1].name = "right";
			_animationDatas[1].start = 33;
			_animationDatas[1].end = 65;
			
			// bring it on
			_md2MovieMesh = _md2Builder.convert(_model, _animationDatas)[0];
			scene.addChild(_md2MovieMesh);

			// save as file
			new FileReference().save(_md2Builder.getMD2(), "untitled.md2");
		}

		override protected function onPreRender():void
		{
			// update the collada animation
			if (_bonesAnimator)
				_bonesAnimator.update(getTimer() / 1000);

			// play only right animation
			if (_md2MovieMesh)
				_md2MovieMesh.play("right");

			// show time
			scene.rotationY++;
		}
	}
}