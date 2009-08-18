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

package com.derschmale.wick3d.core.geometry
{
	import flash.geom.Vector3D;
	
	/**
	 * The Plane class represents an infinite algebraic plane in 3D space.
	 * 
	 * @author David Lenaerts
	 */
	public class Plane
	{
		/**
		 * The normal vector of the plane. The length of the normal should be 1.
		 */
		public var normal : Vector3D;
		
		/**
		 * The offset of the plane from the origin.
		 */
		public var d : Number;
		
		/**
		 * Creates a Plane object, using the Hessian Normal Form.
		 * 
		 * @param normal The normal vector of the plane.
		 * @param d The offset of the plane from the origin.
		 */
		public function Plane(normal : Vector3D, d : Number)
		{
			this.normal = normal;
			this.d = d;
		}
		
		/**
		 * Calculates the distance between the plane and a point.
		 * 
		 * @param point The point to which the distance is calculated.
		 * 
		 * @return The distance between the plane and the point.
		 * 
		 * @see com.derschmale.wick3d.core.math.Vector3D
		 */
		public function distanceToPoint(point : Vector3D) : Number
		{
			return Math.abs(signedDistanceToPoint(point));
		}
			
		/**
		 * Calculates the signed distance between the plane and a point. The result will be negative if the point is on the negative side of the plane, and positive otherwise.
		 * 
		 * @param point The point to which the distance is calculated.
		 * 
		 * @return The distance between the plane and the point.
		 * 
		 * @see com.derschmale.wick3d.core.math.Vector3D
		 */
		public function signedDistanceToPoint(point : Vector3D) : Number
		{
			return normal.x*point.x+normal.y*point.y+normal.z*point.z+d;
		}
		
		/**
		 * Creates a string representation of the plane.
		 * 
		 * @return The plane normal and distance formatted into a String
		 */
		public function toString() : String
		{
			return "Plane <normal: "+normal +", distance: "+d+">";
		}
	}
}