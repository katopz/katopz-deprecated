package 
{
	import de.nulldesign.nd3d.material.PixelMaterial;
	import de.nulldesign.nd3d.objects.Sphere;
	import de.nulldesign.nd3d.view.AbstractView;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author ...
	 */
	public class PixelMaterialExample extends AbstractView
	{
		private var s:Sphere;
		private var s2:Sphere;
		public function PixelMaterialExample() 
		{
			super(this, 600, 400);
			
			s = new Sphere(20, 100, new PixelMaterial(0xFFFFFF, 1, 2));
			s.xPos = -100;
			renderList.push(s);
			
			s2 = new Sphere(10, 80, new PixelMaterial(0xCCCCCC, 1, 1));
			s2.xPos = 100;
			renderList.push(s2);

			stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
		}
		override protected function loop(e:Event):void
		{
			super.loop(e);
			
			s.angleX += 0.01;
			s.angleY += 0.01;
			
			s.angleX += 0.005;
			s.angleY += 0.005;
			
			cam.angleX += (mouseY - cam.vpY) * .0005;
			cam.angleY += (mouseX - cam.vpX) * .0005;
		}
		private function onMouseWheel(evt:MouseEvent):void 
		{
			cam.zOffset -= evt.delta * 10;
		}
	}
}