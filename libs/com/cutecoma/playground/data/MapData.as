package com.cutecoma.playground.data
{
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import flash.net.registerClassAlias;
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
		public var bitmapData:BitmapData;
		public var spawnPoint:Point;
		public var warpPoint:Dictionary = new Dictionary(true);

		private var _scaleX:Number;
		private var _scaleZ:Number;

		public function MapData(id:String, data:*, col:uint, scaleX:Number = 2, scaleZ:Number = 2)
		{
			_scaleX = scaleX;
			_scaleZ = scaleZ;

			parse({data: data, col: col, scaleX: scaleX, scaleZ: scaleZ});
		}

		// ______________________________ Parse ______________________________

		public function parse(raw:*):MapData
		{
			var nodes:Array = raw.data;
			var col:uint = raw.col;

			if (!nodes || nodes.length < 1)
				return null;

			var _length:int = nodes.length;
			var w:uint = col;
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
						spawnPoint = new Point(i * _scaleX, j * _scaleZ);
						break;

					//warp
					default:
						_bitmapData.setPixel(i, j, 0xFF000000 + nodes[k]);
						warpPoint[nodes[k]] = new Point(i * _scaleX, j * _scaleZ);
						// no spawnPoint?
						if (!spawnPoint)
							spawnPoint = warpPoint[nodes[k]];
						break;
				}
			}

			trace(" ! MapData.spawnPoint	: " + spawnPoint);

			if (bitmapData)
				bitmapData.dispose();
			bitmapData = new BitmapData(w * _scaleX, h * _scaleZ);
			bitmapData.draw(_bitmapData, new Matrix(_scaleX, 0, 0, _scaleZ));

			return this;
		}

		/*
		   public function get width(): { return bitmapData.width; }

		   public function set width(value:):void {
		   bitmapData.width = value;
		   }

		   public function get height(): { return bitmapData.height; }

		   public function set height(value:):void {
		   bitmapData.height = value;
		   }
		 */

		// _______________________________________________________ external

		public function writeExternal(output:IDataOutput):void
		{
			output.writeObject({});
		}

		public function readExternal(input:IDataInput):void
		{
			parse(input.readObject());
		}
	}
}