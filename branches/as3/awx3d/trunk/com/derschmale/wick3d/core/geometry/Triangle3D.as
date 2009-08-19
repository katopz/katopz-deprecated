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
	import com.derschmale.wick3d.core.imagemaps.UVCoords;
	import com.derschmale.wick3d.core.objects.Model3D;
	import com.derschmale.wick3d.materials.AbstractMaterial;
	
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.display.IGraphicsData;
	
	/**
	 * The Triangle3D class represents a 3D polygon with 3 vertices. When facing the camera, the vertices should be determined in counterclockwise order.
	 * 
	 * @see com.derschmale.wick3d.core.geometry.Vertex3D
	 * @see com.derschmale.wick3d.core.objects.Model3D
	 * 
	 * @author David Lenaerts
	 */
	public class Triangle3D
	{
		/**
		 * A reference to the Triangle's first vertex in view coordinates.
		 * 
		 * @see com.derschmale.wick3d.core.geometry.Vertex3D
		 */
		public var v1 : Vertex3D;
		
		/**
		 * A reference to the Triangle's second vertex in view coordinates.
		 * 
		 * @see com.derschmale.wick3d.core.geometry.Vertex3D
		 */
		public var v2 : Vertex3D;
		
		/**
		 * A reference to the Triangle's third vertex in view coordinates.
		 * 
		 * @see com.derschmale.wick3d.core.geometry.Vertex3D
		 */
		public var v3 : Vertex3D;
				
		/**
		 * The first vertex' texture UV Coordinates
		 * 
		 * @see com.derschmale.wick3d.materials.TextureMaterial
		 * @see com.derschmale.wick3d.core.imagemaps.UVCoords
		 */
		public var uv1 : UVCoords;
		
		/**
		 * The second vertex' texture UV Coordinates
		 * 
		 * @see com.derschmale.wick3d.materials.TextureMaterial
		 * @see com.derschmale.wick3d.core.imagemaps.UVCoords
		 */
		public var uv2 : UVCoords;
		
		/**
		 * The third vertex' texture UV Coordinates
		 * 
		 * @see com.derschmale.wick3d.materials.TextureMaterial
		 * @see com.derschmale.wick3d.core.imagemaps.UVCoords
		 */
		public var uv3 : UVCoords;
		
		/**
		 * Determines whether a triangle has been culled or not.
		 */
		public var isCulled : Boolean = false;
		
		/**
		 * A reference to the material used to render the triangle
		 * 
		 * @see com.derschmale.wick3d.materials.AbstractMaterial
		 */
		public var material : AbstractMaterial;
		
		private var _normal : Vector3D;
		
		private var _parent : Model3D;
		
		private var _normalInvalid : Boolean = true;
		
		private var _localV1 : Vertex3D;
		private var _localV2 : Vertex3D;
		private var _localV3 : Vertex3D;
		
		/**
		 * The zIndex of the Triangle, used for sorting. This value should only be read and is made public for performance. The zIndex should be set by calling calculateZIndex().
		 */
		public var zIndex : Number;
		
		
		/**
		 * Creates a Triangle3D object. The vertices are the transformed view coordinates and are stored in the parent Model3D object so one vertex can be shared throughout several triangles.
		 * 
		 * @param v1 A reference to the Triangle's first vertex in view coordinates.
		 * @param v1 A reference to the Triangle's second vertex in view coordinates.
		 * @param v1 A reference to the Triangle's third vertex in view coordinates.
		 * 
		 * @see com.derschmale.wick3d.core.geometry.Vertex3D
		 */
		public function Triangle3D(v1 : Vertex3D, v2 : Vertex3D, v3 : Vertex3D)
		{
			this.v1 = v1;
			this.v2 = v2;
			this.v3 = v3;
			_normal = new Vector3D();
		}
		
		/**
		 * The normal vector of the Triangle.
		 * 
		 * @see com.derschmale.wick3d.core.math.Vector3D
		 */
		public function get normal() : Vector3D
		{
			if (_normalInvalid) {
				var sidePx : Number = v2.x-v1.x, sidePy : Number = v2.y-v1.y, sidePz : Number = v2.z-v1.z,
					sideQx : Number = v3.x-v1.x, sideQy : Number = v3.y-v1.y, sideQz : Number = v3.z-v1.z;
				 
				_normal.x = sidePy*sideQz-sidePz*sideQy;
				_normal.y = sidePz*sideQx-sidePx*sideQz;
				_normal.z = sidePx*sideQy-sidePy*sideQx;
				_normal.normalize();
			}
			return _normal;
		}
		
		/**
		 * The Model3D object that contains this triangle.
		 * 
		 * @see com.derschmale.wick3d.core.objects.Model3D
		 */
		public function get parent() : Model3D
		{
			return _parent;
		}
		
		/**
		 * Define the triangle as part of a Model3D triangle mesh.
		 * 
		 * @param parent The parent triangle mesh of which this triangle is a part.
		 * @param localV1 A reference to the first vertex in the parent's local coordinates.
		 * @param localV2 A reference to the first vertex in the parent's local coordinates.
		 * @param localV3 A reference to the first vertex in the parent's local coordinates.
		 * 
		 */
		public function setParent(parent : Model3D, localV1 : Vertex3D, localV2 : Vertex3D, localV3 : Vertex3D) : void
		{
			_parent = parent;
			_localV1 = localV1;
			_localV2 = localV2;
			_localV3 = localV3;
		}
		
		/**
		 * Is called to indicate that the normal will need to be recalculated. It is typically called from the RenderPipeline after view transformation and before any culling or clipping is done.
		 */
		public function invalidateNormal() : void
		{
			_normalInvalid = true;
		}
		
		/**
		 * Recalculates the z-index of the triangle, which is a sum of all vertices' z coordinate, used in depth sorting.
		 */
		public function calculateZIndex() : void
		{
			zIndex = v1.z+v2.z+v3.z;
		}
		
		/**
		 * The plane in which the triangle lies.
		 */
		public function get plane() : Plane
		{
			return new Plane(normal.clone(), -normal.dotProduct(v1));
		}
		
		/**
		 * Checks if the 2D projection of the triangle contains a point
		 * 
		 * @param x The x-coordinate of the point to check
		 * @param y The y-coordinate of the point to check
		 * 
		 * @return A Boolean value which specifies whether the triangle contains the point or not.
		 */
		public function containsPoint2D(x : Number, y : Number) : Boolean
		{
			var p : Point;
			var totalArea : Number, checkArea : Number;
			if (isCulled) return false;
			
			p = new Point(x, y);
			totalArea = calculateArea2D(v1.coords2D, v2.coords2D, v3.coords2D);
			
			// triangle is practically non-existant, automatically false
			if (totalArea < 0.000001) return false;
			
			checkArea = calculateArea2D(p, v1.coords2D, v2.coords2D)
						+ calculateArea2D(p, v2.coords2D, v3.coords2D)
						+ calculateArea2D(p, v1.coords2D, v3.coords2D);
			if (Math.abs(totalArea-checkArea) < 0.00001) return true;
			return false;
		}
		
		/**
		 * Retrieves the material's coordinates for the 2D viewport coordinates.
		 * 
		 * @param x The x-coordinate in Viewport coordinates.
		 * @param y The y-coordinate in Viewport coordinates.
		 * 
		 * @return A Point representing the material's coordinates for the 2D viewport coordinates.
		 */
		public function getUVCoords(x : Number, y : Number) : Point
		{
			if (material)
				return material.getUVCoords(x, y, this);
			else
				return null;
		}
		
		// partitionPlane in view coords!
		public function splitInViewCoords(partitionPlane : Plane) : Vector.<Vector.<Triangle3D>>
		{
			var localVertPos : Vector.<Vertex3D> = new Vector.<Vertex3D>(), localVertNeg : Vector.<Vertex3D> = new Vector.<Vertex3D>();
			var viewVertPos : Vector.<Vertex3D> = new Vector.<Vertex3D>(), viewVertNeg : Vector.<Vertex3D> = new Vector.<Vertex3D>();
			var uvPos : Vector.<UVCoords> = new Vector.<UVCoords>(), uvNeg : Vector.<UVCoords> = new Vector.<UVCoords>();
			var triangles : Vector.<Vector.<Triangle3D>> = new Vector.<Vector.<Triangle3D>>();
			var t : Number;
			var viewV : Vertex3D;
			var dot1 : Number = v1.dotProduct(partitionPlane.normal)+partitionPlane.d;
			var dot2 : Number = v2.dotProduct(partitionPlane.normal)+partitionPlane.d;
			var dot3 : Number = v3.dotProduct(partitionPlane.normal)+partitionPlane.d;
			
			if (Math.abs(dot1) < 0.01) dot1 = 0;
			if (Math.abs(dot2) < 0.01) dot2 = 0;
			if (Math.abs(dot3) < 0.01) dot3 = 0;
			
			if (_parent)
				_parent.removeTriangle(this);
			
			if (dot1 < 0) {
				localVertNeg.push(_localV1);
				viewVertNeg.push(v1);
				uvNeg.push(uv1);
			}
			else if (dot1 > 0) {
				localVertPos.push(_localV1);
				viewVertPos.push(v1);
				uvPos.push(uv1);
			}
			else {
				localVertPos.push(_localV1);
				viewVertPos.push(v1);
				uvPos.push(uv1);
				localVertNeg.push(_localV1);
				viewVertNeg.push(v1);
				uvNeg.push(uv1);
			}
			
			// different signs (= intersects plane):
			if (dot1*dot2 < 0) {
				t = splitLineInViewCoords(partitionPlane, v1, v2, _localV1, _localV2, localVertPos, localVertNeg);
				if (uv1) splitUV(uv1, uv2, t, uvPos, uvNeg);
				viewV = _parent.addVertex(localVertPos[localVertPos.length-1]);
				splitVertices(v1, v2, t, viewV);
				viewVertPos.push(viewV);
				viewVertNeg.push(viewV);
			}
			
			if (dot2 < 0) {
				localVertNeg.push(_localV2);
				viewVertNeg.push(v2);
				uvNeg.push(uv2);
			}
			else if (dot2 > 0) {
				localVertPos.push(_localV2);
				viewVertPos.push(v2);
				uvPos.push(uv2);
			}
			else {
				localVertPos.push(_localV2);
				viewVertPos.push(v2);
				uvPos.push(uv2);
				localVertNeg.push(_localV2);
				viewVertNeg.push(v2);
				uvNeg.push(uv2);
			}
			
			if (dot2*dot3 < 0) {
				t = splitLineInViewCoords(partitionPlane, v2, v3, _localV2, _localV3, localVertPos, localVertNeg);
				if (uv1) splitUV(uv2, uv3, t, uvPos, uvNeg);
				viewV = _parent.addVertex(localVertPos[localVertPos.length-1]);
				splitVertices(v2, v3, t, viewV);
				viewVertPos.push(viewV);
				viewVertNeg.push(viewV);
			}
			
			if (dot3 < 0) {
				localVertNeg.push(_localV3);
				viewVertNeg.push(v3);
				uvNeg.push(uv3);
			}
			else if (dot3 > 0) {
				localVertPos.push(_localV3);
				viewVertPos.push(v3);
				uvPos.push(uv3);
			}
			else {
				localVertPos.push(_localV3);
				viewVertPos.push(v3);
				uvPos.push(uv3);
				localVertNeg.push(_localV3);
				viewVertNeg.push(v3);
				uvNeg.push(uv3);
			}
			
			if (dot3*dot1 < 0) {
				t = splitLineInViewCoords(partitionPlane, v3, v1, _localV3, _localV1, localVertPos, localVertNeg);
				if (uv1) splitUV(uv3, uv1, t, uvPos, uvNeg);
				viewV = _parent.addVertex(localVertPos[localVertPos.length-1]);
				splitVertices(v3, v1, t, viewV);
				viewVertPos.push(viewV);
				viewVertNeg.push(viewV);
			}
			
			triangles[0] = createTriangles(_parent, localVertPos, viewVertPos, uvPos);
			triangles[1] = createTriangles(_parent, localVertNeg, viewVertNeg, uvNeg);
			
			return triangles;
		}
		
		// targetPos and targetNeg are arrays containing vertices for resp. the positive triangle and negative triangle
		// returns t (in ]0, 1[) of intersection interval
		private function splitLineInViewCoords(partitionPlane : Plane, viewV1 : Vertex3D, viewV2 : Vertex3D, localV1 : Vertex3D, localV2 : Vertex3D, targetPos : Vector.<Vertex3D>, targetNeg : Vector.<Vertex3D>) : Number
		{
			var div : Number, t : Number;
			var v : Vertex3D;
			var n : Vector3D = partitionPlane.normal;
			
			div = n.x*(viewV2.x-viewV1.x)+n.y*(viewV2.y-viewV1.y)+n.z*(viewV2.z-viewV1.z);
			
			t = -(n.dotProduct(viewV1) + partitionPlane.d)/div;
					
			v = new Vertex3D(localV1.x+t*(localV2.x-localV1.x), localV1.y+t*(localV2.y-localV1.y), localV1.z+t*(localV2.z-localV1.z));
			
			targetPos.push(v);
			targetNeg.push(v);
			return t;
		}
		
		// t = returned by splitLine
		private function splitUV(uv1 : UVCoords, uv2 : UVCoords, t : Number, targetPos : Vector.<UVCoords>, targetNeg : Vector.<UVCoords>) : void
		{
			var uv : UVCoords = new UVCoords(uv1.u+t*(uv2.u-uv1.u), uv1.v+t*(uv2.v-uv1.v));
			targetPos.push(uv);
			targetNeg.push(uv);
		}
		
		// t = returned by splitLine
		private function splitVertices(vert1 : Vertex3D, vert2 : Vertex3D, t : Number, targetVertex : Vertex3D) : void
		{
			targetVertex.x = vert1.x+t*(vert2.x-vert1.x);
			targetVertex.y = vert1.y+t*(vert2.y-vert1.y);
			targetVertex.z = vert1.z+t*(vert2.z-vert1.z);
		}
		
		private function createTriangles(parent : Model3D, localVertices : Vector.<Vertex3D>, viewVertices : Vector.<Vertex3D>, uv : Vector.<UVCoords>) : Vector.<Triangle3D>
		{
			var all : Vector.<Triangle3D> = new Vector.<Triangle3D>();
			var triangle : Triangle3D = new Triangle3D(viewVertices[0] as Vertex3D, viewVertices[1] as Vertex3D, viewVertices[2] as Vertex3D);
			triangle.uv1 = uv[0] as UVCoords;
			triangle.uv2 = uv[1] as UVCoords;
			triangle.uv3 = uv[2] as UVCoords;
			triangle.material = material;
			
			if (_parent) {
				_parent.insertTriangle(triangle);
				triangle.setParent(_parent, localVertices[0], localVertices[1], localVertices[2]);
			}
		//	trace (localVertices[0], localVertices[1], localVertices[2], viewVertices[0], viewVertices[1], viewVertices[2]);
			all.push(triangle);
			
			if (localVertices.length > 3) { 
				triangle = new Triangle3D(viewVertices[0] as Vertex3D, viewVertices[2] as Vertex3D, viewVertices[3] as Vertex3D);
				triangle.uv1 = uv[0] as UVCoords;
				triangle.uv2 = uv[2] as UVCoords;
				triangle.uv3 = uv[3] as UVCoords;
				triangle.material = material;
				
				if (_parent) {
					_parent.insertTriangle(triangle);
					triangle.setParent(_parent, localVertices[0], localVertices[2], localVertices[3]);
				}
			//	trace (localVertices[0], localVertices[2], localVertices[3], viewVertices[0], viewVertices[2], viewVertices[3]);
				all.push(triangle);
			}
			return all;
		}
		
		private function calculateArea2D(p1 : Point, p2 : Point, p3 : Point) : Number
		{
			return Math.abs(p1.x*p2.y + p2.x*p3.y + p3.x*p1.y - p1.x*p3.y - p3.x*p2.y - p2.x*p1.y)*.5; 
		}
	}
}