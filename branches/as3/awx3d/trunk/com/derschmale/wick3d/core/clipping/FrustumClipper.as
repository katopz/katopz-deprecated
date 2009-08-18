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

package com.derschmale.wick3d.core.clipping
{
	import com.derschmale.wick3d.core.culling.FrustumCuller;
	import com.derschmale.wick3d.core.frustum.ViewFrustum;
	import com.derschmale.wick3d.core.geometry.Triangle3D;
	
	/**
	 * The FrustumClipper class clips triangle polygons to a view frustum and discards the ones outside of it.
	 * 
	 * @see com.derschmale.wick3d.core.frustum.ViewFrustum
	 * @see com.derschmale.wick3d.core.geometry.Triangle3D
	 * 
	 * @author David Lenaerts
	 */
	public class FrustumClipper implements ITriangleClipper
	{
		private var _frustum : ViewFrustum;
		private var _frustumCuller : FrustumCuller;
		
		private var _lastIntersectionRatio : Number;
		
		private var _vertices : Vector.<Vertex3D>;
		private var _uv : Array;
		
		private var _planeClipper : PlaneClipper = new PlaneClipper();
		
		private var _doSideClipping : Boolean;
		
		/**
		 * Creates a FrustumClipper instance.
		 * 
		 * @param doSideClipping Defines if the left, right, top and bottom planes should be used when clipping. Often, setting the value to false will result in higher performance.
		 */
		public function FrustumClipper(doSideClipping : Boolean = true)
		{
			_doSideClipping = doSideClipping;
			_frustumCuller = new FrustumCuller();
		}
		
		/**
		 * Defines the frustum to which is being clipped.
		 * 
		 * @see com.derschmale.wick3d.core.frustum.ViewFrustum
		 */
		public function get frustum() : ViewFrustum
		{
			return _frustum;
		}

		public function set frustum(value : ViewFrustum) : void
		{
			_frustum = value;
			_frustumCuller.frustum = value;
		}

		/**
		 * Clips the triangle to the frustum, generating new triangles from the new set of vertices.
		 * 
		 * @param triangle The triangle to be clipped.
		 * 
		 * @see com.derschmale.wick3d.core.geometry.Triangle3D
		 * @return A new set of triangles after clipping.
		 */
		public function clipTriangle(triangle:Triangle3D):Array
		{
			var triangles : Vector.<Triangle3D>;
			
			if (_frustum.containsPoint(triangle.v1) && _frustum.containsPoint(triangle.v2) && _frustum.containsPoint(triangle.v3))
			{
				return null;
			}
			
			// for now, do plane per plane clipping
			
			if (triangle.isCulled = _frustumCuller.testTriangle(triangle)) return null;
			
			triangles = _planeClipper.clipTriangle(triangle, _frustum.near); 
			triangles = _planeClipper.clipTriangles(triangles, _frustum.far);
			
			if (_doSideClipping) {
				triangles = _planeClipper.clipTriangles(triangles, _frustum.right);
				triangles = _planeClipper.clipTriangles(triangles, _frustum.left);
				triangles = _planeClipper.clipTriangles(triangles, _frustum.top);
				triangles = _planeClipper.clipTriangles(triangles, _frustum.bottom);
			}
				
			return triangles;
		}
	}
}