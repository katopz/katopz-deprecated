package com.sleepydesign.core
{
	import org.osflash.signals.Signal;

	/**
	 * hidden -> show -> shown
	 * shown  -> hide -> hidden
	 */
	public interface ITransitionable
	{
		/**
		 * enable mouse, visible, alpha 1
		 */		
		function shown():void;
		
		/**
		 * disable mouse, not visible, alpha 0
		 */
		function hidden():void;
		
		/**
		 * auto alpha 1 -> shown -> dispatch complete
		 */
		function show():Signal;
		
		/**
		 * auto alpha 0 -> hidden -> dispatch complete
		 */
		function hide():Signal;
	}
}