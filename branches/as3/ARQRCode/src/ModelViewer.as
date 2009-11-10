package
{
	import away3dlite.animators.BonesAnimator;
	import away3dlite.containers.ObjectContainer3D;
	import away3dlite.containers.Scene3D;
	import away3dlite.core.base.Object3D;
	import away3dlite.events.Loader3DEvent;
	import away3dlite.loaders.Collada;
	import away3dlite.loaders.Loader3D;
	import away3dlite.materials.BitmapMaterial;
	import away3dlite.materials.WireColorMaterial;
	import away3dlite.primitives.Sphere;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Vector3D;
	import flash.utils.*;

	public class ModelViewer
	{
		private var _skinAnimation:BonesAnimator;
		
		private var _scene:Scene3D;
		
		private var _loader:Loader3D;
		private var _collada:Collada;
		private var _model:Object3D;
		private var _base:ObjectContainer3D;
		
		public var _anchorA:Object3D;
		public var _anchorB:Object3D;
		public var _anchorC:Object3D;
		
		public function ModelViewer(scene:Scene3D)
		{
			_scene = scene;
			
			_anchorA = new Object3D();
			//_anchorA = new Sphere(new WireColorMaterial(0xFF0000), 50, 4, 4);
			scene.addChild(_anchorA);
			
			_anchorB = new Object3D();
			//_anchorB = new Sphere(new WireColorMaterial(0x00FF00), 50, 4, 4);
			scene.addChild(_anchorB);
			
			_anchorC = new Object3D();
			//_anchorC = new Sphere(new WireColorMaterial(0x0000FF), 50, 4, 4);
			scene.addChild(_anchorC);
			
			_base = new ObjectContainer3D();
			scene.addChild(_base);
		}
		
		public function reset():void
		{
			if(_loader && _loader.parent)
				_loader.parent.removeChild(_loader);
		
			if(_model && _model.parent)
				_model.parent.removeChild(_model);
		}
		
		public function setTexture(bitmap:Bitmap):void
		{
			trace("setTexture");
			_model.materialLibrary.currentMaterialData.material = new BitmapMaterial(bitmap.bitmapData);
		}
		
		public function parse(raw:*):void
		{
			trace("parse");
			
			_collada = new Collada();
			_collada.scaling = 25;
			
			_loader = new Loader3D();
			var _xml:XML = new XML(raw);
			_loader.loadXML(_xml, _collada);
			_loader.addEventListener(Loader3DEvent.LOAD_SUCCESS, onSuccess);
			_base.addChild(_loader);
		}
		
		public function load(uri:String):void
		{
			trace(" load : " + uri);
			
			_collada = new Collada();
			_collada.scaling = 25;
			
			if(_loader && _loader.parent)
				_loader.parent.removeChild(_loader);
			
			_loader = new Loader3D();
			_loader.loadGeometry(uri, _collada);
			_loader.addEventListener(Loader3DEvent.LOAD_SUCCESS, onSuccess);
			_base.addChild(_loader);
		}
		
		private function onSuccess(event:Loader3DEvent):void
		{
			if(_model && _model.parent)
				_model.parent.removeChild(_model);
				
			_model = _loader.handle;
			_model.rotationX = -90;
			_model.rotationZ = -90;
			
			_skinAnimation = _model.animationLibrary.getAnimation("default").animation as BonesAnimator;
		}
		
		private var aa:Vector3D;
		private var bb:Vector3D;
		private var cc:Vector3D;
		
		private var _FLARResult:FLARResult;
		
		public function setAxis(_FLARResult:FLARResult):void
		{
			this._FLARResult = _FLARResult;
		}
		
		public function setRefererPoint(p0:Vector3D, p1:Vector3D, p2:Vector3D):void
		{
			_anchorA.x = p0.x;
			_anchorA.y = -p0.y;
			_anchorA.z = p0.z;
			
			if(p1.x< p2.x)
			{
				_anchorB.x = p1.x;
				_anchorB.y = -p1.y;
				_anchorB.z = p1.z;
				
				_anchorC.x = p2.x;
				_anchorC.y = -p2.y;
				_anchorC.z = p2.z;
			}else{
				_anchorB.x = p2.x;
				_anchorB.y = -p2.y;
				_anchorB.z = p2.z;
				
				_anchorC.x = p1.x;
				_anchorC.y = -p1.y;
				_anchorC.z = p1.z;
			}
		}
		
		public function updateAnchor():void
		{
			if(aa && aa.x == _anchorA.position.x)return;
			
			aa = _anchorA.position;
			bb = _anchorB.position;
			cc = _anchorC.position;
			
			if(_FLARResult)
				_FLARResult.setTransform(_base);
			
			_base.x = (aa.x + bb.x + cc.x)/3;
			_base.y = (aa.y + bb.y + cc.y)/3;
			_base.z = (aa.z + bb.z + cc.z)/3;
		}
		
		public function draw():void
		{
			if(_skinAnimation)
				_skinAnimation.update(getTimer()/1000);
		}
	}
}