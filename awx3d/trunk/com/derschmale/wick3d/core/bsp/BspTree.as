package com.derschmale.wick3d.core.bsp
{
	import com.derschmale.wick3d.cameras.Camera3D;
	import com.derschmale.wick3d.core.data.GeometryData;
	import com.derschmale.wick3d.core.objects.SpatialObject3D;
	
	import flash.display.Graphics;
	
	/**
	 * The BspTree object is the top most BspNode in a bsp tree. A bsp tree is a hierarchically data structure recursively dividing the world into half-spaces, called branches.
	 * The bottom most node is a leaf, which contains the triangles. Traversing the tree according to the camera's position, renders the scene without sorting errors.
	 * However, building a bsp tree is an intensive operation, and therefore should only be done once. As a result, it should not be used on animated objects.
	 * 
	 * @see com.derschmale.wick3d.core.bsp.BspNode
	 */
	public class BspTree extends BspNode
	{
		private var _source : SpatialObject3D;
		
		/**
		 * Creates a BspTree object.
		 * 
		 * @param source The source SpatialObject3D used to generate the Bsp Tree. This can typically be World3D or a Model3D containing the static scene.
		 * 
		 * @see com.derschmale.wick3d.core.objects.SpatialObject3D
		 * @see com.derschmale.wick3d.core.objects.Model3D
		 * @see com.derschmale.wick3d.display3D.World3D
		 */
		public function BspTree(source : SpatialObject3D)
		{
			if (source) {
				_source = source;
				build();
			}
		}
		
		/**
		 * Builds the BSP tree. It creates new child nodes and invokes the build function on the new children.
		 */
		override public function build() : void
		{
			var geometry : GeometryData = new GeometryData();	// to catch triangles
			_source.transformToWorldCoords(geometry);
			addTriangles(geometry.triangles);
			super.build();
		}
		
		override public function render(camera:Camera3D, graphics:Graphics):void
		{
			if (camera.frustum) camera.frustum.transformToWorldCoords(camera);
			super.render(camera, graphics);
		}
	}
}