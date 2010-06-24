package com.cutecoma.playground.editors
{
	import away3dlite.arcane;
	import away3dlite.cameras.Camera3D;
	import away3dlite.core.base.Face;
	import away3dlite.events.Keyboard3DEvent;
	import away3dlite.events.MouseEvent3D;
	import away3dlite.primitives.Trident;
	import away3dlite.ui.Keyboard3D;
	
	import com.cutecoma.game.core.IEngine3D;
	import com.cutecoma.playground.core.Area;
	import com.cutecoma.playground.events.AreaEditorEvent;
	import com.cutecoma.playground.events.GroundEvent;
	import com.cutecoma.playground.events.SDMouseEvent;
	import com.sleepydesign.components.SDDialog;
	import com.sleepydesign.events.EventManager;
	import com.sleepydesign.events.RemovableEventDispatcher;
	import com.sleepydesign.net.LoaderUtil;
	import com.sleepydesign.text.SDTextField;
	import com.sleepydesign.ui.SDMouse;
	import com.sleepydesign.utils.StringUtil;
	
	import flash.display.BitmapData;
	import flash.display.StageAlign;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;

	use namespace arcane;

	public class AreaEditor extends RemovableEventDispatcher
	{
		private var _engine3D:IEngine3D;
		private var _area:Area;

		private var _paintColor:String;
		private var _rollOverColor:String;

		public function set paintColor(value:String):void
		{
			_paintColor = value;
			_codeText.borderColor = Number(_paintColor);
			_codeText.text = _paintColor; //StringUtil.hex(_paintColor).split("0x").join("0xFF");

			if (_rollOverColor)
				_codeText.text = _paintColor + ", " + _rollOverColor;
			else
				_codeText.text = _paintColor;
		}

		public function AreaEditor(engine3D:IEngine3D)
		{
			_engine3D = engine3D;

			/*
			   // log
			   var bg:SDSquare = new SDSquare(this.width, this.height, 0xFF0000);
			   addChild(bg);

			   bg.setSize(this.width, this.height);
			 */

			// controller
			/*
			   Game.inputController = new InputController(_engine3D.systemLayer, true, true);
			   Game.inputController.mouse.addEventListener(SDMouseEvent.MOUSE_DRAG, onMouseIsDrag, false, 0 ,true);
			   Game.inputController.keyboard.addEventListener(SDKeyboardEvent.KEY_PRESS, onKeyIsPress, false, 0 ,true);
			   Game.inputController.mouse.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel, false, 0 ,true);

			   Game.inputController.keyboard.addEventListener(KeyboardEvent.KEY_DOWN, onKeyIsDown, false, 0 ,true);
			 */

			_codeText = new SDTextField("0x000000");
			_codeText.autoSize = "left";
			_codeText.background = true;
			_codeText.backgroundColor = 0xDDDDDD;
			_codeText.border = true;
			_codeText.borderColor = 0x000000;

			paintColor = "0x000000";
			_helpToolDialog = new SDDialog(<question>
					<![CDATA[1. Right Click to load Background<br/>2. Use WASD CV QE to move view.<br/>3. Use NUMPAD or CTRL+NUMPAD to +,- map size.<br/>4. Use CTRL+DRAG to move camera.<br/>5. Use Wheel or +/- to zoom, (+CTRL to focus)]]>
				</question>, this, StageAlign.TOP_RIGHT);
			_engine3D.systemLayer.addChild(_helpToolDialog);

			_helpToolDialog.alpha = .9;
			_buildToolDialog = new SDDialog(<question><![CDATA[Select type to draw Area.]]>
					<answer src="as:onSelectType('0')"><![CDATA[Unwalkable Area]]></answer>
					<answer src="as:onSelectType('1')"><![CDATA[Walkable Area]]></answer>
					<answer src="as:onSelectType('2')"><![CDATA[Spawn point]]></answer>
					<answer src="as:onSelectType('warp')"><![CDATA[Warp point]]></answer>
				</question>, this, "center");

			_buildToolDialog.alpha = .9;

			_engine3D.systemLayer.addChild(_buildToolDialog);
			_engine3D.systemLayer.addChild(_codeText);

			// debug
			_engine3D.scene3D.addChild(new Trident);

			// controller
			new Keyboard3D(_engine3D.systemLayer.stage, onKey).addEventListener(Keyboard3DEvent.KEY_PRESS, onKeyIsPress);
			var _mouse:SDMouse = new SDMouse(_engine3D.systemLayer.stage);

			//_mouse.addEventListener(SDMouseEvent.MOUSE_DOWN, onMouseIsDown);
			_mouse.addEventListener(SDMouseEvent.MOUSE_DRAG, onMouseIsDrag);
			_mouse.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
		}

		public function setArea(area:Area):void
		{
			_area = area;

			if (_area.ground)
			{
				//_area.ground.addEventListener(GroundEvent.MOUSE_DOWN, onTileClick);
				//_area.ground.addEventListener(GroundEvent.MOUSE_MOVE, onTileMouseMove);
				_area.mouseSignal.add(onTileClick);
			}
			_engine3D.systemLayer.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		}

		private var _helpToolDialog:SDDialog;
		private var _buildToolDialog:SDDialog;
		private var _codeText:SDTextField;

		private var areaPanel:AreaPanel;

		public function onSelectType(colorID:String):void
		{
			switch (colorID)
			{
				case "0":
					paintColor = "0x000000";
					break;
				case "1":
					paintColor = "0xFFFFFF";
					break;
				case "2":
					paintColor = "0x0000FF";
					break;
				default:
					// wait for user select area
					showAreaPanel(onAreaIDChange);
					break;
			}
		}

		/*
		   private function onAreaPanelLoad(event:Event):void
		   {
		   if(event.type!="complete")
		   return;

		   areaPanel = event.target.content as AreaPanel;
		   _engine3D.systemLayer.addChild(areaPanel);
		   EventManager.addEventListener(AreaEditorEvent.AREA_ID_CHANGE, onAreaIDChange);
		   }
		 */

		private function onAreaIDChange(event:AreaEditorEvent):void
		{
			EventManager.removeEventListener(AreaEditorEvent.AREA_ID_CHANGE, onAreaIDChange);
			areaPanel.visible = false;
			paintColor = "0x00FF" + event.areaID;
		}

		public function showAreaPanel(callback:Function):void
		{
			if (!areaPanel)
			{
				LoaderUtil.loadAsset("AreaPanel.swf", function onAreaPanelLoad(event:Event):void
					{
						if (event.type != "complete")
							return;

						areaPanel = event.target.content as AreaPanel;
						_engine3D.systemLayer.addChild(areaPanel);
						EventManager.addEventListener(AreaEditorEvent.AREA_ID_CHANGE, callback);
					});
			}
			else
			{
				areaPanel.visible = true;
				EventManager.addEventListener(AreaEditorEvent.AREA_ID_CHANGE, callback);
			}
		}

		public function setupBackground():void
		{
			//SDApplication.system.addEventListener(SDEvent.COMPLETE, onOpenBackgroundComplete);
			_area.background.open();
		}

		/*
		   public function toggleMap(map:Map):void
		   {
		   if(map.scaleX==1)
		   {
		   map.scaleX = 5;
		   map.scaleY = 5;
		   }else{
		   map.scaleX = 1;
		   map.scaleY = 1;
		   }

		   map.x = area.stage.stageWidth - map.width;
		   map.y = 0;//stage.stageHeight/2 - map.height/2;
		   }
		 */

		/*
		   private function onMapClick(event:MouseEvent):void
		   {
		   trace( " ^ onClick:", event.target, event.currentTarget);
		   }
		 */

		/*
		   private function onOpenBackgroundComplete(event:SDEvent):void
		   {
		   trace(" onOpenBackgroundComplete");
		   SDApplication.system.removeEventListener(SDEvent.COMPLETE, onOpenBackgroundComplete);

		   // destroy
		   area.background.destroy();

		   // logical
		   //area.data.background = SystemUtil.openFileName;

		   // physical
		   var loader:Loader = new Loader();
		   loader.loadBytes(event.data);
		   area.background.addChild(loader);
		   }
		 */

		private function onKey(event:KeyboardEvent):void
		{
			switch (event.type)
			{
				case KeyboardEvent.KEY_DOWN:

					var _bitmapData:BitmapData = _area.map.data.bitmapData; //.clone();
					var _rect:Rectangle = _bitmapData.rect;

					// NUM 1 -> 9
					// 97 -> 105
					switch (event.keyCode - 96)
					{
						//-
						case 13:
							zoom(event.shiftKey ? -5 : -1);
							break;
						//+
						case 11:
							zoom(event.shiftKey ? 5 : 1);
							break;
						case 8:
							if (event.ctrlKey)
								_rect.y++;
							else
								_rect.y--;
							break;
						case 2:
							if (event.ctrlKey)
								_rect.height--;
							else
								_rect.height++;
							break;
						case 4:
							if (event.ctrlKey)
								_rect.x++;
							else
								_rect.x--;
							break;
						case 6:
							if (event.ctrlKey)
								_rect.width--;
							else
								_rect.width++;
							break;
						default:
							return;
							break;
					}

					var _width:int = -_rect.x + _rect.width;
					var _height:int = -_rect.y + _rect.height;

					_width = _width > 0 ? _width : 1;
					_height = _height > 0 ? _height : 1;

					//_area.map.data.bitmapData.dispose();

					_area.map.data.bitmapData = new BitmapData(_width, _height, true, 0xFFFFFFFF);
					_area.map.data.bitmapData.draw(_bitmapData, new Matrix(1, 0, 0, 1, -_rect.x, -_rect.y));
					_area.ground.updateBitmapData(_area.map.data.bitmapData);

					_bitmapData.dispose();
					_bitmapData = null;
					break;
			}
		}

		private function onKeyIsPress(event:Keyboard3DEvent):void
		{
			// void while select area
			if (areaPanel && areaPanel.visible)
				return;

			var _camera3D:Camera3D = _engine3D.view3D.camera;
			var _matrix3D:Matrix3D = _camera3D.transform.matrix3D;
			var _f:Vector3D = Vector3D(event.data).clone();
			
			if (Keyboard3D.isSHIFT)
			{
				_f.scaleBy(10);
				_f.w *= 10;
			}
			
			// position
			_matrix3D.position = _matrix3D.transformVector(_f);
			
			// rotationZ
			_camera3D.roll(_f.w*.1);
		}

		private function onMouseIsDrag(event:SDMouseEvent):void
		{
			// void while select area
			if (areaPanel && areaPanel.visible)
				return;

			if (!Keyboard3D.isCTRL)
				return;

			var _camera3D:Camera3D = _engine3D.view3D.camera;
			
			// rotationX
			_camera3D.pitch(event.data.dy * .1);
			
			// rotationY
			_camera3D.yaw(event.data.dx * .1);
		}

		private function onMouseWheel(event:MouseEvent):void
		{
			// void while select area
			if (areaPanel && areaPanel.visible)
				return;

			zoom(event.delta * (event.shiftKey ? 10 : 1) / 5);
		}

		private function zoom(delta:Number):void
		{
			var _camera:Camera3D = _engine3D.view3D.camera;
			//_projection.focalLength = _camera.zoom * _camera.focus;
			if (Keyboard3D.isCTRL)
			{
				var nextFocus:Number = _camera.focus + delta;
				if ((nextFocus > 0) && (nextFocus < 100))
					_camera.focus += (nextFocus - _camera.focus) / 2;
			}
			else
			{
				var nextZoom:Number = _camera.zoom + delta / 10;
				if ((nextZoom > 0) && (nextZoom < 100))
					_camera.zoom += (nextZoom - _camera.zoom) / 2;
			}
		}

		private function onMouseMove(event:MouseEvent):void
		{
			// void while select area
			if (areaPanel && areaPanel.visible)
				return;

			if (!event.relatedObject)
			{
				_codeText.x = 20 + event.stageX;
				_codeText.y = 20 + event.stageY;
			}
		}

		public function onTileMouseMove(event:GroundEvent):void
		{
			//trace("onTileMouseMove:"+event.color);
			_rollOverColor = StringUtil.toHEX(event.color);

			if (_rollOverColor)
				_codeText.text = _paintColor + ", " + _rollOverColor;
			else
				_codeText.text = _paintColor;
		}

		public function onTileClick(event:MouseEvent3D):void
		{
			// void while select area
			if (areaPanel && areaPanel.visible)
				return;
			
			// camera mode
			if (Keyboard3D.isCTRL)
				return;

			/*
			   trace(" ! TilePlane :", event.bitmapX, event.bitmapZ, _paintColor);

			   var _bitmapData:BitmapData = _area.map.data.bitmapData;
			   _bitmapData.setPixel(event.bitmapX, event.bitmapZ , Number(_paintColor));
			   _area.ground.update(_area.map.data);
			 */

			var _face:Face = event.face;
			if (_face)
			{
				//_face.material = new ColorMaterial(Number(_paintColor));
				var _drawPoint:Point = getPositionFromIndex(_face.faceIndex, _area.map.data.bitmapData.width)
				var _bitmapData:BitmapData = _area.map.data.bitmapData;
				_bitmapData.setPixel(_drawPoint.x, _area.map.data.bitmapData.height - _drawPoint.y - 1, Number(_paintColor));

				//TODO : _bitmapData.floodFill(_drawPoint.x, _drawPoint.y, Number(_paintColor));

				_area.ground.updateBitmapData(_area.map.data.bitmapData);
			}
		}

		private function getPositionFromIndex(index:int, size:uint):Point
		{
			return new Point(int(index % size), int(index / size));
		}

		override public function destroy():void
		{
			//Game.inputController.mouse.removeEventListener(SDMouseEvent.MOUSE_DRAG, onMouseIsDrag);
			//Game.inputController.keyboard.removeEventListener(SDKeyboardEvent.KEY_PRESS, onKeyIsPress);
			//Game.inputController.mouse.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);

			//_area.ground.removeEventListener(GroundEvent.MOUSE_DOWN, onTileClick);
			//_area.ground.removeEventListener(GroundEvent.MOUSE_MOVE, onTileMouseMove);
			//area.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);

			_engine3D.systemLayer.removeChild(_helpToolDialog);
			_helpToolDialog.destroy();

			_engine3D.systemLayer.removeChild(_buildToolDialog);
			_buildToolDialog.destroy();

			//removeChild(log);
			super.destroy();
		}
	}
}