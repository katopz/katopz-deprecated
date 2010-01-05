package
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	import net.badimon.five3D.display.Bitmap3D;
	import net.badimon.five3D.display.Scene3D;
	import net.badimon.five3D.display.Sprite3D;
	import net.hires.debug.Stats;

	/*
	TODO:
	1. create fake dot data array (1000 x 500 = 500,000)
	2. read data and wirte to map as set pixel (10,000-100,000)
	3. add view controller move/pan/rotate
	4. add click to view msg (getPixel)
	5. create candle with perlin noise flame (BitmapSprite Clip?)
	6. add button and move to prefer angle view for place candle
	7. add dialog to get user input (name, msg)
	8. send data to server
	9. add blur/glow effect
	10. add LOD setpixel <-> copypixel 
	
	*/
	[SWF(width="640", height="480", frameRate="30", backgroundColor="#FFFFFF")]
	public class main extends Sprite
	{
		[Embed(source="assets/thai_map.txt", mimeType="application/octet-stream")]
		private var ThaiMap:Class;
		private var _map:SVG3D;

/*
		[Embed(source="assets/thai_map.swf")]
		private var ThaiMapSWF:Class;
*/
[Embed(source="assets/thai_map.png")]
		private var ThaiMapPNG:Class;
		private var _scene:Scene3D;
		
		public function main()
		{
			// setup
			stage.scaleMode = StageScaleMode.NO_SCALE;

			_scene = new Scene3D();
			_scene.x = stage.stageWidth / 2;
			_scene.y = stage.stageHeight / 2;
			addChild(_scene);

			// svg map
			//_map = new SVG3D(new ThaiMap() as ByteArray, 1, -410.656 / 2, -758.187 / 2);
			//_scene.addChild(_map);
			//clip = new ThaiMapSWF() as Sprite;
			//clip.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			//addChild(clip);
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		private var clip:Sprite 
		
		protected function onInit(event:Event):void
		{
			trace("onInit");
		}
		
		protected function onAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			/*
			var _clip:Sprite = new Sprite();
			_clip.graphics.beginFill(0xFF0000, .5);
			_clip.graphics.drawCircle(0,0,100);
			_clip.graphics.endFill();
			_clip.addChild(clip);
			*/
			//var bmpData:BitmapData = new BitmapData(410.656, 758.187, true, 0xCC000000);
			//bmpData.draw(_clip);
			//var bitmap:Bitmap = new Bitmap(bmpData);
			var bitmap:Bitmap = new ThaiMapPNG as Bitmap
			//addChild(bitmap);
			
			_canvas = new Sprite3D();
			
			var _bitmap:Bitmap3D = new Bitmap3D(bitmap.bitmapData);
			
			_canvas.addChild(_bitmap);
			_scene.addChild(_canvas);
			
			_canvas.rotationX = -45;
			_canvas.rotationY = 0;
			_canvas.rotationZ = 0;

			// draw
			addEventListener(Event.ENTER_FRAME, starEnterFrameHandler);
			
			// debug
			addChild(new Stats());
		}
private var _canvas:Sprite3D
		private function starEnterFrameHandler(event:Event):void
		{
			_canvas.rotationZ++;
		}
	}
}