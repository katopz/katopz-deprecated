package com.cutecoma.playground.core
{
	import com.cutecoma.game.core.Position;
	import com.cutecoma.playground.data.AreaData;
	import com.cutecoma.playground.data.TerrainData;
	import com.cutecoma.playground.pathfinder.AStar3D;
	import com.sleepydesign.core.SDContainer;
	import com.sleepydesign.core.SDSprite;
	import com.sleepydesign.events.SDEvent;
	
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	public class Terrain extends SDContainer
	{
		private var pathFinder:AStar3D;
		
		private var minimap:SDSprite;
		private var line:Shape;
		
		public static var factorX: Number=1;
		public static var factorZ: Number=1;
		
		private var routes:Array = [];
		
		public var data:TerrainData;
		
		public static const commands : Dictionary = new Dictionary(true);
		
		//public var pathData:MapData
		
		// Singleton
		public static var instance : Terrain;
        public static function getInstance() : Terrain
        {
            if ( instance == null ) instance = new Terrain();//null, factorX, factorZ);
            return instance as Terrain;
        }
        
		public function Terrain(config:AreaData=null)//source:*=null, factorX:Number=1, factorZ:Number=1)
		{
			instance = this;
			super(config.id);
			
			parse(config);
		}
		
        // ______________________________ Initialize ______________________________
        
		public function parse(raw:AreaData):void
		{
			if(!raw)return;
			
			Terrain.factorX = raw.width;
			Terrain.factorZ = raw.height;

			create(raw);
		}
		
		// ______________________________ Create ______________________________
		
		override public function create(config:Object=null):void
		{
			super.create(config);
			
			var _areaData:AreaData = config as AreaData;
			
			data = new TerrainData(_areaData.terrain.nodes, _areaData.terrain.width, _areaData.terrain.scaleX, _areaData.terrain.scaleZ);
			routes.push(_areaData.id);
			
			// _______________________________________________________ MiniMap
			
			minimap = new SDSprite();
			minimap.mouseEnabled = false;
			minimap.mouseChildren = false;
			addChild(minimap);
			
			var bitmap:Bitmap = new Bitmap(data.bitmapData);
			minimap.addChild(bitmap);
			
			line = new Shape();
			line.name = "line";
			minimap.addChild(line);
			
			// AStar3D
			pathFinder = new AStar3D();//engine3D.scene);
			pathFinder.create(data.bitmapData, factorX, 0, factorZ, 1, 0, 1);
			pathFinder.addEventListener(SDEvent.COMPLETE, onPathComplete, false, 0, true);
			pathFinder.addEventListener(SDEvent.ERROR, onPathError, false, 0, true);
		}
		
		// _______________________________________________________ Point
		
		//TODO : public function getSpawnPointById(position:Position):void
		public function getSpawnPoint():Position
		{
			trace(" ! getSpawnPoint : " + TerrainData(data).spawnPoint.x, 0, TerrainData(data).spawnPoint.y);
			return pathFinder.getPositionByNode(TerrainData(data).spawnPoint.x, 0, TerrainData(data).spawnPoint.y)
		}
		
		public function getWarpPoint():Position
		{
			//trace(" ! getWarpPoint : " + MapData(data).spawnPoint.x, 0, MapData(data).spawnPoint.y);
			//return pathFinder.getPositionByNode(MapData(data).spawnPoint.x, 0, MapData(data).spawnPoint.y)
			var key :int = int(routes[routes.length-2]);
			trace(" ! getWarpPoint : " + key);
			var warpPoint:Point = TerrainData(data).warpPoint[key];
			return pathFinder.getPositionByNode(warpPoint.x, 0, warpPoint.y);
		}
		
		public function getCommand(position:*):*
		{
			var color:Number = pathFinder.getColorByPosition(position);
			
			trace(" ! Color		: "+color, color.toString(16));
						
			var command:String;
			var args:Array;
			
			if(color<255)
			{
				command = "warp";
				args = [color];
			}else{
				command = "";
			}
			return {command:command, args:args};
		}
		
		// _______________________________________________________ Path
		
		public function findPath(id:String, startPosition:Position, finishPosition:Position):void
		{
			//var player:Player = Player(this.getElementById(id));
			pathFinder.findPath(startPosition, finishPosition, id);
		}
		
		private function onPathError(event:SDEvent):void
		{
			//trace(" ! Over flow");
		}
		
		private function onPathComplete(event:SDEvent):void
		{
			trace(" ! onPathComplete");
			
			// player
			dispatchEvent(new SDEvent(SDEvent.UPDATE, {id:event.data.id, paths:event.data.paths, positions:event.data.positions}));
			
			// map
			drawPath(event.data.positions, event.data.segmentX, event.data.segmentZ);
		}

		public function drawPath(positions:Array, segmentX:Number=1, segmentZ:Number=1):void
		{
			/*
			//draw
			line.graphics.clear();
			line.graphics.lineStyle(0.5, 0x00FFFF, 1, false, "none" );
			line.graphics.moveTo(positions[0].xPoint, positions[0].zPos);
			
			var length:int = positions.length-1;
			for (var i:uint = 0; i < length;i++ )
			{
				line.graphics.lineTo(positions[i+1].xPoint*segmentX, positions[i+1].zPos*segmentZ);
			}
			line.graphics.endFill();
			*/
		}
		
		// ______________________________ Update ____________________________
		
		public function update(_areaData:AreaData):void
		{
			Terrain.factorX = _areaData.width;
			Terrain.factorZ = _areaData.height;
			
			data = new TerrainData(_areaData.terrain.nodes, _areaData.terrain.width, _areaData.terrain.scaleX, _areaData.terrain.scaleZ);
			routes.push(_areaData.id);
			
			// _______________________________________________________ MiniMap
			
			minimap.destroy();
			var bitmap:Bitmap = new Bitmap(this.data.bitmapData)
			minimap.addChild(bitmap);
			
			line = new Shape();
			line.name = "line";
			minimap.addChild(line);
			
			// AStar3D
			if(pathFinder)
			{
				pathFinder.destroy();
				pathFinder.removeEventListener(SDEvent.COMPLETE, onPathComplete);
				pathFinder.removeEventListener(SDEvent.ERROR, onPathError);
			}
			
			pathFinder = new AStar3D();//engine3D.scene);
			pathFinder.create(this.data.bitmapData, factorX, 0, factorZ, 1, 0, 1);
			pathFinder.addEventListener(SDEvent.COMPLETE, onPathComplete, false, 0, true);
			pathFinder.addEventListener(SDEvent.ERROR, onPathError, false, 0, true);
		}
		
		// ______________________________ Destroy ______________________________

		override public function destroy():void
		{
			minimap.destroy();
			minimap = null;
			
			pathFinder.destroy();
			pathFinder.removeEventListener(SDEvent.COMPLETE, onPathComplete);
			pathFinder.removeEventListener(SDEvent.ERROR, onPathError);
			pathFinder = null;
			
			factorX=1;
			factorZ=1;
		
			routes = [];
			
			super.destroy();
		}
	}
}
