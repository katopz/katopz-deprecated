package com.cutecoma.playground.editors
{
	import away3dlite.containers.Scene3D;
	import away3dlite.containers.View3D;
	import away3dlite.core.IDestroyable;
	import away3dlite.core.base.Object3D;
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
	import com.sleepydesign.net.LoaderUtil;
	import com.sleepydesign.system.SystemUtil;
	import com.sleepydesign.utils.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.ui.ContextMenuItem;
	import flash.utils.*;

	public class WorldEditor 
	{
		private var _engine3D:IEngine3D;
		
		public var areaEditor:AreaEditor;
		
		private var area:Area;
		
		public function WorldEditor(engine3D:IEngine3D)
		{
			_engine3D = engine3D;
			
			init();
		}
		
		private function init():void
		{
			areaEditor = new AreaEditor(_engine3D);
			
			//systemLayer.addChild(areaEditor);
			//area.map.visible = engine3D.grid = area.ground.debug = engine3D.axis = true;
			//PlayerDebugger.toggle(engine3D, Game.getInstance().player);
			
			SystemUtil.addContext(_engine3D.systemLayer, "Open Area", onContextMenu, true);
			SystemUtil.addContext(_engine3D.systemLayer, "Save Area", onContextMenu);
			SystemUtil.addContext(_engine3D.systemLayer, "Import Bitmap", onContextMenu, true);
			SystemUtil.addContext(_engine3D.systemLayer, "Emport Bitmap", onContextMenu);
			SystemUtil.addContext(_engine3D.systemLayer, "Change ID", onContextMenu);
			SystemUtil.addContext(_engine3D.systemLayer, "Change Background", onContextMenu, true);
			SystemUtil.addContext(_engine3D.systemLayer, "Toggle Debug", onContextMenu, !true);
		}
		
		private function onContextMenu(event:ContextMenuEvent):void
		{
			trace(" ^ onContextMenu : " + ContextMenuEvent.MENU_SELECT);
			
			var _caption:String = ContextMenuItem(event.target).caption;//= SDTreeNode(event.data.node).label;
			switch (_caption)
			{
				case "Toggle Debug":
					//PlayerDebugger.toggle(engine3D, Game.getInstance().player);
					//engine3D.grid = !engine3D.grid;
					//area.ground.debug = !area.ground.debug;
					//engine3D.axis = !engine3D.axis;
					break;
				
				case "Change ID":
					areaEditor.showAreaPanel(onAreaIDChange);
					break;
				
				case "Change Background":
					areaEditor.setupBackground();
					break;

				case "Open Area":
					FileUtil.open(["*.ara"], onAreaLoad);
					break;
				
				case "Save Area":
					// TODO : new area id input box here
					var _saveAreaData:AreaData = new AreaData().parse(area.data);
					_saveAreaData.viewData = new ViewData(new CameraData().parse(_engine3D.view3D.camera));

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
		
		public function openArea(uri:String):void
		{
			LoaderUtil.loadBinary(uri, onAreaLoad);
		}
		
		private function onAreaLoad(event:Event):void
		{
			var areaData:AreaData;
			if (event.type == "complete")
				readArea(event.target.data);
			else if (event.type == IOErrorEvent.IO_ERROR)
				newArea();
		}
		
		private function newArea():void
		{
			// new area
			var areaData:AreaData = new AreaData(area.data.id, area.data.id + "_bg.swf", 40, 40);
			//TODEV//SDApplication.getInstance()["gotoArea"](areaData);
		}
		
		private function readArea(rawAreaData:ByteArray):void
		{
			if (!rawAreaData)
				return;
			
			var areaData:AreaData = new AreaData();
			IExternalizable(areaData).readExternal(rawAreaData);
			updateArea(areaData);
			//SDApplication.getInstance()["gotoArea"](areaData);
		}
		
		private function updateArea(areaData:AreaData):void
		{
			if(!area)
			{
				// create area
				area = new Area(_engine3D, areaData);
				
				// bind to editor
				areaEditor.setArea(area);
			}else{
				area.update(areaData);
			}
		}
	}
}