package com.sleepydesign.core
{
    import com.sleepydesign.utils.ObjectUtil;
    
    import flash.display.DisplayObjectContainer;
    import flash.display.LoaderInfo;
    import flash.media.Sound;
    import flash.media.SoundChannel;
    import flash.media.SoundTransform;
    
    import gs.TweenLite;
	
	public class SDSound 
	{
		public var channel			:SoundChannel;
		private var container		:DisplayObjectContainer;
		
		public function SDSound(container:DisplayObjectContainer=null) 
		{
			this.container = container;
		}
		
		public function addMedia(asset:String):void
		{
			var _class:Class;
			if(!container)
			{
				_class = Class(ObjectUtil.getAsset(asset));
			}else{
				_class = ObjectUtil.getDefinition(container.loaderInfo, asset);
			}
			
			var music:Sound = new _class();
			channel = music.play(0,65535);
			channel.soundTransform.volume = 0;
		}
		
		private function updateChannel() : void 
		{
		     channel.soundTransform = new SoundTransform(channel.soundTransform.volume, 0 );
		}
		
		public function unmute():void
		{
			trace("unmute")
			TweenLite.to(channel, 2, {volume:1, onUpdate:updateChannel});
		}
		
		public function mute():void
		{
			trace("mute")
			TweenLite.to(channel, .5, {volume:0, onUpdate:updateChannel});
		}
	}
}
