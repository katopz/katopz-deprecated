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

package com.derschmale.wick3d.core.data
{
	import com.derschmale.wick3d.core.geometry.Triangle3D;
	import com.derschmale.wick3d.core.geometry.Vertex3D;
	
	/**
	 * The GeometryData contains data concerning geometry spanning over several objects, which can be shared throughout different aspects of the engine.
	 * 
	 * @author David Lenaerts
	 */
	public class GeometryData
	{
		/**
		 * The triangles present in the pipeline.
		 */
		public var triangles : Vector.<Triangle3D> = new Vector.<Triangle3D>();
		
		/**
		 * The vertices added to the pipeline.
		 */
		public var vertices : Vector.<Vertex3D> = new Vector.<Vertex3D>();
		
		/**
		 * Resets the data.
		 */
		public function reset() : void
		{
			triangles = new Vector.<Triangle3D>();
			vertices = new Vector.<Vertex3D>();
		}
		
		/**
		 * Adds vertices to the rendering pipeline.
		 */
		public function addVertices(vertices : Vector.<Vertex3D>) : void
		{
			// manually pushing vertices is faster
			var i : int = vertices.length;
			var v : Vertex3D;
			while ((i>0) &&  (v = vertices[--i] as Vertex3D)) {
				this.vertices.push(v);
			}
			//this.vertices = this.vertices.concat(vertices);
		}
		
		/**
		 * Adds triangles to the rendering pipeline.
		 */
		public function addTriangles(triangles : Vector.<Triangle3D>) : void
		{
			// manually pushing vertices is faster
			var i : int = triangles.length;
			var tr : Triangle3D;
			while ((i>0) && (tr = triangles[--i] as Triangle3D)) {
				this.triangles.push(tr);
			}
			
			//this.triangles = this.triangles.concat(triangles);
		}

	}
}