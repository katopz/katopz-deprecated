package
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	public class Test
	{
		// assets
		[Embed(source="assets/ThaiMap.swf",symbol="ThaiMap")]
		private static var ThaiMapSWF:Class;
		private static var _mapSprite:Sprite = new ThaiMapSWF() as Sprite;
		
		public static function getFakeData():String
		{
			// map
			var _mapBitmapData:BitmapData = new BitmapData(_mapSprite.width, _mapSprite.height, true, 0x000000);
			_mapBitmapData.draw(_mapSprite);
			
			//fake data
			var candles:Array = [];

			var j:int = 0;
			for (var i:int=0;i<1000;i++)
			{
				var x:int = int(_mapSprite.width*Math.random()); 
				var y:int = int(_mapSprite.height*Math.random());
				if (_mapBitmapData.getPixel32(x,y) > 0)
				{
					candles.push(i+j+","+x+","+y);
				}
			}
			
			return candles.join(";");
		}
	}
}