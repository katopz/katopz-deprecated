package examples
{
    import com.sleepydesign.core.SDContainer;
    import com.sleepydesign.core.SDLoader;
    import com.sleepydesign.events.SDEvent;
    import com.sleepydesign.io.IOPosition;
    
    import flash.events.Event;
    import flash.net.URLLoader;
    import flash.net.URLLoaderDataFormat;
    import flash.net.URLRequest;
    import flash.net.registerClassAlias;
    import flash.utils.ByteArray;
	
	[SWF(backgroundColor="0xFFFFFF", frameRate="30", width="800", height="480")]
	public class ExReadWritePosition extends SDContainer
	{
		private var loader:SDLoader = new SDLoader();
		
		public function ExReadWritePosition()
		{
			super();
			
			// data
			var writePosition:IOPosition = new IOPosition(1.123456789,2.45,3.78);
			
			// internal write
			var byteArr:ByteArray = new ByteArray();
			byteArr.writeObject(writePosition);
			
			// internal read
 			byteArr.position = 0;
 			var readPosition:IOPosition = IOPosition(byteArr.readObject());
 			
			trace(" ! Internal 	: " + readPosition);
			
			// external write
			loader.loadBinary("http://127.0.0.1/sleepydesign/2009/PlayGround/bin-debug/write.php", byteArr);
			loader.addEventListener(SDEvent.COMPLETE, onWrite);
		}
		
		private function onWrite(event:SDEvent):void
		{
			trace(" ^ onWrite");
			loader.removeEventListener(SDEvent.COMPLETE, onWrite);
			
			// external read
			loader.loadBinary("http://127.0.0.1/sleepydesign/2009/PlayGround/bin-debug/read.php");
			loader.addEventListener(SDEvent.COMPLETE, onRead);
		}
		
		private function onRead(event:SDEvent):void
		{
			loader.removeEventListener(SDEvent.COMPLETE, onRead);
			
			var loadbyteArray:* = SDLoader.getLastContent();
			loadbyteArray.position = 0;
			var readPosition:IOPosition= loadbyteArray.readObject() as IOPosition;
			trace(" ! External 	: " + readPosition);
		}
	}
}
