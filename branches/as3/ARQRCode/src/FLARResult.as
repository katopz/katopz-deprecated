package
{
	import org.libspark.flartoolkit.core.FLARSquare;
	import org.libspark.flartoolkit.core.transmat.FLARTransMatResult;
	import flash.events.MouseEvent;

	public class FLARResult
	{
		public var confidence:Number;
		public var cosine:Number;
		public var distance:Number;
		public var result:FLARTransMatResult;
		public var square:FLARSquare;
	
		public function FLARResult()
		{
			confidence = 0;
			result = new FLARTransMatResult;
		}
	}
}