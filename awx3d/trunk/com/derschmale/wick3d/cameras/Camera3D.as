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

package com.derschmale.wick3d.cameras
{
	import com.derschmale.wick3d.core.data.GeometryData;
	import com.derschmale.wick3d.core.frustum.ViewFrustum;
	import com.derschmale.wick3d.core.math.Transformation3D;
	import flash.geom.Vector3D;
	import com.derschmale.wick3d.core.objects.SpatialObject3D;
	import com.derschmale.wick3d.core.data.RenderPipelineData;
	import com.derschmale.wick3d.projections.IProjection;
	import com.derschmale.wick3d.projections.SDPerspectiveProjection;

	/**
	 * The Camera3D class defines the viewpoint (ie. eye position) from which the 3D world is rendered. Properties that affect the conversion from 3D world to 2D screen coordinates, such as the projection and field of view are set here.
	 * 
	 * @author David Lenaerts
	 * @see com.derschmale.wick3d.projections.PerspectiveProjection
	 * 
	 */
	public class Camera3D extends SpatialObject3D
	{
		/**
		 * The projection that projects 3D coordinates to 2D clip coordinates on the view plane.
		 */
		public var projection : IProjection;
		
		private var _frustum : ViewFrustum;
		
		private var _target : SpatialObject3D;
		
		private var _forwardVector : Vector3D = new Vector3D(0, 0, 1);
		private var _upVector : Vector3D = new Vector3D(0, 1, 0);
		private var _rightVector : Vector3D = new Vector3D(1, 0, 0);
		
		/**
		 * Creates a new Camera3D object.
		 * 
		 * @param fov The horizontal angle of view that can be seen through the camera's "lens".
		 * @param projection The projection that projects 3D coordinates to 2D clip coordinates on the view plane. If no value is specified, PerspectiveProjection is used as a default.
		 * 
		 * @see com.derschmale.wick3d.projections.PerspectiveProjection
		 */
		public function Camera3D(fov : Number = Math.PI/2, projection : IProjection = null)
		{
			if (!projection) this.projection = new SDPerspectiveProjection();
			else this.projection = projection;
			fieldOfView = fov;
			super();
		}
		
		/**
		 * The horizontal angle of view that can be seen through the camera's "lens". Lowering the value will cause the camera to zoom in.
		 */
		public function get fieldOfView() : Number
		{
			return projection.fieldOfView;
		}
		
		public function set fieldOfView(value : Number) : void
		{
			projection.fieldOfView = value;
		}
		
		/**
		 * Updates the camera's view-transformation matrix, and updates the view frustum and projection if necessary. This is typically called from the RenderPipeline in an early stage with each render.
		 * 
		 * @param pipelineData The RenderPipelineData for the currently used RenderPipeline
		 * @param cameraTransform The Transformation3D object of the camera used to transform world coordinates to view coordinates. In a Camera3D object, this is not used.
		 * @param parentTransform The Transformation3D object of the camera used to transform local object coordinates to the parent's local coordinates. In a Camera3D object, this is not used.
		 * @param recursive Specifies whether the object's children should be transformed. In a Camera3D object, this is not used.
		 * 
		 * @see com.derschmale.wick3d.core.data.RenderPipelineData
		 * @see com.derschmale.wick3d.core.math.Transformation3D
		 */
		override public function transformToViewCoords(geometryData : GeometryData, camera:Camera3D, parentTransform:Transformation3D=null, recursive:Boolean=true):void
		{
			if (geometryData is RenderPipelineData) {
				var pipelineData : RenderPipelineData = geometryData as RenderPipelineData;
				projection.aspectRatio = pipelineData.viewPort.aspectRatio;
				if (_frustum) _frustum.update(projection.focalLength, pipelineData.viewPort.aspectRatio);
			}
			
			if (target) {
				transform.lookAt(target.position, true);
			}
			else {
				transform.updateTransformationMatrix();
				transform.generateInverse(false);
			}
		}
		
		/**
		 * The view frustum used by this camera.
		 * 
		 * @see com.derschmale.wick3d.core.frustum.ViewFrustum
		 */
		public function get frustum() : ViewFrustum
		{
			return _frustum;
		}
		
		public function set frustum(value : ViewFrustum) : void
		{
			_frustum = value;
		}
		
		/**
		 * The target SpatialObject3D to which the camera is locked. If set, the camera's rotational properties will be ignored and it will always point toward the target's origin. If a value of null is passed, the camera target is removed.
		 * 
		 * @see com.derschmale.wick3d.core.objects.SpatialObject3D
		 */
		public function get target() : SpatialObject3D
		{
			return _target;
		}
		
		public function set target(value : SpatialObject3D) : void
		{
			_target = value;
		}
		
		/**
		 * Performs a panning movement. The camera will move by a certain distance in the direction of its local X-axis.
		 * 
		 * @param distance The distance to move the camera along the X-axis.
		 */
		public function pan(distance : Number) : void
		{
			transform.moveRight(distance);
		}
		
		/**
		 * Performs a dollying movement. The camera will move by a certain distance in the direction of its local Z-axis.
		 * 
		 * @param distance The distance to move the camera along the Z-axis.
		 */
		public function dolly(distance : Number) : void
		{
			transform.moveForward(distance);
		}
		
		/**
		 * Performs a booming movement. The camera will move by a certain distance in the direction of its local Y-axis.
		 * 
		 * @param distance The distance to move the camera along the Y-axis.
		 */
		public function boom(distance : Number) : void
		{
			transform.moveUp(distance);
		}
	}
}