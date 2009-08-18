package com.derschmale.wick3d.core.geometry.bounds
{
	import com.derschmale.wick3d.core.frustum.ViewFrustum;
	import com.derschmale.wick3d.core.geometry.Plane;
	import com.derschmale.wick3d.core.geometry.Vertex3D;
	import com.derschmale.wick3d.core.math.SDMatrix3D;
	import com.derschmale.wick3d.core.math.Transformation3D;
	import flash.geom.Vector3D;
	
	/**
	 * The BoundingSphere class is a sphere-shaped bounding volume. It uses the object's centre coordinates
	 */
	public class BoundingSphere extends AbstractBoundingVolume implements IBoundingVolume
	{
		private var _center : Vector3D = new Vector3D(0, 0, 0, 1);
		private var _radius : Number = 0;
		
		private var _centerView : Vector3D;
		
		/**
		 * Creates a BoundingSphere object.
		 * 
		 * @param vertices The vertices of the object. The vertices passed here should be in object space.
		 */
		public function BoundingSphere(vertices:Vector.<Vertex3D>)
		{
			super(vertices);
		}
		
		/**
		 * Transforms the bounding volume to view coordinates.
		 * 
		 * @param transform The transformation object to be used.
		 * 
		 * @see com.derschmale.wick3d.core.math.Transformation3D
		 */
		override public function transformToViewCoords(transform : Transformation3D):void
		{
			var matrix : SDMatrix3D = transform.viewTransform;
			_centerView = transform.vectorToViewCoords(_center);
		}
		
		/**
		 * Tests the bounds to a camera's frustum.
		 * 
		 * @param frustum The view frustum to test to.
		 * @returns A boolean value indicating whether or not the object is (partially) contained within the frustum or not at all, used in object culling.
		 * 
		 * @see com.derschmale.wick3d.core.frustum.ViewFrustum
		 */
		override public function testBoundsToFrustum(frustum:ViewFrustum):Boolean
		{
			return 	testBoundsToPlane(frustum.near) &&
					testBoundsToPlane(frustum.far) &&
					testBoundsToPlane(frustum.left) &&
					testBoundsToPlane(frustum.right) &&
					testBoundsToPlane(frustum.top) &&
					testBoundsToPlane(frustum.bottom);
			
			return true;
		}
		
		/**
		 * Updates the bounds according to the current vertices.
		 */
		override public function updateBounds():void
		{
			var dist : Number;
			var diff : Vector3D;
			
			//var covariance : Matrix3D = createCovarianceMatrix();
			for (var i : int = 0; i < _vertices.length; i++) {
				_center.incrementBy(_vertices[i] as Vertex3D);
			}
			_center.scaleBy(1/_vertices.length);
			
			for (i = 0; i < _vertices.length; i++) {
				diff = _center.subtract(_vertices[i]);
				dist = diff.lengthSquared;
				if (dist > _radius*_radius) {
					_radius = Math.sqrt(dist);
				}
			}	
		}
		
		// make public!
		private function testBoundsToPlane(plane : Plane) : Boolean
		{
			var dist : Number = plane.signedDistanceToPoint(_centerView);
			
			if (dist > 0) return true;
			if (Math.abs(dist) > _radius) return false;	// culled
			return true;
		}
	}
}