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

package com.derschmale.wick3d.core.pipeline
{
	import com.derschmale.wick3d.cameras.Camera3D;
	import com.derschmale.wick3d.core.clipping.PlaneClipper;
	import com.derschmale.wick3d.core.culling.BackFaceCuller;
	import com.derschmale.wick3d.core.culling.FrustumCuller;
	import com.derschmale.wick3d.core.culling.SimpleNearCuller;
	import com.derschmale.wick3d.core.data.RenderPipelineData;
	import com.derschmale.wick3d.core.geometry.Plane;
	import com.derschmale.wick3d.core.geometry.Triangle3D;
	import com.derschmale.wick3d.core.geometry.Vertex3D;
	import flash.geom.Vector3D;
	import com.derschmale.wick3d.debug.GeneralStatData;
	import com.derschmale.wick3d.display3D.World3D;
	import com.derschmale.wick3d.events.RenderEvent;
	import com.derschmale.wick3d.view.Viewport;
	
	import flash.display.Graphics;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	/**
	 * The RenderPipeline class is the main hub for the Wick3d rendering process when using standard Z-sorting. It is in charge of initiating all the tasks in the pipeline, such as transforming vertices to view space, culling, clipping, ... In the last stage, the objects are drawn.
	 * 
	 * @see com.derschmale.wick3d.core.pipeline.BSPRenderPipeline
	 * @see com.derschmale.wick3d.core.data.RenderPipelineData
	 * 
	 * @author David Lenaerts
	 * 
	 */
	public class RenderPipeline implements IRenderPipeline
	{	
		protected var _data : RenderPipelineData;
		
		protected var _camera : Camera3D;
		
		private var _nearClipper : PlaneClipper;
		private var _nearCuller : SimpleNearCuller;
		private var _backFaceCuller : BackFaceCuller;
		private var _frustumCuller : FrustumCuller;
		private var _nearPlane : Plane = new Plane(new Vector3D(0, 0, 1), 1);
		 
		private var _clipCoord : Point = new Point();
		
		private var _useNearClipping : Boolean = false;
		
		private var _matchNearPlaneToFocalLength : Boolean = true;
		
		private var _notifier : RenderNotifier;
		
		private static var _renderDataLookup : Dictionary = new Dictionary();
		
		/**
		 * Creates a RenderPipeline instance.
		 */
		public function RenderPipeline()
		{
			_backFaceCuller = new BackFaceCuller();
			_nearClipper = new PlaneClipper();
			_nearCuller = new SimpleNearCuller(5);
			_frustumCuller = new FrustumCuller(false);
			_notifier = RenderNotifier.getInstance();
		}
		
		/**
		 * Defines whether polygons should be clipped against a near plane. If false, the polygons will be culled when one of their vertices is on the negative side of the plane. Default value is false.
		 * 
		 * @see com.derschmale.wick3d.core.clipping.SimpleNearClipper
		 * @see com.derschmale.wick3d.core.culling.SimpleNearCuller
		 */
		public function get useNearClipping() : Boolean
		{
			return _useNearClipping;
		}
		
		public function set useNearClipping(value : Boolean) : void
		{
			_useNearClipping = value;
		}
		
		/**
		 * The distance of the near plane used with near plane culling or clipping.
		 * 
		 * @see com.derschmale.wick3d.core.geometry.Plane
		 */
		public function get nearPlaneDistance() : Number
		{
			return _nearPlane.d;
		}
		
		public function set nearPlaneDistance(value : Number) : void
		{
			_nearPlane.d = value;
		}
		
		/**
		 * Defines whether the near plane used with near plane clipping should be adjusted automatically according to the current projection's focal length. This argument has no effect when useNearClipping is set to false, or when using a ViewFrustum on the camera. Default value is true.
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
		 * Initiates the rendering process, ultimately drawing a world to a target viewport.
		 * 
		 * @param world The World3D instance that needs to be rendered.
		 * @param camera The Camera3D instance through which we view the world.
		 * @param target The Viewport used to drawn the scene to.
		 */
		public function render(world : World3D, camera : Camera3D, target : Viewport) : void
		{
			_notifier.notify(this, RenderEvent.RENDER_START);
			if (!_renderDataLookup[target]) _renderDataLookup[target] = new RenderPipelineData();
			_data = _renderDataLookup[target];
			GeneralStatData.reset(getTimer());
			_data.reset();
			_camera = camera;
			
			if (_camera.frustum)
				_frustumCuller.frustum = _camera.frustum;
			
			_data.viewPort = target;
			
			doViewTransform(world);
			doCulling();
			doScreenCoords(target);
			doRasterization(target);
		}
		
		/**
		 * Returns the last RenderPipelineData used for a certain Viewport, from all used RenderPipeline instances.
		 */
		public static function getDataForViewport(viewport : Viewport) : RenderPipelineData
		{
			return _renderDataLookup[viewport];
		}
		
		protected function doViewTransform(world : World3D) : void
		{
			_camera.transformToViewCoords(_data, null, null, false);
			
			world.transformToViewCoords(_data, _camera);
			
			GeneralStatData.polygons = _data.triangles.length;
			GeneralStatData.vertices = _data.vertices.length;
		}
		
		protected function doCulling() : void
		{
			var i : int = _data.triangles.length;
			var triangle : Triangle3D;
			var newTriangles : Vector.<Triangle3D>;

			if (_matchNearPlaneToFocalLength && _useNearClipping)
				_nearPlane.d = _camera.projection.focalLength;
				
			while ((i>0) && (triangle = _data.triangles[--i] as Triangle3D)) {
				triangle.invalidateNormal();
				triangle.isCulled = _backFaceCuller.testTriangle(triangle); // || _nearCuller.testTriangle(triangle);
				
				if (!triangle.isCulled && _camera.frustum) {
					triangle.isCulled = _frustumCuller.testTriangle(triangle);
				}
				
				if (!triangle.isCulled) {
					if (_useNearClipping) {
						newTriangles = _nearClipper.clipTriangle(triangle, _camera.frustum? _camera.frustum.near : _nearPlane);
						if (newTriangles && newTriangles.length) _data.triangles = _data.triangles.concat(newTriangles);
					}
					else {
						triangle.isCulled = _nearCuller.testTriangle(triangle);
					}
				}
			}
			
		}
		
		protected function doScreenCoords(viewport : Viewport) : void
		{
			var triangle : Triangle3D;
			var i : int = _data.triangles.length;
			
			while ((i>0) && (triangle = _data.triangles[--i] as Triangle3D)) {
				if (!triangle.isCulled) {
					if (!triangle.v1.isProjected) vertexToScreenCoord(triangle.v1, viewport);
					if (!triangle.v2.isProjected) vertexToScreenCoord(triangle.v2, viewport);
					if (!triangle.v3.isProjected) vertexToScreenCoord(triangle.v3, viewport);
					triangle.calculateZIndex();
				}
			}
		}
		
		protected function vertexToScreenCoord(vertex : Vertex3D, viewport : Viewport) : void
		{
			_camera.projection.project(vertex, vertex.coords2D);
		
			vertex.coords2D.x++;
			vertex.coords2D.x *= viewport.centerX;
			
			vertex.coords2D.y++;
			vertex.coords2D.y *= viewport.centerY;
			
			vertex.isProjected = true;
		}
		
		/*
		 * TO DO: do ViewPort clipping
		 */
		protected function doRasterization(target : Viewport) : void
		{
			var triangle : Triangle3D; 
			var i : int = _data.triangles.length;
			var graphics : Graphics = target.graphics;
			
			//TODO//Vector.<Triangle3D>(_data.triangles).sortOn("zIndex", Array.NUMERIC);
			
			target.clear();
			
			while ((i>0) && (triangle = _data.triangles[--i] as Triangle3D)) {
				if (!triangle.isCulled) {
					triangle.material.drawTriangle(triangle, graphics);
					GeneralStatData.drawnPolygons++;
				}
			}
		}		
	}
}