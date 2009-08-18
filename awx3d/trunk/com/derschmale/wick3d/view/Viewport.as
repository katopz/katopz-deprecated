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

package com.derschmale.wick3d.view
{
	import com.derschmale.wick3d.core.data.RenderPipelineData;
	import com.derschmale.wick3d.core.geometry.Triangle3D;
	import com.derschmale.wick3d.core.interaction.Mouse3DController;
	import com.derschmale.wick3d.core.pipeline.RenderPipeline;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * The Viewport class is used as the target on the stage to render to. It can be seen as a window through which we view the three-dimensional world.
	 * 
	 * @author David Lenaerts
	 */
	public class Viewport extends Sprite
	{
		private var _viewportWidth : Number;
		private var _viewportHeight : Number;
		
		private var _centerX : Number;
		private var _centerY : Number;
		
		private var _aspectRatio : Number;
		private var _alignToStage : Boolean;
		
		private var _mouse3D : Mouse3DController;
		/**
		 * Creates a new Viewport
		 * 
		 * @param alignToStage Specifies whether the viewport should be automatically resized to the stage.
		 * @param width The width of the viewport in pixels. This parameter will be ignored if alignToStage is set to true.
		 * @param height The height of the viewport in pixels. This parameter will be ignored if alignToStage is set to true.
		 */
		public function Viewport(alignToStage : Boolean = false, width : Number = 800, height : Number = 600)
		{
			super();
			viewportWidth = width;
			viewportHeight = height;
			_alignToStage = alignToStage;
			_mouse3D = new Mouse3DController(this);
			if (_alignToStage)
				this.addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
		}
		
		/**
		 * The width of the viewport in pixels. This parameter will be ignored if alignToStage is set to true.
		 */
		public function get viewportWidth() : Number
		{
			return _viewportWidth;
		}
		
		public function set viewportWidth(value : Number):void
		{
			_viewportWidth = value;
			_centerX = value*.5;
			_aspectRatio = _viewportHeight/_viewportWidth;
		}
		
		/**
		 * The height of the viewport in pixels. This parameter will be ignored if alignToStage is set to true.
		 */
		public function get viewportHeight() : Number
		{
			return _viewportHeight;
		}
		
		public function set viewportHeight(value : Number):void
		{
			_viewportHeight = value;
			_centerY = value*.5;
			_aspectRatio = _viewportHeight/_viewportWidth;
		}
		
		/**
		 * The aspect ratio of the viewport. It is defined as _viewportHeight/_viewportWidth.
		 */
		public function get aspectRatio() : Number
		{
			return _aspectRatio;
		}
		
		/**
		 * The x-component of the center of the viewport. It is defined as _viewportWidth/2
		 */
		public function get centerX() : Number
		{
			return _centerX;
		}
		
		/**
		 * The y-component of the center of the viewport. It is defined as _viewportHeight/2
		 */
		public function get centerY() : Number
		{
			return _centerY;
		}
		
		/**
		 * Removes all previously drawn graphics in the viewport. This is typically called at the beginning of the drawing loop of the RenderPipeline.
		 */
		public function clear() : void
		{
			this.graphics.clear();
		}
		
		/**
		 * Return an Array of all rendered triangles under the specified point (in viewport coordinates).
		 * 
		 * @param x The x coordinate of the point.
		 * @param y The y coordinate of the point.
		 * @param onlyInteractive If true, triangles whose material aren't interactive are ignored. Otherwise, all triangles are considered.
		 * 
		 * @return An Array of rendered Triangle3D instances that contain the (x, y) point.
		 * 
		 * @see com.derschmale.wick3d.core.geometry.Triangle3D
		 */
		public function getTrianglesUnderPoint(x : Number, y : Number, onlyInteractive : Boolean = false) : Array
		{
			var data : RenderPipelineData = RenderPipeline.getDataForViewport(this);
			var triangles : Vector.<Triangle3D> = data.triangles;
			var i : int = triangles.length;
			var triangle : Triangle3D;
			var validTriangles : Array = [];
			
			while ((i>0) && (triangle = triangles[--i] as Triangle3D)) {
				if ((!onlyInteractive || triangle.material.interactive) && triangle.containsPoint2D(x, y))
					validTriangles.push(triangle);
			}
			return validTriangles;
		} 
		
		/**
		 * Returns the top-most (closest to the viewer) of all rendered triangles under the specified point (in viewport coordinates).
		 * 
		 * @param x The x coordinate of the point.
		 * @param y The y coordinate of the point.
		 * @param onlyInteractive If true, triangles whose material aren't interactive are ignored. Otherwise, all triangles are considered.
		 * 
		 * @return The top-most Triangle3D instance that contain the (x, y) point.
		 * 
		 * @see com.derschmale.wick3d.core.geometry.Triangle3D
		 */
		public function getTopTriangleUnderPoint(x : Number, y : Number, onlyInteractive : Boolean = false) : Triangle3D
		{
			var data : RenderPipelineData = RenderPipeline.getDataForViewport(this);
			var triangles : Vector.<Triangle3D> = data.triangles;
			var i : int = 0;
			var triangle : Triangle3D;
			var validTriangles : Array = [];
			
			while ((i>0) && (triangle = triangles[i++] as Triangle3D)) {
				if (!triangle.isCulled && (!onlyInteractive || triangle.material.interactive) && triangle.containsPoint2D(x, y))
					return triangle;
			}
			return null;
		} 
		
		private function handleAddedToStage(event : Event) : void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
			viewportWidth = stage.stageWidth;
			viewportHeight = stage.stageHeight;
			stage.addEventListener(Event.RESIZE, handleStageResize);
		}
		
		private function handleStageResize(event : Event) : void
		{
			viewportWidth = stage.stageWidth;
			viewportHeight = stage.stageHeight;
		}
	}
}