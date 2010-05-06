package com.cutecoma.playground.editors
{
	import away3dlite.templates.BasicTemplate;
	
	import com.cutecoma.game.core.*;
	import com.cutecoma.game.data.*;
	import com.cutecoma.playground.core.*;
	import com.cutecoma.playground.data.*;
	import com.cutecoma.playground.debugger.PlayerDebugger;
	import com.sleepydesign.components.*;
	import com.sleepydesign.events.*;
	import com.sleepydesign.net.FileUtil;
	import com.sleepydesign.system.SystemUtil;
	import com.sleepydesign.utils.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.ui.ContextMenuItem;
	import flash.utils.*;


	public class WorldEditor extends BasicTemplate
	{
		public var areaEditor:AreaEditor;

		private var area:Area;
		
		private var _selectAreaID:String = "00";

		public function WorldEditor()
		{
		}
		
		override protected function onInit():void
		{
			//areaEditor = new AreaEditor(engine3D, area);
			//addChild(areaEditor);
			//area.map.visible = engine3D.grid = area.ground.debug = engine3D.axis = true;
			//PlayerDebugger.toggle(engine3D, Game.getInstance().player);
			
			SystemUtil.addContext(this, "Open Area", onContextMenu, true);
			SystemUtil.addContext(this, "Save Area", onContextMenu);
			SystemUtil.addContext(this, "Change Background", onContextMenu, true);
			//SystemUtil.addContext(this, "Edit Map", onContextMenu);
			SystemUtil.addContext(this, "Toggle Debug", onContextMenu, !true);
		}
		
		private var tree:SDTree;

		private function toggleOption(event:Event=null):void
		{
			/*
			// Engine Explorer
			if (!tree)
			{
				tree = new SDTree
				(
					<Option>
						<Open/>
						<Save/>
						<Edit>
							<Background/>
							<Map/>
						</Edit>
						<View>
							<MiniMap/>
							<Grid/>
							<Axis/>
							<Debugger/>
							<Ground/>
						</View>
					</Option>
				, true);

				tree.x = 10;
				tree.y = 120;
				tree.filters = [new GlowFilter(0xFFFFFF, 1, 2, 2)]
				SDApplication.system.addChild(tree);
				tree.addEventListener(SDMouseEvent.CLICK, onExplorer);
				tree.visible = false;
			}
			tree.visible = !tree.visible;
			*/
		}

		private function onContextMenu(event:ContextMenuEvent):void
		{
			trace(" ^ onContextMenu : " + ContextMenuEvent.MENU_SELECT);
			
			var _caption:String = ContextMenuItem(event.target).caption;//= SDTreeNode(event.data.node).label;
			switch (_caption)
			{
				case "Edit Map":
					areaEditor.editMap();
					break;
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
				/*case "Grid":
					engine3D.grid = !engine3D.grid;
					break;
				case "Ground":
					area.ground.debug = !area.ground.debug;
					break;
				case "Axis":
					engine3D.axis = !engine3D.axis;
					break;*/
				/*
				case "man1":
				case "man2":
				case "woman1":
				case "woman2":
					var fakeData:PlayerData = new PlayerData("player_" + (new Date().valueOf()), area.map.getSpawnPoint(), _label, "walk", 1.5);
					fakeData.des = new Position(200 * Math.random() - 200 * Math.random(), 0, 200 * Math.random() - 200 * Math.random());
					fakeData.msg = "Walk to : " + fakeData.des;
					game.update(fakeData)
					break;*/
				case "Save Area":
					// TODO : new area id input box here
					var _saveAreaData:AreaData = new AreaData().parse(area.data);
					_saveAreaData.scene = new SceneData(new CameraData().parse(camera));

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
				
				trace(areaData.id);
				
				//TODEV//SDApplication.getInstance()["gotoArea"](areaData);
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