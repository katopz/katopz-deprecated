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
package com.derschmale.wick3d.events
{
	import com.derschmale.wick3d.core.pipeline.RenderPipeline;
	
	import flash.events.Event;

	/**
	 * A RenderEvent object is dispatched by RenderNotifier to inform listening objects throughout the engine of important events in the RenderPipeline.
	 * 
	 * @see com.derschmale.wick3d.core.pipeline.RenderNotifier
	 * @see com.derschmale.wick3d.core.pipeline.RenderPipeline
	 * 
	 * @author David Lenaerts
	 */
	public class RenderEvent extends Event
	{
		/**
		 * Defines the value of the type property of a renderStart event object.
		 */
		public static const RENDER_START : String = "renderStart";
		
		private var _pipeline : RenderPipeline;
		
		/**
		 * Creates a RenderEvent object.
		 * 
		 * @param type The type of the event.
		 * @param pipeline The RenderPipeline responsible for the event.
		 * @param bubbles Determines whether the Event object participates in the bubbling stage of the event flow. The default value is false.
		 * @param cancelable Determines whether the Event object can be canceled. The default values is false.
		 */
		public function RenderEvent(type:String, pipeline : RenderPipeline, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_pipeline = pipeline;
		}
		
		/**
		 * The RenderPipeline responsible for the event.
		 */
		public function get pipeline() : RenderPipeline
		{
			return _pipeline;
		}
		
	}
}