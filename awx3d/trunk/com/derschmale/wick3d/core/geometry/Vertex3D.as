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
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	/**
	 * The Vertex3D class represents a point in 3D space that defines a corner of a Triangle3D.
	 * 
	 * @see com.derschmale.wick3d.core.geometry.Triangle3D
	 * 
	 * @author David Lenaerts
	 */
	public class Vertex3D extends Vector3D
	{
		/**
		 * The local normal of the vector, which is an average of the normals of the triangles containing this vertex.
		 */
		public var normal : Vector3D;
		
		/**
		 * The 2D coordinates on the screen to which this vertex is projected.
		 */
		public var coords2D : Point = new Point();
		
		/**
		 * Defines if this vertex has already been projected unto the screen in the current render loop.
		 */
		public var isProjected : Boolean = false;
		
		/*
		 * Unused until coloured lighting support
		 */
		/* public var colourR : Number;
		public var colourG : Number;
		public var colourB : Number; */
		
		/**
		 * The calculated lighting intensity for monochrome lighting
		 */
		public var intensity : Number;
		
		/**
		 * An array of Triangle3D containing this vertex.
		 */
		public var parents : Array;
		
		/**
		 * Creates a Vertex3D object.
		 * 
		 * @param x The x-coordinate of the vertex
		 * @param x The y-coordinate of the vertex
		 * @param x The z-coordinate of the vertex
		 */
		public function Vertex3D(x : Number = 0, y : Number = 0, z : Number = 0)
		{
			super(x, y, z, 1);
		}
		
		/**
		 * Creates a new Vertex3D object with the same properties.
		 * 
		 * @return A duplicate of this vertex
		 */
		public function copy() : Vertex3D
		{
			var clone : Vertex3D = new Vertex3D(x, y, z);
			clone.intensity = intensity;
			if (normal)
				clone.normal = normal.clone();
			clone.parents = parents;
			return clone;
		}
		
		/**
		 * Creates a string representation of the vertex.
		 * 
		 * @return The 3D coordinates formatted into a String
		 */
		override public function toString():String
		{
			return "Vertex3D("+x+", "+y+" ,"+z+")";
		}
	}
}