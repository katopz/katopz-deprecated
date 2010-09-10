package com.sleepydesign.core
{
	import org.osflash.signals.Signal;

	public interface ITask
	{
		function get completeSignal():Signal;
		function doTask():void;
	}
}