package com.derschmale.wick3d.core.pipeline
{
	import com.derschmale.wick3d.cameras.Camera3D;
	import com.derschmale.wick3d.core.bsp.BspTree;
	import com.derschmale.wick3d.core.data.RenderPipelineData;
	import com.derschmale.wick3d.core.geometry.Triangle3D;
	import com.derschmale.wick3d.debug.GeneralStatData;
	import com.derschmale.wick3d.display3D.World3D;
	import com.derschmale.wick3d.events.RenderEvent;
	import com.derschmale.wick3d.view.Viewport;
	
	import flash.display.Graphics;
	import flash.display.GraphicsSolidFill;
	import flash.display.GraphicsStroke;
	import flash.display.GraphicsTrianglePath;
	import flash.display.IGraphicsData;
	import flash.display.TriangleCulling;
	import flash.geom.Matrix3D;
	import flash.geom.PerspectiveProjection;
	import flash.geom.Utils3D;
	import flash.utils.getTimer;
	
	public class NativeRenderPipeline extends RenderPipeline
	{
		private var _bsp : BspTree
		
		public function NativeRenderPipeline(bsp : BspTree)
		{
			super();
			_bsp = bsp;
			
			projection = new PerspectiveProjection();
			projection.fieldOfView = 53;
			projection.focalLength = 500;
			
			//projection.projectionCenter.x = 320;
			//projection.projectionCenter.y = 240;
			
			projectionMatrix3D = projection.toMatrix3D();
		}
		
		override public function render(world : World3D, camera : Camera3D, target : Viewport) : void
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
		
		public var projection:PerspectiveProjection;
		
		public var projectionMatrix3D:Matrix3D;
		//public var viewMatrix3D:Matrix3D;
		
		private var _triangles:GraphicsTrianglePath;
		private var _graphicsData:Vector.<IGraphicsData>;
		private var stroke:GraphicsStroke = new GraphicsStroke(1, false, "normal", "none", "round", 0, new GraphicsSolidFill(0xFF0000));
		
		private function ZSort(a:Triangle3D, b:Triangle3D) : int
		{
		    if (a.zIndex < b.zIndex)
		    {
		        return -1;
		    }
		    else if (a.zIndex > b.zIndex)
		    {
		        return 1;
		    }
		    else
		    {
		        return 0;
		    }
		}
		
		override protected function doRasterization(target : Viewport) : void
		{
			var graphics : Graphics = target.graphics;
			
			Vector.<Triangle3D>(_data.triangles).sort(ZSort);
			
			target.clear();
			
			var i:int = 0;
			var n:int = -1;
			
			var _vin:Vector.<Number>;
			
			for each(var triangle:Triangle3D in _data.triangles) 
			{
				if (!triangle.isCulled) 
				{
					_vin = new Vector.<Number>();
					i = 0;
					n = -1;
					
					_triangles = new GraphicsTrianglePath(new Vector.<Number>(), new Vector.<int>(), new Vector.<Number>(), TriangleCulling.NONE);
					_graphicsData = new Vector.<IGraphicsData>();
					
					graphics.lineStyle();
					triangle.material.drawTriangle(triangle, graphics);
					
					_vin[i++] = triangle.v1.x;
					_vin[i++] = triangle.v1.y;
					_vin[i++] = triangle.v1.z;
					
					_vin[i++] = triangle.v2.x;
					_vin[i++] = triangle.v2.y;
					_vin[i++] = triangle.v2.z;
					
					_vin[i++] = triangle.v3.x;
					_vin[i++] = triangle.v3.y;
					_vin[i++] = triangle.v3.z;
					
					_triangles.uvtData.push(triangle.uv1.u, triangle.uv1.v, 1);
					_triangles.uvtData.push(triangle.uv2.u, triangle.uv2.v, 1);
					_triangles.uvtData.push(triangle.uv3.u, triangle.uv3.v, 1);
					
					n += 3;
	
					_triangles.indices.push(0, n - 1, n - 2);
					
					_graphicsData.push(triangle.material.graphicsBitmapFill, _triangles);
					_graphicsData.push(stroke, _triangles);
					
					// view
					if(_camera.transform.viewTransform)
						_camera.transform.viewTransform.toNative().transformVectors(_vin, _vin);
					
					// project
					Utils3D.projectVectors(projectionMatrix3D, _vin, _triangles.vertices, _triangles.uvtData);
					
					graphics.drawGraphicsData(_graphicsData);
					
					GeneralStatData.drawnPolygons++;
				}
			}
		}
	}
}