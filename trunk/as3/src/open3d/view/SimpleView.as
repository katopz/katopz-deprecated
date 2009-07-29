package open3d.view
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.utils.*;
	
	import open3d.objects.Camera3D;
	import open3d.objects.Mesh;
	import open3d.render.Renderer;
	import open3d.utils.ProfilerUtil;
	import open3d.utils.TextUtil;

	/**
	 * SimpleView
	 * @author katopz
	 */
	public class SimpleView extends Sprite
	{
		protected var renderer:Renderer;
		
		public var camera:Camera3D;
		
		protected var _isDebug:Boolean;
		protected var debugText:TextField;
		protected var stat:DisplayObject;

		public function SimpleView()
		{
			addEventListener(Event.ADDED_TO_STAGE, onStage, false, 0, true);
		}

		protected function onStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onStage);
			init();
		}

		protected function init():void
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.quality = StageQuality.MEDIUM;

			camera = new Camera3D();
			camera.projection.fieldOfView = 53;
			camera.projection.focalLength = 500;
			camera.z = -500;
			
			var canvas:Sprite = new Sprite();
			addChild(canvas);
			
			renderer = new Renderer(camera, canvas);

			debugText = TextUtil.getTextField();
			debugText.x = 80;
			debugText.textColor = 0xFFFFFF;
			debugText.filters = [new GlowFilter(0x000000, 1, 4, 4, 2, 1)];

			isDebug = true;

			create();

			stat = ProfilerUtil.addStat(this);
			addChild(debugText);

			stat.visible = isDebug;
			debugText.visible = isDebug;
			
			ProfilerUtil.addContext(this, "Toggle Z-Sort", toggleZSort);

			start();
		}
		
		private function toggleZSort(event:ContextMenuEvent):void
		{
			renderer.isFaceZSort = renderer.isMeshZSort = !renderer.isFaceZSort;
		}

		protected function create():void
		{
			// override me
		}

		protected function start():void
		{
			addEventListener(Event.ENTER_FRAME, run, false, 0, true);
		}

		protected function stop():void
		{
			removeEventListener(Event.ENTER_FRAME, run);
		}

		protected function run(event:Event):void
		{
			prerender()
			renderer.render();
			if (_isDebug)debug();
			draw();
		}

		protected function debug():void
		{
			debugText.text = String("Object3D(s) : " + renderer.numChildren + ", Face(s) : " + renderer.totalFaces);
		}
		
		protected function prerender():void
		{
			// override me
		}
		
		protected function draw():void
		{
			// override me
		}
		
		protected function get isDebug():Boolean
		{
			return _isDebug;
		}

		protected function set isDebug(value:Boolean):void
		{
			_isDebug = value;
			debugText.visible = _isDebug;

			if (_isDebug)
			{
				stage.addEventListener(MouseEvent.MOUSE_DOWN, toggleStroke, false, 0, true);
				stage.addEventListener(MouseEvent.MOUSE_UP, toggleStroke, false, 0, true);
				stage.addEventListener(MouseEvent.MOUSE_WHEEL, onWheel, false, 0, true);
			}
			else
			{
				stage.removeEventListener(MouseEvent.MOUSE_DOWN, toggleStroke);
				stage.removeEventListener(MouseEvent.MOUSE_UP, toggleStroke);
				stage.removeEventListener(MouseEvent.MOUSE_WHEEL, onWheel);
			}
			
			debugMesh(_isDebug);
		}

		protected function onWheel(event:MouseEvent):void
		{
			if(event.ctrlKey)
			{
				// The value must be greater than 0 and less than 180
				if(event.delta>0)
				{
					if(camera.projection.fieldOfView+event.delta*2<180)camera.projection.fieldOfView+=event.delta*2;
				}else{
					if(camera.projection.fieldOfView+event.delta*2>0)camera.projection.fieldOfView+=event.delta*2;
				}
			}else{
				if(event.delta>0)
				{
					camera.projection.focalLength+=event.delta*2;
				}else{
					if(camera.projection.focalLength+event.delta*2>0)camera.projection.focalLength+=event.delta*2;
				}
			}
		}
		
		protected function toggleStroke(event:MouseEvent):void
		{
			debugMesh((event.type == MouseEvent.MOUSE_DOWN));
		}

		private function debugMesh(isDebugMesh:Boolean):void
		{
			for each (var mesh:Mesh in renderer.childs)
				mesh.material.isDebug = isDebugMesh;
		}
	}
}