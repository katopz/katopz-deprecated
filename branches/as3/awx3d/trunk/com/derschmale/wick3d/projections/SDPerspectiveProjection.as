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

package com.derschmale.wick3d.projections
{
	import flash.geom.Vector3D;
	
	import flash.geom.Point;
	import flash.geom.PerspectiveProjection;
	
	/**
	 * The PerspectiveProjection class is used to project three-dimensional points onto the view plane by finding the intersection of the ray from the eye to the point. The result is a two-dimensional point in clip space, which can be used to transform to screen coordinates.
	 * 
	 * @author David Lenaerts
	 * 
	 * @see flash.geom.Vector3D
	 * 
	 */
	public class SDPerspectiveProjection extends PerspectiveProjection implements IProjection
	{
		private var _horizontalFieldOfView : Number;
		
		//private var focalLength : Number;
		
		private var _aspectRatio : Number;
		
		/**
		 * Creates a PerspectiveProjection instance.
		 */
		public function SDPerspectiveProjection()
		{
			fieldOfView = 1.4;
		}
		
		/**
		 * Projects the Vector3D's coordinates to 2D clip coordinates as a Point.
		 * 
		 * @param v The Vector3D instance to be projected onto the view plane.
		 * @param clipCoord The Point object storing the clip coordinates for this point.
		 * 
		 * @see flash.geom.Vector3D
		 */
		public function project(v : Vector3D, clipCoord : Point) : void
		{
			clipCoord.x = focalLength*v.x/v.z;
			clipCoord.y = -focalLength*v.y/(v.z*_aspectRatio);
		}
		
		/**
		 * The projection's current field of view. This is typically a parameter passed from the camera. 
		 */
		override public function get fieldOfView() : Number
		{
			return _horizontalFieldOfView;
		}
		
		override public function set fieldOfView(value : Number) : void
		{
			if (value <= 0.0001) value = 0.0001;
			if (value >= Math.PI-0.01) value = Math.PI-0.01;
			_horizontalFieldOfView = value;
			focalLength = 1/Math.tan(value/2);
		}
		
		/**
		 * The aspect ratio of the currently used viewport. 
		 */
		public function get aspectRatio() : Number
		{
			return _aspectRatio;
		}
		
		public function set aspectRatio(value : Number) : void
		{
			_aspectRatio = value;
		}
	}
}