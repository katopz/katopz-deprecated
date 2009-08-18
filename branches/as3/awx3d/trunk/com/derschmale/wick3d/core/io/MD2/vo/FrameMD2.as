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

package com.derschmale.wick3d.core.io.MD2.vo
{
	import __AS3__.vec.Vector;
	
	import com.derschmale.wick3d.core.geometry.Vertex3D;
	
	/**
	 * The FrameMD2 class represents a frame loaded from a MD2 model file.
	 * 
	 * @author David Lenaerts
	 */
	public class FrameMD2
	{
		/**
		 * The scaling to be applied to all vertices of this array in this frame.
		 */
		public var scale : Array = new Array(3);
		
		/**
		 * The translation to be applied to all vertices of this array in this frame.
		 */
		public var translate : Array = new Array(3);
		
		/**
		 * The name of the frame.
		 */
		public var name : String;
		
		/**
		 * An Array representing the vertex coordinates in this frame.
		 */
		public var vertices : Vector.<VertexMD2> = new Vector.<VertexMD2>();
		
		/**
		 * Returns the i-th vertex with scaling and translation applied.
		 * 
		 * @return The i-th vertex with scaling and translation applied.
		 */
		public function getTransformedVertex(i : int) : VertexMD2
		{
			var vertex : VertexMD2 = new VertexMD2();
			vertex.coords[0] = VertexMD2(vertices[i]).coords[0]*scale[0]+translate[0];
			vertex.coords[1] = VertexMD2(vertices[i]).coords[1]*scale[1]+translate[1];
			vertex.coords[2] = VertexMD2(vertices[i]).coords[2]*scale[2]+translate[2];
			return vertex;
		}
	}
}