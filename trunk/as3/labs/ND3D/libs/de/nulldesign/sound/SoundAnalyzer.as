package de.nulldesign.sound 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.media.Sound;
	import flash.media.SoundMixer;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;	

	public class SoundAnalyzer extends EventDispatcher 
	{

		private var sound:Sound;
		private var bytes:ByteArray;
		private var dummySprite:Sprite;

		public var averageEnergy:Number = 0;
		private var lastAverageEnergy:Number = 0;

		public function SoundAnalyzer(songUrl:String) 
		{
			
			dummySprite = new Sprite();
			dummySprite.addEventListener(Event.ENTER_FRAME, onAnalyze);
			
			sound = new Sound();
			sound.load(new URLRequest(songUrl));
			sound.play(0, 999);	
			
			bytes = new ByteArray();
		}

		private function onAnalyze(evt:Event):void 
		{
			
			// SOUND SPECTRUM 0-255 left channel, 256 - 512 right channel
			SoundMixer.computeSpectrum(bytes, true, 3);
			
			var value:Number = 0;
			var i:Number = 0;
			while(bytes.bytesAvailable) 
			{
				value += bytes.readFloat();
				++i;
			}

			averageEnergy = value / i;

			if(averageEnergy > lastAverageEnergy && Math.abs(averageEnergy - lastAverageEnergy) > 0.02) 
			{
				dispatchEvent(new SoundEvent(averageEnergy));
			}
			
			lastAverageEnergy = averageEnergy;
		}
	}
}
