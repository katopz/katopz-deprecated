package examples
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import org.papervision3d.core.geom.renderables.Vertex3D;
	import org.papervision3d.core.math.Number3D;
	import org.papervision3d.core.math.Plane3D;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.primitives.Cylinder;
	import org.papervision3d.scenes.Scene3D;
	import org.papervision3d.view.BasicView;
	import org.papervision3d.view.stats.StatsView;
	
	[SWF(width="640", height="480", backgroundColor="#000000", frameRate="60")]
	public class ExPlane3D extends BasicView
	{
		private const XZPLANE:Number3D = new Number3D(0, 1, 0);
		
		private var plane3D:Plane3D  = new Plane3D(XZPLANE, Number3D.ZERO);
		private var isRotating:Boolean = false;
		
		public function ExPlane3D() 
		{
			camera.y = 200;
			
			startRendering();
			
			stage.addEventListener(MouseEvent.CLICK, clickHandler);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
		}
		
		private function keyDownHandler(event:KeyboardEvent):void
		{
			//toggle rotating
			if(event.keyCode == Keyboard.CONTROL)
			{
				isRotating = (isRotating == false) ? true : false;
			}
			
			//rebuild scene
			if(event.keyCode == Keyboard.SHIFT)
			{
				scene = new Scene3D();
			}
		}
		
		
		private function clickHandler(event:MouseEvent):void
		{
			var ray:Number3D = camera.unproject(viewport.containerSprite.mouseX, viewport.containerSprite.mouseY);
			ray = Number3D.add(ray, camera.position);
			
			var cameraVertex3D:Vertex3D = new Vertex3D(camera.x, camera.y, camera.z);
			var rayVertex3D:Vertex3D = new Vertex3D(ray.x, ray.y, ray.z);
			
			var intersectPoint:Vertex3D = plane3D.getIntersectionLine(cameraVertex3D, rayVertex3D);
			
			var cylinder:Cylinder = new Cylinder(null, 10, 100, 1, 1);
			cylinder.x = intersectPoint.x;
			cylinder.y = intersectPoint.y;
			cylinder.z = intersectPoint.z;
			
			//the closer to the center, the larger the tower
			cylinder.scale = 1000 / cylinder.distanceTo(new DisplayObject3D());
			//readjust y based on scale (half height times scale)
			cylinder.y += 50 * cylinder.scale;
			

			scene.addChild(cylinder);
		}
		
		override protected function onRenderTick(event:Event=null):void
		{
			if(isRotating)
			{
				camera.moveForward(1000);
				camera.yaw(.5);
				camera.moveBackward(1000);
			}
			
			renderer.renderScene(scene, camera, viewport);
		}
	}
	
}