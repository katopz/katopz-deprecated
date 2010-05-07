package com.cutecoma.image.editors
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;

	public class Handle extends Sprite
	{
		public var segment:Segment;
		private var fillColor:Number = 0xFFFF00;
		private var mcAnchor:MovieClip;

		private var mcControlF:Sprite;
		private var mcControlB:Sprite;

		private var draggingF:Boolean;
		private var revCtrlLength:Number;
		private static var id:Number = 0;

		public var mergeHandle:Handle;

		public static var current:Sprite;

		public function Handle(iSegment:Segment)
		{
			segment = iSegment;
			name = "handle_" + id++;

			x = segment.anchor.x;
			y = segment.anchor.y;

			mcControlF = createControlHandle("control_F");
			mcControlB = createControlHandle("control_B");

			createAnchorHandle(fillColor);

			update();
		}

		private function createAnchorHandle(fillColor:Number = 0xFFFF00):void
		{
			var mc:Sprite = addChild(new Sprite()) as Sprite;
			mc.name = "anchor_" + id;
			var size:int = 6;
			mc.graphics.lineStyle(0.5, 0x000000);
			mc.graphics.moveTo(size, -size);
			mc.graphics.beginFill(fillColor, 0.5);
			mc.graphics.lineTo(size, size);
			mc.graphics.lineTo(-size, size);
			mc.graphics.lineTo(-size, -size);
			mc.graphics.lineTo(size, -size);
			mc.graphics.endFill();
		}

		private function createControlHandle(name:String):Sprite
		{
			var mc:Sprite = addChild(new Sprite()) as Sprite;
			mc.name = name;
			var size:int = 6;
			mc.graphics.lineStyle(-1, 0xFFFF00);
			mc.graphics.moveTo(0, -size);
			mc.graphics.beginFill(fillColor);
			mc.graphics.lineTo(size, 0);
			mc.graphics.lineTo(0, size);
			mc.graphics.lineTo(-size, 0);
			mc.graphics.lineTo(0, -size);
			mc.graphics.endFill();
			return mc;
		}

		public function setControlPoint(x:Number, y:Number):void
		{
			segment.controlF.x = x - segment.anchor.x;
			segment.controlF.y = y - segment.anchor.y;
			segment.controlB.x = -segment.controlF.x;
			segment.controlB.y = -segment.controlF.y;
			update();
		}

		public function onMousePress(target:*):void
		{
			switch (String(target.name).split("_")[0])
			{
				case "anchor":
					//
					break;
				case "control":
					onControlPress(target);
					if (mergeHandle)
					{
						mergeHandle.onControlPress(target);
					}
					break;
			}
		}

		public function onDrag(target:*):void
		{
			switch (String(target.name).split("_")[0])
			{
				case "anchor":
					onAnchorDrag();
					if (mergeHandle)
					{
						mergeHandle.onAnchorDrag();
					}
					break;
				case "control":
					onControlDrag(target);
					if (mergeHandle)
					{
						mergeHandle.onControlDrag(target);
					}
					break;
			}
		}

		private function onAnchorDrag():void
		{
			segment.anchor = new Point(parent.mouseX, parent.mouseY);
			x = segment.anchor.x;
			y = segment.anchor.y;
		}

		private function onControlPress(c:*):void
		{
			draggingF = (c == mcControlF);
			if (draggingF)
			{
				revCtrlLength = segment.controlB.length;
			}
			else
			{
				revCtrlLength = segment.controlF.length;
			}
		}

		private function onControlDrag(iControl:*):void
		{
			var mousePoint:Point = new Point(mouseX, mouseY);
			var ratio:Number = revCtrlLength ? -revCtrlLength / mousePoint.length : -1;
			if (iControl.name == "control_F")
			{
				segment.controlF = mousePoint;
				if (!Tools.isCTRL)
				{
					segment.controlB = mousePoint.clone();
					segment.controlB.x *= ratio;
					segment.controlB.y *= ratio;
				}
			}
			else
			{
				segment.controlB = mousePoint;
				if (!Tools.isCTRL)
				{
					segment.controlF = mousePoint.clone();
					segment.controlF.x *= ratio;
					segment.controlF.y *= ratio;
				}
			}
			update();
		}

		public function update():void
		{
			mcControlF.visible = Boolean(segment.controlF.length);
			mcControlB.visible = Boolean(segment.controlB.length);
			mcControlF.x = segment.controlF.x;
			mcControlF.y = segment.controlF.y;
			mcControlB.x = segment.controlB.x;
			mcControlB.y = segment.controlB.y;
			graphics.clear();
			graphics.lineStyle(-1, 0xFFFF00, 80);
			graphics.moveTo(mcControlB.x, mcControlB.y);
			graphics.lineTo(0, 0);
			graphics.lineTo(mcControlF.x, mcControlF.y);
		}
	}
}