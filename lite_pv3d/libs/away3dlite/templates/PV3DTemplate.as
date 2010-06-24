package away3dlite.templates
{
	import away3dlite.arcane;
	import away3dlite.core.clip.*;
	import away3dlite.core.render.*;
	import away3dlite.plugins.PV3D;
	
	import flash.events.Event;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import org.papervision3d.cameras.Camera3D;
	import org.papervision3d.core.proto.DisplayObjectContainer3D;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.render.BasicRenderEngine;
	import org.papervision3d.scenes.Scene3D;
	import org.papervision3d.view.Viewport3D;
	
	use namespace arcane;
	
	public class PV3DTemplate extends Template
	{
		protected var _pv3d_viewport:Viewport3D;
		protected var _pv3d_scene:Scene3D;
		protected var _pv3d_camera:Camera3D;
		protected var _pv3d_renderer:BasicRenderEngine;
		
		protected var _pv3d_root:DisplayObject3D;
		
		/** @private */
		arcane override function init():void
		{
			// pv3d
			addChild(_pv3d_viewport = new Viewport3D(_screenRect.width, _screenRect.height));
			
			_pv3d_renderer = new BasicRenderEngine();
			_pv3d_scene = new Scene3D();
			_pv3d_camera = new Camera3D();
			
			_pv3d_scene.addChild(_pv3d_root = new DisplayObject3D);
			
			//pv3d_camera.z = -1000;
			//pv3d_camera.focus = 100;//8.660254037844387
			//pv3d_camera.fov = 25;//60
			//pv3d_camera.zoom = 10;//40
			
			// lite
			super.init();
			
			view.renderer = renderer || view.renderer;
			view.clipping = clipping || view.clipping;
			
			// apply lite camera
			PV3D.setTransform(_pv3d_camera, camera.transform.matrix3D);
			PV3D.setCamera(_pv3d_camera, camera);
			
			onInitPV3D();
		}
		
		protected function onInitPV3D():void
		{
			// override me
		}
		
		override protected function onEnterFrame(event:Event):void
		{
			// lite
			super.onEnterFrame(event);
			
			PV3D.setTransform(_pv3d_root, scene.transform.matrix3D);
			PV3D.setTransform(_pv3d_camera, camera.transform.matrix3D);
			
			// pv3d
			_pv3d_renderer.renderScene(_pv3d_scene, _pv3d_camera, _pv3d_viewport);
		}
		
		/**
		 * The renderer object used in the template.
		 */
		public var renderer:BasicRenderer = new BasicRenderer();
		
		/**
		 * The clipping object used in the template.
		 */
		public var clipping:Clipping;
	}
}