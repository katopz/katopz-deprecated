package com.cutecoma.playground.editors
{
	import com.cutecoma.game.core.Game;
	import com.cutecoma.playground.core.Area;
	import com.cutecoma.playground.core.Engine3D;
	import com.cutecoma.playground.core.Map;
	import com.cutecoma.playground.events.AreaEditorEvent;
	import com.cutecoma.playground.events.GroundEvent;
	import com.sleepydesign.application.core.SDApplication;
	import com.sleepydesign.components.SDDialog;
	import com.sleepydesign.events.RemovableEventDispatcher;
	import com.sleepydesign.events.SDKeyboardEvent;
	import com.sleepydesign.events.SDMouseEvent;
	import com.sleepydesign.managers.EventManager;
	import com.sleepydesign.text.SDTextField;
	import com.sleepydesign.ui.InputController;
	import com.sleepydesign.ui.SDKeyBoard;
	import com.sleepydesign.utils.FileUtil;
	import com.sleepydesign.utils.LoaderUtil;
	import com.sleepydesign.utils.StringUtil;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.papervision3d.core.math.Matrix3D;
	import org.papervision3d.core.math.Number3D;
	
	public class AreaEditor extends RemovableEventDispatcher
	{		
		//public var log			:SDTextField;
		private var engine3D	:Engine3D;
		private var area		:Area;
		private static const FORWARD:Number3D = new Number3D(0, 0, -1);
		
		private var _paintColor:Number = 0;
		public function set paintColor(vaule:Number):void
		{
			_paintColor = vaule;
			_codeText.borderColor = _paintColor;
			_codeText.text = StringUtil.hex(_paintColor);
		}
		
		public function AreaEditor(engine3D:Engine3D, area:Area)
		{
			this.engine3D = engine3D;
			this.area = area;
			
			/*
			// log
			var bg:SDSquare = new SDSquare(this.width, this.height, 0xFF0000);
			addChild(bg);
			
			bg.setSize(this.width, this.height);
			*/
			
			// controller
			Game.inputController = new InputController(true, true);
			Game.inputController.mouse.addEventListener(SDMouseEvent.MOUSE_DRAG, onMouseIsDrag, false, 0 ,true);
			Game.inputController.keyboard.addEventListener(SDKeyboardEvent.KEY_PRESS, onKeyIsPress, false, 0 ,true);
			Game.inputController.mouse.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel, false, 0 ,true);
			
			_codeText = new SDTextField("0xFF000000");
			_codeText.autoSize= "left";
			_codeText.background = true;
			_codeText.backgroundColor = 0xDDDDDD;
			_codeText.border = true;
			_codeText.borderColor = 0x000000;
			
			_buildToolDialog = new SDDialog(
				<question><![CDATA[Select type]]>
					<answer src="as:onSelectType('0')"><![CDATA[No entry]]></answer>
					<answer src="as:onSelectType('1')"><![CDATA[Walkable]]></answer>
					<answer src="as:onSelectType('warp')"><![CDATA[Warp point]]></answer>
					<textinput width="100"/>
				</question>, false, this);

			SDApplication.system.addChild(_buildToolDialog);
			SDApplication.system.addChild(_codeText);
			
			area.ground.addEventListener(GroundEvent.MOUSE_DOWN, onTileClick);
			area.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		}
		
		private var _buildToolDialog:SDDialog;
		private var _codeText:SDTextField;
		
		private var areaPanel:AreaPanel;
		
		public function onSelectType(colorID:String):void
		{
			switch(colorID)
			{
				case "0":
					paintColor = 0xFF000000;
				break;
				case "1":
					paintColor = 0xFFFFFFFF;
				break;
				default :
					// wait for user select area
					LoaderUtil.loadAsset("AreaPanel.swf", onAreaPanelLoad);
				break;
			}
		}
		
		private function onAreaPanelLoad(event:Event):void
		{
			if(event.type!="complete")return;
			areaPanel = event.target.content as AreaPanel;
			SDApplication.system.addChild(areaPanel);
			EventManager.addEventListener(AreaEditorEvent.AREA_ID_CHANGE, onAreaIDChange);
		}
		
		private function onAreaIDChange(event:AreaEditorEvent):void
		{
			EventManager.removeEventListener(AreaEditorEvent.AREA_ID_CHANGE, onAreaIDChange);
			areaPanel.visible = false;
			paintColor = Number("0xFF00FF"+event.areaID);
		}
		
		public function setupBackground():void
		{
			//SDApplication.system.addEventListener(SDEvent.COMPLETE, onOpenBackgroundComplete);
			FileUtil.openImageTo(area.background);
		}
		
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
		
		private function onKeyIsPress(event:SDKeyboardEvent):void
		{
			engine3D.dolly.moveForward(event.data.dz*5);
			engine3D.dolly.moveRight(event.data.dx*5);
			engine3D.dolly.moveUp(event.data.dy*5);
			
			engine3D.dolly.roll(-event.data.dr);
		}
		
	    private function onMouseIsDrag(event:SDMouseEvent):void
	    {  
	        var target:* = engine3D.dolly;
			var vector:Number3D = new Number3D(event.data.dx, event.data.dy, 0);
			
			var targetRotationAxis:Number3D = new Number3D(target.x, target.y, target.z)
			
			var rotationAxis:Number3D = Number3D.cross(vector, FORWARD);
			rotationAxis.normalize();
			
			var rotationMatrix:Matrix3D = Matrix3D.rotationMatrix(-rotationAxis.x*Math.abs(target.z)/target.z, -rotationAxis.y, rotationAxis.z*Math.abs(target.y)/target.y, event.data.distance/(600*Math.pow(target.scale, 5)));
			
			target.transform.calculateMultiply3x3(rotationMatrix, target.transform);
			
			//this line used to apply transform to actual rotation values, so that if you change scale, the changes are persisted
			//target.copyTransform(target);
			/*
			//move decoy
			var distance:Number = engine3D.dolly.distanceTo(engine3D.decoy);
			engine3D.decoy.copyTransform(engine3D.dolly);
			engine3D.decoy.moveForward(distance); 
			*/
		}
		
		private function onMouseWheel( event:MouseEvent ):void
		{
			if(SDKeyBoard.isSHIFT)
			{
				var nextFOV:Number = engine3D.camera.fov + event.delta
				if((nextFOV>0)&&(nextFOV<500))
				{
					engine3D.camera.fov = nextFOV;
				}
			}
			else if(SDKeyBoard.isCTRL)
			{
				var nextFocus:Number = engine3D.camera.focus + event.delta
				if((nextFocus>0)&&(nextFocus<100))
				{
					engine3D.camera.focus = nextFocus;
				}
			}
			else
			{
				var nextZoom:Number = engine3D.camera.zoom + event.delta
				if((nextZoom>0)&&(nextZoom<100))
				{
					engine3D.camera.zoom = nextZoom;
				}
			}
		}
		
		private function onMouseMove( event:MouseEvent ):void
		{
			if(!event.relatedObject)
			{
				_codeText.x = 20+event.stageX;
				_codeText.y = 20+event.stageY;
			}
		}
		
		public function onTileClick(event:GroundEvent):void
		{
			trace("TilePlane:", event.bitmapX, event.bitmapZ, _paintColor);
			
			var _bitmapData:BitmapData = area.map.data.bitmapData;
			_bitmapData.setPixel32(event.bitmapX, event.bitmapZ , _paintColor);
			area.ground.update();
		}
		
		override public function destroy():void
		{
			Game.inputController.mouse.removeEventListener(SDMouseEvent.MOUSE_DRAG, onMouseIsDrag);
			Game.inputController.keyboard.removeEventListener(SDKeyboardEvent.KEY_PRESS, onKeyIsPress);
			Game.inputController.mouse.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			
			area.ground.removeEventListener(GroundEvent.MOUSE_DOWN, onTileClick);
			//area.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			
			//removeChild(log);
			super.destroy();
		}
	}
}
