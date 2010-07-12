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

	public class Map extends SDSprite
	{
		//MODEL//
		private var _data:MapData;
		
		public function get data():MapData
		{
			return _data;
		}
		public static var factorX:Number = 1;
		public static var factorZ:Number = 1;

		//VIEW//
		private var _miniMap:SDSprite;
		
		//CONTROL//
		private var _pathFinder:AStar3D;

		public function Map() //source:*=null, factorX:Number=1, factorZ:Number=1)
		{
			addEventListener(Event.ADDED_TO_STAGE, onStage, false, 0, true);
		}

		protected function onStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onStage);
			draw();
		}

		public var bitmap:Bitmap;

		// Point _______________________________________________________

		//TODO : public function getSpawnPointById(position:Position):void
		public function getSpawnPoint():Position
		{
			trace(" ! getSpawnPoint : " + MapData(data).spawnPoint.x, 0, MapData(data).spawnPoint.y);
			return _pathFinder.getPositionByNode(MapData(data).spawnPoint.x, 0, MapData(data).spawnPoint.y)
		}

		public function getWarpPoint(areaID:String):Position
		{
			//trace(" ! getWarpPoint : " + MapData(data).spawnPoint.x, 0, MapData(data).spawnPoint.y);
			//return pathFinder.getPositionByNode(MapData(data).spawnPoint.x, 0, MapData(data).spawnPoint.y)
			trace(" ! getWarpPoint : " + areaID);
			//var warpPoint:Point = MapData(data).warpPoint[areaID];
			var warpRect:Rectangle = MapData(data).bitmapData.getColorBoundsRect(0xFFFFFF, Number("0x00FF" + areaID));
			var warpPoint:Point = warpRect.topLeft;

			if (warpRect.size.length > 0)
				return _pathFinder.getPositionByNode(warpPoint.x, 0, warpPoint.y);
			else
			{
				DebugUtil.trace(" ! no warp point for : " + areaID);
				return getSpawnPoint();
			}
		}

		// TODO : move this to game rule?
		public function getCommand(position:*):*
		{
			var color:Number = _pathFinder.getColorByPosition(position);

			DebugUtil.trace(" ! Color		: " + color, color.toString(16));

			var command:String;
			var args:Array;

			// warp color zone
			if (color >= 0xFF00 && color <= 0xFFFF)
			{
				command = "warp";
				args = [Number(color - 0xFF00).toString(16).toUpperCase()];
			}
			else
			{
				command = "";
			}
			return {command: command, args: args};
		}

		// Path _______________________________________________________
		
		public function findPath(id:String, startPosition:Position, finishPosition:Position):void
		{
			//var player:Player = Player(this.getElementById(id));
			try
			{
				_pathFinder.findPath(startPosition, finishPosition, id);
			}
			catch (e:*)
			{
				trace(e);
			}
		}

		public var completeSignal:Signal = new Signal(String, Array);

		private function onPathComplete(id:String, paths:Array):void
		{
			trace(" ! onPathComplete");

			// player
			//dispatchEvent(new SDEvent(SDEvent.UPDATE, { id: event.data.id, paths: event.data.paths, positions: event.data.positions }));
			completeSignal.dispatch(id, paths);
		}

		// Update _______________________________________________________

		public function update(_areaData:AreaData):void
		{
			Map.factorX = _areaData.width;
			Map.factorZ = _areaData.height;

			//if(!_areaData.map)
			//	data = new MapData(_areaData.map.nodes, _areaData.map.width, _areaData.map.scaleX, _areaData.map.scaleZ);
			//else
			_data = _areaData.mapData;

			updateBitmapData(data.bitmapData);
		}

		public function updateBitmapData(bitmapData:BitmapData):void
		{
			// MiniMap _______________________________________________________

			if (!_miniMap)
			{
				_miniMap = new SDSprite();
				_miniMap.mouseEnabled = false;
				_miniMap.mouseChildren = false;
				addChild(_miniMap);

				bitmap = new Bitmap(bitmapData);
				_miniMap.addChild(bitmap);
			}
			else
			{
				bitmap.bitmapData = bitmapData;
			}

			draw();

			// AStar3D _______________________________________________________
			
			if (_pathFinder)
			{
				_pathFinder.destroy();
				_pathFinder = null;
				AStar3D.completeSignal.removeAll();
			}

			_pathFinder = new AStar3D(); //engine3D.scene);
			_pathFinder.create(bitmapData, factorX, 0, factorZ, 1, 0, 1);
			AStar3D.completeSignal.add(onPathComplete);
			//AStar3D.errorSignal.add(onPathError);
		}
		
		public function draw():void
		{
			if (stage && _miniMap)
				_miniMap.x = stage.stageWidth - _miniMap.width;
		}

		// Destroy _______________________________________________________

		override public function destroy():void
		{
			bitmap = null;

			if (_miniMap)
				_miniMap.destroy();
			_miniMap = null;

			if (_pathFinder)
			{
				_pathFinder.destroy();
				AStar3D.completeSignal.removeAll();
				_pathFinder = null;
			}

			factorX = 1;
			factorZ = 1;
			
			_data = null;

			super.destroy();
		}
	}
}
