package 
{
	import flash.display.BitmapData;
	
	public final class Particle 
	{
		public var x: Number = 0.0;
		public var y: Number = 0.0;
		public var z: Number = 0.0;
		
		public var next: Particle;
		
		public var screenX: Number = 0.0;
		public var screenY: Number = 0.0;
		public var screenZ: Number = 0.0;
		
		public var index:uint = 0;
		
		public var bitmapData:BitmapData;
		public var scale:Number = 1;
		
		public var scales:Vector.<BitmapData>;
	}
}
