package com.sleepydesign.components
{
	import com.sleepydesign.core.SDLoader;
	import com.sleepydesign.events.SDEvent;
	import com.sleepydesign.events.SDMouseEvent;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.errors.*;
	import flash.events.*;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.text.TextField;
	
	public class SDMediaPlayer extends SDComponent
	{
		private var uri			:String;
		
		private var _soundButton:SimpleButton;
		private var _playButton	:SimpleButton;
		private var _stopButton	:SimpleButton;
		private var _labelText	:TextField;
		
		private var _volumeBar	:MovieClip;
		
		private var loader		:SDLoader;
		private var isPlay		:Boolean = false;
		private var isMute		:Boolean = false;
		
		public function SDMediaPlayer(uri:String="")
		{
			this.uri = uri;
			
			// load music
			loaderInstance = new SDMacPreloader();
			addChild(loaderInstance);
			//loaderInstance.visible = false;
			
			super();
		}
		
		private var loaderInstance:SDMacPreloader
		
		override protected function onStage(event:Event=null):void
		{
			super.onStage(event);
			
			_soundButton = getChildByName("soundButton")?SimpleButton(getChildByName("soundButton")):new SimpleButton();
			_playButton = getChildByName("playButton")?SimpleButton(getChildByName("playButton")):new SimpleButton();
			_stopButton = getChildByName("stopButton")?SimpleButton(getChildByName("stopButton")):new SimpleButton();
			_labelText = getChildByName("labelText")?TextField(getChildByName("labelText")):new TextField();
			
			_volumeBar = getChildByName("volumeBar")?MovieClip(getChildByName("volumeBar")):new MovieClip();
			
			_soundButton.addEventListener(MouseEvent.CLICK, onSoundButtonClick);
			_playButton.addEventListener(MouseEvent.CLICK, onPlayButtonClick);
			_stopButton.addEventListener(MouseEvent.CLICK, onStopButtonClick);
			
			_volumeBar.addEventListener(MouseEvent.MOUSE_DOWN, onVolumeBar);
			stage.addEventListener(MouseEvent.MOUSE_UP, onVolumeBar);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onVolumeBar);
			
			// auto load
			if(uri!="")load(uri);
		}
		
		public function load(uri:String):void
		{
			this.uri = uri;
			
			if(_labelText)
				_labelText.text = "Streaming...";
			
			//song name
			loader = new SDLoader(loaderInstance);
			SDLoader.engine.logLevel = 0;
			loader.addEventListener(SDEvent.COMPLETE, onSongNameComplete);
			loader.load(songName_URI,null,null,"text");
			
			//loaderInstance.visible = true;
		}
		
		private var songName_URI:String = "http://www.myfineday.com/research/100/radio/radio_stats.php";
		private function onSongNameComplete(event:SDEvent):void
		{
			trace("onSongNameComplete")
			loader.removeEventListener(SDEvent.COMPLETE, onSongNameComplete);
			
			if(loader.isContent(songName_URI))
			{
				var songName:String = loader.getContent(songName_URI, true);
				if(_labelText)
					_labelText.text = songName;
			}
			
			loader.addEventListener(SDEvent.PROGRESS, onSoundStream);
			loader.addEventListener(SDEvent.COMPLETE, onSoundComplete);
			loader.load(uri,null,null,"sound");
		}
		
		private function onSoundComplete(event:SDEvent):void
		{
			loader.removeEventListener(SDEvent.COMPLETE, onSoundComplete);
			loader.removeEventListener(SDEvent.PROGRESS, onSoundStream);
			
			stop();
			
			// complete = fail
			fail();
		}
		
		private var sound:Sound;
		
		private function onSoundStream(event:SDEvent):void
		{
			sound = loader.getContent(uri, false) as Sound;
			if(sound)
			{
				if(!isPlay && !sound.isBuffering)
				{
					_channel = sound.play();
					_volume = _channel.soundTransform.volume;
					trace(" ! SoundChannel : "+_channel)
					
					isPlay = true;
					dispatchEvent(new SDEvent(SDEvent.PROGRESS));
				}
			}
		}
		
		private var _channel		:SoundChannel;
		private function updateChannel() : void 
		{
		     _channel.soundTransform = new SoundTransform(_channel.soundTransform.volume, 0 );
		}
		
		// _________________________________________________ Mouse
		
		private var isDrag:Boolean = false;
		
		private function onVolumeBar(event:MouseEvent):void
		{
			var barClip:MovieClip;
			
			if(event.currentTarget && event.currentTarget==_volumeBar)
				barClip = event.currentTarget.fullness_mc.fill_mc;
			
			switch(event.type)
			{
				case MouseEvent.MOUSE_DOWN:
					isDrag = true;
					barClip.width = event.localX;
					setVolume(_volumeBar.fullness_mc.fill_mc.scaleX);
				break;
				case MouseEvent.MOUSE_UP:
					isDrag = false;
				break;
				case MouseEvent.MOUSE_MOVE:
					if(isDrag)
					{
						_volumeBar.fullness_mc.fill_mc.width = _volumeBar.mouseX;
						setVolume(_volumeBar.fullness_mc.fill_mc.scaleX);
					}
				break;
			}
		}
		
		private var _volume:Number;
		
		private function setVolume(volume:Number):void
		{
			if(!_channel)return;
			
			_volume = Math.min(1, volume);
			
			trace(" * setVolume : "+_volume);
			
			if(_volume>0)
			{
				//TweenMax.to(_channel, .25, {volume:_volume, onUpdate:updateChannel});
				_channel.soundTransform = new SoundTransform(_volume, 0);
			}else{
				 _channel.soundTransform = new SoundTransform(0, 0);
			}
		}
		
		private function onSoundButtonClick(event:MouseEvent):void
		{
			if(!_channel)return;
			trace(" ^ onSoundButtonClick : "+isMute);
			isMute = !isMute;
			
			if(isMute)
			{
				event.target.alpha = 0;
				_channel.soundTransform = new SoundTransform(0, 0);
				//TweenMax.to(_channel, .25, {volume:0, onUpdate:updateChannel});
			}else{
				event.target.alpha = 1;
				setVolume(_volume);
			}
			
			//_soundButton.on_mc.visible = !_soundButton.on_mc.visible;
			//dispatchEvent(new SDMouseEvent(SDMouseEvent.CLICK, {type:_soundButton.on_mc.visible?"sound_on":"sound_off"}, event));
			
			dispatchEvent(new SDMouseEvent(SDMouseEvent.CLICK, {type:isMute?"sound_off":"sound_on"}, event));
		}
		
		private function onPlayButtonClick(event:MouseEvent):void
		{
			trace(" ^ onPlayButtonClick");
			dispatchEvent(new SDMouseEvent(SDMouseEvent.CLICK, {type:"play"}, event));
			//_playButton.play_mc.visible = !_playButton.play_mc.visible;
			//dispatchEvent(new SDMouseEvent(SDMouseEvent.CLICK, {type:"play", status:_playButton.play_mc.visible?"play":"pause"}, event));
			
			if(!loader)
			{
				load(uri);
			}
		}
		
		private function onStopButtonClick(event:MouseEvent):void
		{
			trace(" ^ onStopButtonClick");
			dispatchEvent(new SDMouseEvent(SDMouseEvent.CLICK, {type:"stop"}, event));
			stop();
		}
		
		public function stop():void 
		{
			if(_channel)
			{
				_channel.soundTransform = new SoundTransform(0, 0);
				_channel = null;
			}
			
			if(sound)
			{
				if(sound.isBuffering)
					sound.close();
				
				sound = null;
			}
			
			isPlay = false;
			
			if(loader)
			{
				loader.remove(uri);
				loader = null;
			}
		}
		
		// _________________________________________________ Header
		
		private var stream:URLStream;
		
        public function readHeader():void 
        {
           trace("readHeader");
           
            stream = new URLStream();
            var request:URLRequest = new URLRequest(uri);
            //stream.addEventListener(Event.COMPLETE, onComplete);
            stream.addEventListener(ProgressEvent.PROGRESS, onProgress)
            
            try {
                stream.load(request);
            } catch (error:Error) {
                dispatchEvent(new SDEvent(SDEvent.ERROR));
                trace("\n ! FAIL\n");
            }
        }

		private function parseHeader():void 
		{
            trace(" * Parse header\n");
            
			var header:String ="";
			var i:uint = 304;
			while (stream.bytesAvailable && --i) 
			{
				var num:int = Number(stream.readByte());
				if(num>19)
				{
					header = header + String.fromCharCode(num);
				}
			}
			
			var icy_name:String = header.substring(header.indexOf("icy-name:")+String("icy-name:").length, header.indexOf("icy-genre:"));
			trace(header+"\n");
			
			if(icy_name.length>0)
			{
				trace(" ! icy_name : " + icy_name+"\n");
				//trace("_labelText:"+_labelText,_labelText.text);
				
				_labelText.text = icy_name;
				
				//trace("_labelText:"+_labelText,_labelText.text);
			}
			
			/*
			ICY200OK
			icy-notice1:
			<BR>Thisstreamrequires<ahref="http://www.winamp.com/">Winamp</a>
			<BR>icy-notice2:SHOUTcastDistributedNetworkAudioServer/FreeBSDv1.9.7
			<BR>icy-name:DJ-Articulator
			icy-genre:Various
			icy-url:http://www.100community.com/
			content-type:audio/mpeg
			icy-pub:1
			icy-br:80
			*/
        }

        private function onProgress(event:ProgressEvent):void 
        {
			// header ready
			if(event.bytesLoaded>304)
            {
            	trace(" ^ progressHandler: " + event);
            	
            	event.target.removeEventListener(ProgressEvent.PROGRESS, onProgress);
            	event.target.removeEventListener(Event.COMPLETE, onComplete);
            	
            	parseHeader();
            	stream.close();
            	stream = null;
            }
        }

        private function onComplete(event:Event):void 
        {
            trace("completeHandler: " + event);
            
            event.target.removeEventListener(Event.COMPLETE, onComplete);
            
            //parseHeader();
            stream.close();
            stream = null;
            
            _labelText.text = "Disconnected";
            
			// complete = fail
			//fail();
        }
        
         private function fail():void
         {
         	trace("\n ! FAIL\n");
         	if(_labelText)
         	_labelText.text = "Disconnected";
         	
         	dispatchEvent(new SDEvent(SDEvent.ERROR));
         } 
	}
}