/*
Copyright (c) 2008 David Lenaerts.  See:
    http://code.google.com/p/wick3d
    http://www.derschmale.com

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/
package com.derschmale.wick3d.core.pipeline
{
	import com.derschmale.wick3d.events.RenderEvent;
	
	import flash.events.EventDispatcher;
	
	/**
	 * The RenderNotifier class is responsible for broadcasting events concerning the RenderPipeline to the engine. This class uses the singleton design pattern.
	 * 
	 * @see com.derschmale.wick3d.core.pipeline.RenderPipeline
	 * @see com.derschmale.wick3d.events.RenderEvent
	 * 
	 * @author David Lenaerts
	 */
	public class RenderNotifier extends EventDispatcher
	{
		private static var _instance : RenderNotifier;
		
		/**
		 * @private
		 */
		public function RenderNotifier(sf : SingletonEnforcer)
		{
			super();
		}
		
		/**
		 * Returns the only instance of RenderNotifier, which is accessible throughout the whole engine.
		 * 
		 */
		public static function getInstance() : RenderNotifier
		{
			if (!_instance) _instance = new RenderNotifier(new SingletonEnforcer());
			return _instance;
		}
		
		/**
		 * Broadcasts a RenderEvent to the whole engine.
		 * 
		 * @param pipeline The RenderPipeline causing the event.
		 * @param type The type of the event to be broadcast.
		 * 
		 * @see com.derschmale.wick3d.events.RenderEvent
		 */
		public function notify(pipeline : RenderPipeline, type : String) : void
		{
			dispatchEvent(new RenderEvent(type, pipeline));
		}
	}
}

class SingletonEnforcer {}