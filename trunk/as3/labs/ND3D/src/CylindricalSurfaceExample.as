package 
{
	import de.nulldesign.nd3d.geom.Vertex;
	import de.nulldesign.nd3d.material.BitmapMaterial;
	import de.nulldesign.nd3d.material.LineMaterial;
	import de.nulldesign.nd3d.material.PixelMaterial;
	import de.nulldesign.nd3d.objects.CylindricalSurface;
	import de.nulldesign.nd3d.view.AbstractView;

	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;

	/**
	 *  Hunan University of China(湖南大学)
	 * @author FlyingWind (戴意愿)  (falwujn@163.com)
	 * @link  http://colorfuldiary.blog.163.com
	 * 2009/06/04
	 */
	public class CylindricalSurfaceExample extends AbstractView
	{
		private var s1:CylindricalSurface;
		private var s2:CylindricalSurface;
		private var s3:CylindricalSurface;

		[Embed("assets/doggy.jpg")]
		private var MyTexture:Class;    

		public function CylindricalSurfaceExample() 
		{
			super(this, 600, 400);
                         
			var ma:PixelMaterial = new PixelMaterial(0x000000);
			s1 = new CylindricalSurface(ma, 50, new Vertex(210, 0, 0), 200, 5, 3);
			renderList.push(s1); 
						 
			var mat:LineMaterial = new LineMaterial(0x000000);
			s2 = new CylindricalSurface(mat, 50, new Vertex(-210, 0, 0), 200, 5, 3);
			renderList.push(s2);
						 
			var texture1:BitmapData = new MyTexture().bitmapData;
			texture1.colorTransform(texture1.rect, new ColorTransform(0.3, 0.5, 0.6, 1, 0, 0, 0, 0));
			var mat1:BitmapMaterial = new BitmapMaterial(texture1, false, false, true, true);
			s3 = new CylindricalSurface(mat1, 50, new Vertex(10, 0, 0), 200, 5, 3);
			renderList.push(s3); 
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			renderer.render(renderList, cam);
		}

		override protected function loop(e:Event):void
		{
			super.loop(e);
                                                  
			cam.angleX += (mouseY - cam.vpY) * .0005;
			cam.angleY += (mouseX - cam.vpX) * .0005;
		}

		private function onMouseWheel(evt:MouseEvent):void 
		{
			cam.zOffset -= evt.delta * 10;
		}
	}
}
 