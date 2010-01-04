package 
{
	import de.nulldesign.nd3d.geom.Face;
	import de.nulldesign.nd3d.geom.Vertex;
	import de.nulldesign.nd3d.material.LineMaterial;
	import de.nulldesign.nd3d.material.Material;
	import de.nulldesign.nd3d.material.WireMaterial;
	import de.nulldesign.nd3d.objects.Line3D;
	import de.nulldesign.nd3d.objects.SimpleCube;
	import de.nulldesign.nd3d.view.AbstractView;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Lars Gerckens (lars@nulldesign.de)
	 */
	public class NormalsTest extends AbstractView
	{
		public function NormalsTest() 
		{
			super(this, 600, 400);
			
			renderer.dynamicLighting = true;
			
			var cube:SimpleCube = new SimpleCube(new WireMaterial(0xFFFFFF, 1, false, 0xFF9900, 1), 100);
			renderList.push(cube);
			
			// calc normal of faces
			var f:Face;
			var n:Vertex;
			var m:Vertex;
			
			for(var i:uint = 0; i < cube.faceList.length; i++)
			{
				f = cube.faceList[i];

				m = new Vertex((f.v1.x + f.v2.x + f.v3.x) / 3, (f.v1.y + f.v2.y + f.v3.y) / 3, (f.v1.z + f.v2.z + f.v3.z) / 3);
				n = f.getNormal();
				
				n.length = 30;
				
				n.x += m.x;
				n.y += m.y;
				n.z += m.z;
				
				var l:Line3D = new Line3D(m, n, new LineMaterial(0xFF0000, 1, 4));
				renderList.push(l);
			}
		}
		
		override protected function loop(e:Event):void
		{
			super.loop(e);
			
			cam.angleX += (mouseY - cam.vpY) * .001;
			cam.angleY += (mouseX - cam.vpX) * .001;
		}
		
	}
	
}