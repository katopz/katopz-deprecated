package 
{
	import de.nulldesign.nd3d.geom.Vertex;
	import de.nulldesign.nd3d.material.LineMaterial;
	import de.nulldesign.nd3d.material.WireMaterial;
	import de.nulldesign.nd3d.objects.Ground;
	import de.nulldesign.nd3d.objects.Line3D;
	import de.nulldesign.nd3d.objects.Sphere;
	import de.nulldesign.nd3d.view.AbstractView;

	import flash.events.Event;

	/**
	 * ...
	 * @author ...
	 */
	public class MaterialExample2 extends AbstractView
	{
		private var s:Sphere;

		public function MaterialExample2() 
		{
			super(this, 600, 400);
			
			s = new Sphere(10, 100, new WireMaterial(0x00FF00, 1));
			renderList.push(s);
			
			//axis
			var xLine:Line3D = new Line3D(new Vertex(0, 0, 0), new Vertex(300, 0, 0), new LineMaterial(0xFF0000));
			var yLine:Line3D = new Line3D(new Vertex(0, 0, 0), new Vertex(0, 300, 0), new LineMaterial(0x00FF00));
			var zLine:Line3D = new Line3D(new Vertex(0, 0, 0), new Vertex(0, 0, 300), new LineMaterial(0x0000FF));
			
			renderList.push(xLine);
			renderList.push(yLine);
			renderList.push(zLine);
			
			var g:Ground = new Ground(300, 300, 5, 5, new WireMaterial(0xCCCCCC, 0.4, true));
			renderList.push(g);
		}

		override protected function loop(e:Event):void
		{
			super.loop(e);
			
			s.angleX += 0.01;
			s.angleY += 0.01;
			
			cam.angleX += (mouseY - cam.vpY) * .0005;
			cam.angleY += (mouseX - cam.vpX) * .0005;
		}
	}
}