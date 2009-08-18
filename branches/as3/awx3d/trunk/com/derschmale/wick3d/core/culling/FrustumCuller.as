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
	import com.derschmale.wick3d.core.frustum.ViewFrustum;
	import com.derschmale.wick3d.core.geometry.Triangle3D;
	import com.derschmale.wick3d.core.geometry.Vertex3D;
	import flash.geom.Vector3D;
	
	/**
	 * The FrustumCuller class culls triangles that are completely outside of a view frustum.
	 * 
	 * @see com.derschmale.wick3d.core.geometry.Triangle3D
	 * @see com.derschmale.wick3d.core.frustum.ViewFrustum
	 * 
	 * @author David Lenaerts
	 */
	public class FrustumCuller implements IFaceCuller
	{
		private var _frustum : ViewFrustum
		private var _doNearCulling : Boolean;
		
		/**
		 * Creates a FrustumCuller object.
		 * 
		 * @param doNearCulling Defines if the near plane should be used for culling. If a SimpleNearCuller is already used, this value should be set to false.
		 * 
		 */
		public function FrustumCuller(doNearCulling : Boolean = true)
		{
			_doNearCulling = doNearCulling;
		}
		
		/**
		 * The view frustum that will be used determine whether the triangle is visible or not.
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
		}

		/**
		 * Checks if a triangle should be culled.
		 * 
		 * @param triangle The triangle to be tested.
		 * 
		 * @return A boolean value whether or not the triangle should be culled.
		 */
		public function testTriangle(triangle:Triangle3D):Boolean
		{
			var v1 : Vertex3D = triangle.v1,
				v2 : Vertex3D = triangle.v2,
				v3 : Vertex3D = triangle.v3;
				
			var nearZ : Number = _frustum.nearZ;
			var farZ : Number;
			var normal : Vector3D;
			
			if (_doNearCulling && v1.z < nearZ && v2.z < nearZ && v3.z < nearZ) {
				return true;
			}
			
			farZ = _frustum.farZ;
			
			if (v1.z > farZ && v2.z > farZ && v3.z > farZ) {
				return true;
			}
			
			normal = _frustum.left.normal;
			if (v1.dotProduct(normal) < 0 && v2.dotProduct(normal) < 0 && v3.dotProduct(normal) < 0) {
				return true;
			}
			
			normal = _frustum.right.normal;
			if (v1.dotProduct(normal) < 0 && v2.dotProduct(normal) < 0 && v3.dotProduct(normal) < 0) {
				return true;
			}
			
			normal = _frustum.top.normal;
			if (v1.dotProduct(normal) < 0 && v2.dotProduct(normal) < 0 && v3.dotProduct(normal) < 0) {
				return true;
			}
			
			normal = _frustum.bottom.normal;
			if (v1.dotProduct(normal) < 0 && v2.dotProduct(normal) < 0 && v3.dotProduct(normal) < 0) {
				return true;
			}
			
			return false;
		}
	}
}