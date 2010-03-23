package
{
	import com.sleepydesign.net.FileUtil;
	import flash.geom.Vector3D;
	import flash.utils.*;
	import away3dlite.animators.BonesAnimator;
	import away3dlite.core.base.Object3D;
	import away3dlite.core.utils.Debug;
	import away3dlite.events.Loader3DEvent;
	import away3dlite.loaders.Collada;
	import away3dlite.loaders.Loader3D;
	import away3dlite.loaders.MD2Builder;
	import away3dlite.materials.BitmapFileMaterial;
	import away3dlite.templates.BasicTemplate;

	[SWF(backgroundColor="#CCCCCC", frameRate="30", width="800", height="600")]
	public class ExMD2Builder extends BasicTemplate
	{
		private var _skinAnimation:BonesAnimator;
		private var _md2Builder:MD2Builder;

		override protected function onInit():void
		{
			// behide the scene
			Debug.active = false;

			// better view
			camera.y = -500;
			camera.lookAt(new Vector3D());

			// some collada with animation
			var collada:Collada = new Collada();
			collada.scaling = 5;

			// load it
			var loader3D:Loader3D = new Loader3D();
			loader3D.loadGeometry("assets/30_box_smooth_translate.dae", collada);
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
			_md2Builder.scaling = 5;
			_md2Builder.material = new BitmapFileMaterial("assets/yellow.jpg");
			scene.addChild(_md2Builder.convert(model));

			// save as File
			var _data:ByteArray = _md2Builder.export();
			FileUtil.save(_data);
		}

		override protected function onPreRender():void
		{
			// update the collada animation
			if (_skinAnimation)
				_skinAnimation.update(getTimer() / 1000);

			// show time
			scene.rotationY++;
		}
	}
}