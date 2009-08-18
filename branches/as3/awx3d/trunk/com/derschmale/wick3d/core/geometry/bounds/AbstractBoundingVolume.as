package com.derschmale.wick3d.core.geometry.bounds
{
	import com.derschmale.wick3d.core.frustum.ViewFrustum;
	import com.derschmale.wick3d.core.geometry.Vertex3D;
	import com.derschmale.wick3d.core.math.SDMatrix3D;
	import com.derschmale.wick3d.core.math.Transformation3D;
	import flash.geom.Vector3D;
	
	/**
	 * AbstractBoundingVolume is an abstract class used as the base for bounding volumes. Bounding volumes are used for culling before any vertices are transformed to view space.
	 */
	public class AbstractBoundingVolume implements IBoundingVolume
	{
		protected var _vertices : Vector.<Vertex3D>;
		
		/**
		 * Creates an AbstractBoundingVolume object.
		 * 
		 * @param vertices The vertices of the object. The vertices passed here should be in object space.
		 */
		public function AbstractBoundingVolume(vertices : Vector.<Vertex3D>)
		{
			_vertices = vertices;
			updateBounds();
		}
		
		/**
		 * Transforms the bounding volume to view coordinates.
		 * 
		 * @param transform The transformation object to be used.
		 * 
		 * @see com.derschmale.wick3d.core.math.Transformation3D
		 */
		public function transformToViewCoords(transform : Transformation3D) : void {
			throw(new Error("AbstractBoundingVolume::transformToViewCoords is an abstract function and must be overridden"));
		}
		
		/**
		 * Tests the bounds to a camera's frustum.
		 * 
		 * @param frustum The view frustum to test to.
		 * @returns A boolean value indicating whether or not the object is (partially) contained within the frustum or not at all, used in object culling.
		 * 
		 * @see com.derschmale.wick3d.core.frustum.ViewFrustum
		 */
		public function testBoundsToFrustum(frustum : ViewFrustum) : Boolean {
			throw(new Error("AbstractBoundingVolume::testBoundsToFrustum is an abstract function and must be overridden"));
			return true;
		}
		
		/**
		 * Updates the bounds according to the current vertices.
		 */
		public function updateBounds() : void
		{
			throw(new Error("AbstractBoundingVolume::update is an abstract function and must be overridden"));
		}
		
		protected function createCovarianceMatrix() : SDMatrix3D
		{
			var len : int = _vertices.length
			var i : int = len;
			var leninv : Number = 1/len;
			var vertex : Vertex3D;
			var mean : Vector3D = new Vector3D(0, 0, 0, 1);
			var c : SDMatrix3D = new SDMatrix3D();
			
			while (vertex = _vertices[--i] as Vertex3D) {
				mean.x += vertex.x;
				mean.y += vertex.y;
				mean.z += vertex.z;
			}
			mean.x *= leninv;
			mean.y *= leninv;
			mean.z *= leninv;
			
			i = _vertices.length;
			
			while (vertex = _vertices[--i] as Vertex3D) {
				c.m11 += (vertex.x-mean.x)*(vertex.x-mean.x);
				c.m22 += (vertex.y-mean.y)*(vertex.y-mean.y);
				c.m33 += (vertex.z-mean.z)*(vertex.z-mean.z);
				c.m12 = c.m21 = (vertex.x-mean.x)*(vertex.y-mean.y);
				c.m13 = c.m31 = (vertex.x-mean.x)*(vertex.z-mean.z);
				c.m23 = c.m32 = (vertex.y-mean.y)*(vertex.z-mean.z);
			}
			c.m11 *= leninv; c.m12 *= leninv; c.m13 *= leninv;
			c.m21 *= leninv; c.m22 *= leninv; c.m23 *= leninv;
			c.m31 *= leninv; c.m32 *= leninv; c.m33 *= leninv;
			
			return c;
		}
	}
}