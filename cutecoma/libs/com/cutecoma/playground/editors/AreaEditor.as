package com.cutecoma.playground.editors
{
	import away3dlite.primitives.Plane;
	import away3dlite.templates.BasicTemplate;
	
	import com.cutecoma.game.core.Game;
	import com.cutecoma.game.core.IEngine3D;
	import com.cutecoma.playground.core.Area;
	import com.cutecoma.playground.core.Engine3D;
	import com.cutecoma.playground.events.AreaEditorEvent;
	import com.cutecoma.playground.events.GroundEvent;
	import com.cutecoma.playground.events.SDKeyboardEvent;
	import com.cutecoma.playground.events.SDMouseEvent;
	import com.sleepydesign.components.SDDialog;
	import com.sleepydesign.events.RemovableEventDispatcher;
	import com.sleepydesign.managers.EventManager;
	import com.sleepydesign.net.LoaderUtil;
	import com.sleepydesign.text.SDTextField;
	import com.sleepydesign.ui.InputController;
	import com.sleepydesign.utils.StringUtil;
	
	import flash.display.BitmapData;
	import flash.display.StageAlign;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	
	public class AreaEditor extends RemovableEventDispatcher
	{		
		//public var log			:SDTextField;
		private var _engine3D	:IEngine3D;
		private var _area		:Area;
		private static const FORWARD:Vector3D = new Vector3D(0, 0, -1);
		
		private var _paintColor:String;
		private var _rollOverColor:String;
		
		public function set paintColor(value:String):void
		{
			_paintColor = value;
			_codeText.borderColor = Number(_paintColor);
			_codeText.text = _paintColor;//StringUtil.hex(_paintColor).split("0x").join("0xFF");
			
			if(_rollOverColor)
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
			Game.inputController = new InputController(_engine3D.systemLayer, true, true);
			Game.inputController.mouse.addEventListener(SDMouseEvent.MOUSE_DRAG, onMouseIsDrag, false, 0 ,true);
			Game.inputController.keyboard.addEventListener(SDKeyboardEvent.KEY_PRESS, onKeyIsPress, false, 0 ,true);
			Game.inputController.mouse.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel, false, 0 ,true);
			
			Game.inputController.keyboard.addEventListener(KeyboardEvent.KEY_DOWN, onKeyIsDown, false, 0 ,true);
			
			_codeText = new SDTextField("0x000000");
			_codeText.autoSize= "left";
			_codeText.background = true;
			_codeText.backgroundColor = 0xDDDDDD;
			_codeText.border = true;
			_codeText.borderColor = 0x000000;
			
			paintColor = "0x000000";
			_helpToolDialog = new SDDialog(
			<question>
				<![CDATA[1. Right Click to load Background<br/>2. Use WASD CV QE to move view.<br/>3. Use NUMPAD or CTRL+NUMPAD to +,- map size.<br/>4. Use CTRL+DRAG to move camera.<br/>5. Use Wheel or +/- (SHIFT) to zoom]]>
			</question>, this);
			_engine3D.systemLayer.addChild(_helpToolDialog);

			_helpToolDialog.alpha = .9;
			_helpToolDialog.align = StageAlign.TOP_LEFT;
			
			_buildToolDialog = new SDDialog(
				<question><![CDATA[Select type to draw Area.]]>
					<answer src="as:onSelectType('0')"><![CDATA[Unwalkable Area]]></answer>
					<answer src="as:onSelectType('1')"><![CDATA[Walkable Area]]></answer>
					<answer src="as:onSelectType('2')"><![CDATA[Spawn point]]></answer>
					<answer src="as:onSelectType('warp')"><![CDATA[Warp point]]></answer>
				</question>, this);

			_buildToolDialog.alpha = .9;
			_buildToolDialog.align = "center";
			
			_engine3D.systemLayer.addChild(_buildToolDialog);
			_engine3D.systemLayer.addChild(_codeText);
		}
		
		public function setArea(area:Area):void
		{
			_area = area;
			
			if(_area.ground)
			{
				//_area.ground.addEventListener(GroundEvent.MOUSE_DOWN, onTileClick);
				//_area.ground.addEventListener(GroundEvent.MOUSE_MOVE, onTileMouseMove);
			}
			_area.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		}
		
		private var _helpToolDialog:SDDialog;
		private var _buildToolDialog:SDDialog;
		private var _codeText:SDTextField;
		
		private var areaPanel:AreaPanel;
		
		public function onSelectType(colorID:String):void
		{
			switch(colorID)
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
			_engine3D.canvasLayer.addChild(areaPanel);
			EventManager.addEventListener(AreaEditorEvent.AREA_ID_CHANGE, onAreaIDChange);
		}
		
		private function onAreaIDChange(event:AreaEditorEvent):void
		{
			EventManager.removeEventListener(AreaEditorEvent.AREA_ID_CHANGE, onAreaIDChange);
			areaPanel.visible = false;
			paintColor = "0x00FF"+event.areaID;
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
		
		private function onKeyIsDown(event:KeyboardEvent):void
		{
			var _bitmapData:BitmapData = _area.map.data.bitmapData.clone();
			var _rect:Rectangle = _bitmapData.rect; 
			
			// NUM 1 -> 9
			// 97 -> 105
			switch(event.keyCode-96)
			{
				//-
				case 13:
					zoom(event.shiftKey?-5:-1);
				break;
				//+
				case 11:
					zoom(event.shiftKey?5:1);
				break;
				case 8:
					if(event.ctrlKey)
						_rect.y++;
					else
						_rect.y--;
				break;
				case 2:
					if(event.ctrlKey)
						_rect.height--;
					else
						_rect.height++;
				break;
				case 4:
					if(event.ctrlKey)
						_rect.x++;
					else
						_rect.x--;
				break;
				case 6:
					if(event.ctrlKey)
						_rect.width--;
					else
						_rect.width++;
				break;
				default : 
					return;
				break;
			}
			
			var _width:int = -_rect.x+_rect.width;
			var _height:int = -_rect.y+_rect.height;
			
			_width = _width>0?_width:1;
			_height = _height>0?_height:1;
			
			_area.map.bitmap.bitmapData = _area.map.data.bitmapData = new BitmapData(_width, _height, true, 0xFFFFFFFF);
			_area.map.data.bitmapData.draw(_bitmapData, new Matrix(1,0,0,1,-_rect.x, -_rect.y));
			_area.ground.update(_area.map.data);
			
			_bitmapData.dispose();
		}
		
		private function onKeyIsPress(event:SDKeyboardEvent):void
		{
			// void while select area
	        if(areaPanel && areaPanel.visible)
	        	return;
	        
			/*
			engine3D.dolly.moveForward(event.data.dz*5);
			engine3D.dolly.moveRight(event.data.dx*5);
			engine3D.dolly.moveUp(event.data.dy*5);
			
			engine3D.dolly.roll(-event.data.dr);
			*/
		}
		
	    private function onMouseIsDrag(event:SDMouseEvent):void
	    {  
	        // void while select area
	        if(areaPanel && areaPanel.visible)
	        	return;
	        /*
	        if(!SDKeyBoard.isCTRL)
	        	return;
	        
	        var target:* = engine3D.dolly;
			var vector:Vector3D = new Vector3D(event.data.dx, event.data.dy, 0);
			
			var targetRotationAxis:Vector3D = new Vector3D(target.x, target.y, target.z)
			
			var rotationAxis:Vector3D = Vector3D.cross(vector, FORWARD);
			rotationAxis.normalize();
			
			var rotationMatrix:Matrix3D = Matrix3D.rotationMatrix(-rotationAxis.x*Math.abs(target.z)/target.z, -rotationAxis.y, rotationAxis.z*Math.abs(target.y)/target.y, event.data.distance/(600*Math.pow(target.scale, 5)));
			
			target.transform.calculateMultiply3x3(rotationMatrix, target.transform);
			*/
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
	        // void while select area
	        if(areaPanel && areaPanel.visible)
	        	return;
	        	
	        zoom(event.delta*(event.shiftKey?10:1)/5);
		}
		
		private function zoom(delta:Number):void
		{
			/*
			if(SDKeyBoard.isCTRL)
			{
				var nextFOV:Number = engine3D.camera.fov + delta;
				if((nextFOV>0)&&(nextFOV<2000))
					engine3D.camera.fov += (nextFOV - engine3D.camera.fov)/2;
			}
			else if(SDKeyBoard.isSPACE)
			{
				var nextFocus:Number = engine3D.camera.focus + delta;
				if((nextFocus>0)&&(nextFocus<100))
					engine3D.camera.focus = (nextFocus - engine3D.camera.focus)/2;
			}
			else
			{
				var nextZoom:Number = engine3D.camera.zoom + delta/10;
				if((nextZoom>0)&&(nextZoom<100))
					engine3D.camera.zoom += (nextZoom - engine3D.camera.zoom)/2;
			}
			*/
		}
		
		private function onMouseMove( event:MouseEvent ):void
		{
	        // void while select area
	        if(areaPanel && areaPanel.visible)
	        	return;
			
			if(!event.relatedObject)
			{
				_codeText.x = 20+event.stageX;
				_codeText.y = 20+event.stageY;
			}
		}
		
		public function onTileMouseMove(event:GroundEvent):void
		{
			//trace("onTileMouseMove:"+event.color);
			_rollOverColor = StringUtil.toHEX(event.color);
			
			if(_rollOverColor)
				_codeText.text = _paintColor + ", " + _rollOverColor;
			else
				_codeText.text = _paintColor;
		}
		
		public function onTileClick(event:GroundEvent):void
		{
	        // void while select area
	        if(areaPanel && areaPanel.visible)
	        	return;
	        	
			trace(" ! TilePlane :", event.bitmapX, event.bitmapZ, _paintColor);
			
			var _bitmapData:BitmapData = _area.map.data.bitmapData;
			_bitmapData.setPixel(event.bitmapX, event.bitmapZ , Number(_paintColor));
			_area.ground.update(_area.map.data);
		}
		
		override public function destroy():void
		{
			Game.inputController.mouse.removeEventListener(SDMouseEvent.MOUSE_DRAG, onMouseIsDrag);
			Game.inputController.keyboard.removeEventListener(SDKeyboardEvent.KEY_PRESS, onKeyIsPress);
			Game.inputController.mouse.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			
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
