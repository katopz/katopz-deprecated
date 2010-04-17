package
{
	import away3dlite.animators.BonesAnimator;
	import away3dlite.animators.MovieMesh;
	import away3dlite.builders.MDJBuilder;
	import away3dlite.core.base.Object3D;
	import away3dlite.core.utils.Debug;
	import away3dlite.events.Loader3DEvent;
	import away3dlite.loaders.Collada;
	import away3dlite.loaders.Loader3D;
	import away3dlite.templates.BasicTemplate;
	
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	import flash.net.FileReference;
	import flash.utils.*;

	[SWF(backgroundColor="#CCCCCC", frameRate="30", width="800", height="600")]
	/**
	 * Example : MDJ build from DAE and save as MDJ.
	 * @author katopz
	 */	
	public class ExMDJBuilder extends BasicTemplate
	{
		private var _bonesAnimator:BonesAnimator;
		private var _mdjBuilder:MDJBuilder;
		private var _meshes:Vector.<MovieMesh>;

		override protected function onInit():void
		{
			title = "Click to save |";
			
			// behide the scene
			Debug.active = true;

			// better view angle
			camera.y = -500;
			camera.lookAt(new Vector3D());

			// some collada with animation
			var _collada:Collada = new Collada();
			_collada.scaling = 20;
			_collada.bothsides = false;

			// load target model
			var _loader3D:Loader3D = new Loader3D();
			_loader3D.loadGeometry("nemuvine/nemuvine.dae", _collada);
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
			_mdjBuilder = new MDJBuilder();
			_mdjBuilder.meshPath = "mdj/";
			_mdjBuilder.texturePath = "nemuvine/";

			// convert to meshes
			_meshes = _mdjBuilder.convert(_model);

			// bring it on one by one
			for each (var _mesh:MovieMesh in _meshes)
			{
				// add to scene
				scene.addChild(_mesh);
				
				// and play it
				_mesh.play();
			}
			
			// click to save
			stage.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		private function onClick(event:MouseEvent):void
		{
			// save all as .mdj file
			new FileReference().save(_mdjBuilder.getMDJ(_meshes), "nemuvine.mdj");
		}

		override protected function onPreRender():void
		{
			// update the collada animation
			if (_bonesAnimator)
				_bonesAnimator.update(getTimer() / 1000);

			// show time
			scene.rotationY++;
		}
	}
}