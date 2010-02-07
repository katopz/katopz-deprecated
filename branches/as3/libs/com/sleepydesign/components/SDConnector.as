package com.sleepydesign.components
{
    import com.sleepydesign.events.SDEvent;
    import com.sleepydesign.events.SDMouseEvent;
    import com.sleepydesign.net.Red5Connector;
    import com.sleepydesign.net.events.NetEvent;
	
	public class SDConnector extends SDComponent
	{
		public var uri:String;
		private var room:String;
		private var currentRoom:String="";
		
		private var connector:Red5Connector;
		
		private var serverInputText:SDInputText
		private var connectButton:SDButton;
		
		private var isConnect:Boolean = false;
		
		public function SDConnector(uri:String="rtmp://localhost/SOSample", room:String = "lobby" , autorun:Boolean = true)
		{
			this.uri = uri;
			this.room = room;
			
			//[1935, 80, 443, 8080, 7070];
			//var uri:String = "rtmp://dedibox1.free.new-net.net/SOSample";
			//var uri:String = "rtmp://140.110.240.196/SOSample";
			//var uri:String = "rtmp://tomfmason.net/SOSample";
			//var uri:String = "rtmpt://red5.fatdot.com/SOSample";
			//var uri:String = "rtmp://red5.4ng.net/SOSample";
			//var uri:String = "rtmpt://217.29.160.103:5080/SOSample";
			//var uri:String = "rtmp://www.digs.jp/SOSample";
			
			// TODO : apply from config ?
			serverInputText = new SDInputText(uri);
			serverInputText.width = 200;
			addChild(serverInputText);
			
			// TODO : Toggle Button
			connectButton = new SDButton("Connect");
			connectButton.setSize(64, connectButton.height);
			connectButton.x = serverInputText.width;
			addChild(connectButton);
			connectButton.addEventListener(SDMouseEvent.CLICK, onClick);
			
			super();
			
			if(autorun)
			{
				connect(uri, room);
			}
		}
		
		private function onClick(event:SDMouseEvent):void
		{
			trace( " ^ onClick : "+isConnect);
			if(!isConnect)
			{
				connect(uri, room);
			}else{
				disconnect();
				connectButton.label = "Connect";
			}
		}
		
		public function connect(uri:String, room:String = "lobby"):Red5Connector
		{
			trace( " * Connect		: "+uri, room);
			this.uri = uri;
			this.room = room;
			
			// debug
			serverInputText.text = "Try Connecting...";
			
			// dispose
			if(connector)disconnect();
			
			// new
			connector = new Red5Connector(uri);
			connector.addEventListener(NetEvent.CONNECT, onConnect);
			connector.addEventListener(NetEvent.DISCONNECT, onDisConnect);
			connector.connect();
			
			return connector;
		}
		
		private function onConnect(event:NetEvent):void
		{
			trace( " ^ onConnect");
			/*
			// go out
			if(currentRoom==room)
			{
				exitRoom(room);
			}
			
			// go in
			currentRoom = room;
			*/
			enterRoom(room);
		}
		
		public function enterRoom(room:String):void
		{
			this.room = room;
			
			trace( " * Enter		: "+room);
			
			if(connector)
			{
				connector.addEventListener(SDEvent.INIT, onServerInit);
				connector.addEventListener(SDEvent.UPDATE, onServerUpdate);
				
				connector.createSharedObject(room);
			}
			
			// debug
			serverInputText.text = "Enter		: "+room;
		}
		
		public function exitRoom():void
		{
			trace( " * Exit			: "+room);
			
			if(connector)
			{
				connector.removeSharedObject();
			
				connector.removeEventListener(SDEvent.INIT, onServerInit);
				connector.removeEventListener(SDEvent.UPDATE, onServerUpdate);
			}
			
			// debug
			serverInputText.text = "Exit		: "+room;
		}
		
		public function disconnect():void
		{
			connector.removeEventListener(SDEvent.INIT, onServerInit);
			connector.removeEventListener(NetEvent.CONNECT, onConnect);
			connector.removeEventListener(NetEvent.DISCONNECT, onDisConnect);
			connector.disconnect();
			connector = null;
			isConnect = false;
		}
		
		private function onDisConnect(event:NetEvent):void
		{
			trace( " ^ onDisConnect");
			connector.removeEventListener(NetEvent.DISCONNECT, onDisConnect);
			
			// debug
			serverInputText.text = serverInputText.defaultText;
		}
		
		// Server
		private function onServerInit(event:SDEvent):void
		{
			trace(" ^ onServerInit");
			connector.removeEventListener(SDEvent.INIT, onServerInit);
			
			// debug
			serverInputText.text = " ^ onServerInit";
			connectButton.label = "Disconnect";
			isConnect = true;
			dispatchEvent(new SDEvent(SDEvent.COMPLETE));
		}
		
		private function onServerUpdate(event:SDEvent):void
		{
			trace(" ^ onServerUpdate");
			dispatchEvent(event.clone());
			
			// debug
			serverInputText.text = " ^ onServerUpdate";
		}
		
		// Client
		public function onClientUpdate(event:SDEvent):void
		{
			trace( " ^ onClientUpdate : "+ event.data);
			if(connector)
			{
				var domain:String = String(stage.loaderInfo.applicationDomain.parentDomain);
				domain = (domain!="null")?domain:"127.0.0.1";
				
				var sid:String = String(event.data.ms+"@"+domain);
				
				/*
				connector.send( 
				{
					// time stamp, TODO : ip
					sid:sid,
					
					// data
					data:event.data
				});
				
				trace( " ! sid : "+sid);
				trace( " ! data : "+event.data);
				*/
				
				connector.send(event.data);
			}else{
				trace( " ! Not Connect yet");
			}
		}
		/*
		public function onClientRemove(event:SDEvent):void
		{
			trace( " ^ onClientRemove : "+ event.data);
			if(connector)
				connector.send(event.data);
		}
		*/
	}
}
