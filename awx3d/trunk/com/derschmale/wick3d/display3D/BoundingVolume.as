package com.derschmale.wick3d.display3D
{
	/**
	 * The BoundingVolume class is an enumeration class for types of bounding volumes. These are used to simplify the creation of bounding volumes for objects.
	 * 
	 * @see com.derschmale.wick3d.core.geometry.bounds.BoundingSphere
	 * @see com.derschmale.wick3d.core.geometry.bounds.BoundingVolumeGenerator
	 */
	public class BoundingVolume
	{
		/**
		 * The type value for no bounding box.
		 */
		public static var NONE : String = "none";
		
		/**
		 * The type value for a bounding sphere
		 * 
		 * @see com.derschmale.wick3d.core.geometry.bounds.BoundingSphere
		 */
		public static var BOUNDING_SPHERE : String = "boundingBoxAxisAligned";
	}
}