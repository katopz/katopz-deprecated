package com.sleepydesign.core
{
	/**
	 * hidden -> show -> shown
	 * shown  -> hide -> hidden
	 */
	public interface ITransitionable
	{
		/**
		 * enable mouse, visible, alpha 1
		 */		
		function activate():void;
		
		/**
		 * disable mouse, not visible, alpha 0
		 */
		function deactivate():void;
		
		/**
		 * auto alpha 1 -> shown -> dispatch complete
		 */
		function show():void;
		
		/**
		 * auto alpha 0 -> hidden -> dispatch complete
		 */
		function hide():void;
	}
}