package
{
	import away3dlite.animators.BonesAnimator;
	import away3dlite.animators.bones.Bone;
	import away3dlite.containers.ObjectContainer3D;
	import away3dlite.core.base.Mesh;
	import away3dlite.core.base.Object3D;
	import away3dlite.core.utils.Debug;
	import away3dlite.events.Loader3DEvent;
	import away3dlite.loaders.Collada;
	import away3dlite.loaders.Loader3D;
	import away3dlite.templates.BasicTemplate;
	
	import com.sleepydesign.utils.FileUtil;
	import com.sleepydesign.utils.SystemUtil;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.utils.*;
	
	[SWF(backgroundColor="#000000", frameRate="30", width="800", height="600")]
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
		private var _collada:Collada;
		private var _loader:Loader3D;
		private var model:Object3D;
		private var canvas:ObjectContainer3D;
		
		private var collada2:Collada;
		private var loader2:Loader3D;
		private var model2:Object3D;
		private var skinAnimation:BonesAnimator;
		
		private var _bone:Bone; 
		
		private function onSuccess(event:Loader3DEvent):void
		{
			model = _loader.handle;
			model.rotationY = 180;
			canvas.addChild(model);
			
			skinAnimation = model.animationLibrary.getAnimation("default").animation as BonesAnimator;
			
			/*
			collada2 = new Collada();
			collada2.scaling = 5;
			
			loader2 = new Loader3D();
			loader2.loadGeometry("man/man1.dae", collada2);
			loader2.addEventListener(Loader3DEvent.LOAD_SUCCESS, onSuccess2);
			
			_bone = ObjectContainer3D(model).getBoneByName("HP_Head");
			*/
			
////var _head:Mesh = ObjectContainer3D(model).getChildByName("Head_01") as Mesh;
////var _hair:Mesh = ObjectContainer3D(model).getChildByName("Hair_01") as Mesh;
			
			//var mat:Material = Mesh(_head1).material//.materialLibrary.currentMaterialData;//.getMaterial("MapFBXASC032FBXASC035117");
////var targetMaterial:MaterialData = model.materialLibrary.getMaterial("Hair_01_ncl1_2");
////targetMaterial.material = new BitmapFileMaterial("man/Hair_1_Color_4.png");
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
			
			/*
			_collada = new Collada();
			_collada.bothsides = false;
			_collada.scaling = 5;
			
			_loader = new Loader3D();
			_loader.loadGeometry("man/man1.dae", collada);
			_loader.addEventListener(Loader3DEvent.LOAD_SUCCESS, onSuccess);
			scene.addChild(_loader);
			*/
			
			// EditorTool
			_EditorTool = new EditorTool(scene);
				
			// menu
			SystemUtil.addContext(this, "Open Model", function ():void{FileUtil.openXML(onOpenModel)});
			SystemUtil.addContext(this, "Open Texture", function ():void{FileUtil.openAsset(function onTextureReady(event:Event):void
			{
				if(event.type == Event.COMPLETE)
					setTexture(event.target.content);
			})});
			
			SystemUtil.addContext(this, "Open Model (Compress)", function ():void
			{
				FileUtil.openCompress(onOpenModel)
			});
			SystemUtil.addContext(this, "Save Model (Compress)", function ():void
			{
				if(_currentXML)
				{
					var _srcURLs:Array = _currentURI.split("/");
					var _fileName:String = _srcURLs.pop();
					FileUtil.saveCompress(_currentXML.toXMLString(), _fileName.split(".")[0]+".bin");
				}
			});
		}
		/* for later use, chking before save */
		private var _currentXML:XML;
		/* for later use, save ???.bin */
		private var _currentURI:String;
		/* path for texture */
		private const _texturePath:String = "chars/man/2/";
		private var _EditorTool:EditorTool;
		
		private function onOpenModel(event:Event):void
		{
			if(event.type == Event.COMPLETE)
			{
				parse(new XML(event["data"]));
			} else if(event.type == Event.SELECT){
				_currentURI = event.target["name"];
			}
		}
		
		public function setTexture(bitmap:Bitmap):void
		{
			trace(" * setTexture");
			//_model.materialLibrary.currentMaterialData.material = new BitmapMaterial(bitmap.bitmapData);
		}
		
		public function parse(xml:XML):void
		{
			trace(" * Parse");
			
			_currentXML = xml;
			
			_collada = new Collada();
			_collada.bothsides = false;
			_collada.scaling = 5;
			
			_loader = new Loader3D();
			_loader.loadXML(xml, _collada, _texturePath);
			_loader.addEventListener(Loader3DEvent.LOAD_SUCCESS, onSuccess);
			addChild(_loader);
		}
		
		override protected function onPreRender():void
		{
			if(skinAnimation)
				skinAnimation.update(getTimer()/1000);
		}
	}
}