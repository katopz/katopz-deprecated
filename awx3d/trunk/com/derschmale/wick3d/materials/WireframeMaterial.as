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
	import com.derschmale.wick3d.core.geometry.Triangle3D;
	
	import flash.display.Graphics;

	/**
	 * The ColourMaterial class is a material consisting out of a single colour.
	 * 
	 * @author David Lenaerts
	 */
	public class WireframeMaterial extends AbstractMaterial implements IMaterial
	{
		private var _colour : int;
		private var _thickness : Number;
		
		/**
		 * Creates a ColourMaterial instance.
		 * 
		 * @param colour The colour of the material.
		 * @param alpha The transparency of this material;
		 */
		public function WireframeMaterial(colour : int, thickness : Number = 1)
		{
			super();
			_colour = colour;
			_thickness = thickness;
			doubleSided = true;
		}
		
		/**
		 * Renders a Triangle3D to the target Graphics object.
		 * 
		 * @param triangle The Triangle3D object to be rendered.
		 * @param target The Graphics instance that will be drawn to.
		 * 
		 * @see com.derschmale.wick3d.core.geometry.Triangle3D
		 */
		override public function drawTriangle(triangle:Triangle3D, target:Graphics):void
		{
			target.lineStyle(_thickness, _colour);
			target.moveTo(triangle.v1.coords2D.x, triangle.v1.coords2D.y);
			target.lineTo(triangle.v2.coords2D.x, triangle.v2.coords2D.y);
			target.lineTo(triangle.v3.coords2D.x, triangle.v3.coords2D.y);
			target.lineTo(triangle.v1.coords2D.x, triangle.v1.coords2D.y);
			target.lineStyle(0);
		}
	}
}