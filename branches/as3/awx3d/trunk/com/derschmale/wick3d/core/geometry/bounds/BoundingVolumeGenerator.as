package com.derschmale.wick3d.core.geometry.bounds
{
	import __AS3__.vec.Vector;
	
	import com.derschmale.wick3d.core.geometry.Vertex3D;
	import com.derschmale.wick3d.display3D.BoundingVolume;
	
	/**
	 * BoundingVolumeGenerator creates bounding volume objects depending on the type given, simplifying the assignment of bounding volumes.
	 */
	public class BoundingVolumeGenerator
	{
		/**
		 * Creates a bounding volume of a given type for a set of vertices.
		 * 
		 * @param vertices The vertices of the object for which the bounding box is created. These need to be in object space.
		 * @param type A string value describing the type of bounding box which is needed.
		 * 
		 * @return A bounding volume for the set of vertices.
		 * 
		 * @see com.derschmale.wick3d.display3D.BoundingVolume
		 */
		public static function generateBoundingVolume(vertices : Vector.<Vertex3D>, type : String) : AbstractBoundingVolume
		{
			switch (type)
			{
				case BoundingVolume.NONE:
					return null;
					break;
				case BoundingVolume.BOUNDING_SPHERE:
					return new BoundingSphere(vertices);
					break;
			}
			
			return null;
		}
	}
}