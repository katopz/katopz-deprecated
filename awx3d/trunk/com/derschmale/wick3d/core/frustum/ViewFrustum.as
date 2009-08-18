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

package com.derschmale.wick3d.core.frustum
{
	import com.derschmale.wick3d.cameras.Camera3D;
	import com.derschmale.wick3d.core.geometry.Plane;
	import com.derschmale.wick3d.core.geometry.Vertex3D;
	import flash.geom.Vector3D;
	
	/**
	 * The ViewFrustum class describes the volume of 3D space that is visible from a camera and a viewport. The visible space is enclosed by 6 planes, to which objects can be culled and/or clipped.
	 * If many objects are known to often be outside the visible area of the screen, it is suggested to define a ViewFrustum to a Camera3D and using a FrustumCuller in the pipeline. 
	 *
	 * @see com.derschmale.wick3d.cameras.Camera3D
	 * @see com.derschmale.wick3d.view.Viewport
	 * @see com.derschmale.wick3d.core.culling.FrustumCuller
	 *  
	 * @author David Lenaerts
	 */
	public class ViewFrustum
	{
		private var _aspectRatio : Number;
		private var _focalLength : Number;
		
		private var _left : Plane;
		private var _right : Plane;
		private var _top : Plane;
		private var _bottom : Plane;
		private var _near : Plane;
		private var _far : Plane;
		
		private var _matchNearPlaneToFocalLength : Boolean = true;
		
		public var corners : Vector.<Vertex3D>;
		public var worldCorners : Vector.<Vertex3D>;
		
		/**
		 * Creates a ViewFrustum object.
		 * 
		 * @param nearZ The distance of the near plane. Typically, this is set to the camera's focal length.
		 * @param farZ The distance of the far plane. If culling or clipping is used with this frustum, it can be considered the drawing distance.
		 */
		public function ViewFrustum(nearZ : Number, farZ : Number)
		{
			_near = new Plane(new Vector3D(0, 0, 1), nearZ);
			_far = new Plane(new Vector3D(0, 0, -1), farZ);
			_left = new Plane(new Vector3D(), 0);
			_right = new Plane(new Vector3D(), 0);
			_top = new Plane(new Vector3D(), 0);
			_bottom = new Plane(new Vector3D(), 0);
			corners = new Vector.<Vertex3D>();
			worldCorners = new Vector.<Vertex3D>(8, true);
			for (var i : int = 0; i < 8; i++) {
				worldCorners[i] = new Vertex3D();
			}
		}
		
		/**
		 * Updates the planes of the frustum
		 * 
		 * @param focalLength The focal length of the camera.
		 * @param aspectRatio The aspect ratio of the viewport
		 * 
		 * @see com.derschmale.wick3d.cameras.Camera3D
		 * @see com.derschmale.wick3d.view.Viewport
		 */
		public function update(focalLength : Number, aspectRatio : Number) : void
		{
			if (focalLength != _focalLength || aspectRatio != _aspectRatio) {
				var divH : Number = 1/Math.sqrt(focalLength*focalLength+1);
				var divV : Number = 1/Math.sqrt(focalLength*focalLength+aspectRatio*aspectRatio);
				
				_left.normal.x = focalLength*divH;
				_left.normal.z = divH;
				_right.normal.x = -focalLength*divH;
				_right.normal.z = divH;
				_bottom.normal.y = focalLength*divV;
				_bottom.normal.z = aspectRatio*divV;
				_top.normal.y = -focalLength*divV;
				_top.normal.z = aspectRatio*divV;
				
				if (_matchNearPlaneToFocalLength)
					_near.d = focalLength;
				
				_focalLength = focalLength;
				_aspectRatio = aspectRatio;
				updateCorners();
			}
		}
		
		/**
		 * The distance of the near plane. Typically, if _matchNearPlaneToFocalLength is set to true, this is automatically set to the camera's focal length. Otherwise, changing this value has no effect.
		 */
		public function get nearZ() : Number 
		{
			return _near.d;
		}
		
		public function set nearZ(value : Number) : void 
		{
			if (!_matchNearPlaneToFocalLength)
				_near.d = value;
		}
		
		/**
		 * The distance of the far plane. If culling or clipping is used with this frustum, it can be considered the drawing distance.
		 */
		public function get farZ() : Number 
		{
			return _far.d;
		}
		
		public function set farZ(value : Number) : void 
		{
			_far.d = value;
		}
		
		/**
		 * The frustum's left plane.
		 * 
		 * @see com.derschmale.wick3d.core.geometry.Plane
		 */
		public function get left() : Plane
		{
			return _left;
		}
		
		/**
		 * The frustum's right plane.
		 * 
		 * @see com.derschmale.wick3d.core.geometry.Plane
		 */
		public function get right() : Plane
		{
			return _right;
		}
		
		/**
		 * The frustum's top plane.
		 * 
		 * @see com.derschmale.wick3d.core.geometry.Plane
		 */
		public function get top() : Plane
		{
			return _top;
		}
		
		/**
		 * The frustum's bottom plane.
		 * 
		 * @see com.derschmale.wick3d.core.geometry.Plane
		 */
		public function get bottom() : Plane
		{
			return _bottom;
		}
		
		/**
		 * The frustum's near plane.
		 * 
		 * @see com.derschmale.wick3d.core.geometry.Plane
		 */
		public function get near() : Plane
		{
			return _near;
		}
		
		
		/**
		 * The frustum's far plane.
		 * 
		 * @see com.derschmale.wick3d.core.geometry.Plane
		 */
		public function get far() : Plane
		{
			return _far;
		}
		
		/**
		 * Defines whether the near plane should be adjusted automatically according to the current projection's focal length. Default value is true.
		 * 
		 * @see com.derschmale.wick3d.core.geometry.Plane
		 * @see com.derschmale.wick3d.projections.IProjection
		 */
		public function get matchNearPlaneToFocalLength() : Boolean
		{
			return _matchNearPlaneToFocalLength;
		}
		
		public function set matchNearPlaneToFocalLength(value : Boolean) : void
		{
			_matchNearPlaneToFocalLength = value;
		}
		
		/**
		 * Checks if a vector's coordinates are inside the ViewFrustum
		 * 
		 * @return A boolean value indicating whether or not the vector's coordinates are inside the frustum.
		 * 
		 * @see com.derschmale.wick3d.core.math.Vector3D
		 * 
		 */
		public function containsPoint(v : Vector3D) : Boolean
		{
			if (v.z < _near.d) return false;
			if (v.z > _far.d) return false;
			if (_left.normal.dotProduct(v) < 0) return false;
			if (_right.normal.dotProduct(v) < 0) return false;
			if (_bottom.normal.dotProduct(v) < 0) return false;
			if (_top.normal.dotProduct(v) < 0) return false;
			return true;
		}
		
		public function transformToWorldCoords(camera : Camera3D) : void
		{
			camera.transform.transformVerticesToWorld(corners, worldCorners);
		}
		
		private function updateCorners() : void
		{
			var sc : Number;
			var cross : Vector3D;
			var corner : Vertex3D;
			cross = _left.normal.crossProduct(_top.normal);
			
			// near-left-top
			corner = new Vertex3D(cross.x, cross.y, cross.z);
			corner.scaleBy(_near.d/corner.z);
			corners[0] = corner;
			
			// far-left-top
			corner = new Vertex3D(cross.x, cross.y, cross.z);
			corner.scaleBy(_far.d/corner.z);
			corners[1] = corner;
			
			cross = _right.normal.crossProduct(_top.normal);
			
			// near-right-top
			corner = new Vertex3D(cross.x, cross.y, cross.z);
			corner.scaleBy(_near.d/corner.z);
			corners[2] = corner;
			
			// far-right-top
			corner = new Vertex3D(cross.x, cross.y, cross.z);
			corner.scaleBy(_far.d/corner.z);
			corners[3] = corner;
			
			
			cross = _left.normal.crossProduct(_bottom.normal);
			
			// near-left-bottom
			corner = new Vertex3D(cross.x, cross.y, cross.z);
			corner.scaleBy(_near.d/corner.z);
			corners[4] = corner;
			
			// far-right-bottom
			corner = new Vertex3D(cross.x, cross.y, cross.z);
			corner.scaleBy(_far.d/corner.z);
			corners[5] = corner;
			
			cross = _right.normal.crossProduct(_bottom.normal);
			
			// near-right-bottom
			corner = new Vertex3D(cross.x, cross.y, cross.z);
			corner.scaleBy(_near.d/corner.z);
			corners[6] = corner;
			
			// far-right-bottom
			corner = new Vertex3D(cross.x, cross.y, cross.z);
			corner.scaleBy(_far.d/corner.z);
			corners[7] = corner;
		}
	}
}