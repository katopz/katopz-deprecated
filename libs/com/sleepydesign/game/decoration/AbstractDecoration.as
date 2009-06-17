package com.sleepydesign.playground
{
	import org.papervision3d.objects.parsers.Collada;
	import org.papervision3d.objects.parsers.DAE;
	import org.papervision3d.objects.primitives.Plane;
	
	import org.papervision3d.scenes.Scene3D;
	import org.papervision3d.materials.ColorMaterial;
	import org.papervision3d.materials.BitmapFileMaterial;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public class AbstractDecoration extends EventDispatcher
	{
		public var scene	: Scene3D;
		
		public function AbstractDecoration(iScene:Scene3D, initObject:*=null)
		{
			scene = iScene;
			
			if(initObject){
				setup(initObject);
			}
		}
		
		public function setup(initObject):void
		{
			for( var i in initObject){
				this[i] = initObject[i];
			}
		}
		
		public function create(decorateObject:*=null):void
		{
			
			for( var i in decorateObject)
			{
				add(decorateObject[i].id,decorateObject[i].pos);
			}
			
		}
		
		public function add(id:String,pos:PositionVO):void
		{
			trace(" > Add Decor : "+id)
			
			var decor0:Collada = new Collada("assets/" + id, null, 0.1);
			decor0.rotationY = 180;
			scene.addChild(decor0);
			
			//decor0.copyPosition(pos.toDisplayObject3D());
		}
		
		public function remove():void
		{
			//
		}
		
		public function init():void
		{
			//dispatchEvent(new PlayerEvent(PlayerEvent.COMPLETE, this));
		}
		
	}
}