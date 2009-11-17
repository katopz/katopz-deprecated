package
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.NativeWindow;
	import flash.display.NativeWindowInitOptions;
	import flash.display.NativeWindowSystemChrome;
	import flash.display.NativeWindowType;
	import flash.display.Screen;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NativeWindowBoundsEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;

	public class ImagePreview extends NativeWindow
	{
		private var _file:File;
		private var _tile:TileUnit;
		private var sprite:Sprite;

		public function ImagePreview(tile:TileUnit)
		{
			var winArgs:NativeWindowInitOptions = new NativeWindowInitOptions();
			winArgs.type = NativeWindowType.UTILITY;
			winArgs.systemChrome = NativeWindowSystemChrome.NONE;
			winArgs.transparent = true;
			super(winArgs);
			
			this.title = "FileTile Preview";
			this.visible = false;

			this.stage.align = StageAlign.TOP_LEFT;
			this.stage.scaleMode = StageScaleMode.NO_SCALE;

			this.addEventListener(NativeWindowBoundsEvent.MOVE, onResize);

			this._tile = tile;
			this._file = tile.file;

			this.sprite = new Sprite();
			this.sprite.addEventListener(MouseEvent.CLICK, onClick);
			this.sprite.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			this.sprite.x = 0;
			this.sprite.y = 0;
			this.stage.addChild(sprite);

			var imageBytes:ByteArray = new ByteArray();
			var stream:FileStream = new FileStream();
			stream.open(this._file, FileMode.READ);
            stream.readBytes(imageBytes);
            stream.close();
            var loader:Loader = new Loader();
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
            loader.loadBytes(imageBytes);
		}

		public function get tile():TileUnit
		{
			return this._tile;
		}

        private function onComplete(event:Event):void
        {
        	var loaderInfo:LoaderInfo = event.currentTarget as LoaderInfo;
        	var loader:Loader = loaderInfo.loader;

        	var screenBounds:Rectangle = Screen.mainScreen.bounds;
        	var usableWidth:uint = screenBounds.width - 80;
        	var usableHeight:uint = screenBounds.height - 100;

			var iconRotation:uint = _tile.iconCanvas.rotation;

        	var loaderWidth:uint;
        	var loaderHeight:uint;
        	var usabelWidth:uint;
        	var usabelHeight:uint;

        	if (iconRotation == 0 || iconRotation == 180)
        	{
        		loaderWidth = loaderInfo.width;
        		loaderHeight = loaderInfo.height;
        	}
        	else
        	{
        		loaderWidth = loaderInfo.height;
        		loaderHeight = loaderInfo.width;
        	}

			if (loaderWidth > usableWidth)
			{
				var xFactor:Number = usableWidth / loaderWidth;
				loader.scaleX = xFactor;
				loader.scaleY = xFactor;
			}
			if (loaderHeight > usableHeight)
			{
				var yFactor:Number = usableHeight / loaderHeight;
				loader.scaleX = yFactor;
				loader.scaleY = yFactor;
			}
			
			switch (iconRotation)
			{
				case 0:
					loader.x = 0;
					loader.y = 0;
					loaderWidth = loader.width;
					loaderHeight = loader.height;
					break;
				case 90:
					loaderWidth = loader.height;
					loaderHeight = loader.width;
					loader.x = loaderWidth;
					loader.y = 0;
					loader.rotation = 90;
					break;
				case 180:
					loaderWidth = loader.width;
					loaderHeight = loader.height;
					loader.x = loaderWidth;
					loader.y = loaderHeight;
					loader.rotation = 180;
					break;
				default:
					loaderWidth = loader.height;
					loaderHeight = loader.width;
					loader.x = 0;
					loader.y = loaderHeight;
					loader.rotation = 270;
					break;
			}

			loader.x += 12;
			loader.y += 12;
			this.sprite.addChild(loader);

			var windowBounds:Rectangle = new Rectangle((screenBounds.width / 2) - (loaderWidth / 2),
													   (screenBounds.height / 2) - (loaderHeight / 2),
													   loaderWidth + 25,
													   loaderHeight + 25);
			this.bounds = windowBounds;
		}

		protected function onResize(e:NativeWindowBoundsEvent):void
		{
			var w:uint = e.afterBounds.width;
			var h:uint = e.afterBounds.height;
		
			// Rounded corners
			this.sprite.graphics.clear();
			this.sprite.graphics.beginFill(0x000000, .75);
			this.sprite.graphics.drawRoundRectComplex(0, 0, w, h, 10, 10, 10, 10);
			this.sprite.graphics.endFill();

			// Close button circle
			this.sprite.graphics.beginFill(0xffffff, .75);
			this.sprite.graphics.drawCircle(w - 8, 8, 5);
			this.sprite.graphics.endFill();

			// Close button "X"
			this.sprite.graphics.lineStyle(2, 0x000000, .75);
			this.sprite.graphics.moveTo(w - 10, 6);
			this.sprite.graphics.lineTo(w - 6, 10);
			this.sprite.graphics.moveTo(w - 6, 6);
			this.sprite.graphics.lineTo(w - 10, 10);
			this.sprite.graphics.endFill();
			this.stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);  // Goofy hack to avoid the flash of move/resize
		}
		
		private function onEnterFrame(e:Event):void
		{
			this.stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			this.visible = true;
		}
		
		private function onMouseDown(e:MouseEvent):void
		{
			this.startMove();
		}

		private function onClick(e:MouseEvent):void
		{
			if (e.localX >= (this.width - 13) && e.localX <= (this.width - 3) && e.localY >= 3 && e.localY <= 13) // Close
			{
				this.close();
			}
		}

	}
}