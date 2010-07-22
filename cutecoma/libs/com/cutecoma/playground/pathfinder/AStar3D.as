package com.cutecoma.playground.pathfinder
{
	import com.cutecoma.game.core.Position;
	import com.sleepydesign.system.DebugUtil;

	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.events.EventDispatcher;
	import flash.geom.Point;

	import org.osflash.signals.Signal;

	//import org.papervision3d.materials.WireframeMaterial;
	//import org.papervision3d.objects.primitives.Plane;

	/**
	 * Application class for the A* 3D
	 * @auther Paul Spitzer, katopz
	 */
	public class AStar3D extends EventDispatcher
	{
		// Node members
		public static var nodes:Array;

		public static var xDepth:uint = 1; // columns
		public static var yDepth:uint = 1;
		public static var zDepth:uint = 1; // rows

		private var startNode:AStarNode;
		private var finishNode:AStarNode;

		// A*
		private var positions:Array;
		private var open:Array;
		private var closed:Array;

		//3D
		public static var x0:Number = 0;
		public static var y0:Number = 0;
		public static var z0:Number = 0;

		private var position:Position;
		private var destination:Position;

		public static var xSize:uint;
		public static var ySize:uint;
		public static var zSize:uint;

		public var segmentX:Number;
		public var segmentY:Number;
		public var segmentZ:Number;

		private static var bitmapData:BitmapData;

		//debug
		private var scene:*;

		public static var completeSignal:Signal = new Signal(String, Array);//, uint, uint, uint);
		public static var errorSignal:Signal = new Signal(String);

		/**
		 * Constructs a new AStar3D object.
		 */
		public function AStar3D(scene:* = null)
		{
			if (nodes)
			{
				DebugUtil.trace(" ! Already 've AStar3D : " + nodes.length, xSize);
				return;
			}
			if (scene)
			{
				this.scene = scene
			}
		}

		/**
		 * Creates the Node graph
		 */
		public function create(iPathData:BitmapData, scaleX:Number = 100, scaleY:Number = 100, scaleZ:Number = 100, segmentX:uint = 1, segmentY:uint = 1, segmentZ:uint = 1):void
		{
			bitmapData = iPathData;

			this.segmentX = segmentX;
			this.segmentY = segmentY;
			this.segmentZ = segmentZ;

			//world size
			var width:Number = scaleX * bitmapData.width;
			var height:Number = scaleZ * bitmapData.height;

			//TODO : height map
			//var depth:Number = scaleY * bitmapData.height;

			//size
			xSize = scaleX / segmentX;
			zSize = scaleZ / segmentZ;

			//map size
			xDepth = uint(width / xSize);
			zDepth = uint(height / zSize);

			DebugUtil.trace(" * AStar3D	: " + width, height, xDepth, zDepth, xSize, zSize);

			nodes = [];

			var i:uint;
			var j:uint;
			var k:uint;
			var node:AStarNode;
			var color:Number;

			x0 = (xSize - width) * .5;
			z0 = (zSize - height) * .5;

			for (i = 0; i < zDepth; i++)
			{
				nodes[i] = [];
				for (j = 0; j < yDepth; j++)
				{
					nodes[i][j] = [];
					for (k = 0; k < xDepth; k++)
					{
						node = nodes[i][j][k] = new AStarNode();

						node.x = x0 + k * xSize;
						node.y = y0 + j * ySize;
						node.z = -(z0 + i * zSize);

						node.xPoint = k;
						node.yPoint = j;
						node.zPoint = i;

						color = bitmapData.getPixel(k * segmentX, i * segmentZ);

						node.walkable = color > 0;

						node.color = color;

						if (!node.walkable && scene)
						{
							/*
							   var ground:Plane = new Plane(new WireframeMaterial(color), xSize, zSize );
							   ground.x = node.x;
							   ground.y = node.y;
							   ground.z = node.z;
							   ground.rotationX = 90;
							   scene.addChild(ground);
							 */
						}
					}
				}
			}
		}

		public function getXPos(iPosition:*):uint
		{
			return Math.round((iPosition.x - x0) / xSize);
		}

		public function getZPos(iPosition:*):uint
		{
			return Math.round((-iPosition.z - z0) / zSize);
		}

		public function getNodeByPosition(iPosition:*):AStarNode
		{
			DebugUtil.trace(" ! try : " + iPosition);

			var xPoint:int = getXPos(iPosition);
			var zPoint:int = getZPos(iPosition);

			DebugUtil.trace(" ! getNodeByPosition : " + xPoint, zPoint);

			if (xPoint < 0 || zPoint < 0 || zPoint > nodes.length - 1)
				return null;
			if (xPoint > nodes[zPoint][0].length - 1)
				return null;

			return nodes[zPoint][0][xPoint];
		}

		public function getColorByPosition(iPosition:*):Number
		{
			return getNodeByPosition(iPosition).color;
		}

		public function getPositionByNode(xPoint:uint, yPoint:uint, zPoint:uint):Position
		{
			DebugUtil.trace(" ! getPositionByNode : " + xPoint, zPoint);
			DebugUtil.trace(" ! got : " + Position(nodes[zPoint][yPoint][xPoint]));

			return Position(nodes[zPoint][0][xPoint]);
		}

		private function isPathHit2(startNode:*, finishNode:*):Boolean
		{
			// finishNode chk
			var isHit:Boolean = (bitmapData.getPixel(finishNode.xPoint, finishNode.zPoint) == 0x000000);
			if (isHit)
				return isHit;

			var bitmapData:BitmapData = bitmapData.clone();
			var pathBitmapData:BitmapData = new BitmapData(bitmapData.width * xSize, bitmapData.height * zSize, true, 0x00000000)
			var hitBitmapData:BitmapData = new BitmapData(bitmapData.width * xSize, bitmapData.height * zSize, true, 0x00000000)

			var line:Shape = new Shape();
			line.graphics.lineStyle(1, 0xFFFFFF, 1);
			line.graphics.moveTo(startNode.xPoint * xSize, startNode.zPoint * zSize);
			line.graphics.lineTo(finishNode.xPoint * xSize, finishNode.zPoint * zSize);
			line.graphics.endFill();
			pathBitmapData.draw(line);

			var pt:Point = new Point(0, 0);

			bitmapData.threshold(bitmapData, bitmapData.rect, pt, ">", 0xFF000000, 0x00000000, 0xFFFFFFFF, false);

			hitBitmapData.copyPixels(bitmapData, bitmapData.rect, pt, pathBitmapData, pt);

			DebugUtil.trace("++" + hitBitmapData.getColorBoundsRect(0xFF000000, 0xFF000000, true))
			DebugUtil.trace("++" + (!hitBitmapData.getColorBoundsRect(0xFF000000, 0xFF000000, true).isEmpty()))

			return !hitBitmapData.getColorBoundsRect(0xFF000000, 0xFF000000, true).isEmpty();
		}

		// A*
		/**
		 * Starts the search for the positions
		 */
		private function isPathHit(startNode:*, finishNode:*):Boolean
		{
			var isHit:Boolean = (bitmapData.getPixel(finishNode.xPoint, finishNode.zPoint) == 0x000000);
			if (isHit)
				return true;

			var xd:Number = (finishNode.xPoint - startNode.xPoint);
			var zd:Number = (finishNode.zPoint - startNode.zPoint);

			var xa:Number = xSize;
			var za:Number = zSize;

			var xs:Number = xd / xa;
			var zs:Number = zd / za;

			var partial:uint = 4 * Math.max(Math.abs(xd), Math.abs(zd));

			var i:uint = 0;

			var _bitmapData_width:Number = bitmapData.width;
			var _bitmapData_height:Number = bitmapData.height;

			while (i < partial && !isHit)
			{
				var xx:int = startNode.xPoint + int(xs * i);
				var zz:int = startNode.zPoint + int(zs * i);

				xx = int(xx * segmentX);
				zz = int(zz * segmentZ);

				if (xx < 0)
					xx = 0;
				if (zz < 0)
					zz = 0;

				if (xx >= _bitmapData_width)
					xx = _bitmapData_width - 1;
				if (zz >= _bitmapData_height)
					zz = _bitmapData_height - 1;

				isHit = (bitmapData.getPixel(xx, zz) == 0x000000);

				i++
			}

			return isHit;
		}

		private function optimize(positions:Array):Array
		{
			var _length:int = positions.length;
			if (_length > 2)
			{
				DebugUtil.trace(" * Optimize Path : " + positions.length)

				var goodpositions:Array = [];

				goodpositions.push(positions[0]);

				var i:uint = 0;
				while (i < _length - 2)
				{
					// skip 2 and not hit!
					if (!isPathHit(positions[i], positions[i + 2]))
					{
						// good way!
						goodpositions.push(positions[i + 2]);
						i += 2;
					}
					else
					{
						// give up!
						goodpositions.push(positions[i + 1]);
						i++;
					}
				}

				if (goodpositions[_length - 1] != positions[_length - 1])
					goodpositions.push(positions[_length - 1]);

				return goodpositions;
			}
			else
			{
				return positions;
			}
		}

		public function findPath(position:Position, destination:Position, id:String = ""):void
		{
			//DebugUtil.trace(" >> FindPath : [AStarNode true,0,0,0 - -350,0,-250] -> [AStarNode true,5,0,5 - 150,0,250]")
			/*
			   startNode = nodes[0][0][0];
			   finishNode = nodes[0][0][7];

			   DebugUtil.trace(" > Find Path : " + startNode + " -> " + finishNode);
			 */

			//position = Position.parse(iPosition);
			//destination = Position.parse(iDestination);

			this.position = position;
			this.destination = destination;

			startNode = getNodeByPosition(position);
			finishNode = getNodeByPosition(destination);

			if (!finishNode || startNode == finishNode || bitmapData.getPixel(finishNode.xPoint, finishNode.zPoint) == 0x000000)
			{
				onError(id);
				return;
			}

			DebugUtil.trace(" > Find Path : " + startNode + " -> " + finishNode);

			positions = [];
			open = [];
			closed = [];

			var isHit:Boolean = isPathHit(startNode, finishNode);

			if (!isHit)
			{
				DebugUtil.trace(" ! Way is clear")
				onDone(id);
			}
			else
			{
				DebugUtil.trace(" ! Find Path")
				look(startNode, id);
			}
		/*
		   positions = [];
		   open = [];
		   closed = [];

		   look(startNode);
		 */
		}

		private function onDone(id:String):void
		{
			// precise startNode
			startNode.x = position.x;
			startNode.y = position.y;
			startNode.z = position.z;

			// precise finishNode
			finishNode.x = destination.x;
			finishNode.y = destination.y;
			finishNode.z = destination.z;

			positions.unshift(startNode.toObject());
			positions.push(finishNode.toObject());

			/*
			   //smooth
			   if (positions.length > 4)
			   {
			   positions[1].x = (positions[2].x + positions[0].x ) * .5;
			   positions[1].z = (positions[2].z + positions[0].z ) * .5;

			   positions[positions.length-2].x = (positions[positions.length-1].x + positions[positions.length-3].x ) * .5;
			   positions[positions.length-2].z = (positions[positions.length-1].z + positions[positions.length-3].z ) * .5;
			   }
			 */

			DebugUtil.trace(" * Found Path : " + positions.length)

			if (positions.length > 2)
			{
				//1 pass
				positions = optimize(positions);

				//2 pass
				positions = optimize(positions);

				/*
				   //3 pass
				   positions = optimize(positions);
				   DebugUtil.trace(" * Optimize Path : " + positions.length)
				 */
			}

			for (var i:int = 0; i < positions.length; i++)
			{
				positions[i] = new Position(positions[i].x, positions[i].y, positions[i].z);
			}

			completeSignal.dispatch(id, positions);//id, positions, segmentX, segmentY, segmentZ);
		}

		private function onError(id:String):void
		{
			DebugUtil.trace(" * Error Occur");
			errorSignal.dispatch(id);
		}

		/**
		 * Performs a search of adjacent nodes looking for the
		 * most optimal positions to the destination
		 */
		private function look(current:AStarNode, id:String):void
		{
			if (current != null)
			{
				closed.push(current);

				if (current != finishNode)
				{
					var startZ:uint = Math.max(current.zPoint - 1, 0);
					var endZ:uint = Math.min(current.zPoint + 1, zDepth - 1);

					var startY:uint = Math.max(current.yPoint - 1, 0);
					var endY:uint = Math.min(current.yPoint + 1, yDepth - 1);

					var startX:uint = Math.max(current.xPoint - 1, 0);
					var endX:uint = Math.min(current.xPoint + 1, xDepth - 1);

					var i:uint;
					var j:uint;
					var k:uint;
					var adjacentNode:AStarNode;

					for (i = startZ; i <= endZ; i++)
					{
						for (j = startY; j <= endY; j++)
						{
							for (k = startX; k <= endX; k++)
							{
								if (!(i == current.zPoint && j == current.yPoint && k == current.xPoint))
								{
									adjacentNode = nodes[i][j][k];
									searchNode(adjacentNode, current);
								}
							}
						}
					}

					open.sortOn("f", Array.NUMERIC);
					var best:AStarNode = open.splice(0, 1)[0];
					look(best, id);

				}
				else
				{

					var node:AStarNode = finishNode;
					while (node != startNode)
					{
						if (node != finishNode)
						{
							node.isPath = true;
							positions.unshift(node.toObject());
						}
						node = node.parentNode;
					}

					onDone(id);
				}
			}
			else
			{
				onError(id);
			}
		}

		/**
		 * Searches a node and scores it based heuristics
		 */
		private function searchNode(node:AStarNode, parent:AStarNode):void
		{
			var xZDiagonal:Boolean = (node.xPoint != parent.xPoint && node.zPoint != parent.zPoint);
			var xYDiagonal:Boolean = (node.xPoint != parent.xPoint && node.yPoint != parent.yPoint);
			var yZDiagonal:Boolean = (node.yPoint != parent.yPoint && node.zPoint != parent.zPoint);

			// we can't cut solid corners so we first need to check for that
			var corner:Boolean = false;
			/*
			   if(xZDiagonal || xYDiagonal || yZDiagonal) // we only cut a corner when moving diagonally
			   {
			   // Check the direction of travel
			   var xDirection: int = (node.xPoint - parent.xPoint);
			   var yDirection: int = (node.yPoint - parent.yPoint);
			   var zDirection: int = (node.zPoint - parent.zPoint);

			   var xZCorner1: AStarNode = nodes[parent.zPoint][parent.yPoint][parent.xPoint + xDirection];
			   var xZCorner2: AStarNode = nodes[parent.zPoint + zDirection][parent.yPoint][parent.xPoint];

			   var xYCorner1: AStarNode = nodes[parent.zPoint][parent.yPoint][parent.xPoint + xDirection];
			   var xYCorner2: AStarNode = nodes[parent.zPoint][parent.yPoint + yDirection][parent.xPoint];

			   var yZCorner1: AStarNode = nodes[parent.zPoint][parent.yPoint + yDirection][parent.xPoint];
			   var yZCorner2: AStarNode = nodes[parent.zPoint + zDirection][parent.yPoint][parent.xPoint];

			   corner = (xZCorner1 || xZCorner2 || xYCorner1 || xYCorner2 || yZCorner1 || yZCorner2);
			   }
			 */
			if (node.walkable && !hasItem(open, node) && !hasItem(closed, node) && !corner)
			{
				node.parentNode = parent;
				node.g = parent.g + (xZDiagonal || xYDiagonal || yZDiagonal) ? 14 : 10;

				var difX:Number = finishNode.xPoint - node.xPoint;
				var difY:Number = finishNode.yPoint - node.yPoint;
				var difZ:Number = finishNode.zPoint - node.zPoint;

				if (difX < 0)
					difX = difX * -1;
				if (difY < 0)
					difY = difY * -1;
				if (difZ < 0)
					difZ = difZ * -1;

				node.h = (difX + difY + difZ) * 10;
				node.f = node.g + node.h;

				open.push(node);
			}
			else if (node.walkable && !hasItem(closed, node) && !corner)
			{
				var g:Number = parent.g + (xZDiagonal || xYDiagonal || yZDiagonal) ? 14 : 10;
				if (g < node.g)
				{
					node.g = g;
					node.parentNode = parent;
				}
			}
		}

		/**
		 * Utility function go see if an Array has an item. Using Arrays
		 * is not the most efficient but it works for a proof of concept.
		 */
		private function hasItem(array:Array, item:Object):Boolean
		{
			var i:uint;
			var len:uint = array.length;
			for (i = 0; i < len; i++)
			{
				if (array[i] == item)
					return true;
			}
			return false;
		}

		// ______________________________ Destroy ______________________________

		public function destroy():void
		{
			nodes = null;

			startNode = null;
			finishNode = null;

			positions = null;
			open = null;
			closed = null;

			position = null;
			destination = null;

			bitmapData.dispose();
			bitmapData = null;

			scene = null;
		}
	}
}