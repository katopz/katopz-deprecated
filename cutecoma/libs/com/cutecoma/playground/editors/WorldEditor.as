package com.cutecoma.playground.editors
{
	import com.adobe.images.PNGEncoder;
	import com.cutecoma.game.core.IEngine3D;
	import com.cutecoma.playground.core.Area;
	import com.cutecoma.playground.core.World;
	import com.cutecoma.playground.data.AreaData;
	import com.cutecoma.playground.data.CameraData;
	import com.cutecoma.playground.data.ViewData;
	import com.cutecoma.playground.events.AreaEditorEvent;
	import com.sleepydesign.events.EventManager;
	import com.sleepydesign.net.FileUtil;
	import com.sleepydesign.system.SystemUtil;

	import flash.display.Bitmap;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.ui.ContextMenuItem;

	public class WorldEditor extends World
	{
		public var areaEditor:AreaEditor;

		public function WorldEditor(engine3D:IEngine3D, path:String)
		{
			super(engine3D, path);
			
			areaEditor = new AreaEditor(_engine3D);
			
			areaEditor.setArea(_area);

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

			var _caption:String = ContextMenuItem(event.target).caption; //= SDTreeNode(event.data.node).label;
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
	}
}