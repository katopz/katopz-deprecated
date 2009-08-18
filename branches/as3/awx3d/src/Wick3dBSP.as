package {
	import com.derschmale.wick3d.cameras.Camera3D;
	import com.derschmale.wick3d.core.bsp.BspTree;
	import com.derschmale.wick3d.core.pipeline.BSPRenderPipeline;
	import com.derschmale.wick3d.debug.StatsDisplay;
	import com.derschmale.wick3d.display3D.World3D;
	import com.derschmale.wick3d.display3D.primitives.Cube3D;
	import com.derschmale.wick3d.display3D.primitives.SphereUV;
	import com.derschmale.wick3d.display3D.primitives.Torus;
	import com.derschmale.wick3d.materials.TextureMaterial;
	import com.derschmale.wick3d.view.Viewport;
	
	import flash.display.GradientType;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	
	[SWF(backgroundColor="0x000000", frameRate="30", width="640", height="480")]
	public class Wick3dBSP extends Sprite
	{	
		[Embed(source="/assets/whiteTexture.jpg")]
		private var _texture : Class;
		
		[Embed(source="/assets/whiteTexture.jpg")]
		private var _texture2: Class;
		
		[Embed(source="/assets/whiteTexture.jpg")]
		private var _texture3: Class;
		
		private var _world : World3D;
		private var _stats : StatsDisplay;
		private var _renderer : BSPRenderPipeline;
		private var _camera : Camera3D;
		private var _bspTree : BspTree;
		private var _renderTarget : Viewport;
		
		private var _material1 : TextureMaterial;
		
		private var _angle : Number = 0;
		
		public function Wick3dBSP()
		{		
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.quality = StageQuality.MEDIUM;
			
			initScreen();
			initWick3d();
			
			addEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
			addEventListener(Event.ENTER_FRAME, handleEnterFrame);
		}
		
		/**
		 * Draw the background
		 */
		private function initScreen() : void
        {
        	var bg : MovieClip = new MovieClip();
            var matrix : Matrix = new Matrix();
            matrix.createGradientBox(stage.stageWidth, stage.stageHeight, Math.PI*.5);
            bg.graphics.beginGradientFill(GradientType.LINEAR, [0xffffff, 0xcccccc, 0xffffff], [1, 1, 1], [20, 60, 200], matrix);
            bg.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
            bg.graphics.endFill();
            addChild(bg);
        }
        
		/**
		 * Create the 3D scene
		 */
		private function initWick3d() : void
		{
		//
		// create the basic 3D elements needed for a scene
		//
			// the world containing the 3D objects (ie: the topmost container in the 3D hierarchy)
			_world = new World3D();					
			
			// a normal camera
			_camera = new Camera3D();
			_camera.x = 0;
			_camera.y = 100;
			_camera.z = -200;
			
			_renderTarget = new Viewport(true);		// the target to render to
			addChild(_renderTarget);				// add it to the stage
			
			createObjects();
			
		// the camera should always look at the cube
			_camera.target = _world;
			
		// create a bsp tree based on the world (bsp trees cannot contain moving elements due to heavy cost in constructing)
			_bspTree = new BspTree(_world);
			
		// create a render pipeline especially for bsp trees
			_renderer = new BSPRenderPipeline(_bspTree);
			
		// create the stat display
			_stats = new StatsDisplay(0x000000);
			addChild(_stats);
		}
		
		/**
		 * Create some random cubes
		 */
		private function createObjects() : void
		{
			// create the material
			_material1 = new TextureMaterial(new _texture().bitmapData);
			
			var cube : Cube3D;
			for (var i : int = 0; i < 7; i++) {
				cube = new Cube3D(_material1, Math.random()*75+25, 1, 1, 1);
				cube.x = (Math.random()-.5)*150;
				cube.y = (Math.random()-.5)*150;
				cube.z = (Math.random()-.5)*150;
				cube.rotationX = (Math.random()-.5)*Math.PI;
				cube.rotationY = (Math.random()-.5)*Math.PI;
				cube.rotationZ = (Math.random()-.5)*Math.PI;
				_world.addChild(cube);
			}
		}

		private function handleEnterFrame(event : Event) : void
		{
			// make the camera orbit the center of the world 
			_camera.x = Math.sin(_angle)*200;
			_camera.z = -Math.cos(_angle)*200;
			_angle += 0.01;
			
			// render the 3D world using the camera and the target viewport
			_renderer.render(_world, _camera, _renderTarget);
		}
		
		private function handleMouseMove(event : MouseEvent) : void
		{
			// move the camera up/down according to mouse position
			var relY : Number = mouseY/stage.stageHeight-.5;
			_camera.y = Math.sin(relY*2)*200;
		}
	}
}