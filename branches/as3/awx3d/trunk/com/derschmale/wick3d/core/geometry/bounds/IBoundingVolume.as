package com.derschmale.wick3d.core.geometry.bounds
{
	import com.derschmale.wick3d.core.frustum.ViewFrustum;
	import com.derschmale.wick3d.core.math.Transformation3D;
	
	/**
	 * The IBoundingVolume interface describes the methods which are necessary for a bounding volume.
	 */
	public interface IBoundingVolume
	{
		/**
		 * Transforms the bounding volume to view coordinates.
		 * 
		 * @param transform The transformation object to be used.
		 * 
		 * @see com.derschmale.wick3d.core.math.Transformation3D
		 */
		function transformToViewCoords(transform : Transformation3D) : void;
		
		/**
		 * Tests the bounds to a camera's frustum.
		 * 
		 * @param frustum The view frustum to test to.
		 * @returns A boolean value indicating whether or not the object is (partially) contained within the frustum or not at all, used in object culling.
		 * 
		 * @see com.derschmale.wick3d.core.frustum.ViewFrustum
		 */
		function testBoundsToFrustum(frustum : ViewFrustum) : Boolean;
		
		/**
		 * Updates the bounds according to the current vertices.
		 */
		function updateBounds() : void;
	}
}