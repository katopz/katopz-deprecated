package com.sleepydesign.core
{
	import org.osflash.signals.Signal;

	public interface ICommand
	{
		function get completeSignal():Signal;
		function doCommand():void;
	}
}