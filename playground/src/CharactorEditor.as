package
{
	import away3dlite.animators.BonesAnimator;
	import away3dlite.animators.bones.Bone;
	import away3dlite.cameras.*;
	import away3dlite.containers.*;
	import away3dlite.core.base.Mesh;
	import away3dlite.core.base.Object3D;
	import away3dlite.core.utils.*;
	import away3dlite.events.Loader3DEvent;
	import away3dlite.loaders.*;
	import away3dlite.loaders.data.MaterialData;
	import away3dlite.materials.*;
	import away3dlite.primitives.*;
	import away3dlite.templates.BasicTemplate;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Vector3D;
	import flash.utils.*;
	
	[SWF(backgroundColor="#000000", frameRate="30", quality="MEDIUM", width="800", height="600")]
	/**
	 * TODO
	 * 1. load 5 prototype compressed model
	 * 2. create model tree
	 * 
	 * + Hair
	 *   - Mesh
	 *   - Texture
	 * + Head
	 *   - Mesh
	 *   - Texture
	 * + Shirt
	 *   - Mesh
	 *   - Texture
	 * + Pant
	 *   - Mesh
	 *   - Texture
	 * + Shoes
	 *   - Mesh
	 *   - Texture
	 * 
	 * 3. rebuild dae and compress+save
	 * 4. reload model for testing animation
	 *  
	 */
	public class CharactorEditor extends BasicTemplate
	{
		private var collada:Collada;
		private var loader:Loader3D;
		private var model:Object3D;
		
		private var collada2:Collada;
		private var loader2:Loader3D;
		private var model2:Object3D;
		private var skinAnimation:BonesAnimator;
		
		private var _bone:Bone; 
		
		private function onSuccess(event:Loader3DEvent):void
		{
			model = loader.handle;
			model.rotationY = 180;
			
			skinAnimation = model.animationLibrary.getAnimation("default").animation as BonesAnimator;
			
			/*
			collada2 = new Collada();
			collada2.scaling = 5;
			
			loader2 = new Loader3D();
			loader2.loadGeometry("man/man1.dae", collada2);
			loader2.addEventListener(Loader3DEvent.LOAD_SUCCESS, onSuccess2);
			
			_bone = ObjectContainer3D(model).getBoneByName("HP_Head");
			*/
			
			var _head:Mesh = ObjectContainer3D(model).getChildByName("Head_01") as Mesh;
			var _hair:Mesh = ObjectContainer3D(model).getChildByName("Hair_01") as Mesh;
			
			//var mat:Material = Mesh(_head1).material//.materialLibrary.currentMaterialData;//.getMaterial("MapFBXASC032FBXASC035117");
			var targetMaterial:MaterialData = model.materialLibrary.getMaterial("Hair_01_ncl1_2");
			targetMaterial.material = new BitmapFileMaterial("man/Hair_1_Color_4.png");
		}
		
		private var _head1:Mesh;
		private var _head2:Mesh;
		private function onSuccess2(event:Loader3DEvent):void
		{
			model2 = loader2.handle;
			//model2.rotationY = 180;
			
			_head2 = ObjectContainer3D(model2).getChildByName("Hair_02") as Mesh;
			
			//_head1.visible = false;
			
			//_bone.addChild(_head2);
			//_head1.parent.addChild(_head2);
		}
		
		override protected function onInit():void
		{
			mouseEnabled = mouseChildren = view.mouseEnabled3D = false;
			
			Debug.active = true;
			
			collada = new Collada();
			collada.bothsides = false;
			collada.scaling = 5;
			
			loader = new Loader3D();
			loader.loadGeometry("man/man1.dae", collada);
			loader.addEventListener(Loader3DEvent.LOAD_SUCCESS, onSuccess);
			scene.addChild(loader);
			
			camera.y = -100;

			// axis
			var _size:int = 500;
			var _lines:Array = [];
			_lines.push(new LineSegment(new WireframeMaterial(0xFF0000), new Vector3D(0, 0, 0), new Vector3D(_size, 0, 0)));
			_lines.push(new LineSegment(new WireframeMaterial(0x00FF00), new Vector3D(0, 0, 0), new Vector3D(0, _size, 0)));
			_lines.push(new LineSegment(new WireframeMaterial(0x0000FF), new Vector3D(0, 0, 0), new Vector3D(0, 0, _size)));
			
			for each(var _line:LineSegment in _lines)
				scene.addChild(_line);
		}
		
		//public var ok:int=0
		override protected function onPreRender():void
		{
			if(skinAnimation)
			{
				skinAnimation.update(getTimer()/1000);
				//skinAnimation = null;
			}
			
			//scene.rotationY++;
			
			//if(_head1 && _head2)
			//	_head2.transform.matrix3D = _head1.transform.matrix3D.clone();
		}
	}
}