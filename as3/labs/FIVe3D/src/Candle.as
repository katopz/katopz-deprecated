package
{
	import flash.display.BitmapData;
	
	import net.badimon.five3D.display.Sprite2D;
	
	public final class Candle
	{
		public var id:String;
		public var x:int;
		public var y:int;
		
		public var visible:Boolean = true;
		public var sprite2D:Sprite2D;
		
		public var currentFrame:uint = 1;
		public var totalFrames:uint = 1;
		
		public var next:Candle;
		
		public var bitmapData:BitmapData;
		public var scale:Number = 1;
		public var scales:Array;
		
		public function Candle(id:String, x:int = 0, y:int = 0)
		{
			this.id = id;
			this.x = x;
			this.y = y;
		}
	}
}