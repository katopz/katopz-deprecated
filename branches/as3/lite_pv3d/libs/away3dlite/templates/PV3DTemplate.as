package away3dlite.templates
{
	import away3dlite.arcane;
	import away3dlite.core.clip.*;
	import away3dlite.core.render.*;
	
	import flash.events.Event;
	
	import org.papervision3d.cameras.Camera3D;
	import org.papervision3d.core.proto.DisplayObjectContainer3D;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.render.BasicRenderEngine;
	import org.papervision3d.scenes.Scene3D;
	import org.papervision3d.view.Viewport3D;
	
	use namespace arcane;
	
	public class PV3DTemplate extends Template
	{
		protected var pv3d_viewport:Viewport3D;
		protected var pv3d_scene:Scene3D;
		protected var pv3d_camera:Camera3D;
		protected var pv3d_renderer:BasicRenderEngine;
		
		protected var pv3d_root:DisplayObject3D;
		
		/** @private */
		arcane override function init():void
		{
			// pv3d
			addChild(pv3d_viewport = new Viewport3D(_screenRect.width, _screenRect.height));
			
			pv3d_renderer = new BasicRenderEngine();
			pv3d_scene = new Scene3D();
			pv3d_camera = new Camera3D();
			
			pv3d_scene.addChild(pv3d_root = new DisplayObject3D);
			
			// apply lite config
			pv3d_camera.z = -1000;
			pv3d_camera.focus = 100;
			pv3d_camera.zoom = 9.5;
			
			// lite
			super.init();
			
			view.renderer = renderer;
			view.clipping = clipping || new RectangleClipping();
			
			onInitPV3D();
		}
		
		protected function onInitPV3D():void
		{
			// override me
		}
		
		override protected function onEnterFrame(event:Event):void
		{
			// pv3d
			pv3d_renderer.renderScene(pv3d_scene, pv3d_camera, pv3d_viewport);
			
			// lite
			super.onEnterFrame(event);
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