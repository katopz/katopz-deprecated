package com.cutecoma.playground.data
{
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.net.registerClassAlias;
	import flash.utils.Dictionary;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;

	/**
	 * MapData
	 * @author katopz
	 *
	 * TODO : get mapdata from file
	 * - Image -> MapData
	 * - Array -> MapData
	 * - AMF IOMapData -> MapData
	 */
	public class MapData implements IExternalizable
	{
		registerClassAlias("com.cutecoma.playground.data.MapData", MapData);
		
		public var bitmapData:BitmapData;
		public var spawnPoint:Point;
		public var warpPoint:Dictionary = new Dictionary(true);

		public var nodes:Array;
		public var width:uint;
		
		public var scaleX:Number;
		public var scaleZ:Number;

		public function MapData(nodes:Array=null, width:uint=100, scaleX:Number = 4, scaleZ:Number = 4)
		{
			parse({nodes:nodes, width: width, scaleX: scaleX, scaleZ: scaleZ});
		}

		// ______________________________ Parse ______________________________

		public function parse(raw:*):MapData
		{
			nodes = raw.nodes;
			width = raw.width;
			
			scaleX = raw.scaleX;
			scaleZ = raw.scaleZ;
			
			if (!nodes || nodes.length < 1)
				return null;

			var _length:int = nodes.length;
			var w:uint = width;
			var h:uint = uint(_length / w);

			var _bitmapData:BitmapData = new BitmapData(w, h, true, 0xFF000000);

			for (var k:uint = 0; k < _length; k++)
			{
				var i:uint = k % w;
				var j:uint = uint(k / w);

				switch (nodes[k])
				{
					// OB
					case 0:
						_bitmapData.setPixel(i, j, 0xFF000000);
						break;
					// walkable
					case 1:
						_bitmapData.setPixel(i, j, 0xFFFFFFFF);
						break;

					// spawn
					case 2:
						_bitmapData.setPixel(i, j, 0xFF00FF00);
						spawnPoint = new Point(i * scaleX, j * scaleZ);
						break;

					//warp
					default:
						_bitmapData.setPixel(i, j, 0xFF000000 + nodes[k]);
						warpPoint[nodes[k]] = new Point(i * scaleX, j * scaleZ);
						// no spawnPoint?
						if (!spawnPoint)
							spawnPoint = warpPoint[nodes[k]];
						break;
				}
			}

			trace(" ! MapData.spawnPoint	: " + spawnPoint);

			if (bitmapData)
				bitmapData.dispose();
			bitmapData = new BitmapData(w * scaleX, h * scaleZ);
			bitmapData.draw(_bitmapData, new Matrix(scaleX, 0, 0, scaleZ));

			return this;
		}

		// _______________________________________________________ external

		public function writeExternal(output:IDataOutput):void
		{
			output.writeObject({nodes:nodes, width: width, scaleX: scaleX, scaleZ: scaleZ});
		}

		public function readExternal(input:IDataInput):void
		{
			parse(input.readObject());
		}
	}
}