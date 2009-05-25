package open3d.view
{
	import flash.display.Sprite;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.*;
	
	import net.hires.debug.Stats;
	
	import open3d.debug.SimpleTextField;
	import open3d.objects.Mesh;
	import open3d.render.Renderer;
	
	/**
	 * SimpleView
	 * @author katopz
	 */	
	public class SimpleView extends Sprite
	{
		protected var renderer:Renderer;
		
		protected var _isDebug:Boolean = false;
		protected var debugText:SimpleTextField;
		protected var stat:Stats;
		
		public function SimpleView()
		{
			addEventListener(Event.ADDED_TO_STAGE, onStage);
		}
		
		protected function onStage(event:Event):void
		{
			init();
		}
		
		protected function init():void
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.quality = StageQuality.MEDIUM;

			renderer = new Renderer(this);
			renderer.world.z = 500;
			
			debugText = new SimpleTextField();
			debugText.x = 80;
			
			isDebug = true;
			stat = new Stats();
			
			create();
			
			addChild(stat);
			addChild(debugText);
			
			stat.visible = isDebug;
			debugText.visible = isDebug;
			
			start();
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
            debug();
            draw();
            renderer.render();
		}
		
		protected function draw():void
		{
			// override me
		}
		
		protected function debug():void
		{
            if(_isDebug)
            {
            	debugText.text = String("Object3D(es) : "+renderer.numChildren+ ", Face(s) : "+renderer.totalFaces);
            }
		}
		
		protected function get isDebug():Boolean
		{
			return _isDebug;
		}
		
		protected function set isDebug(value:Boolean):void
		{
			_isDebug = value;
			debugText.visible = _isDebug;
			if(_isDebug)
			{
				stage.addEventListener(MouseEvent.MOUSE_DOWN, toggleStroke,false,0,true);
				stage.addEventListener(MouseEvent.MOUSE_UP, toggleStroke,false,0,true);
			}else{
				stage.removeEventListener(MouseEvent.MOUSE_DOWN, toggleStroke);
				stage.removeEventListener(MouseEvent.MOUSE_UP, toggleStroke);
			}
		}

		protected function toggleStroke(event:MouseEvent):void
		{
			for each (var mesh:Mesh in renderer.childs)
			{
				//mesh.stroke.thickness = (event.type == MouseEvent.MOUSE_DOWN) ? 1 : NaN;
			}
		}
	}
}