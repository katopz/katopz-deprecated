package com.cutecoma.playground.core
{
	import away3dlite.cameras.Camera3D;
	import away3dlite.core.base.Object3D;
	import away3dlite.templates.BasicTemplate;
	
	import com.cutecoma.playground.data.CameraData;
	import com.cutecoma.playground.data.SceneData;
	import com.sleepydesign.display.SDSprite;
	
	import flash.display.Sprite;

	public class Engine3D extends BasicTemplate
	{
		public var system:SDSprite;
		
		public var dolly:Camera3D;
		public var decoy:Object3D;

		public var im:*;
		
		public var container:Sprite;
		private var _data:Object;
		
		private var config:Object;

		// ______________________________ Core ______________________________

		public function Engine3D(container:Sprite, engine3DData:Object = null):void
		{
			this.container = container;
			_data = engine3DData;
			init();
		}

		// ______________________________ Initialize ______________________________

		protected function init():void
		{
			//container.stage.quality = "medium";

			//var defaultRaw:SceneData = new SceneData(new CameraData(0,1000,-0.00000001,0,0,0,60,8.7,70));

			//ObjectUtil.merge(raw, defaultRaw);

			parse(_data ? _data : new SceneData(new CameraData()));
			
			addChild(system = new SDSprite);
		}

		// ______________________________ Parse ______________________________

		public function parse(raw:Object = null):void
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

		public function create(config:Object = null):void
		{
			//super.create(config);
			this.config = config;

			dolly = new Camera3D();
			//decoy = new DisplayObject3D();

			update(config);
		}

		// ______________________________ Update ____________________________

		public function update(data:Object = null):void
		{
			config = data;

			camera.x = config.camera.x;
			camera.y = config.camera.y;
			camera.z = config.camera.z;
			camera.rotationX = config.camera.rotationX;
			camera.rotationY = config.camera.rotationY;
			camera.rotationZ = config.camera.rotationZ;
			//camera.fov = config.camera.fov;
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
			//dolly.copyTransform(camera);
			dolly.transform.matrix3D = camera.transform.matrix3D.clone();
			//dolly.fov = camera.fov;
			dolly.focus = camera.focus;
			dolly.zoom = camera.zoom;

			//trace("dolly:" + dolly)

			//var length:uint = dolly.distanceTo(decoy);

			//trace("length:" + length)
			//var vt = new Vertex3D(0, 0, 0)

			//camLee = new LeeCamera3D(vt,length,0,0);

			//____________________________________________________________ Debug

			//init3d(new Event(Event.COMPLETE));

		/*
		   trace("____________________________________________________");
		   trace("camera:" + camera);
		   trace("____________________________________________________");
		 */

			 //trace("dolly:" + dolly);
			 //trace("decoy:" + decoy);

			 //trace("fov:" + camera.fov);
			 //trace("focus:" + camera.focus);
			 //trace("zoom:" + camera.zoom);
		}

		override protected function onPreRender():void
		{
			/*
			   camera.copyTransform(dolly);

			   renderer.renderScene(scene, camera, viewport);

			   if(uiScene)
			   renderer.renderScene(uiScene, camera, uiViewport);
			 */

			//draw();
		}
	}
}