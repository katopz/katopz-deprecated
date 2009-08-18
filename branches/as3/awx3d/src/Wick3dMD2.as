package {
	import caurina.transitions.Tweener;
	
	import com.derschmale.display.io.PCXLoader;
	import com.derschmale.wick3d.cameras.Camera3D;
	import com.derschmale.wick3d.core.pipeline.RenderPipeline;
	import com.derschmale.wick3d.debug.StatsDisplay;
	import com.derschmale.wick3d.display3D.MD2Model;
	import com.derschmale.wick3d.display3D.World3D;
	import com.derschmale.wick3d.view.Viewport;
	
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.ui.Keyboard;
	
	[SWF(backgroundColor="0x000000", frameRate="30", width="800", height="600")]
	public class Wick3dMD2 extends Sprite
	{	
		private var _world : World3D;
		private var _stats : StatsDisplay;
		private var _renderer : RenderPipeline;
		private var _camera : Camera3D;
		
		private var _md2 : MD2Model;
		
		private var _renderTarget : Viewport;
		
		private var _pcxLoader : PCXLoader;
		
		// states:
		private var _isRunning : Boolean = false;
		private var _isBacking : Boolean = false;
		private var _turningDir : int = 0;
		
		public function Wick3dMD2()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.quality = StageQuality.MEDIUM;
			
			initScreen();
			initWick3d();
			
			addEventListener(Event.ENTER_FRAME, handleEnterFrame);
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, handleMouseWheel);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, handleKeyUp);
			
			stage.focus = stage;
		}
		
		private function initScreen() : void
		{
			var textField : TextField;
			var matrix : Matrix = new Matrix();
			matrix.createGradientBox(stage.stageWidth, stage.stageHeight, Math.PI*.5);
			graphics.beginGradientFill(GradientType.LINEAR, [0xffffff, 0xcccccc, 0xffffff], [1, 1, 1], [20, 60, 200], matrix);
			graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			graphics.endFill();
			
			textField = new TextField();
			textField.text = "E - Forward\tD - Backward\tS - Turn Left\tR - Turn Right\tENTER - Reset";
			textField.y = stage.stageHeight-20;
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.x = (stage.stageWidth-textField.textWidth)*.5;
			addChild(textField);
		}
		
		private function initWick3d() : void
		{
			_renderer = new RenderPipeline();
			_world = new World3D();
			_camera = new Camera3D();
			
			_renderTarget = new Viewport(true);
			addChild(_renderTarget);
			
			_md2 = new MD2Model("assets/md2/tris.md2", true, 100, true);
			_md2.addEventListener(Event.COMPLETE, handleComplete);
			_md2.z = 100;
			_world.addChild(_md2);
			
			_camera.y = 40;
			_camera.lookAt(_md2);
			
			_stats = new StatsDisplay(0x000000);
			addChild(_stats);
		}
		
		private function handleKeyDown(event : KeyboardEvent) : void
		{
			var char : String = String.fromCharCode(event.charCode);
			if (!_isRunning && (char == "e" || char == "E")) {
				_md2.setFrameRangeSet("run");
				_isRunning = true;
			}
			if (char == "s" || char == "S") {
				_turningDir = 1;
			}
			if (char == "f" || char == "F") {
				_turningDir = -1;
			}
			if (!_isBacking && (char == "d" || char == "d")) {
				_isBacking = true;
				_md2.setFrameRangeSet("crwalk");
			}
			
		}
		
		private function handleKeyUp(event : KeyboardEvent) : void
		{
			var char : String = String.fromCharCode(event.charCode);

			if (char == "e" || char == "E") {
				_md2.setFrameRangeSet("stand");
				_isRunning = false;
			}
			if (char == "s" || char == "S" || char == "f" || char == "F") {
				_turningDir = 0;
			}
			if (char == "d" || char == "d") {
				_isBacking = false;
				_md2.setFrameRangeSet("stand");
			}
			if (event.keyCode == Keyboard.ENTER) {
				_md2.x = 0;
				_md2.y = 0;
				_md2.z = 100;
				_md2.yaw = 0;
			}
			
		}
		
		private function handleComplete(event : Event) : void
		{
			_md2.setFrameRangeSet("stand");
		}
		
		private function handleClick(event : MouseEvent) : void
		{
			if (hasEventListener(Event.ENTER_FRAME)) {
				stage.quality = StageQuality.BEST;
				removeEventListener(Event.ENTER_FRAME, handleEnterFrame);
			}
			else {
				stage.quality = StageQuality.MEDIUM;
				addEventListener(Event.ENTER_FRAME, handleEnterFrame);
			}
		}
		
		private function handleMouseWheel(event : MouseEvent) : void
		{
			Tweener.addTween(_camera, {fieldOfView: _camera.fieldOfView+event.delta*0.05, time: 0.25, transition: "easeOutQuad"});
		}
		
		private function handleEnterFrame(event : Event) : void
		{
			_renderer.render(_world, _camera, _renderTarget);
			if (_isRunning) _md2.moveForward(5);
			if (_isBacking) _md2.moveBackward(1);
			if (_turningDir != 0) _md2.yaw += _turningDir*0.1;
		}
	}
}