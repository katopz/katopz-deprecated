package examples
{
    import com.sleepydesign.core.SDContainer;
    import com.sleepydesign.core.SDLoader;
    import com.sleepydesign.events.SDEvent;
    import com.sleepydesign.io.IOTransform;
    
    import flash.utils.ByteArray;
    
    import org.papervision3d.objects.DisplayObject3D;
	
	public class ExReadWriteTransform extends SDContainer
	{
		private var loader:SDLoader = new SDLoader();
		
		public function ExReadWriteTransform()
		{
			super();
			
			// data
			var displayObject3D:DisplayObject3D = new DisplayObject3D();
			
			displayObject3D.x = 1.123456789;
			displayObject3D.y = 2.45;
			displayObject3D.z = 3.78;
			
			displayObject3D.rotationX = 10;
			displayObject3D.rotationY = 20;
			displayObject3D.rotationZ = 30;
			
			// force update
			displayObject3D.updateTransform();
			trace(displayObject3D.transform);
			
			var writeTransform:IOTransform = new IOTransform(displayObject3D.transform.toArray());
			
			// internal write
			var byteArr:ByteArray = new ByteArray();
			byteArr.writeObject(writeTransform);
			
			// internal read
 			byteArr.position = 0;
 			var readTransform:IOTransform = IOTransform(byteArr.readObject());
 			
			trace(" ! Internal 	: " + readTransform);
			
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
			var readTransform:IOTransform= loadbyteArray.readObject() as IOTransform;
			trace(" ! External 	: " + readTransform);
		}
	}
}
