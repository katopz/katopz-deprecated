package com.sleepydesign.events
{
	import org.osflash.signals.Signal;

	public class SignalProxy
	{
		public static var globalSignal:Signal = new Signal(String, Object);
	}
}