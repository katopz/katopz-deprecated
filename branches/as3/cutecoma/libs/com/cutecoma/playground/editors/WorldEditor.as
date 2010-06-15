package com.cutecoma.playground.editors
{
	import away3dlite.containers.Scene3D;
	import away3dlite.containers.View3D;
	import away3dlite.core.IDestroyable;
	import away3dlite.templates.BasicTemplate;
	
	import com.adobe.images.PNGEncoder;
	import com.cutecoma.game.core.*;
	import com.cutecoma.game.data.*;
	import com.cutecoma.playground.core.*;
	import com.cutecoma.playground.data.*;
	import com.cutecoma.playground.events.AreaEditorEvent;
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
			SystemUtil.addContext(this, "Import Bitmap", onContextMenu, true);
			SystemUtil.addContext(this, "Emport Bitmap", onContextMenu);
			SystemUtil.addContext(this, "Change ID", onContextMenu);
			SystemUtil.addContext(this, "Change Background", onContextMenu, true);
			//SystemUtil.addContext(this, "Edit Map", onContextMenu);
			SystemUtil.addContext(this, "Toggle Debug", onContextMenu, !true);
		}
		
		private function updateArea(areaData:AreaData):void
		{
			if(!area)
			{
				// create area
				area = new Area(this, areaData);
				_canvasLayer.addChild(area);
				
				// bind to editor
				areaEditor.setArea(area);
			}else{
				area.update(areaData);
			}
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
				case "Change ID":
					/*
					var _idDialog:SDInputDialog = new SDInputDialog(
						"+----------------------+\n"+
						"| Enter number.        |\n"+
						"| ID : [$id-number-____]|\n"+
						"|          [OK][CANCEL]|\n"+
						"+----------------------+"
						, onChangeID);
					systemLayer.addChild(_idDialog);
					*/
					areaEditor.showAreaPanel(onAreaIDChange);
					break;
				case "Change Background":
					this.areaEditor.setupBackground();
					break;

				case "Open Area":
					FileUtil.open(["*.ara"], onAreaLoad);
					break;
				case "Save Area":
					// TODO : new area id input box here
					var _saveAreaData:AreaData = new AreaData().parse(area.data);
					_saveAreaData.viewData = new ViewData(new CameraData().parse(camera));

					FileUtil.save(_saveAreaData, area.data.id + ".ara");
					break;
				
				case "Import Bitmap":
					FileUtil.openImage(onImportBitmap, ["*.png"]);
					break;
				case "Emport Bitmap":
					FileUtil.save(PNGEncoder.encode(area.map.data.bitmapData), area.data.id + ".png");
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
			area.data.id = event.areaID;
		}
		
		private function onImportBitmap(event:Event):void
		{
			if (event.type != "complete")
				return;
			area.updateBitmap(Bitmap(event.target["content"]).bitmapData);
		}
		
		private function onAreaLoad(event:Event):void
		{
			var areaData:AreaData;
			if (event.type == "complete")
			{
				// exist area
				areaData = new AreaData();
				IExternalizable(areaData).readExternal(event.target.data);
				updateArea(areaData);
				
				//SDApplication.getInstance()["gotoArea"](areaData);
			}
			else if (event.type == IOErrorEvent.IO_ERROR)
			{
				// new area
				areaData = new AreaData(area.data.id, area.data.id + "_bg.swf", 40, 40);
				//TODEV//SDApplication.getInstance()["gotoArea"](areaData);
			}
		}
	}
}