package com.sleepydesign.core
{
	//import com.sleepydesign.utils.DisplayObjectUtil;
	import com.greensock.TweenLite;
	import com.sleepydesign.utils.DisplayObjectUtil;
	import com.sleepydesign.utils.SystemUtil;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.IEventDispatcher;

	/**
	 * SleepyDesign Sprite
	 * @author katopz
	 */
	public class SDSprite extends Sprite implements IEventDispatcher, IDestroyable
	{
		protected var _isDestroyed:Boolean;
		public function get destroyed():Boolean {
			return this._isDestroyed;
		}
		
		public function SDSprite():void
		{
			//
		}

		// Event Garbage Collector : Use weak referrence http://www.onflex.org/ted/2008/09/useweakreferencesboolean-false.php
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = true):void
		{
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}

		/**
		 * Destroy Strategy #1 : http://www.moock.org/blog/archives/000279.html
		 * - Tell any loaded .swf child assets to disable themselves.
		 * - Stop any sounds from playing.
		 * - Stop the main timeline, if it is currently playing.
		 * - Stop any movie clips that are currently playing.
		 * - Close any connected network objects, such as instances of Loader, URLLoader, Socket, XMLSocket, LocalConnection, NetConnections, and NetStream.
		 * - Release all references to cameras and microphones.
		 * - Unregister all event listeners in the .swf (particularly Event.ENTER_FRAME, and mouse and keyboard listeners)
		 * - Stop any currently running intervals (via clearInterval()).
		 * - Stop any Timer objects (via the Timer class’s instance method stop()).
		 *
		 * Destroy Strategy #2 : Adobe Doc
		 * - Sounds are stopped.
		 * - Stage event listeners are removed.
		 * - Event listeners for enterFrame, frameConstructed, exitFrame, activate and deactivate are removed.
		 * - Timers are stopped.
		 * - Camera and Microphone instances are detached
		 * - Movie clips are stopped.
		 *
		 */
		override public function removeChild(child:DisplayObject):DisplayObject
		{
			// Exist?
			if (!child)
				return null;

			//trace(" * removeChild	: "+DisplayObjectUtil.toString(child));

			// Tween?
			TweenLite.killTweensOf(child);

			if (child is Shape)
			{
				Shape(child).graphics.clear();
			}
			else if (child is Bitmap && Bitmap(child).bitmapData)
			{
				Bitmap(child).bitmapData.dispose();
			}
			else if (child is DisplayObjectContainer)
			{
				// MovieClip is stopped.
				if (child is MovieClip)
					MovieClip(child).stop();

				var childContainer:DisplayObjectContainer = DisplayObjectContainer(child);
				while (childContainer.numChildren > 0)
				{
					var _child:DisplayObject = childContainer.getChildAt(childContainer.numChildren - 1);
					_child.parent.removeChild(_child);
				}
			}

			// Remove
			if (child.parent && child != this)
			{
				if(super.contains(child))
					super.removeChild(child);

				// Got own suicide plane
				if (child is IDestroyable)
					IDestroyable(child).destroy();
			}

			if (child.mask)
				child.mask = null;

			// Kill
			child = null;

			return null;
		}

		// ______________________________ Destroy ______________________________

		public function destroy():void
		{
			removeChild(this);

			// Garbage Collecter
			SystemUtil.gc();
		}

		public function kill(... lists):void
		{
			if (lists[0] is Array)
				lists = lists[0];

			// Self Destruction
			if (lists.length == 0)
			{
				destroy();
			}
			else
			{
				for each (var child:*in lists)
				{
					if (child is DisplayObject)
						child.parent.removeChild(child);
					child = null;
				}

				// Garbage Collecter
				SystemUtil.gc();
			}
		}
	}
}