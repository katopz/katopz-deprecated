package
{
	public class Test
	{
		private static function getFakeData():Array
		{
			//fake data
			var candles:Array = [];

			var totalPoint:int = 1000;
			for (var i:int = 0; i < totalPoint; i++)
			{
				var _candle:Candle = new Candle(String(i), int(1000 * Math.random()), int(1000 * Math.random()));
				candles[i] = _candle;
			}
			return candles;
		}
	}
}