package
{
	import com.sleepydesign.components.DialogBalloon;
	import com.sleepydesign.display.SDSprite;
	import com.sleepydesign.net.LoaderUtil;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.events.Event;
	import flash.events.MouseEvent;

	[SWF(width="1680",height="822",frameRate="30",backgroundColor="#000000")]
	public class main extends SDSprite
	{
		private var container:Sprite;
		protected var _stageWidth:int;
		protected var _stageHeight:int;
		
		public function main()
		{
			stage.align = StageAlign.TOP_LEFT;
			
			addChild(LoaderUtil.loadAsset("bg.jpg"));
			
			container = new Sprite();
			container.x = stage.stageWidth/2;
			container.y = stage.stageHeight/2;
			addChild(container);
			
			var _cp:DisplayObject = container.addChild(LoaderUtil.loadAsset("CandlePage.swf"));
			_cp.x = -stage.stageWidth/2;
			_cp.y = -stage.stageHeight/2;
			
			var testButton:DialogBalloon = addChild(new DialogBalloon("click me for search!")) as DialogBalloon;
			testButton.mouseEnabled = true;
			testButton.buttonMode = true;
			testButton.addEventListener(MouseEvent.CLICK, function():void
			{
				Search.show();
			});
			
			testButton.x = 200;
			testButton.y = 200;
			
			/*
			x = 1680/2;
			y = 822/2
			*/
			
			_stageWidth = _stageWidth?_stageWidth:stage.stageWidth;
			_stageHeight = _stageHeight?_stageHeight:stage.stageHeight;
			
			// resize
			stage.addEventListener(Event.RESIZE, onResize);
		}
		
		private function draw():void
		{
			/*
			trace(" ! draw : " + _stageWidth, _stageHeight);
			//pos
			var _x0:int = int((_stageWidth-stage.stageWidth)/2);
			var _y0:int = int((_stageHeight-stage.stageHeight)/2);
			
			container.x = _x0 + stage.stageWidth/2;
			container.y = _y0 + stage.stageHeight/2;
			*/
		}
		
		private function onResize(event:Event):void
		{
			draw();
		}
	}
}