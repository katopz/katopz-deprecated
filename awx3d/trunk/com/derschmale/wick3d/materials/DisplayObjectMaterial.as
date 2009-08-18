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

package com.derschmale.wick3d.materials
{
	import com.derschmale.wick3d.core.pipeline.RenderNotifier;
	import com.derschmale.wick3d.events.RenderEvent;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	/**
	 * The DisplayObjectMaterial class is a material that uses a DisplayObject as a texture, providing a way to create animated surfaces.
	 * 
	 * @author David Lenaerts
	 */
	public class DisplayObjectMaterial extends TextureMaterial implements IMaterial
	{
		private var _source : DisplayObject;
		private var _transparent : Boolean;
		private var _animated : Boolean;
		private var _width : Number;
		private var _height : Number;
		private var _rectangle : Rectangle;
		private var _renderNotifier : RenderNotifier;
		
		/**
		 * Creates a DisplayObjectMaterial instance.
		 * 
		 * @param source The DisplayObject used as the texture.
		 * @param width The width of the source in pixels. If not provided or -1, the current width of the source is used. Provide a different value if the source needs to be clipped or if the current width is smaller than the total width covered by the source over time.
		 * @param height The height of the source in pixels. If not provided or -1, the current height of the source is used. Provide a different value if the source needs to be clipped or if the current height is smaller than the total height covered by the source over time.
		 * @param animated Defines whether the source is animated or not. If true, the texture data is updated with every render.
		 * @param transparent Defines whether the texture should be transparent or not.
		 * @param smooth Defines whether the texture should be smoothed when drawing or not.
		 */
		public function DisplayObjectMaterial(source:DisplayObject, width:Number = -1, height:Number = -1, animated:Boolean=true, transparent:Boolean=false, smooth:Boolean=false)
		{
			super(null, smooth);
			_source = source;
			_transparent = transparent;
			_width = width;
			_height = height;
			
			if (_width == -1) _width = _source.width;
			if (_height == -1) _height = _source.height;
			_rectangle = new Rectangle(0, 0, _width, _height);
			
			initBitmapData();
			updateBitmapData();
			
			_renderNotifier = RenderNotifier.getInstance();
			
			this.animated = animated;
		}
		
		/**
		 * Updates the texture's bitmapData to match the current state of the source DisplayObject.
		 */
		public function updateBitmapData() : void
		{
			bitmapData.lock();
			if (_transparent) bitmapData.fillRect(_rectangle, 0xffffff);
			bitmapData.draw(_source);
			bitmapData.unlock();
		}
		
		/**
		 * Defines whether the source is animated or not. If true, the texture data is updated with every render. It is recommended to set this property to false whenever there is no animation. 
		 */
		public function get animated() : Boolean
		{
			return _animated;
		}
		
		public function set animated(value : Boolean) : void
		{
			if (_animated != value) {
				if (value)
					_renderNotifier.addEventListener(RenderEvent.RENDER_START, handleRenderStart);
				else
					_renderNotifier.removeEventListener(RenderEvent.RENDER_START, handleRenderStart);
			}
			_animated = value;
		}
		
		/**
		 * Defines whether the texture should be transparent or not.
		 */
		public function get transparent() : Boolean
		{
			return _transparent;
		}
		
		public function set transparent(value : Boolean) : void
		{
			_transparent = value;
			initBitmapData();
		}
		
		/**
		 * The DisplayObject used as the material's texture.
		 */
		public function get source() : DisplayObject
		{
			return _source;
		}
		
		public function set source(value : DisplayObject) : void
		{
			_source = value;
			initBitmapData();
		}
		
		private function initBitmapData() : void
		{
			if (bitmapData) bitmapData.dispose();
			bitmapData = new BitmapData(_width, _height, _transparent, 0xffffff);
		}
		
		private function handleRenderStart(event : RenderEvent) : void
		{
			updateBitmapData();
		}
	}
}