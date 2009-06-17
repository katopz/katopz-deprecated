package examples
{
    import com.sleepydesign.core.SDContainer;
    import com.sleepydesign.events.NetEvent;
    import com.sleepydesign.events.SDEvent;
    import com.sleepydesign.io.IOPosition;
    import com.sleepydesign.net.Red5Connector;
	
	[SWF(backgroundColor="0xFFFFFF", frameRate="30", width="800", height="480")]
	public class ExRed5 extends SDContainer
	{
		private var connector:Red5Connector;
		private var room:String = "SampleChat";
		
		public function ExRed5()
		{
			super();
			
			//[1935, 80, 443, 8080, 7070];
			//var uri:String = "rtmp://dedibox1.free.new-net.net/SOSample";
			//var uri:String = "rtmp://140.110.240.196/SOSample";
			//var uri:String = "rtmp://tomfmason.net/SOSample";
			//var uri:String = "rtmpt://red5.fatdot.com/SOSample";
			//var uri:String = "rtmp://red5.4ng.net/SOSample";
			//var uri:String = "rtmpt://217.29.160.103:5080/SOSample";
			//var uri:String = "rtmp://www.digs.jp/SOSample";
			
			var uri:String = "rtmp://localhost/SOSample";
			
			connector = new Red5Connector(uri);
			connector.addEventListener(NetEvent.CONNECT, onConnect);
			connector.addEventListener(NetEvent.DISCONNECT, onDisConnect);
			connector.connect();
		}
		
		private function onConnect(event:NetEvent):void
		{
			trace( " ^ onConnect");
			connector.addEventListener(SDEvent.INIT, onServerInit);
			connector.addEventListener(SDEvent.UPDATE, onServerUpdate);
			
			trace( " ^ enter		: "+room);
			connector.createSharedObject(room);
		}
		
		private function onServerInit(event:SDEvent):void
		{
			trace( " ^ onServerInit");
			trace( " * write");
			var writePosition:IOPosition = new IOPosition(1.123456789, 2.45, 3.78);
			connector.send("writePosition");
		}
		
		private function onServerUpdate(event:SDEvent):void
		{
			trace( " ^ onServerUpdate");
			trace( " * exit");
			connector.disconnect();
		}
		
		private function onDisConnect(event:NetEvent):void
		{
			trace( " ^ onDisConnect");
		}
	}
}
