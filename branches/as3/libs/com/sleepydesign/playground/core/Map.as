package com.sleepydesign.playground.core
{
	import com.sleepydesign.core.SDContainer;
	import com.sleepydesign.core.SDLoader;
	import com.sleepydesign.core.SDSprite;
	import com.sleepydesign.events.SDEvent;
	import com.sleepydesign.game.core.Position;
	import com.sleepydesign.playground.data.MapData;
	import com.sleepydesign.playground.pathfinder.AStar3D;
	
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	public class Map extends SDContainer
	{
		private var pathFinder:AStar3D;
		
		private var minimap:SDSprite;
		private var line:Shape;
		
		public static var factorX: Number=1;
		public static var factorZ: Number=1;
		
		private var routes:Array = [];
		
		public var data:MapData;
		
		public static const commands : Dictionary = new Dictionary(true);
		
		//public var pathData:MapData
		
		// Singleton
		public static var instance : Map;
        public static function getInstance() : Map
        {
            if ( instance == null ) instance = new Map();//null, factorX, factorZ);
            return instance as Map;
        }
        
		public function Map(config:*=null)//source:*=null, factorX:Number=1, factorZ:Number=1)
		{
			instance = this;
			super(config.id);
			
			parse(config);
		}
		
        // ______________________________ Initialize ______________________________
        
		override public function parse(raw:Object=null):void
		{
			if(!raw)return;
			
			Map.factorX = raw.factorX;
			Map.factorZ = raw.factorZ;
			
			_config = load(raw.source)
			//var _loader:SDLoader = new SDLoader();
			//_loader.load(raw.source);
			
			create(_config);
		}
		
		public function load(sourceURI:String=null):Object
		{
			var raw:Object;
			
			// TODO : load from external source
			if(sourceURI=="l0r0.dat")
			{
				raw = {
					id:3,
					nodes:
					[
						0, 0, 0, 4, 4, 4, 0,
						0, 0, 0, 4, 4, 4, 0,
						0, 0, 0, 4, 4, 4, 0,
						0, 0, 0, 1, 1, 1, 0,
						0, 0, 0, 1, 1, 1, 0,
						2, 1, 1, 1, 1, 1, 0,
						0, 0, 0, 1, 1, 1, 0,
						0, 0, 0, 1, 1, 1, 0,
						0, 0, 0, 1, 1, 1, 0,
						0, 0, 0, 1, 1, 1, 0,
						0, 0, 0, 1, 1, 1, 0,
						0, 0, 0, 1, 1, 1, 0
					],
					col:7,
					scaleX:3, 
					scaleZ:4
				}
				
			}else{
				raw = {
					id:4,
					nodes:
					[
						0, 0, 5, 5, 5, 0, 0,
						0, 0, 5, 5, 5, 0, 0,
						1, 1, 1, 1, 1, 0, 0,
						1, 1, 1, 1, 1, 0, 0,
						1, 1, 1, 1, 1, 0, 0,
						1, 1, 1, 1, 1, 0, 0,
						0, 1, 1, 1, 1, 0, 0,
						0, 1, 1, 1, 1, 0, 0,
						0, 0, 1, 1, 1, 0, 0,
						0, 0, 3, 3, 3, 0, 0,
						0, 0, 0, 0, 0, 0, 0,
						0, 0, 0, 0, 0, 0, 0,
					],
					col:7,
					scaleX:4, 
					scaleZ:4
				}
			}
			
			return raw;
		}
		
		// ______________________________ Create ______________________________
		
		override public function create(config:Object=null):void
		{
			super.create(config);
			
			data = new MapData(config.id, config.nodes, config.col, config.scaleX, config.scaleZ);
			routes.push(config.id);
			
			// _______________________________________________________ MiniMap
			
			minimap = new SDSprite();
			minimap.mouseEnabled = false;
			minimap.mouseChildren = false;
			addChild(minimap);
			
			var bitmap:Bitmap = new Bitmap(data.bitmapData)
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
			trace(" ! getSpawnPoint : " + MapData(data).spawnPoint.x, 0, MapData(data).spawnPoint.y);
			return pathFinder.getPositionByNode(MapData(data).spawnPoint.x, 0, MapData(data).spawnPoint.y)
		}
		
		public function getWarpPoint():Position
		{
			//trace(" ! getWarpPoint : " + MapData(data).spawnPoint.x, 0, MapData(data).spawnPoint.y);
			//return pathFinder.getPositionByNode(MapData(data).spawnPoint.x, 0, MapData(data).spawnPoint.y)
			var key :int = int(routes[routes.length-2]);
			trace(" ! getWarpPoint : " + key);
			var warpPoint:Point = MapData(data).warpPoint[key];
			return pathFinder.getPositionByNode(warpPoint.x, 0, warpPoint.y);
		}
		
		public function getCommand(position:*):*
		{
			var color:Number = pathFinder.getColorByPosition(position);
			
			trace(" ! Color		: "+(255-color));
			
			/*
			// TODO : comfig.color:command
			
			var command:String;
			if(color==255)
			{
				command = "warp";
			}else{
				command = "";
			}
			switch(color)
			{
				//warp #A
				case 3	: command = "warp"; break;
				//warp #B
				case 4	: command = "warp"; break;
			}
			*/
			
			var command:String;
			var args:Array;
			
			if(color<255)
			{
				command = "warp";
				args = [255-color];
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
		
		public function update(data:Object=null):void
		{
			Map.factorX = data.width;
			Map.factorZ = data.height;
			_config = load(data.src);
			
			this.data = new MapData(_config.id, _config.nodes, _config.col, _config.scaleX, _config.scaleZ);
			
			routes.push(_config.id);
			
			// _______________________________________________________ MiniMap
			
			var bitmap:Bitmap = new Bitmap(this.data.bitmapData)
			minimap.destroy();
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
