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

package com.derschmale.events
{
	import flash.display.BitmapData;
	import flash.events.Event;
	
	/**
	 * The ImageLoaderEvent represents Event objects dispatched when Image Loaders have finished loading.
	 * 
	 * @see com.derschmale.display.io.PCXLoader
	 * 
	 * @author David Lenaerts
	 */
	public class ImageLoaderEvent extends Event
	{
		/**
		 * The ImageLoaderEvent.IMAGE_LOADED constant defines the value of the type property of an image loaded event object.
		 */
		public static const IMAGE_LOADED : String = "imageLoaded";
		
		private var _bitmapData : BitmapData;
		
		/**
		 * Creates an ImageLoaderEvent object to pass as a parameter to event listeners.
		 * 
		 * @param type The type of the event.
		 * @param bitmapData The bitmapData containing the image that was loaded.
		 * @param bubbles Determines whether the ImageLoaderEvent object participates in the bubbling stage of the event flow. The default value is false.  
		 * @param cancelable Determines whether the ImageLoaderEvent object can be canceled. The default values is false.  
		 */
		public function ImageLoaderEvent(type:String, bitmapData:BitmapData = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_bitmapData = bitmapData;
		}
		
		/**
		 * The bitmapData containing the image that was loaded.
		 */
		public function get bitmapData() : BitmapData
		{
			return _bitmapData;
		}
		
		/**
		 * Duplicates an instance of an ImageLoaderEvent object.
		 * 
		 * @return An exact duplicate of this ImageLoaderEvent object.
		 */
		override public function clone():Event
		{
			var clone : ImageLoaderEvent = new ImageLoaderEvent(type, _bitmapData, bubbles, cancelable);
			return clone;
		}
	}
}