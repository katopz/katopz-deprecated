package com.sleepydesign.playground.core
{
	import com.sleepydesign.core.SDContainer;
	import com.sleepydesign.events.SDEvent;
	import com.sleepydesign.game.core.AbstractEngine;
	import com.sleepydesign.playground.components.Axis;
	import com.sleepydesign.playground.components.Compass;
	import com.sleepydesign.playground.components.Grid;
	import com.sleepydesign.playground.data.CameraData;
	import com.sleepydesign.playground.data.SceneData;
	import com.sleepydesign.ui.SDMouse;
	import com.sleepydesign.utils.ObjectUtil;
	
	import flash.events.Event;
	
	import org.papervision3d.cameras.Camera3D;
	import org.papervision3d.core.utils.Mouse3D;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.render.BasicRenderEngine;
	import org.papervision3d.scenes.Scene3D;
	import org.papervision3d.view.Viewport3D;
	import org.papervision3d.view.layer.ViewportLayer;

	public class Engine3D extends AbstractEngine
	{
		//____________________________________________________________ 3D
		
		public var scene			: Scene3D;
		public var camera			: Camera3D;
		public var viewport			: Viewport3D;
		
		public var uiScene			: Scene3D;
		public var uiViewport		: Viewport3D;
		
		public var renderer			: BasicRenderEngine;
		
		public var layer			: ViewportLayer;
		
		public var root3D			: DisplayObject3D;
		public var mouse3D			: Mouse3D;
		
		//____________________________________________________________ Variables
		
		public var dolly 			: Camera3D;
		public var decoy 			: DisplayObject3D;
		
		public var im 				: *;
		
		//____________________________________________________________ Axis
		
		private var _axis			: Boolean = false;
		private var _axisInstance	: Axis;
		
		public function get axis():Boolean
		{
			return _axis;
		}
		
		public function set axis(value:Boolean):void
		{
			if(value)
			{
				_axisInstance = new Axis();
				/*
				var layer:ViewportLayer =  new ViewportLayer(viewport, _axisInstance);
				layer.sortMode = ViewportLayerSortMode.INDEX_SORT;
				layer = viewport.getChildLayer(_axisInstance);
				*/
				_axisInstance.useOwnContainer = true;
				addChild(_axisInstance);
			}else{
				_axisInstance.destroy();
				removeChild(_axisInstance);
				_axisInstance = null;
			}
			_axis = value;
		}
		
		//____________________________________________________________ Grid
		
		private var _grid			: Boolean = false;
		private var _gridInstance	: Grid;
		
		public function get grid():Boolean
		{
			return _grid;
		}
		
		public function set grid(value:Boolean):void
		{
			if(value)
			{
				_gridInstance = new Grid();
				addChild(_gridInstance);
			}else{
				_gridInstance.destroy();
				removeChild(_gridInstance);
				_gridInstance = null;
			}
			_grid = value;
		}
		
		//____________________________________________________________ Compass
		
		private var _compass			: Boolean;
		private var _compassInstance	: Compass;
		
		public function get compass():Boolean
		{
			return _compass;
		}
		
		public function set compass(value:Boolean):void
		{
			if(value)
			{
				_compassInstance = new Compass(viewport, root3D);
				addChild(_compassInstance);
				
				//layer = new ViewportLayer(viewport, _compassInstance);
				/*
				layer.alpha = .1;
				trace(_compassInstance.container)
				trace(_compassInstance.container.alpha)
				*/
				
				//layer = viewport.getChildLayer(_compassInstance);
				//layer.alpha = .5;
				
				
				
			}else{
				_compassInstance.destroy();
				removeChild(_compassInstance);
				_compassInstance = null;
			}
			
			_compass = value;
		}
		
		// ______________________________ Core ______________________________

		public function get config():*
		{
			return _config;
		}
		
		public function set config(value:*):void
		{
			_config = value;
		}
		
		public function Engine3D(container:SDContainer, engine3DData:Object=null):void
		{
			this.container = container;
			init(engine3DData);
		}
		
        // ______________________________ Initialize ______________________________
        
		override public function init(raw:Object=null):void
		{
			//container.stage.quality = "medium";
			
			root3D = new DisplayObject3D();
			
			//var defaultRaw:SceneData = new SceneData(new CameraData(0,1000,-0.00000001,0,0,0,60,8.7,70));
			
			//ObjectUtil.merge(raw, defaultRaw);
			
			parse(raw);
		}
		
		// ______________________________ Parse ______________________________
		
		override public function parse(raw:Object=null):void
		{
			// default config
			raw.animated = true;
			raw.interactive = true;
			raw.autoClipping = !true;
			raw.autoCulling = !true;
			raw.width = container.stage.stageWidth;
			raw.height = container.stage.stageHeight;
			
			//ObjectUtil.merge(raw, config);
			
			create(raw);
		}
		
		// ______________________________ Create ______________________________	
		
		override public function create(config:Object=null):void
		{
			//super.create(config);
			config = config;
			
			dolly = new Camera3D();
			//decoy = new DisplayObject3D();
			
			//____________________________________________________________ System
			
			scene = new Scene3D();
			
			renderer = new BasicRenderEngine();
			
			viewport = new Viewport3D(config.width, config.height, false, false, config.autoClipping, config.autoCulling);
			
			scene.addChild(root3D);
			
			camera = new Camera3D();//config.camera.fov, config.camera.focus, config.camera);
			
			//camera.rotationX = -45;
			//camera.moveBackward(500);
			
			update(config);
			
			viewport.addEventListener(Event.ADDED_TO_STAGE, init3d);
			container.addChild(viewport);
		}
		
		// ______________________________ Update ____________________________
		
		override public function update(data:Object=null):void
		{
			config = data;
			
			camera.x = config.camera.x;
			camera.y = config.camera.y;
			camera.z = config.camera.z;
			camera.rotationX = config.camera.rotationX;
			camera.rotationY = config.camera.rotationY;
			camera.rotationZ = config.camera.rotationZ;
			camera.fov = config.camera.fov;
			camera.focus = config.camera.focus;
			camera.zoom = config.camera.zoom;
			
			/*
			camera.copyPosition(camLee);
			*/
			
			/*
			decoy.x = config.decoy.x;
			decoy.y = config.decoy.y;
			decoy.z = config.decoy.z;
			dolly.lookAt(decoy);
			decoy.lookAt(dolly);
			*/
			
			//camera.copyPosition(dolly);
			dolly.copyTransform(camera);
			dolly.fov = camera.fov;
			dolly.focus = camera.focus;
			dolly.zoom = camera.zoom;
			
			//trace("dolly:" + dolly)
			
			//var length:uint = dolly.distanceTo(decoy);
			
			//trace("length:" + length)
			//var vt = new Vertex3D(0, 0, 0)
			
			//camLee = new LeeCamera3D(vt,length,0,0);
			
			//____________________________________________________________ Debug
			
			//init3d(new Event(Event.COMPLETE));
			
			trace("____________________________________________________");
			trace("camera:" + camera);
			trace("____________________________________________________");
			//trace("dolly:" + dolly);
			//trace("decoy:" + decoy);
			
			//trace("fov:" + camera.fov);
			//trace("focus:" + camera.focus);
			//trace("zoom:" + camera.zoom);
		}	
		
		//public function addChild( child :DisplayObject3D, name:String=null ):Object
		override public function addChild(child:Object):Object
        {
        	return root3D.addChild(DisplayObject3D(child));
        }
        
        override public function removeChild( child :Object ):Object
        {
        	return root3D.removeChild(DisplayObject3D(child));
        }
        
		public function init3d(event:Event):void
		{
			event.target.removeEventListener(Event.ADDED_TO_STAGE, init3d);
			
			if(event.target==viewport)
			{
				/*
				uiScene = new Scene3D();
				uiViewport = new Viewport3D(config.width, config.height, false, true, config.autoClipping, config.autoCulling);
				uiViewport.alpha = 0;
				uiViewport.addEventListener(Event.ADDED_TO_STAGE, init3d);
				container.addChild(uiViewport);
			}else{
				*/
				dispatchEvent(new Event(SDEvent.COMPLETE));
			}
		}
				
		//length between decoy|--|dolly
		//public var length:uint = 500;
		
		//rotation between decoy|--|dolly
		//public var rotationX:Number = 30;
		//public var rotationY:Number = 0;
		//public var rotationZ:Number = 0;
		
		public function setupDolly(ref:DisplayObject3D=null):void
		{
			/*
			trace(ref,decoy)
			
			length = ref.distanceTo(decoy);
			
			rotationX = 180 - Math.atan2(ref.y - decoy.y, ref.z - decoy.z) * toDEGREES;e
			rotationY = 180 - Math.atan2(ref.x - decoy.x, ref.z - decoy.z) * toDEGREES;
			
			trace("to object:" + decoy,dolly);
			trace("to rotationY:" + rotationY);
			
			
			trace(camLee.rotationX, camLee.rotationY);
			trace(ref.rotationX, ref.rotationY, ref.rotationZ);
			
			camLee.rotationX = dolly.rotationX;
			camLee.rotationY = dolly.rotationY;
			*/
			//if (camLee.rotationY < 0) camLee.rotationY = 0;
			//if (camLee.rotationY > 90) camLee.rotationY = 90;
			
			
			
		}
		/*
		//public var camLeeTarget:Vertex3D = new Vertex3D();
		
		private function updateView():void
		{
			camLeeTarget.x = decoy.x
			camLeeTarget.y = decoy.y
			camLeeTarget.z = decoy.z
			
			camLee.target = camLeeTarget;
			camLee.toCamera3D(dolly);
		}
		*/
		
		//TODO renderRTS, renderGOD
		override protected function run(event:Event=null) : void
		{
			/*
			switch(config.type) {
				case "RTS":
					//updateView();
					
					//move back _/
					dolly.copyPosition(decoy);
					
					dolly.rotationX = -rotationX;
					dolly.rotationY = -rotationY;
					
					dolly.moveBackward(length);
					
				break;
				case "GOD":
					//dolly.copyPosition(decoy);
					//dolly.rotationX = -3;
					//dolly.moveBackward(500);
				break;
			}
			*/
			
			//camera.copyPosition(dolly);

			
			/*
			camera.x+=(dolly.x-camera.x)*camera.extra.speed;
			camera.y+=(dolly.y-camera.y)*camera.extra.speed;
			camera.z+=(dolly.z-camera.z)*camera.extra.speed;
			*/
			
			if(SDMouse.isMouseDown)
			{
				//dolly.lookAt(decoy);
				//dolly.copyTransform(camera);
				
				trace("____________________________________________________");
				
				trace("camera:" + camera);
				//trace("dolly:" + dolly);
				//trace("decoy:" + decoy);
				
				//trace("fov:" + camera.fov);
				//trace("focus:" + camera.focus);
				//trace("zoom:" + camera.zoom);
				trace("____________________________________________________");
			}
			
			
			//camera.copyTransform(dolly);
/*
camera.x=3.7e+2;
camera.y=1.3e+2;
camera.z=-5.3e+2;

dolly.rotationX=-2.4;
dolly.rotationY=-29;
dolly.rotationZ=0.00;
/*
camera.fov=43;
camera.focus=8.7;
camera.zoom=70
*/
//dolly.x=3.7e+2;dolly.y=1.3e+2;dolly.z=-5.3e+2;dolly.rotationX=-2.4;dolly.rotationY=-29;dolly.rotationZ=0.00;dolly.fov=36;dolly.focus=8.7;dolly.zoom=70
//decoy.x=-190;decoy.y=160;decoy.z=0
camera.copyTransform(dolly);
			
			
			//_fps.anim = "\nplayer : " + Capabilities.version;
			//_fps.anim += "\nrendered: "  ;
			
			renderer.renderScene(scene, camera, viewport);
			
			if(uiScene)
				renderer.renderScene(uiScene, camera, uiViewport);
			
			//call back
			//if(hasEventListener(SDEvent.DRAW))
			//	dispatchEvent(new SDEvent(SDEvent.DRAW));
			
			/*
			if (im) {
				renderer.renderScene(im.scene, camera, im.viewport);
			}
			*/
			
			draw();
		}
	}
}