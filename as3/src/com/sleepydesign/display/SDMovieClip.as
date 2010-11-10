package com.sleepydesign.display
{
	import com.sleepydesign.core.IDestroyable;
	import com.sleepydesign.utils.DisplayObjectUtil;

	import flash.display.MovieClip;

	dynamic public class SDMovieClip extends MovieClip implements IDestroyable
	{
		protected var _isDestroyed:Boolean;

		public function get destroyed():Boolean
		{
			return _isDestroyed;
		}

		public function destroy():void
		{
			_isDestroyed = true;

			DisplayObjectUtil.removeChildren(this, true, true);

			try
			{
				if (parent != null)
					parent.removeChild(this);
			}
			catch (e:*)
			{
			}
		}
	}
}