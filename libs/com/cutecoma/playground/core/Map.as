package com.cutecoma.playground.core
{
	import com.cutecoma.game.core.Position;
	import com.cutecoma.playground.data.AreaData;
	import com.cutecoma.playground.data.MapData;
	import com.cutecoma.playground.pathfinder.AStar3D;
	import com.sleepydesign.core.SDContainer;
	import com.sleepydesign.core.SDSprite;
	import com.sleepydesign.events.SDEvent;
	
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
        
		public function Map(config:AreaData=null)//source:*=null, factorX:Number=1, factorZ:Number=1)
		{
			instance = this;
			super(config.id);
			
			if(!config)
				update(config);
			//parse(config);
		}
		/*
        // ______________________________ Initialize ______________________________
        
		public function parse(raw:AreaData):void
		{
			if(!raw)return;
			
			Map.factorX = raw.width;
			Map.factorZ = raw.height;

			create(raw);
		}
		
		// ______________________________ Create ______________________________
		
		override public function create(config:Object=null):void
		{
			super.create(config);
			
			var _areaData:AreaData = config as AreaData;
			
			if(!_areaData.map)
				data = new MapData(_areaData.map.nodes, _areaData.map.width, _areaData.map.scaleX, _areaData.map.scaleZ);
			else
				data = _areaData.map;
			
			routes.push(_areaData.id);
			
			// _______________________________________________________ MiniMap
			
			minimap = new SDSprite();
			minimap.mouseEnabled = false;
			minimap.mouseChildren = false;
			addChild(minimap);
			
			bitmap = new Bitmap(data.bitmapData);
			minimap.addChild(bitmap);
			
			//minimap.addEventListener(MouseEvent.MOUSE_DOWN, onMapClick);
			
			line = new Shape();
			line.name = "line";
			minimap.addChild(line);
			
			// AStar3D
			pathFinder = new AStar3D();//engine3D.scene);
			pathFinder.create(data.bitmapData, factorX, 0, factorZ, 1, 0, 1);
			pathFinder.addEventListener(SDEvent.COMPLETE, onPathComplete, false, 0, true);
			pathFinder.addEventListener(SDEvent.ERROR, onPathError, false, 0, true);
		}
		*/
		
		public var bitmap:Bitmap;
		/*
		private function onMapClick(event:MouseEvent):void
		{
			trace( " ^ onClick:", event.target, event.currentTarget, scaleX);
			trace(event.localX/scaleX,event.localY/scaleY);
			trace(data.bitmapData);
			trace(data.bitmapData.width, data.bitmapData.height);
			trace(data.bitmapData.getPixel(int(event.localX/scaleX),int(event.localY/scaleY)));
			data.nodes[0] = 1;
		}
		*/
		
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
			try{
				pathFinder.findPath(startPosition, finishPosition, id);
			}catch(e:*){trace(e)};
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
			Map.factorX = _areaData.width;
			Map.factorZ = _areaData.height;
			
			if(!_areaData.map)
				data = new MapData(_areaData.map.nodes, _areaData.map.width, _areaData.map.scaleX, _areaData.map.scaleZ);
			else
				data = _areaData.map;
				
			routes.push(_areaData.id);
			
			// _______________________________________________________ MiniMap
			
			//if(minimap)
				//minimap.destroy();
			
			if(!minimap)
			{	
				minimap = new SDSprite();
				minimap.mouseEnabled = false;
				minimap.mouseChildren = false;
				addChild(minimap);
			
				bitmap = new Bitmap(data.bitmapData);
				minimap.addChild(bitmap);
			}else{
				bitmap.bitmapData = data.bitmapData;
			}
			
			/*
			line = new Shape();
			line.name = "line";
			minimap.addChild(line);
			*/
			
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
			//bitmap.removeEventListener(MouseEvent.CLICK, onMapClick);
			bitmap = null;
			
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
