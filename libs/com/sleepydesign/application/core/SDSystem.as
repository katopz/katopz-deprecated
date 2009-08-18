package com.sleepydesign.application.core
{
	import com.sleepydesign.core.SDContainer;
	
	import flash.net.FileReference;

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