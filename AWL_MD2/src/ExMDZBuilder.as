package
{
	import away3dlite.animators.BonesAnimator;
	import away3dlite.animators.MovieMesh;
	import away3dlite.builders.MD2Builder;
	import away3dlite.builders.MDZBuilder;
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
	public class ExMDZBuilder extends BasicTemplate
	{
		private var _skinAnimation:BonesAnimator;
		private var _mdzBuilder:MDZBuilder;
		private var _meshes:Vector.<MovieMesh>;

		override protected function onInit():void
		{
			// behide the scene
			Debug.active = true;

			// better view angle
			camera.y = -500;
			camera.lookAt(new Vector3D());

			// some collada with animation
			var collada:Collada = new Collada();
			collada.scaling = 20;
			collada.bothsides = false;

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
			try{
				_skinAnimation = model.animationLibrary.getAnimation("default").animation as BonesAnimator;
			}catch (e:*){}

			// build as MD2
			_mdzBuilder = new MDZBuilder();
			_mdzBuilder.material = new BitmapFileMaterial("assets/yellow.jpg");

			// convert to meshes
			_meshes = _mdzBuilder.convert(model);

			// bring it on one by one
			for each (var _mesh:MovieMesh in _meshes)
				scene.addChild(_mesh);

			// save the 1st one as .mds file
			new FileReference().save(_mdzBuilder.getMDZ(_meshes).byteArray, "nemuvine.mdz");
		}

		override protected function onPreRender():void
		{
			// update the collada animation
			if (_skinAnimation)
				_skinAnimation.update(getTimer() / 1000);

			// play animation
			if (_meshes)
				for each (var _mesh:MovieMesh in _meshes)
					_mesh.play();

			// show time
			scene.rotationY++;
		}
	}
}