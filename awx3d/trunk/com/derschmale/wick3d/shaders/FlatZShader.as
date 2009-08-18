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

package com.derschmale.wick3d.shaders
{
	import com.derschmale.wick3d.core.geometry.Triangle3D;
	
	import flash.display.Graphics;
	import flash.geom.Point;
	
	/**
	 * @private
	 */
	public class FlatZShader extends AbstractShader implements IShader
	{
		private var _minDistance : Number = 800;
		private var _maxDistance : Number = 1500;
		
		public function FlatZShader()
		{
			super();
		}
		
		override public function drawTriangle(triangle : Triangle3D, target : Graphics) : void
		{
			var distance : Number = (triangle.v1.z+triangle.v2.z+triangle.v3.z)*.333333;
			var intensity : Number;
		
			if (distance < _minDistance) intensity = 1;
			else if (distance > _maxDistance) intensity = 0;
			else intensity = 1-(distance-_minDistance)/(_maxDistance-_minDistance);
			
			if (intensity > 1) intensity = 1;
			else if (intensity < 0) intensity = 0;
			intensity = intensity*0x7f;

			target.beginFill((intensity << 16) + (intensity << 8) + intensity);
			target.moveTo(triangle.v1.coords2D.x, triangle.v1.coords2D.y);
			target.lineTo(triangle.v2.coords2D.x, triangle.v2.coords2D.y);
			target.lineTo(triangle.v3.coords2D.x, triangle.v3.coords2D.y);
			target.endFill();
		}
		
	}
}