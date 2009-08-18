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
	import com.derschmale.wick3d.core.geometry.Triangle3D;
	
	import flash.events.Event;

	/**
	 * A Mouse3DEvent object is dispatched by a Model3D whenever a mouse events occurs on it, if its material's interactive property is set to true.
	 * If the material is a TextureMaterial (or any of its subclasses), the texture coordinates over which the mouse points in the 2D viewport are provided.  
	 * 
	 * @see com.derschmale.wick3d.core.objects.Model3D
	 * @see com.derschmale.wick3d.materials.AbstractMaterial
	 * 
	 * @author David Lenaerts
	 */
	public class Mouse3DEvent extends Event
	{
		/**
		 * Defines the value of the type property of a mouse3DMove event object.
		 */
		public static const MOUSE_MOVE : String = "mouse3DMove";
		
		/**
		 * Defines the value of the type property of a mouse3DOut event object.
		 */
		public static const MOUSE_OUT : String = "mouse3DOut";
		
		/**
		 * Defines the value of the type property of a mouse3DOver event object.
		 */
		public static const MOUSE_OVER : String = "mouse3DOver";
		
		/**
		 * Defines the value of the type property of a mouse3DClick event object.
		 */
		public static const CLICK : String = "mouse3DClick";
		
		private var _triangle : Triangle3D;
		
		private var _x : Number;
		private var _y : Number;
		
		/**
		 * Creates a new Mouse3DEvent instance.
		 * 
		 * @param type The type of the Mouse3DEvent.
		 * @param x The x-coordinate in texture coordinates of the material rendered under the mouse position.
		 * @param y The y-coordinate in texture coordinates of the material rendered under the mouse position.
		 * @param triangle The triangle upon which the mouse event was detected.
		 * @param bubbles Determines whether the Event object participates in the bubbling stage of the event flow. The default value is false.
		 * @param cancelable Determines whether the Event object can be canceled. The default values is false.
		 */
		public function Mouse3DEvent(type:String, x : Number, y : Number, triangle : Triangle3D, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			_x = x;
			_y = y;
			_triangle = triangle;
			super(type, bubbles, cancelable);
		}
		
		/**
		 * The triangle upon which the mouse event was detected.
		 * 
		 * @see com.derschmale.wick3d.core.geometry.Triangle3D
		 */
		public function get triangle() : Triangle3D
		{
			return _triangle;
		}
		
		/**
		 * The x-coordinate in texture coordinates of the material rendered under the mouse position.
		 */
		public function get x() : Number
		{
			return _x;
		}
		
		/**
		 * The y-coordinate in texture coordinates of the material rendered under the mouse position.
		 */
		public function get y() : Number
		{
			return _y;
		}
	}
}