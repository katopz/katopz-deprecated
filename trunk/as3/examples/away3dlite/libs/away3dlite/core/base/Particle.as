package away3dlite.core.base
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	
	public final class Particle extends Vector3D
	{
		public var id:uint = 0;
		public var next: Particle;
		
		public var screenX: Number = 0.0;
		public var screenY: Number = 0.0;
		public var screenZ: Number = 0.0;
		
		public var width: Number = 1.0;
		public var height: Number = 1.0;
		
		public var scale: Number = 1.0;
		
		public var bitmapData:BitmapData;
		
		public var scales:Vector.<BitmapData>;
		public var rects:Vector.<Rectangle>;
		
		public function Particle(x:Number, y:Number, z:Number, bitmapData:BitmapData)
		{
			super(x, y, z);
			this.bitmapData = bitmapData;
			
			width = bitmapData.width; 
			height = bitmapData.height; 
		}
		
		public function render(_screenX:Number, _screenY:Number, _scale:Number):Particle
		{
			screenX = _screenX;
			screenY = _screenY;
			
			scale = _scale;
			
			return next;
		}
	}
}