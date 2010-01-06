package
{
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.text.*;
	
	import net.badimon.five3D.display.Scene3D;
	import net.hires.debug.Stats;

	/**
	 * Base template class.
	 */
	public class Template extends Sprite
	{
		/** @private */
		protected function init():void
		{
			// init stage
			setupStage();
			
			//
			setupLayer();
			
			//init scene
			_scene = new Scene3D();
			_scene.x = stage.stageWidth / 2;
			_scene.y = stage.stageHeight / 2;
			addChild(_scene);
			
			//init stats panel
			stats = new Stats();
			
			//add stats to the displaylist
			addChild(stats);
			
			//init debug textfield
			debugText = new TextField();
			debugText.selectable = false;
			debugText.mouseEnabled = false;
			debugText.mouseWheelEnabled = false;
			debugText.defaultTextFormat = new TextFormat("Tahoma", 12, 0x000000);
			debugText.autoSize = "left";
			debugText.x = 75;
			debugText.textColor = 0xFFFFFF;
			debugText.filters = [new GlowFilter(0x000000, 1, 4, 4, 2, 1)];
			
			//add debug textfield to the displaylist
			addChild(debugText);
			
			//set default debug
			debug = true;
			
			//set default title
			title = "Five3D";
			
			//add enterframe listener
			start();
			
			//trigger onInit method
			onInit();
		}
		
		protected var _scene:Scene3D;
		protected var stats:Stats;
		protected var debugText:TextField;
		private var _title:String;
		private var _debug:Boolean;
		
		protected function setupStage():void
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.quality = StageQuality.MEDIUM;
		}
		
		protected function setupLayer():void
		{
			// override me
		}
		
		protected function onAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			init();
		}
		
		private function onEnterFrame(event:Event):void
		{
			onPreRender();
			
			if (_debug) {
				debugText.text = _title;
				onDebug();
			}
			
			onPostRender();
		}
		
		/**
		 * Fired on instantiation of the template.
		 */
		protected function onInit():void
		{
			// override me
		}
		
		/**
		 * Fired at the beginning of a render loop.
		 */
		protected function onPreRender():void
		{
			// override me
		}
		
		/**
		 * Fired if debug is set to true.
		 * 
		 * @see #debug
		 */
		protected function onDebug():void
		{
			// override me
		}
		
		/**
		 * Fired at the end of a render loop.
		 */
		protected function onPostRender():void
		{
			// override me
		}
		
		/**
		 * Defines the text appearing in the template title.
		 */
		public function get title():String
		{
			return _title;
		}
		
		public function set title(val:String):void
		{
			if (_title == val)
				return;
			
			_title = val;
			
			debugText.text = _title;
		}
		
		/**
		 * Defines if the template is run in debug mode.
		 */
		public function get debug():Boolean
		{
			return _debug;
		}
		
		public function set debug(val:Boolean):void
		{
			if (_debug == val)
				return;
			
			_debug = val;
			
			debugText.visible = _debug;
			stats.visible = _debug;
		}
		
		/**
		 * The scene object used in the template.
		 */
		public var scene:Scene3D;
		
		/**
		 * Creates a new <code>Template</code> object.
		 */
		public function Template()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		/**
		 * Starts the view rendering.
		 */
		public function start():void
		{
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		/**
		 * Stops the view rendering.
		 */
		public function stop():void
		{
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
	}
}