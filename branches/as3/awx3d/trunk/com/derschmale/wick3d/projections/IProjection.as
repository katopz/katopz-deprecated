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
	
	
	/**
	 * The IProjection interface is implemented by classes that can map 3D coordinates onto the view plane, resulting in 2D clip coordinates that are used to draw object to the viewport. 
	 * 
	 * @author David Lenaerts
	 */
	public interface IProjection
	{
		/**
		 * Projects the Vector3D's coordinates to 2D clip coordinates as a Point.
		 * 
		 * @param v The Vector3D instance to be projected onto the view plane.
		 * @param clipCoord The Point object storing the clip coordinates for this point.
		 * 
		 * @see com.derschmale.wick3d.core.math.Vector3D
		 */
		function project(v : Vector3D, clipCoord : Point) : void;
		
		/**
		 * The projection's current field of view. This is typically a parameter passed from the camera. 
		 */
		function get fieldOfView() : Number;
		function set fieldOfView(value : Number) : void;
		
		/**
		 * The aspect ratio of the currently used viewport. 
		 */
		function get aspectRatio() : Number;
		function set aspectRatio(value : Number) : void;
		
		/**
		 * The focal length of the projection. This is the distance between the projection plane and the eye position. The value is determined by the field of view parameter.
		 */
		function get focalLength() : Number;
	}
}