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
	import away3dlite.materials.BitmapFileMaterial;
	import away3dlite.templates.BasicTemplate;
	
	import flash.geom.Vector3D;
	import flash.net.FileReference;
	import flash.utils.*;

	[SWF(backgroundColor="#CCCCCC", frameRate="30", width="800", height="600")]
	public class ExMultiMD2AnimationBuilder extends BasicTemplate
	{
		private var _skinAnimation:BonesAnimator;
		private var _md2Builder:MD2Builder;
		private var _meshes:Vector.<MovieMesh>

		override protected function onInit():void
		{
			// behide the scene
			Debug.active = true;

			// better view angle
			camera.y = -500;
			camera.lookAt(new Vector3D());

			// some collada with animation
			var collada:Collada = new Collada();
			collada.scaling = 25;

			// load target model
			var loader3D:Loader3D = new Loader3D();
			loader3D.loadGeometry("nemuvine/nemuvine.dae", collada);
			loader3D.addEventListener(Loader3DEvent.LOAD_SUCCESS, onSuccess);
		}

		private function onSuccess(event:Loader3DEvent):void
		{
			// preview
			var model:Object3D = event.target.handle;
			scene.addChild(model);
			model.x = 100;

			// test animation
			_skinAnimation = model.animationLibrary.getAnimation("default").animation as BonesAnimator;

			// build as MD2
			_md2Builder = new MD2Builder();
			_md2Builder.scaling = 1;
			_md2Builder.material = new BitmapFileMaterial("assets/yellow.jpg");
			
			// bring it on
			var _meshes:Vector.<MovieMesh> = _md2Builder.convert(model);
			for each(var _mesh:MovieMesh in _meshes)
				scene.addChild(_mesh);

			// save as file
			//new FileReference().save(_md2Builder.getMD2(), "untitled.md2");
		}

		override protected function onPreRender():void
		{
			// update the collada animation
			if (_skinAnimation)
				_skinAnimation.update(getTimer() / 1000);

			// play animation
			if (_meshes)
				for each(var _mesh:MovieMesh in _meshes)
					_mesh.play();

			// show time
			scene.rotationY++;
		}
	}
}