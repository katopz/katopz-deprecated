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
	
	/**
	 * The SimpleNearCuller class culls triangles that have a vertex behind the camera or within a close range of it.
	 * 
	 * @see com.derschmale.wick3d.core.geometry.Triangle3D
	 * 
	 * @author David Lenaerts
	 */
	public class SimpleNearCuller implements IFaceCuller
	{
		private var _nearZ : Number;
		
		/**
		 * Creates a SimpleNearCuller object.
		 * 
		 * @param nearZ the minimum z-coordinate of a vertex for it to be considered potentially visible.
		 */
		public function SimpleNearCuller(nearZ : Number = 0) : void
		{
			_nearZ = nearZ;
		}
		
		/**
		 * Checks if a triangle should be culled.
		 * 
		 * @param triangle The triangle to be tested.
		 * 
		 * @return A boolean value whether or not the triangle should be culled.
		 */
		public function testTriangle(triangle:Triangle3D) : Boolean
		{
			return (triangle.v1.z <= _nearZ || triangle.v2.z <= _nearZ || triangle.v3.z <= _nearZ);
		}
		
	}
}