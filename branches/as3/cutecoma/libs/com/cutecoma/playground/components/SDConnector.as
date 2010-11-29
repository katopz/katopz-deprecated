package com.cutecoma.playground.components
{
	import com.cutecoma.game.events.PlayerEvent;
	import com.cutecoma.playground.events.NetEvent;
	import com.cutecoma.playground.net.SharedObjectConnector;
	import com.sleepydesign.components.SDButton;
	import com.sleepydesign.components.SDComponent;
	import com.sleepydesign.components.SDTextInput;

	import flash.events.MouseEvent;

	import org.osflash.signals.Signal;

	public class SDConnector extends SDComponent
	{
		public var uri:String;
		private var room:String;
		private var currentRoom:String = "";

		private var connector:SharedObjectConnector;

		private var serverInputText:SDTextInput;
		private var connectButton:SDButton;

		private var isConnect:Boolean = false;

		public function get initSignal():Signal
		{
			return connector.initSignal;
		}

		public function get updateSignal():Signal
		{
			return connector.updateSignal;
		}

		//public var completeSignal:Signal = new Signal();

		public function SDConnector(uri:String = "rtmp://localhost/SOSample", room:String = "lobby", autorun:Boolean = true)
		{
			this.uri = uri;
			this.room = room;

			// TODO : apply from config ?
			serverInputText = new SDTextInput(uri);
			serverInputText.width = 200;
			addChild(serverInputText);

			// TODO : Toggle Button
			connectButton = new SDButton("Connect");
			connectButton.setSize(64, connectButton.height);
			connectButton.x = serverInputText.width;
			addChild(connectButton);
			connectButton.addEventListener(MouseEvent.CLICK, onClick);

			super();

			if (autorun)
			{
				connect(uri, room);
			}
		}

		private function onClick(event:MouseEvent):void
		{
			trace(" ^ onClick : " + isConnect);
			if (!isConnect)
			{
				connect(uri, room);
			}
			else
			{
				disconnect();
				connectButton.label = "Connect";
			}
		}

		public function connect(uri:String, room:String = "lobby"):SharedObjectConnector
		{
			trace(" * Connect		: " + uri, room);
			this.uri = uri;
			this.room = room;

			// debug
			serverInputText.text = "Try Connecting...";

			// dispose
			if (connector)
				disconnect();

			// new
			connector = new SharedObjectConnector(uri);
			connector.connectSignal.add(onConnect);
			//connector.addEventListener(NetEvent.CONNECT, onConnect);
			//connector.addEventListener(NetEvent.DISCONNECT, onDisConnect);
			connector.connect();

			return connector;
		}

		private function onConnect(type:String):void
		{
			if (type == NetEvent.CONNECT)
			{
				trace(" ^ onConnect");
				enterRoom(room);
			}
			else
			{
				trace(" ^ onDisConnect");
				serverInputText.text = serverInputText.defaultText;
			}
		}

		public function enterRoom(room:String):void
		{
			this.room = room;

			trace(" * Enter		: " + room);

			if (connector)
			{
				connector.initSignal.addOnce(onServerInit);
				connector.updateSignal.add(onServerUpdate);

				connector.createSharedObject(room);
			}

			// debug
			serverInputText.text = "Enter		: " + room;
		}

		public function exitRoom():void
		{
			trace(" * Exit			: " + room);

			if (connector)
			{
				connector.removeSharedObject();

				connector.initSignal.removeAll();
				connector.updateSignal.removeAll();
			}

			// debug
			serverInputText.text = "Exit		: " + room;
		}

		public function disconnect():void
		{
			connector.initSignal.removeAll();
			connector.updateSignal.removeAll();

			//connector.removeEventListener(NetEvent.CONNECT, onConnect);
			//connector.removeEventListener(NetEvent.DISCONNECT, onDisConnect);
			connector.connectSignal.removeAll();
			connector.disconnect();

			connector = null;
			isConnect = false;
		}

		// Server
		private function onServerInit():void
		{
			// debug
			serverInputText.text = " ^ onServerInit";
			connectButton.label = "Disconnect";
			isConnect = true;
		}

		private function onServerUpdate(data:Object):void
		{
			trace(" ^ onServerUpdate");
			// debug
			serverInputText.text = " ^ onServerUpdate";
		}

		// Client
		// TODO : replace player event with register player data
		public function onClientUpdate(data:Object):void
		{
			trace(" ^ onClientUpdate : " + data, data.act);
			if (connector)
			{
				var domain:String = String(stage.loaderInfo.applicationDomain.parentDomain);
				domain = (domain != "null") ? domain : "127.0.0.1";

				var sid:String = String(data.ms + "@" + domain);

				/*
				   connector.send(
				   {
				   // time stamp, TODO : ip
				   sid:sid,

				   // data
				   data:data
				   });

				   trace( " ! sid : "+sid);
				   trace( " ! data : "+data);
				 */

				connector.send(data);
			}
			else
			{
				trace(" ! Not Connect yet");
			}
		}
	}
}
