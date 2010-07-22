package com.cutecoma.playground.net
{
	import com.cutecoma.playground.events.NetEvent;
	import com.sleepydesign.events.RemovableEventDispatcher;
	import com.sleepydesign.system.DebugUtil;
	import com.sleepydesign.utils.ObjectUtil;
	
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.SyncEvent;
	import flash.net.NetConnection;
	import flash.net.ObjectEncoding;
	import flash.net.SharedObject;
	
	import org.osflash.signals.Signal;

	public class SharedObjectConnector extends RemovableEventDispatcher
	{
		private var uri:String;

		private var nc:NetConnection;
		private var so:SharedObject;
		private var room:String;

		private var ports:Array = [1935, 80, 443, 8080, 7070];
		
		public var initSignal:Signal = new Signal();
		public var updateSignal:Signal = new Signal(Object);

		public var status:String = NetEvent.DISCONNECT;

		// _______________________________________________________ Main

		public function SharedObjectConnector(uri:String):void
		{
			this.uri = uri;

			//set
			nc = new NetConnection();
			nc.objectEncoding = ObjectEncoding.AMF3;

			//listen
			nc.addEventListener(NetStatusEvent.NET_STATUS, onConnectHandler, false, 0, true);
			nc.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onConnectErrorHandler, false, 0, true);
		}

		public function connect():void
		{
			trace(" ! Connect		: " + uri);
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
			switch (event.info.code)
			{
				case "NetConnection.Connect.Success":
					status = NetEvent.CONNECT;
					dispatchEvent(new NetEvent(NetEvent.CONNECT));
					break;
				default:
					status = NetEvent.DISCONNECT;
					dispatchEvent(new NetEvent(NetEvent.DISCONNECT));
					break;
			}
		}

		// _______________________________________________________ SharedObject

		public function removeSharedObject():void
		{
			if (so)
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

			try
			{
				so.connect(nc);
			}
			catch (e:*)
			{
				DebugUtil.trace(e);
			}
		}

		// _______________________________________________________ SyncEvent

		private function onServerUpdate(event:SyncEvent):void
		{
			var data:* = so.data[room];

			if (data != undefined)
			{
				DebugUtil.trace(" ! ServerUpdate		: " + data);
				//ObjectUtil.print(data);
				updateSignal.dispatch(data);
			}
			else
			{
				DebugUtil.trace(" ! ServerInit		: " + event);
				initSignal.dispatch();
			}
		}

		public function send(data:Object = null):void
		{
			if (!nc.connected)
				return;

			DebugUtil.trace(" * Send			: " + room, data);

			try
			{
				so.setProperty(room, data);
			}
			catch (e:*)
			{
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
