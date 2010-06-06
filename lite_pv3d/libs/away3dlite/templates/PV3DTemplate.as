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
			
			//pv3d_camera.z = -1000;
			//pv3d_camera.focus = 100;//8.660254037844387
			//pv3d_camera.fov = 25;//60
			//pv3d_camera.zoom = 10;//40
			
			// lite
			super.init();
			
			view.renderer = renderer || view.renderer;
			view.clipping = clipping || view.clipping;
			
			// apply lite config
			pv3d_camera.z = camera.z;//-1000
			pv3d_camera.focus = camera.focus;//100
			pv3d_camera.zoom = camera.zoom;//10
			
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
			
			// pv3d
			// TODO : use matrix transform 
			/*if(pv3d_root.rotationX != -scene.rotationX)
				pv3d_root.rotationX = -scene.rotationX;
			if(pv3d_root.rotationY != scene.rotationY)
				pv3d_root.rotationY = scene.rotationY;
			if(pv3d_root.rotationZ != -scene.rotationZ)
				pv3d_root.rotationZ = -scene.rotationZ;*/
			
			// camera
/*			if(pv3d_camera.x != camera.x)
				pv3d_camera.x = camera.x;
			if(pv3d_camera.y !== -camera.y)
				pv3d_camera.y = -camera.y;
			if(pv3d_camera.z !== camera.z)
				pv3d_camera.z = camera.z;
			
			if(pv3d_camera.rotationX != -camera.rotationX)
				pv3d_camera.rotationX = -camera.rotationX;
			if(pv3d_camera.rotationY !== camera.rotationY)
				pv3d_camera.rotationY = camera.rotationY;
			if(pv3d_camera.rotationZ !== -camera.rotationZ)
				pv3d_camera.rotationZ = -camera.rotationZ;
*/			
			PV3D.setTransform(pv3d_root, scene.transform.matrix3D);
			PV3D.setTransform(pv3d_camera, camera.transform.matrix3D);
			
			// pv3d
			pv3d_renderer.renderScene(pv3d_scene, pv3d_camera, pv3d_viewport);
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