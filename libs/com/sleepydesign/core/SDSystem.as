package com.sleepydesign.core
{
	import com.sleepydesign.events.SDEvent;
	import com.sleepydesign.utils.URLUtil;
	
	import flash.events.Event;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	import flash.utils.IExternalizable;

	/**
	 * _____________________________________________________
	 *
	 * SleepyDesign System
	 * @author katopz
	 * _____________________________________________________
	 *
	 */
	public class SDSystem extends SDContainer
	{
		public var file:FileReference;

		public function SDSystem(id:String = null, raw:Object = null)
		{
			super(id, raw);
		}

		// ______________________________ Initialize ______________________________

		override public function init(raw:Object = null):void
		{
			if (!raw || !raw.container || !raw.stage)
				return;
			raw.stage.addChild(this);
		}
	}
}