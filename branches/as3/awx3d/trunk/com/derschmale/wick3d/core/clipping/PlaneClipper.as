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
	import com.derschmale.wick3d.core.geometry.Plane;
	import com.derschmale.wick3d.core.geometry.Triangle3D;
	import com.derschmale.wick3d.core.geometry.Vertex3D;
	import com.derschmale.wick3d.core.imagemaps.UVCoords;
	import com.derschmale.wick3d.materials.AbstractMaterial;
	
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;
	
	/**
	 * The PlaneClipper class clips triangle polygons to a plane and discards the ones on the negative side of it.
	 * 
	 * @see com.derschmale.wick3d.core.geometry.Plane
	 * @see com.derschmale.wick3d.core.geometry.Triangle3D
	 * 
	 * @author David Lenaerts
	 * 
	 */
	public class PlaneClipper
	{
		private var _vertices : Vector.<Vertex3D> = new Vector.<Vertex3D>();
		private var _uv : Vector.<UVCoords> = new Vector.<UVCoords>();
		private var _lastIntersectionRatio : Number;
		private var _dots : Dictionary = new Dictionary();
		
		/**
		 * Clips the triangle to a plane, generating new triangles from the new set of vertices.
		 * 
		 * @param triangle The triangle to be clipped.
		 * @param plane The plane to which the triangles will be clipped.
		 * @return A new set of triangles after culling.
		 *  
		 * @see com.derschmale.wick3d.core.geometry.Triangle3D
		 */
		public function clipTriangle(triangle : Triangle3D, plane : Plane) : Vector.<Triangle3D>
		{
			if (plane.normal.z == 1 || plane.normal.z == -1) {
				return clipTriangleToZPlane(triangle, plane);
			}
			
			return clipTriangleToPlane(triangle, plane);
		}
		
		/**
		 * Clips a set of triangles to a plane, generating new triangles from the new sets of vertices.
		 * 
		 * @param triangles The triangles to be clipped.
		 * @param plane The plane to which the triangles will be clipped.
		 * 
		 * @return A new set of triangles after clipping.
		 */
		public function clipTriangles(triangles:Vector.<Triangle3D>, plane : Plane):Vector.<Triangle3D>
		{
			var newTriangles : Vector.<Triangle3D> = new Vector.<Triangle3D>();
			var triangle : Triangle3D;
			var i : int = triangles.length;
			
			while ((i>0) && (triangle = triangles[--i])) {
				if (!triangle.isCulled)
					triangles = triangles.concat(clipTriangle(triangle, plane));
			}
			return triangles;
		}
		
	
		private function clipTriangleToPlane(triangle : Triangle3D, plane : Plane) : Vector.<Triangle3D>
		{
			var v1 : Vertex3D = triangle.v1,
				v2 : Vertex3D = triangle.v2,
				v3 : Vertex3D = triangle.v3;
			
			var v1Dot : Number = plane.normal.dotProduct(v1)-plane.d;
			var v2Dot : Number = plane.normal.dotProduct(v2)-plane.d;
			var v3Dot : Number = plane.normal.dotProduct(v3)-plane.d;
			
			
			if (v1Dot < 0 || v2Dot < 0 || v3Dot < 0) {
				
				_dots[v1] = v1Dot;
				_dots[v2] = v2Dot;
				_dots[v3] = v3Dot;
			
				triangle.isCulled = true;
				
				_vertices = new Vector.<Vertex3D>(); // = [];
				_uv = new Vector.<UVCoords>();; // = [];
				
				if (v1Dot >= plane.d) {
					_vertices.push(v1);
					_uv.push(triangle.uv1);
				}
				
				clipLineToPlane(v1, v2, triangle.uv1, triangle.uv2, plane);
				
				if (v2Dot >= 0) {
					_vertices.push(v2);
					_uv.push(triangle.uv2);
				}
				
				clipLineToPlane(v2, v3, triangle.uv2, triangle.uv3, plane);
				
				if (v3Dot >= 0) {
					_vertices.push(v3);
					_uv.push(triangle.uv3);
				}
				
				clipLineToPlane(v3, v1, triangle.uv3, triangle.uv1, plane);
				
				return constructTriangles(triangle.material);
			}
			
			return Vector.<Triangle3D>([ triangle ]);
		}
		
		private function clipTriangleToZPlane(triangle : Triangle3D, plane : Plane) : Vector.<Triangle3D>
		{
			var z : Number = plane.d;
			var sign : Number = plane.normal.z;
			var v1 : Vertex3D = triangle.v1,
				v2 : Vertex3D = triangle.v2,
				v3 : Vertex3D = triangle.v3;
			
			if (sign*v1.z < sign*z || sign*v2.z < sign*z || sign*v3.z < sign*z) {
				triangle.isCulled = true;
				
				_vertices = new Vector.<Vertex3D>();
				_uv = new Vector.<UVCoords>();;
				
				if (sign*v1.z > sign*z) {
					_vertices.push(v1);
					_uv.push(triangle.uv1);
				}
				
				clipLineToZPlane(v1, v2, triangle.uv1, triangle.uv2, z);
				
				if (sign*v2.z > sign*z) {
					_vertices.push(v2);
					_uv.push(triangle.uv2);
				}
				
				clipLineToZPlane(v2, v3, triangle.uv2, triangle.uv3, z);
				
				if (sign*v3.z > sign*z) {
					_vertices.push(v3);
					_uv.push(triangle.uv3);
				}
				
				clipLineToZPlane(v3, v1, triangle.uv3, triangle.uv1, z);
				
				return constructTriangles(triangle.material);
			}

			return Vector.<Triangle3D>([ triangle ]);
		}
		
		private function clipLineToPlane(v1 : Vertex3D, v2 : Vertex3D, uv1 : UVCoords, uv2 : UVCoords, plane : Plane) : void
		{
			var newVertex : Vertex3D;
			
			newVertex = planeIntersection(v1, v2, plane);
			
			if (newVertex) {
				_vertices.push(newVertex);
				if (uv1)
					_uv.push(interpolateUV(uv1, uv2, _lastIntersectionRatio));
			}
		}
		
		private function clipLineToZPlane(v1 : Vertex3D, v2 : Vertex3D, uv1 : UVCoords, uv2 : UVCoords, z : Number) : void
		{
			var newVertex : Vertex3D = ZPlaneIntersection(v1, v2, z);
			
			if (newVertex) {
				_vertices.push(newVertex);
				if (uv1)
					_uv.push(interpolateUV(uv1, uv2, _lastIntersectionRatio));
			}
		}
		
		private function ZPlaneIntersection(v1 : Vertex3D, v2 : Vertex3D, z : Number) : Vertex3D
		{
			var t : Number;
			var v : Vertex3D;
			
			if (v1.z == v2.z) return null;
			
			if (v1.z >= z && v2.z >= z) return null;
			if (v1.z <= z && v2.z <= z) return null;
			
			t = (z-v1.z)/(v2.z-v1.z);
			
			// intersection is not on segment
			if (t < 0 || t > 1) return null;
			
			v = new Vertex3D(v1.x+t*(v2.x-v1.x), v1.y+t*(v2.y-v1.y), z);
			
			_lastIntersectionRatio = t;
			
			return v;
		}
		
		private function planeIntersection(v1 : Vertex3D, v2 : Vertex3D, plane : Plane) : Vertex3D
		{
			var t : Number;
			var v : Vertex3D;
			var n : Vector3D = plane.normal;
			var div : Number;
			
			
			// inline t= -(N dot V1 + plane.d)/(N dot (v2-v1))
			div = n.x*(v2.x-v1.x)+n.y*(v2.y-v1.y)+n.z*(v2.z-v1.z);
			
			if (div == 0) return null;	// parallel
			
			t = -(_dots[v1] + 2*plane.d)/div;
			
			// intersection is not on segment
			if (t < 0 || t > 1) return null;
			
			v = new Vertex3D(v1.x+t*(v2.x-v1.x), v1.y+t*(v2.y-v1.y), v1.z+t*(v2.z-v1.z));
			
			_lastIntersectionRatio = t;
			
			return v;
		}
		
		// treat vertices as triangle fan
		private function constructTriangles(material : AbstractMaterial) : Vector.<Triangle3D>
		{
			var triangles : Vector.<Triangle3D> = new Vector.<Triangle3D>();
			var newTriangle : Triangle3D;
			
			if (_vertices.length != 0) {
				newTriangle = new Triangle3D(_vertices[0] as Vertex3D, _vertices[1] as Vertex3D, _vertices[2] as Vertex3D);
				newTriangle.uv1 = _uv[0] as UVCoords;
				newTriangle.uv2 = _uv[1] as UVCoords;
				newTriangle.uv3 = _uv[2] as UVCoords;
				newTriangle.material = material;
				triangles.push(newTriangle);
				
				if (_vertices.length > 3) {
					newTriangle = new Triangle3D(_vertices[0] as Vertex3D, _vertices[2] as Vertex3D, _vertices[3] as Vertex3D);
					newTriangle.uv1 = _uv[0] as UVCoords;
					newTriangle.uv2 = _uv[2] as UVCoords;
					newTriangle.uv3 = _uv[3] as UVCoords;
					newTriangle.material = material;
					triangles.push(newTriangle);
				}
			}
			return triangles;
		}
		
		
		private function interpolateUV(uv1 : UVCoords, uv2 : UVCoords, ratio : Number) : UVCoords
		{
			return new UVCoords(uv1.u+_lastIntersectionRatio*(uv2.u-uv1.u), uv1.v+_lastIntersectionRatio*(uv2.v-uv1.v));
		}
	}
}