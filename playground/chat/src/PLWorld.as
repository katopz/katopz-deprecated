package
{
	import com.cutecoma.game.core.Game;
	import com.cutecoma.playground.components.SDConnector;
	import com.cutecoma.playground.core.Area;
	import com.cutecoma.playground.core.Engine3D;
	import com.cutecoma.playground.core.World;
	import com.cutecoma.playground.data.*;
	import com.cutecoma.playground.events.AreaEditorEvent;
	import com.sleepydesign.components.SDDialog;
	import com.sleepydesign.events.EventManager;
	import com.sleepydesign.net.LoaderUtil;
	import com.sleepydesign.templates.ApplicationTemplate;

	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.registerClassAlias;
	import flash.utils.Dictionary;
	import flash.utils.IExternalizable;

	[SWF(backgroundColor="#FFFFFF", frameRate="30", width="800", height="480")]
	public class PLWorld extends ApplicationTemplate
	{
		private var _world:World;
		private var _engine3D:Engine3D;

		private var area:Area;

		private var areaPanel:AreaPanel;

		private var _isEditArea:Boolean = false;

		private var dialog:SDDialog;

		private var configs:Dictionary = new Dictionary();

		private var _selectAreaID:String = "00";

		private var connector:SDConnector;

		private var game:Game;

		private var currentRoomID:String = "";

		public function PLWorld()
		{
			registerClassAlias("com.cutecoma.playground.data.AreaData", AreaData);
			registerClassAlias("com.cutecoma.playground.data.MapData", MapData);
			registerClassAlias("com.cutecoma.playground.data.SceneData", SceneData);
			registerClassAlias("com.cutecoma.playground.data.ViewData", ViewData);
			registerClassAlias("com.cutecoma.playground.data.CameraData", CameraData);

			alpha = .1
		}

		override protected function onInit():void
		{
			_engine3D = new Engine3D();
			_engine3D.systemLayer = _systemLayer;
			_engine3D.contentLayer = _contentLayer;
			_engine3D.completeSignal.addOnce(onEngineInit);

			addChild(_engine3D);
		}

		private function onEngineInit():void
		{
			_world = new World(_engine3D);
		}

		override protected function onInitXML():void
		{
			PixelLiving.areaPath = String(_xml.world.area.@path);

			initMenu();
		}

		private function initMenu():void
		{
			addChild(dialog = new SDDialog(<question><![CDATA[Welcome! What you want to do?]]>
					<!--<answer src="as:onUserSelect('edit-character')"><![CDATA[Select Character.]]></answer>-->
					<answer src="as:onUserSelect('enter-area')"><![CDATA[Enter Area]]></answer>
					<answer src="as:onUserSelect('edit-area')"><![CDATA[Edit Area]]>
					</answer></question>, this));
		}

		public function onUserSelect(action:String):void
		{
			dialog.destroy();

			switch (action)
			{
				case "edit-area":
					_isEditArea = true;
				case "enter-area":
					showAreaPanel(onAreaIDChange);
					break;
				case "edit-character":

					break;
			}
		}

		private function showAreaPanel(callback:Function):void
		{
			if (!areaPanel)
			{
				LoaderUtil.loadAsset("AreaPanel.swf", function onAreaPanelLoad(event:Event):void
					{
						if (event.type != "complete")
							return;

						areaPanel = event.target.content as AreaPanel;
						systemLayer.addChild(areaPanel);
						EventManager.addEventListener(AreaEditorEvent.AREA_ID_CHANGE, callback);
					});
			}
			else
			{
				areaPanel.visible = true;
				EventManager.addEventListener(AreaEditorEvent.AREA_ID_CHANGE, callback);
			}
		}

		private function onAreaIDChange(event:AreaEditorEvent):void
		{
			_selectAreaID = event.areaID;

			EventManager.removeEventListener(AreaEditorEvent.AREA_ID_CHANGE, onAreaIDChange);
			dialog.destroy();
			gotoAreaID(event.areaID);
		}

		private function gotoAreaID(id:String):void
		{
			var _data:AreaData = configs[id];

			// cache not exist
			if (!_data)
				LoaderUtil.load(PixelLiving.areaPath + id + ".ara", onAreaLoad);
			else
				gotoArea(_data);
		}

		public function gotoArea(areaData:AreaData):void
		{
			if (!area)
			{
				areaData.background = PixelLiving.areaPath + areaData.background;
				createArea(areaData);
				currentRoomID = areaData.id;
				return;
			}

			// dirty
			if (currentRoomID != areaData.id)
			{
				// tell everybody i'm exit
				game.player.exit();

				// update server
				connector.exitRoom();

				// wait for exit complete?
				connector.addEventListener(SDEvent.COMPLETE, onEnterRoom);
				connector.addEventListener(SDEvent.UPDATE, onEnterRoom);
				connector.enterRoom(areaData.id);

				// destroy
				game.removeOtherPlayer();

				//update area
				area.update(areaData);
				////engine3D.update(areaData.scene);
				game.player.warp(area.map.getWarpPoint(currentRoomID));

				// TODO : actually we need to wait for connection success?
				currentRoomID = areaData.id;
			}
		}

		private function onEnterRoom(event:SDEvent):void
		{
			connector.removeEventListener(SDEvent.COMPLETE, onEnterRoom);
			connector.removeEventListener(SDEvent.UPDATE, onEnterRoom);
			// tell everybody i'm enter
			game.player.enter();
		}

		public function createArea(areaData:AreaData):void
		{
		/*
		   // ___________________________________________________________ 2D Layer

		   // game
		   game = new Game();

		   area = new Area(areaData);
		   content.addChild(area);

		   // ___________________________________________________________ 3D Layer

		   // 3D engine
		   engine3D = new Engine3D(content, areaData.scene);

		   // bind
		   game.engine = engine3D;

		   // Ground
		   area.ground = new Ground(engine3D, area.map, true);
		   area.ground.addEventListener(SDMouseEvent.MOUSE_DOWN, onGroundClick);

		   // ___________________________________________________________ Player

		   game.player = new Player();//new PlayerData("player_" + (new Date().valueOf()), area.map.getSpawnPoint(), "man1", "stand", 3));

		   // read map
		   game.player.map = area.map;

		   game.addPlayer(game.player);
		   game.player.talk(VERSION);

		   // ___________________________________________________________ System Layer

		   if (_isEditArea)
		   {
		   worldEditor = new WorldEditor(engine3D, area);
		   systemLayer.addChild(worldEditor);
		   worldEditor.activate();
		   }
		   else
		   {
		   createConnector(area.id);
		   createChatBox();
		   // bind player -> connector
		   game.player.addEventListener(PlayerEvent.UPDATE, connector.onClientUpdate);
		   }

		   // start
		   game.start();
		 */
		}

		private function onAreaLoad(event:Event):void
		{
			var areaData:AreaData
			if (event.type == "complete")
			{
				// exist area
				areaData = new AreaData();
				IExternalizable(areaData).readExternal(event.target.data);

				//cache
				configs[areaData.id] = areaData;

					//SDApplication.getInstance()["gotoArea"](areaData);
			}
			else if (event.type == IOErrorEvent.IO_ERROR && _isEditArea)
			{
				// new area
				areaData = new AreaData(_selectAreaID, PixelLiving.areaPath + _selectAreaID + "_bg.swf", 40, 40);
					//SDApplication.getInstance()["gotoArea"](areaData);
			}
		}
	}
}