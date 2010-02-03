package com.sleepydesign.net
{	
	import com.sleepydesign.core.SDObject;
	import com.sleepydesign.events.SDEvent;
	import com.sleepydesign.net.events.NetEvent;
	
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.SyncEvent;
	import flash.net.NetConnection;
	import flash.net.ObjectEncoding;
	import flash.net.SharedObject;
	
	public class Red5Connector extends SDObject
	{
		private var uri		: String;
		
		private var nc		: NetConnection;
		private var so		: SharedObject;
		private var room	: String;
		
		private var ports 	: Array = [1935, 80, 443, 8080, 7070];
		
		public var status 	: String = NetEvent.DISCONNECT;
		
		// _______________________________________________________ Main
		
		public function Red5Connector(uri:String):void 
		{
			if(uri)
				create({uri:uri});
		}
		
		// _______________________________________________________ Connect
		
		override public function create(config:Object=null):void 
		{
			uri = config.uri;
			
			//set
			nc = new NetConnection();
			nc.objectEncoding = ObjectEncoding.AMF3;
			
			//listen
			nc.addEventListener(NetStatusEvent.NET_STATUS, onConnectHandler, false, 0, true);
			nc.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onConnectErrorHandler, false, 0, true);
		} 
		
		public function connect():void 
		{
			//try
			trace(" ! Connect		: "+uri);
			
			//real
			nc.connect(uri);
		}
		
		public function disconnect():void 
		{
			trace(" ! Disconnect");
			removeSharedObject();
			
			nc.removeEventListener(NetStatusEvent.NET_STATUS, onConnectHandler);
			nc.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onConnectErrorHandler);
			nc.close();
		}
	
		// _______________________________________________________ NetConnectionHandler
		
		private function onConnectErrorHandler(event:SecurityErrorEvent):void 
		{
			trace(" ! Can't connect	: " + event);
		}
		
		private function onConnectHandler(event:NetStatusEvent):void 
		{
			trace(" ^ onConnectHandler	: " + event.info.code);
			
			switch(event.info.code) {
				case "NetConnection.Connect.Success" :
					status = NetEvent.CONNECT;
					dispatchEvent( new NetEvent(NetEvent.CONNECT));
				break;
				default :
					status = NetEvent.DISCONNECT;
					//SystemUtil.alert("Sorry! Can't connect you to server.");
					dispatchEvent( new NetEvent(NetEvent.DISCONNECT));
				break;
			}
		}
		
		// _______________________________________________________ SharedObject
		
		public function removeSharedObject():void 
		{
			if(so)
			{
				try
				{
					so.removeEventListener(SyncEvent.SYNC, onServerUpdate);
					so.clear();
					so.close();	
					so = null;
				}
				catch (e:Error) 
				{
					//
				}
			}
		}
		
		public function createSharedObject(room:String):void 
		{
			this.room = room;
			
			//destroy?
			//removeSharedObject();
			
			//create
			so = SharedObject.getRemote(room, nc.uri, false);
			so.removeEventListener(SyncEvent.SYNC, onServerUpdate);
			so.addEventListener(SyncEvent.SYNC, onServerUpdate, false, 0, true);
			try{
				so.connect(nc);
			}catch(e:*){trace(e);}
		}
		
		// _______________________________________________________ SharedObjectHandler
		
		private function onServerUpdate(event:SyncEvent):void 
		{
			var data:* = so.data[room];
			
			if(data != undefined) 
			{
				trace(" ! ServerUpdate		: "+ data);
				dispatchEvent( new SDEvent(SDEvent.UPDATE, data ));
			}else{
				trace(" ! ServerInit		: " + event);
				dispatchEvent( new SDEvent(SDEvent.INIT, data ));
			}
		}		
		
		// _______________________________________________________ Client
		
        public function send(data:Object=null):void 
		{
			if(!nc.connected)return;
			
			trace(" * Send			: " + room, data);
			
			/*
			//TODO : Object Serialize
			var player = event.player;
			var data = {
				id : player.data.id,
				
				pos : player.dolly.toXYZ(true),
				des : player.decoy.toXYZ(true),	
				
				act : player.extra.action,
				
				alias : player.data.alias,
				msg : player.data.msg
				
				//tag : extra.tag
				//skin : extra.skin
			}
			*/
			try{
				so.setProperty(room, data);
				/*
				so.setProperty(room, {
					ss : data.ss,
					id : data.id,
					pos : data.pos,
					src : data.src,
					act : data.act,
					spd : data.spd,
					des : data.des,
					msg : data.msg
				});
				*/
				/*
				so.setProperty(room, 
				{
					sid:String(data.ms+"@127.0.0.1"),
					data:data
				});
				*/
			}catch (e:*) {
				trace(e);
			}
        }
	}
}

/*
function init() {

 portList = [1935, 80, 443, 8080, 7070];

 i = 0;

 nc = new NetConnection();

 nc.onStatus = function(info) {

  if (info.code == "NetConnection.Connect.Failed") {

   trace("failed on "+portList[i]);

   i++;

   connectInterval = setInterval(doConnect, 100);

  } else if (info.code == "NetConnection.Connect.Success") {

   //call other functions here

   trace(nc.uri+": "+info.code);

  }

 };

 doConnect();

}

function doConnect() {

 clearInterval(connectInterval);

 trace("i is: "+i+" and portList[i] is: "+portList[i]);

 nc.connect("rtmp://yourDomain.com:"+portList[i]+"/yourAppName");

}
*/
