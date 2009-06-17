package com.sleepydesign.playground.data
{
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	/**
	* MapData
	* @author katopz@sleepydesign.com
	* @version 0.1
	*/
	public class MapData
	{
		public var bitmapData 	: BitmapData;
		public var spawnPoint	: Point;
		public var warpPoint	: Dictionary = new Dictionary(true);
		
		public function MapData(bitmapData:BitmapData=null)
		{
			if(bitmapData)
				this.bitmapData = bitmapData;
		}
		
		// ______________________________ Parse ______________________________
		
		public function parse(nodes:Array, colSize:uint, _scaleX:Number = 2, _scaleY:Number = 2):void
		{
			if(!nodes || nodes.length<1)return;
			
			var _length:int = nodes.length;
			var w:uint=colSize;
			var h:uint=uint(_length/w);
			
			var _bitmapData:BitmapData = new BitmapData(w,h,true,0xFF000000);
			
			for(var k :uint= 0; k < _length; k++)
			{
				var i:uint = k%w;
				var j:uint = uint(k/w);
				
				switch(nodes[k])
				{
					// OB
					case 0	: _bitmapData.setPixel(i, j, 0xFF000000); break;
					// walkable
					case 1	: _bitmapData.setPixel(i, j, 0xFFFFFFFF); break;
					
					// spawn
					case 2	: 
						_bitmapData.setPixel(i, j, 0xFF00FF00); 
						spawnPoint = new Point(i*_scaleX,j*_scaleY); 
					break;
					
					//warp
					default	: 
						_bitmapData.setPixel(i, j, 0xFF0000FF - nodes[k]);
						warpPoint[nodes[k]] = new Point(i*_scaleX,j*_scaleY);
						// no spawnPoint?
						if(!spawnPoint)spawnPoint=warpPoint[nodes[k]];
					break;
				}
			}
			
			trace(" ! MapData.spawnPoint	: "+spawnPoint);
			
			if(bitmapData)bitmapData.dispose();
			bitmapData = new BitmapData(w*_scaleX, h*_scaleY);
			bitmapData.draw(_bitmapData,new Matrix(_scaleX,0,0,_scaleY));
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
	}
}