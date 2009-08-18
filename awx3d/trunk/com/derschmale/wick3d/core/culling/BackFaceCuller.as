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

package com.derschmale.wick3d.core.culling
{
	import com.derschmale.wick3d.core.geometry.Triangle3D;
	import flash.geom.Vector3D;
	
	/**
	 * The BackFaceCuller class culls single sided triangles that are facing away from the camera.
	 * 
	 * @see com.derschmale.wick3d.core.geometry.Triangle3D
	 * 
	 */
	public class BackFaceCuller implements IFaceCuller
	{
		/**
		 * Checks if a triangle should be culled.
		 * 
		 * @param triangle The triangle to be tested.
		 * 
		 * @return A boolean value whether or not the triangle should be culled.
		 */
		public function testTriangle(triangle : Triangle3D) : Boolean
		{
			return (!triangle.material.doubleSided && triangle.v1.dotProduct(triangle.normal) < 0);
		}
	}
}