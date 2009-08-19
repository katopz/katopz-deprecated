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
	import com.derschmale.wick3d.core.geometry.Triangle3D;
	import com.derschmale.wick3d.core.geometry.Vertex3D;
	import com.derschmale.wick3d.core.imagemaps.UVCoords;
	
	/**
	 * The SimpleNearClipper class clips triangle polygons to a near plane and discards objects that are on the negative side of it.
	 * 
	 * @see com.derschmale.wick3d.core.geometry.Triangle3D
	 * 
	 * @author David Lenaerts
	 */
	public class SimpleNearClipper implements ITriangleClipper
	{
		private var _nearZ : Number;
		private var _lastIntersectionRatio : Number;
		
		private var _vertices : Vector.<Vertex3D>;
		private var _uv : Vector.<UVCoords>;
		private var _triangles : Vector.<Triangle3D>;
		
		/**
		 * Creates a SimpleNearClipper object.
		 * 
		 * @param nearZ The z coordinate of the near plane. This is most often the focal length of the camera.
		 */
		public function SimpleNearClipper(nearZ : Number = 0.00001)
		{
			_nearZ = nearZ;
		}
		
		/**
		 * The z coordinate of the near plane. This is most often the focal length of the camera.
		 */
		public function get nearZ() : Number
		{
			return _nearZ;
		}
		
		public function set nearZ(value : Number) : void
		{
			_nearZ = value;
		}
		
		
		/**
		 * Clips the triangle to the near plane, generating new triangles from the new set of vertices.
		 * 
		 * @param triangle The triangle to be clipped.
		 * @param plane The plane to which the triangles will be clipped.
		 * @return A new set of triangles after culling.
		 * 
		 * @see com.derschmale.wick3d.core.geometry.Triangle3D
		 */
		public function clipTriangle(triangle:Triangle3D):Vector.<Triangle3D>
		{
			var newVertex : Vertex3D;
			var newUV : UVCoords;
			var v1 : Vertex3D = triangle.v1,
				v2 : Vertex3D = triangle.v2,
				v3 : Vertex3D = triangle.v3;
			var uv1 : UVCoords;
			var uv2 : UVCoords;
			var uv3 : UVCoords;
			var newTriangle : Triangle3D;
			
			// cull triangle if completely behind near plane
			if (v1.z <= _nearZ && v2.z <= _nearZ && v3.z <= _nearZ) {
				triangle.isCulled = true;
				return null;
			}
			
			// keep triangle unchanged if nothing differs
			if (v1.z >= _nearZ && v2.z >= _nearZ && v3.z >= _nearZ)
				return null;
			
			_vertices = [];
			_uv = new Vector.<UVCoords>();;
			
			uv1 = triangle.uv1;
			uv2 = triangle.uv2;
			uv3 = triangle.uv3;
			
			if (v1.z >= _nearZ) {
				_vertices.push(v1);
				_uv.push(uv1)
			}
			
			newVertex = intersection(v1, v2);
			if (newVertex) {
				_vertices.push(newVertex);
				_uv.push(new UVCoords(uv1.u+_lastIntersectionRatio*(uv2.u-uv1.u), uv1.v+_lastIntersectionRatio*(uv2.v-uv1.v)));
			}
			
			if (v2.z >= _nearZ) {
				_vertices.push(v2);
				_uv.push(uv2)
			}
			
			newVertex = intersection(v2, v3);
			if (newVertex) {
				_vertices.push(newVertex);
				_uv.push(new UVCoords(uv2.u+_lastIntersectionRatio*(uv3.u-uv2.u), uv2.v+_lastIntersectionRatio*(uv3.v-uv2.v)));
			}
			
			if (v3.z >= _nearZ) {
				_vertices.push(v3);
				_uv.push(uv3);
			}
			
			newVertex = intersection(v1, v3);
			if (newVertex) {
				_vertices.push(newVertex);
				_uv.push(new UVCoords(uv1.u+_lastIntersectionRatio*(uv3.u-uv1.u), uv1.v+_lastIntersectionRatio*(uv3.v-uv1.v)));
			} 
			
			triangle.isCulled = true;
			
			if (_vertices.length == 3) {
				newTriangle = new Triangle3D(_vertices[0] as Vertex3D, _vertices[1] as Vertex3D, _vertices[2] as Vertex3D);
				
				// not right, calculate uv correctly later on
				newTriangle.uv1 = _uv[0] as UVCoords;
				newTriangle.uv2 = _uv[1] as UVCoords;
				newTriangle.uv3 = _uv[2] as UVCoords;
				newTriangle.material = triangle.material; 
				_triangles = [ newTriangle ];
			}
			else {
				_triangles = new Vector.<Triangle3D>();
				newTriangle = new Triangle3D(_vertices[0] as Vertex3D, _vertices[1] as Vertex3D, _vertices[2] as Vertex3D);
				
				// not right, calculate uv correctly later on
				newTriangle.uv1 = _uv[0] as UVCoords;
				newTriangle.uv2 = _uv[1] as UVCoords;
				newTriangle.uv3 = _uv[2] as UVCoords;
				newTriangle.material = triangle.material; 
				
				_triangles.push(newTriangle);
				
				newTriangle = new Triangle3D(_vertices[0] as Vertex3D, _vertices[2] as Vertex3D, _vertices[3] as Vertex3D);
				
				// not right, calculate uv correctly later on
				newTriangle.uv1 = _uv[0] as UVCoords;
				newTriangle.uv2 = _uv[2] as UVCoords;
				newTriangle.uv3 = _uv[3] as UVCoords;
				newTriangle.material = triangle.material;
				
				_triangles.push(newTriangle);
			}
			
			return _triangles;
		}
		
		private function intersection(v1 : Vertex3D, v2 : Vertex3D) : Vertex3D
		{
			var t : Number;
			var v : Vertex3D;
			
			if (v1.z == v2.z) return null;
			
			if (v1.z >= _nearZ && v2.z >= _nearZ) return null;
			if (v1.z <= _nearZ && v2.z <= _nearZ) return null;
			
			t = (_nearZ-v1.z)/(v2.z-v1.z);
			v = new Vertex3D(v1.x+t*(v2.x-v1.x), v1.y+t*(v2.y-v1.y), _nearZ);
			
			_lastIntersectionRatio = t;
			
			return v;
		}
		
	}
}