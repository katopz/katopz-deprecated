package de.nulldesign.sound 
{
	import flash.events.Event;		

	public class SoundEvent extends Event 
	{

		static public const TYPE:String = "onSound";
		public var amp:Number;

		public function SoundEvent(amp:Number) 
		{
			super(TYPE, true);
			this.amp = amp;
		}
	}
}
