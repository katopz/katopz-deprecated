package com.sleepydesign.graphics.tools
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class SlicerTools extends Tools
	{
		private var firsthandle:Handle;
		private var lasthandle:Handle;
		
		private var segments:Array;
		private var handles:Array;

		public static var currentTool:Sprite;
		
		private var _segment:uint;
		
		public var maskShape:Sprite;

		public function SlicerTools(bitmapLayer:BitmapLayer, canvas:Sprite, segment:uint=8)
		{
			super(bitmapLayer, canvas);
			_segment = segment;
			
			maskShape = addChild(new Sprite()) as Sprite;
		}
		
		override public function set bitmap(value:Bitmap):void
		{
			super.bitmap = value;
			if(_bitmap)
			{
				// destroy
				for each(var handle:Handle in handles)
					handle.parent.removeChild(handle);
				
				// create
				createCircle(bitmapRectangle.x + bitmapRectangle.width / 2, bitmapRectangle.y + bitmapRectangle.height / 2, 50, 50, _segment);
				drawSegments();
			}
		}

		private function createCircle(ix:Number, iy:Number, ra:Number, rb:Number, quality:uint = 4):void
		{
			var step:Number = 2 * Math.PI / quality;
			var j:int = 0;
			
			segments = [];
			handles = [];

			for (var i:Number = 0; i <= 2 * Math.PI; i += step)
			{
				var px:Number;
				var py:Number;

				var rr:Number = (ra + rb) * .5;

				px = ix + ra * Math.cos(i);
				py = iy + rb * Math.sin(i);

				var segment:Segment = new Segment(px, py);
				segments.push(segment);

				var handle:Handle = new Handle(segment);
				addChild(handle);

				var ara:Number = 2.5 * ra * step / quality;
				var arb:Number = 2.5 * rb * step / quality;

				var apx:Number = px + ara * Math.cos(i + Math.PI / 2);
				var apy:Number = py + arb * Math.sin(i + Math.PI / 2);

				handle.setControlPoint(apx, apy);
				handles.push(handle);
			}

			firsthandle = handles[0];
			lasthandle = handles[handles.length - 1];
			lasthandle.mergeHandle = firsthandle;
			firsthandle.visible = false;
		}

		override protected function onMouseIsDown(event:MouseEvent):void
		{
			super.onMouseIsDown(event);
			if (event.target.parent is Handle)
			{
				Handle.current = event.target as Sprite;
				Handle(Handle.current.parent).onMousePress(Handle.current);
				addEventListener(Event.ENTER_FRAME, draw);
			}
		}

		private function getPointArray(s0:Segment, s1:Segment):Array
		{
			var p0:Point = s0.anchor;
			var p4:Point = s1.anchor;
			var p1:Point = p0.add(s0.controlF);
			var p3:Point = p4.add(s1.controlB);
			var p2:Point = Point.interpolate(p1, p3, 0.5);
			return [p0, p1, p2, p3, p4];
		}

		private function drawSegment(s0:Segment, s1:Segment):void
		{
			var pa:Array = getPointArray(s0, s1);
			maskShape.graphics.curveTo(pa[1].x, pa[1].y, pa[2].x, pa[2].y);
			maskShape.graphics.curveTo(pa[3].x, pa[3].y, pa[4].x, pa[4].y);
		}

		private function drawSegments():void
		{
			if (segments.length > 1)
			{
				maskShape.graphics.clear();
				maskShape.graphics.lineStyle(.25, 0x000000, .5);
				maskShape.graphics.beginFill(0xFFFFFF, .5);
				maskShape.graphics.moveTo(segments[0].anchor.x, segments[0].anchor.y);

				for (var i:int = 1; i < segments.length; ++i)
					drawSegment(segments[i - 1], segments[i]);
			}
		}

		override protected function draw(event:Event = null):void
		{
			Handle(Handle.current.parent).onDrag(Handle.current);
			drawSegments();
		}

		override protected function idle():void
		{
			removeEventListener(Event.ENTER_FRAME, draw);
		}
	}
}