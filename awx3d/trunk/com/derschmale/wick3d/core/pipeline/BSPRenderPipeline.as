package com.derschmale.wick3d.core.pipeline
{
	import com.derschmale.wick3d.core.bsp.BspTree;
	import com.derschmale.wick3d.core.geometry.Triangle3D;
	import com.derschmale.wick3d.view.Viewport;
	
	import flash.display.Graphics;
	
	/**
	 * The RenderPipeline class is the main hub for the Wick3d rendering process when using a BSP Tree. It eliminates z-sorting issues, but can only be used in scenes in which the camera can move, but the objects itself cannot.
	 * 
	 * @see com.derschmale.wick3d.core.bsp.BspTree
	 */
	public class BSPRenderPipeline extends RenderPipeline
	{
		private var _bsp : BspTree
		
		/**
		 * Creates a RenderPipeline instance.
		 * 
		 * @param bsp The BspTree object to use for rendering.
		 * 
		 * @see com.derschmale.wick3d.core.bsp.BspTree
		 */
		public function BSPRenderPipeline(bsp : BspTree)
		{
			super();
			_bsp = bsp;
		}
		
		override protected function doRasterization(target : Viewport) : void
		{
			var triangle : Triangle3D; 
			var graphics : Graphics = target.graphics;
			
			target.clear();
			
			_bsp.render(_camera, graphics);
		}
	}
}