package com.cutecoma.image.editors
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class TransformTool extends Tools
	{
		private var controls:Array;
		private var currentHandle:SizeHandle;

		private var cHandle:SizeHandle
		private var isDrag:Boolean = false;

		public function TransformTool(bitmapLayer:BitmapLayer, canvas:Sprite)
		{
			super(bitmapLayer, canvas);

			controls = [];

			bitmapLayer.addEventListener(MouseEvent.MOUSE_DOWN, onMouseIsDown);
			bitmapLayer.addEventListener(MouseEvent.MOUSE_UP, onMouseIsUp);
		}

		override public function set bitmap(value:Bitmap):void
		{
			super.bitmap = value;
			if (_bitmap)
			{
				_bitmap.smoothing = true;
				
				// destroy
				for each (var _sizeHandle:SizeHandle in controls)
				{
					_sizeHandle.parent.removeChild(_sizeHandle);
					_sizeHandle = null;
				}
				controls = [];

				// tl
				var tlSizeHandle:SizeHandle = new SizeHandle(bitmapRectangle.x, bitmapRectangle.y);
				controls[0] = addChild(tlSizeHandle);

				// br
				var brSizeHandle:SizeHandle = new SizeHandle(bitmapRectangle.x + bitmapRectangle.width, bitmapRectangle.y + bitmapRectangle.height);
				controls[1] = addChild(brSizeHandle);

				// c
				cHandle = new SizeHandle(bitmapRectangle.x + bitmapRectangle.width / 2, bitmapRectangle.y + bitmapRectangle.height / 2);
				controls[2] = addChild(cHandle);
			}
		}

		override protected function onMouseIsDown(event:MouseEvent):void
		{
			super.onMouseIsDown(event);

			//var _gPoint:Point = bitmapLayer.localToGlobal(new Point(bitmapLayer.x, bitmapLayer.y));
			//var _theta:Number = parent.parent.rotation; 
			//_gPoint.x = Math.cos(_theta*Math.PI/180);

			if (event.target is SizeHandle)
			{
				currentHandle = SizeHandle(event.target);
				SizeHandle(event.target).startDrag(false);
				removeEventListener(Event.ENTER_FRAME, draw);
				addEventListener(Event.ENTER_FRAME, draw);
			}
			else if (_bitmap && event.target == _bitmap.parent)
			{
				//if(_bitmap.hitTestPoint(_gPoint.x+event.localX, _gPoint.y+event.localY))
				{
					currentHandle = cHandle;
					cHandle.startDrag(false);
					removeEventListener(Event.ENTER_FRAME, draw);
					addEventListener(Event.ENTER_FRAME, draw);
				}
			}
			else
			{
				currentHandle = null;
			}
		}

		override protected function draw(event:Event = null):void
		{
			if (!_bitmap)
				return;
			
			_bitmap.smoothing = true;

			var tlSizeHandle:SizeHandle = controls[0];
			var brSizeHandle:SizeHandle = controls[1];
			var cHandle:SizeHandle = controls[2];

			var scaleFactorX:Number = _bitmap.scaleX > 0 ? 1 : -1;
			var scaleFactorY:Number = _bitmap.scaleY > 0 ? 1 : -1;

			// move
			if (currentHandle == cHandle)
			{
				tlSizeHandle.x = cHandle.x - scaleFactorX * _bitmap.width / 2;
				tlSizeHandle.y = cHandle.y - scaleFactorY * _bitmap.height / 2;

				brSizeHandle.x = cHandle.x + scaleFactorX * _bitmap.width / 2;
				brSizeHandle.y = cHandle.y + scaleFactorY * _bitmap.height / 2;
			}
			else
			{
				cHandle.x = (tlSizeHandle.x + brSizeHandle.x) / 2;
				cHandle.y = (tlSizeHandle.y + brSizeHandle.y) / 2;
			}

			// scale
			var _scaleX:Number = (brSizeHandle.x - tlSizeHandle.x) / bitmapRectangle.width;
			var _scaleY:Number = (brSizeHandle.y - tlSizeHandle.y) / bitmapRectangle.height;

			_bitmap.x = tlSizeHandle.x;
			_bitmap.y = tlSizeHandle.y;

			_bitmap.scaleX = _scaleX;
			_bitmap.scaleY = _scaleY;
		}

		public function moveTo(x:Number, y:Number):void
		{
			if (!_bitmap)
				return;
			
			_bitmap.smoothing = true;
			
			if(cHandle.x == x && cHandle.y == y)
				return;
			
			var tlSizeHandle:SizeHandle = controls[0];
			var brSizeHandle:SizeHandle = controls[1];
			var cHandle:SizeHandle = controls[2];
			
			cHandle.x = x;
			cHandle.y = y;

			var scaleFactorX:Number = _bitmap.scaleX > 0 ? 1 : -1;
			var scaleFactorY:Number = _bitmap.scaleY > 0 ? 1 : -1;

			tlSizeHandle.x = cHandle.x - scaleFactorX * _bitmap.width / 2;
			tlSizeHandle.y = cHandle.y - scaleFactorY * _bitmap.height / 2;

			brSizeHandle.x = cHandle.x + scaleFactorX * _bitmap.width / 2;
			brSizeHandle.y = cHandle.y + scaleFactorY * _bitmap.height / 2;

			cHandle.x = (tlSizeHandle.x + brSizeHandle.x) / 2;
			cHandle.y = (tlSizeHandle.y + brSizeHandle.y) / 2;

			_bitmap.x = tlSizeHandle.x;
			_bitmap.y = tlSizeHandle.y;
		}
		
		public function scaleTo(scaleX:Number, scaleY:Number):void
		{
			if (!_bitmap)
				return;
			
			_bitmap.smoothing = true;
			
			if(_bitmap.scaleX == scaleX && _bitmap.scaleY == scaleY)
				return;
				
			_bitmap.scaleX = scaleX;
			_bitmap.scaleY = scaleY;

			var tlSizeHandle:SizeHandle = controls[0];
			var brSizeHandle:SizeHandle = controls[1];
			var cHandle:SizeHandle = controls[2];

			var scaleFactorX:Number = _bitmap.scaleX > 0 ? 1 : -1;
			var scaleFactorY:Number = _bitmap.scaleY > 0 ? 1 : -1;

			tlSizeHandle.x = cHandle.x - scaleFactorX * _bitmap.width / 2;
			tlSizeHandle.y = cHandle.y - scaleFactorY * _bitmap.height / 2;

			brSizeHandle.x = cHandle.x + scaleFactorX * _bitmap.width / 2;
			brSizeHandle.y = cHandle.y + scaleFactorY * _bitmap.height / 2;

			cHandle.x = (tlSizeHandle.x + brSizeHandle.x) / 2;
			cHandle.y = (tlSizeHandle.y + brSizeHandle.y) / 2;

			_bitmap.x = tlSizeHandle.x;
			_bitmap.y = tlSizeHandle.y;
		}

		override protected function idle():void
		{
			if (currentHandle)
				currentHandle.stopDrag();

			if (hasEventListener(Event.ENTER_FRAME))
				removeEventListener(Event.ENTER_FRAME, draw);

			currentHandle = null;
			draw();
		}
	}
}