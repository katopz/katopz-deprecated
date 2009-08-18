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

package com.derschmale.wick3d.core.objects
{
	import com.derschmale.wick3d.cameras.Camera3D;
	import com.derschmale.wick3d.core.data.GeometryData;
	import com.derschmale.wick3d.core.frustum.ViewFrustum;
	import com.derschmale.wick3d.core.geometry.Triangle3D;
	import com.derschmale.wick3d.core.geometry.Vertex3D;
	import com.derschmale.wick3d.core.geometry.bounds.AbstractBoundingVolume;
	import com.derschmale.wick3d.core.geometry.bounds.BoundingVolumeGenerator;
	import com.derschmale.wick3d.core.imagemaps.UVCoords;
	import com.derschmale.wick3d.core.math.Transformation3D;
	import com.derschmale.wick3d.debug.GeneralStatData;
	import com.derschmale.wick3d.materials.AbstractMaterial;
	
	/**
	 * The Model3D class is a renderable object in 3D space consisting out of a triangle mesh.
	 * 
	 * @see com.derschmale.wick3d.core.geometry.Vertex3D
	 * @see com.derschmale.wick3d.core.imagemaps.UVCoords
	 * @see com.derschmale.wick3d.materials.AbstractMaterial
	 * 
	 * @author David Lenaerts
	 * 
	 */
	public class Model3D extends HierarchicObject3D
	{
		protected var _vertices : Vector.<Vertex3D>;
		protected var _trVertices : Vector.<Vertex3D>;
		
		private var _material : AbstractMaterial;
		
		protected var _triangles : Vector.<Triangle3D>;
		
		private var _bounds : AbstractBoundingVolume;
				
		/**
		 * Creates a Model3D instance.
		 * 
		 * @param material The material used to render the model's triangles.
		 * @see com.derschmale.wick3d.materials.AbstractMaterial 
		 */
		public function Model3D(material : AbstractMaterial)
		{
			_vertices = new Vector.<Vertex3D>();
			_trVertices = new Vector.<Vertex3D>();
			_triangles = new Vector.<Triangle3D>();
			_material = material;
		}
		
		/**
		 * The material used to render the model's triangles.
		 */
		public function get material() : AbstractMaterial
		{
			return _material;
		}
		
		public function set material(value : AbstractMaterial) : void
		{
			_material = value;
			var i : int = _triangles.length;
			var triangle : Triangle3D;
			
			while ((i>0) && (triangle = _triangles[--i] as Triangle3D)) {
				triangle.material = value;
			}
		}
		
		/**
		 * Updates the object's transformation if necessary and transforms the vertices to view coordinates
		 * 
		 * @param recursive If true (default), the current's objects children will also be transformed into world coordinates. The whole hierarchical tree is traversed starting from this object until no children are found.
		 */
		override public function transformToViewCoords(geometryData : GeometryData, camera:Camera3D, parentTransform:Transformation3D=null, recursive:Boolean=true):void
		{
			super.transformToViewCoords(geometryData, camera, parentTransform, recursive);
			
			GeneralStatData.vertices += _vertices.length;
			GeneralStatData.polygons += _triangles.length;
			GeneralStatData.models++;
			
			// if not within frustum, do nothing
			if (camera.frustum && !testBoundsToFrustum(camera.frustum)) return;
			
			GeneralStatData.drawnModels++;
			
			transform.transformVerticesToView(_vertices, _trVertices);
			
			geometryData.addVertices(_trVertices);
			geometryData.addTriangles(_triangles);
			
		}
		
		/**
		 * Updates the object's transformation if necessary and transforms the vertices to world coordinates
		 * 
		 * @param recursive If true (default), the current's objects children will also be transformed into world coordinates. The whole hierarchical tree is traversed starting from this object until no children are found.
		 */
		override public function transformToWorldCoords(geometryData : GeometryData, parentTransform:Transformation3D=null, recursive:Boolean=true):void
		{
			super.transformToWorldCoords(geometryData, parentTransform, recursive);
			
			transform.transformVerticesToWorld(_vertices, _trVertices);
			
			geometryData.addVertices(_trVertices);
			geometryData.addTriangles(_triangles);
			
		}
		
		/**
		 * Adds a triangle to the model. The vertices passed to the method should be in counterclockwise order when the triangle is facing the camera.
		 * 
		 * @param v1 The triangle's first vertex in object coordinates
		 * @param v2 The triangle's second vertex in object coordinates
		 * @param v3 The triangle's third vertex in object coordinates
		 * @param uv1 The uv texture coordinates for the first vertex
		 * @param uv2 The uv texture coordinates for the second vertex
		 * @param uv3 The uv texture coordinates for the third vertex
		 * 
		 * @see com.derschmale.wick3d.core.geometry.Vertex3D
		 * @see com.derschmale.wick3d.core.imagemaps.UVCoords
		 */
		public function addTriangle(v1 : Vertex3D, v2 : Vertex3D, v3 : Vertex3D, uv1 : UVCoords = null, uv2 : UVCoords = null, uv3 : UVCoords = null) : void
		{
			var i : int = _vertices.length;
			var vertex : Vertex3D;
			var v1Index : int = -1;
			var v2Index : int = -1;
			var v3Index : int = -1; 
			var triangle : Triangle3D;
			
			while ((i>0) && (vertex = _vertices[--i] as Vertex3D)) {
				if (v1Index == -1 && vertex.nearEquals(v1, 0)) {
					v1Index = i;
					v1 = vertex;
				}
				else if (v2Index == -1 && vertex.nearEquals(v2, 0)) {
					v2Index = i;
					v2 = vertex;
				}
				else if (v3Index == -1 && vertex.nearEquals(v3, 0)) {
					v3Index = i;
					v3 = vertex;
				}
			}
			
			if (v1Index == -1) {
				_vertices.push(v1);
				v1Index = _vertices.length-1;
				_trVertices[v1Index] = v1.copy();
			}
			if (v2Index == -1) {
				_vertices.push(v2);
				v2Index = _vertices.length-1;
				_trVertices[v2Index] = v2.copy();
			}
			if (v3Index == -1) {
				_vertices.push(v3);
				v3Index = _vertices.length-1;
				_trVertices[v3Index] = v3.copy();
			}
			triangle = new Triangle3D(_trVertices[v1Index], _trVertices[v2Index], _trVertices[v3Index])
			triangle.uv1 = uv1;
			triangle.uv2 = uv2;
			triangle.uv3 = uv3;
			triangle.material = _material;
			triangle.setParent(this, _vertices[v1Index], _vertices[v2Index], _vertices[v3Index]);
			_triangles.push(triangle);
		}
		
		/**
		 * Adds a vertex directly to the list of vectors. This should only be called internally!
		 * 
		 * @private
		 */
		public function addVertex(vertex : Vertex3D) : Vertex3D
		{
			var v : Vertex3D = vertex.copy() as Vertex3D;
			_vertices.push(vertex);
			_trVertices.push(v);
			return v;
		}
		
		/**
		 * Removes a triangle directly from the list of triangles. This should only be called internally!
		 * 
		 * @private
		 */
		public function removeTriangle(triangle : Triangle3D) : void
		{
			var current : Triangle3D;
			var i : int = _triangles.length;
			
			while (current = _triangles[--i] as Triangle3D) {
				if (current == triangle) {
					_triangles.splice(i, 1);
					return;
				}
			}
		}
		
		/**
		 * Inserts a new triangle under the assumption the vertices are already in the array. This function should only be called internally!
		 * 
		 * @private
		 */
		public function insertTriangle(triangle : Triangle3D) : void
		{
			_triangles.push(triangle);
		}
		
		/**
		 * Assigns a bounding volume to this object, by type.
		 * 
		 * @see com.derschmale.wick3d.core.geometry.bounds.BoundingVolumeGenerator
		 */
		public function set boundingVolume(type : String) : void
		{
			_bounds = BoundingVolumeGenerator.generateBoundingVolume(_vertices, type);
		}
				
		private function testBoundsToFrustum(frustum : ViewFrustum) : Boolean
		{
			if (_bounds) {
				_bounds.transformToViewCoords(transform);
				return _bounds.testBoundsToFrustum(frustum);
			}
			else return true;
		}
	}
}