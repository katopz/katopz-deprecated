package com.cutecoma.playground.core
{
	import com.cutecoma.game.core.Position;
	import com.cutecoma.playground.data.AreaData;
	import com.cutecoma.playground.data.MapData;
	import com.cutecoma.playground.pathfinder.AStar3D;
	import com.sleepydesign.display.SDSprite;
	import com.sleepydesign.system.DebugUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import org.osflash.signals.Signal;

	public class Map extends com.sleepydesign.display.SDSprite
	{
		private var pathFinder:AStar3D;

		private var minimap:SDSprite;

		private var line:Shape;

		public static var factorX:Number = 1;

		public static var factorZ:Number = 1;

		public var data:MapData;

		public static const commands:Dictionary = new Dictionary(true);

		//public var pathData:MapData

		// Singleton
		public static var instance:Map;

		public static function getInstance():Map
		{
			if(instance == null)
				instance = new Map(); //null, factorX, factorZ);
			return instance as Map;
		}

		public function Map() //source:*=null, factorX:Number=1, factorZ:Number=1)
		{
			instance = this;
			super();

			//if(!config)
			//	update(config);
			//parse(config);
			addEventListener(Event.ADDED_TO_STAGE, onStage);
		}

		protected function onStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onStage);
			draw();
		}

		public var bitmap:Bitmap;

		// _______________________________________________________ Point

		//TODO : public function getSpawnPointById(position:Position):void
		public function getSpawnPoint():Position
		{
			trace(" ! getSpawnPoint : " + MapData(data).spawnPoint.x, 0, MapData(data).spawnPoint.y);
			return pathFinder.getPositionByNode(MapData(data).spawnPoint.x, 0, MapData(data).spawnPoint.y)
		}

		public function getWarpPoint(areaID:String):Position
		{
			//trace(" ! getWarpPoint : " + MapData(data).spawnPoint.x, 0, MapData(data).spawnPoint.y);
			//return pathFinder.getPositionByNode(MapData(data).spawnPoint.x, 0, MapData(data).spawnPoint.y)
			trace(" ! getWarpPoint : " + areaID);
			//var warpPoint:Point = MapData(data).warpPoint[areaID];
			var warpRect:Rectangle = MapData(data).bitmapData.getColorBoundsRect(0xFFFFFF, Number("0x00FF" + areaID));
			var warpPoint:Point = warpRect.topLeft;

			if(warpRect.size.length > 0)
				return pathFinder.getPositionByNode(warpPoint.x, 0, warpPoint.y);
			else
			{
				DebugUtil.trace(" ! no warp point for : " + areaID);
				return getSpawnPoint();
			}
		}
		
		// TODO : move this to game rule?
		public function getCommand(position:*):*
		{
			var color:Number = pathFinder.getColorByPosition(position);

			DebugUtil.trace(" ! Color		: " + color, color.toString(16));

			var command:String;
			var args:Array;

			// warp color zone
			if(color >= 0xFF00 && color <= 0xFFFF)
			{
				command = "warp";
				args = [ Number(color - 0xFF00).toString(16).toUpperCase()];
			}
			else
			{
				command = "";
			}
			return { command: command, args: args };
		}

		// _______________________________________________________ Path

		public function findPath(id:String, startPosition:Position, finishPosition:Position):void
		{
			//var player:Player = Player(this.getElementById(id));
			try
			{
				pathFinder.findPath(startPosition, finishPosition, id);
			}
			catch(e:*)
			{
				trace(e)
			}
		}

		public var completeSignal:Signal = new Signal(Array);

		private function onPathComplete(paths:Array):void
		{
			trace(" ! onPathComplete");

			// player
			//dispatchEvent(new SDEvent(SDEvent.UPDATE, { id: event.data.id, paths: event.data.paths, positions: event.data.positions }));
			completeSignal.dispatch(paths);
		}

		// ______________________________ Update ____________________________

		public function update(_areaData:AreaData):void
		{
			Map.factorX = _areaData.width;
			Map.factorZ = _areaData.height;

			//if(!_areaData.map)
			//	data = new MapData(_areaData.map.nodes, _areaData.map.width, _areaData.map.scaleX, _areaData.map.scaleZ);
			//else
			data = _areaData.mapData;
			
			updateBitmapData(data.bitmapData);
		}
		
		public function updateBitmapData(bitmapData:BitmapData):void
		{
			// _______________________________________________________ MiniMap

			//if(minimap)
			//minimap.destroy();

			if(!minimap)
			{
				minimap = new SDSprite();
				minimap.mouseEnabled = false;
				minimap.mouseChildren = false;
				addChild(minimap);

				bitmap = new Bitmap(bitmapData);
				minimap.addChild(bitmap);
			}
			else
			{
				bitmap.bitmapData = bitmapData;
			}

			draw();

			/*
			   line = new Shape();
			   line.name = "line";
			   minimap.addChild(line);
			 */

			// AStar3D
			if(pathFinder)
			{
				pathFinder.destroy();
				pathFinder = null;
				AStar3D.completeSignal.removeAll();
				//pathFinder.removeEventListener(SDEvent.COMPLETE, onPathComplete);
				//pathFinder.removeEventListener(SDEvent.ERROR, onPathError);
			}

			pathFinder = new AStar3D(); //engine3D.scene);
			pathFinder.create(bitmapData, factorX, 0, factorZ, 1, 0, 1);
			AStar3D.completeSignal.add(onPathComplete);
			//AStar3D.errorSignal.add(onPathError);
			
			//pathFinder.addEventListener(SDEvent.COMPLETE, onPathComplete, false, 0, true);
			//pathFinder.addEventListener(SDEvent.ERROR, onPathError, false, 0, true);
		}

		public function draw():void
		{
			if(stage && minimap)
				minimap.x = stage.stageWidth - minimap.width;
		}

		// ______________________________ Destroy ______________________________

		override public function destroy():void
		{
			//bitmap.removeEventListener(MouseEvent.CLICK, onMapClick);
			bitmap = null;

			if(minimap)
				minimap.destroy();
			minimap = null;

			if(pathFinder)
			{
				pathFinder.destroy();
				AStar3D.completeSignal.removeAll();
				pathFinder = null;
			}

			factorX = 1;
			factorZ = 1;

			super.destroy();
		}
	}
}
