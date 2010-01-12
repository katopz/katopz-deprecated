package data
{
	public final class CandleData
	{
		public var id:String;
		public var x:int;
		public var y:int;
		
		public var msg:String;
		
		public function CandleData(id:String, x:int = 0, y:int = 0, msg:String = "")
		{
			this.id = id;
			this.x = x;
			this.y = y;
			this.msg = msg
		}
	}
}