package com.cutecoma.playground.data
{
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;
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

		//public function MapData(nodes:Array=null, width:uint=100, scaleX:Number = 1, scaleZ:Number = 1)
		public function MapData(bitmapData:BitmapData, spawnPoint:Point)
		{
			//parse({nodes:nodes, width: width, scaleX: scaleX, scaleZ: scaleZ});
			this.bitmapData = bitmapData;
			this.spawnPoint = spawnPoint;
		}

		// ______________________________ Parse ______________________________

		/*
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
						_bitmapData.setPixel(i, j, 0xFF0000FF);
						spawnPoint = new Point(i * scaleX, j * scaleZ);
						break;
					//warp
					default:
						_bitmapData.setPixel(i, j, Number("0xFF00FF"+ nodes[k]));
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
		*/

		// _______________________________________________________ external

		public function writeExternal(output:IDataOutput):void
		{
			var _bytes:ByteArray = bitmapData.getPixels(bitmapData.rect);
			//_png.compress();
			output.writeObject({width:bitmapData.width, height:bitmapData.height, bytes:_bytes});
			//output.writeBytes(_png);
			//var _png:ByteArray = new PNGEncoder().encode(bitmapData);
			//output.writeBytes(_png, 0, _png.length);
		}

		public function readExternal(input:IDataInput):void
		{
			//parse(input.readObject());
			var _obj:Object = input.readObject();
			
			var _rect:Rectangle = new Rectangle(0,0,_obj.width,_obj.height);
			var _bytes:ByteArray = ByteArray(_obj.bytes);
			_bytes.position = 0;
			bitmapData = new BitmapData(_rect.width, _rect.height, true, 0xFF000000);
			bitmapData.setPixels(_rect, _bytes);
			
			var spawnRect:Rectangle = bitmapData.getColorBoundsRect(0xFFFFFFFF, 0xFF0000FF);
			spawnPoint = spawnRect.topLeft; 
		}
	}
}