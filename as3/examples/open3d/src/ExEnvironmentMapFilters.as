package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	
	import open3d.filters.EnvMapFilter;
	import open3d.materials.BitmapMaterial;
	import open3d.objects.Plane;
	import open3d.view.SimpleView;
	
	/**
	 * Native FP10 3D Environment Mapping demo
	 * 
	 * @author David Lenaerts
	 * http://www.derschmale.com
	 */
	
	[SWF(width="600", height="600", frameRate="30", backgroundColor="0x000000")]
	public class ExEnvironmentMapFilters extends SimpleView
	{
		[Embed(source="assets/bagger.jpg")]
		private var Texture : Class;
		
		[Embed(source="assets/normalmap.jpg")]
		private var NormalMap : Class;
		
		[Embed(source="assets/left.jpg")]
		private var ReflLeft : Class;
		
		[Embed(source="assets/right.jpg")]
		private var ReflRight : Class;
		
		[Embed(source="assets/front.jpg")]
		private var ReflFront : Class;
		
		[Embed(source="assets/back.jpg")]
		private var ReflBack : Class;
		
		[Embed(source="assets/top.jpg")]
		private var ReflTop : Class;
		
		[Embed(source="assets/bottom.jpg")]
		private var ReflBottom : Class;
		
		private var _startX : Number;
		private var _startY : Number;
		
		private var _mouseDown : Boolean;
		
		private var _surface : Sprite;
		
		private var _filter : EnvMapFilter;
		
		private var plane:Plane;
		private var step:Number=0;
		
		private var bitmapData:BitmapData;
		
		override protected function create():void
		{
			initView();
			initFilter();
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
			stage.addEventListener(KeyboardEvent.KEY_UP, handleKeyUp);
			//addEventListener(Event.ENTER_FRAME, handleEnterFrame);
			//addChild(new Stats());
		}
		
		private function initView() : void
		{
			removeChild(renderer.view);
			
			// init background
			var bg : Bitmap = new Bitmap(new ReflBack().bitmapData);
			bg.width = stage.stageWidth;
			bg.height = stage.stageWidth;
			addChild(bg);
			
			// add on top
			addChild(renderer.view);
			
			var textField : TextField = new TextField();
			textField.textColor = 0xffffff;
			textField.multiline = true;
			textField.text = 	"Click & drag : Rotate surface\n" + 
								"+/- : Change surface reflectance\n" + 
								"PgUp/PgDown : Change surface relief";
			textField.width = textField.textWidth + 10;
			textField.height = textField.textHeight + 10;
			textField.x = stage.stageWidth-textField.width;
			addChild(textField);
			// init rotatable surface, make sure registration point is in center
			var bmp : Bitmap = new Texture();
			//bmp.x = -bmp.width*.5;
			//bmp.y = -bmp.height*.5;
			_surface = new Sprite();
			_surface.addChild(bmp);
			
			// higher z gives better reflections
			_surface.z = 1000;
			
			// position and scale
			_surface.x = stage.stageWidth*.5;
			_surface.y = stage.stageHeight*.5;
			
			_surface.scaleY = 2;
			_surface.scaleX = 4;
			
			addChild(_surface);
			_surface.visible = false;
			
			bitmapData = bmp.bitmapData;
			
			var planeMaterial:BitmapMaterial = new BitmapMaterial(bitmapData);
			
			plane = new Plane(_surface.width, _surface.height, planeMaterial, 10, 10);
			renderer.addChild(plane);
			plane.rotationX = -45;
		}
		
		private function handleKeyUp(event : KeyboardEvent) : void
		{
			switch(event.keyCode) {
				case 107:	// +
					_filter.alpha += 0.1;
					if (_filter.alpha > 1) _filter.alpha = 1;
					_surface.filters = [_filter];
					bitmapData.draw(_surface);
					break;
				case 109:	// -
					_filter.alpha -= 0.1;
					if (_filter.alpha < 0.0) _filter.alpha = 0.0;
					_surface.filters = [_filter];
					bitmapData.draw(_surface);
					break;
				case Keyboard.PAGE_UP:
					_filter.normalMapStrength += 0.005;
					if (_filter.normalMapStrength > 0.1) _filter.normalMapStrength = 0.1;
					_surface.filters = [_filter];
					bitmapData.draw(_surface);
					break;
				case Keyboard.PAGE_DOWN:
					_filter.normalMapStrength -= 0.005;
					if (_filter.normalMapStrength < 0.0) _filter.normalMapStrength = 0.0;
					_surface.filters = [_filter];
					bitmapData.draw(_surface);
					break;
			}
		}
		
		/**
		 * Create the EnvMapFilter object and assign it to the surface
		 */
		private function initFilter() : void
		{
			var faces : Array = [];
			faces[EnvMapFilter.LEFT] = new ReflLeft().bitmapData;
			faces[EnvMapFilter.RIGHT] = new ReflRight().bitmapData;
			faces[EnvMapFilter.TOP] = new ReflTop().bitmapData;
			faces[EnvMapFilter.BOTTOM] = new ReflBottom().bitmapData;
			faces[EnvMapFilter.FRONT] = new ReflFront().bitmapData;
			faces[EnvMapFilter.BACK] = new ReflBack().bitmapData; 
			
			_filter = new EnvMapFilter(faces, .5, new NormalMap().bitmapData, 0.03);
			_filter.update(_surface);
			_surface.filters = [ _filter ];
			
			// draw or apply filter
			bitmapData.draw(_surface);
		}
		
		private function handleMouseDown(event : MouseEvent) : void
		{
			_mouseDown = true;
			_startX = mouseX;
			_startY = mouseY;
		}
		
		private function handleMouseUp(event : MouseEvent) : void
		{
			_mouseDown = false;
		}
		
		override protected function draw():void
		{
			if (_mouseDown) {
		 		_surface.rotationY += (_startX-mouseX)*.01;
		 		_surface.rotationX += (_startY-mouseY)*.01;
		 		
		 		renderer.world.rotationX = _surface.rotationX;
		 		renderer.world.rotationY = _surface.rotationY;
		 		
		 		_filter.update(_surface);
		 		_surface.filters = [ _filter ];
		 		
		 		// draw or apply filter
				bitmapData.draw(_surface);
		 	}
		 	
			for (var i:int = 0; i<plane.vin.length/3; ++i)
			{
				plane.setVertices(i, "z", (i+1)*0.1*Math.sin(step+i/10));
				step+=0.001;
			}
		}
	}
}