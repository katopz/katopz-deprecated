package com.cutecoma.playground.editors
{
	import away3dlite.containers.Scene3D;
	import away3dlite.containers.View3D;
	import away3dlite.core.IDestroyable;
	import away3dlite.templates.BasicTemplate;
	
	import com.cutecoma.game.core.*;
	import com.cutecoma.game.data.*;
	import com.cutecoma.playground.core.*;
	import com.cutecoma.playground.data.*;
	import com.sleepydesign.components.*;
	import com.sleepydesign.display.SDSprite;
	import com.sleepydesign.events.*;
	import com.sleepydesign.net.FileUtil;
	import com.sleepydesign.system.SystemUtil;
	import com.sleepydesign.utils.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.ui.ContextMenuItem;
	import flash.utils.*;

	public class WorldEditor extends BasicTemplate implements IEngine3D, IDestroyable
	{
		public var areaEditor:AreaEditor;

		private var area:Area;
		
		private var _selectAreaID:String = "00";
		
		private var _systemLayer:SDSprite;
		public function get systemLayer():SDSprite
		{
			return _systemLayer;
		}
		
		private var _canvasLayer:SDSprite;
		public function get canvasLayer():SDSprite
		{
			return _canvasLayer;
		}
		
		public function get view3D():View3D
		{
			return view;
		}
		
		public function get scene3D():Scene3D
		{
			return scene;
		}

		public function WorldEditor()
		{
		}
		
		override protected function onStage():void
		{
			addChild(_canvasLayer = new SDSprite);
		}
		
		override protected function onInit():void
		{
			addChild(_systemLayer = new SDSprite);
			
			areaEditor = new AreaEditor(this);
			//systemLayer.addChild(areaEditor);
			//area.map.visible = engine3D.grid = area.ground.debug = engine3D.axis = true;
			//PlayerDebugger.toggle(engine3D, Game.getInstance().player);
			
			SystemUtil.addContext(this, "Open Area", onContextMenu, true);
			SystemUtil.addContext(this, "Save Area", onContextMenu);
			SystemUtil.addContext(this, "Change Background", onContextMenu, true);
			//SystemUtil.addContext(this, "Edit Map", onContextMenu);
			SystemUtil.addContext(this, "Toggle Debug", onContextMenu, !true);
		}
		
		public function createArea(areaData:AreaData):void
		{
			// create area
			area = new Area(this, areaData);
			_canvasLayer.addChild(area);
			
			// bind to editor
			areaEditor.setArea(area);
		}
		
		private function onContextMenu(event:ContextMenuEvent):void
		{
			trace(" ^ onContextMenu : " + ContextMenuEvent.MENU_SELECT);
			
			var _caption:String = ContextMenuItem(event.target).caption;//= SDTreeNode(event.data.node).label;
			switch (_caption)
			{
				/*case "MiniMap":
						area.map.visible = !area.map.visible;
					break;*/
				case "Toggle Debug":
					//PlayerDebugger.toggle(engine3D, Game.getInstance().player);
					//engine3D.grid = !engine3D.grid;
					//area.ground.debug = !area.ground.debug;
					//engine3D.axis = !engine3D.axis;
					break;
				/*case "Edit":
						if(this.isActivate)
							this.activate();
						else
							this.deactivate();
					break;*/
					/*
				case "Map":
					FileUtil.openImage(onMapLoad, ["*.png"]);
					//areaEditor.toggleTerrain(area.map);
					break;
					*/
				case "Change Background":
					this.areaEditor.setupBackground();
					break;

				case "Save Area":
					// TODO : new area id input box here
					var _saveAreaData:AreaData = new AreaData().parse(area.data);
					_saveAreaData.viewData = new ViewData(new CameraData().parse(camera));

					FileUtil.save(_saveAreaData, _selectAreaID + ".ara");
					break;
				case "Open Area":
					FileUtil.open(["*.ara"], onAreaLoad);
					break;
			}
		}
		
		private function onAreaLoad(event:Event):void
		{
			var areaData:AreaData
			if (event.type == "complete")
			{
				// exist area
				areaData = new AreaData();
				IExternalizable(areaData).readExternal(event.target.data);
				createArea(areaData);
				
				//SDApplication.getInstance()["gotoArea"](areaData);
			}
			else if (event.type == IOErrorEvent.IO_ERROR)
			{
				// new area
				areaData = new AreaData(_selectAreaID, _selectAreaID + "_bg.swf", 40, 40);
				//TODEV//SDApplication.getInstance()["gotoArea"](areaData);
			}
		}
	}
}