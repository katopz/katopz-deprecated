package
{
	import away3dlite.materials.WireColorMaterial;
	import away3dlite.primitives.Cube6;
	import away3dlite.templates.PV3DTemplate;
	
	import flash.geom.Vector3D;
	
	import org.papervision3d.materials.WireframeMaterial;
	import org.papervision3d.materials.utils.MaterialsList;
	import org.papervision3d.objects.primitives.Cube;

	[SWF(backgroundColor="#CCCCCC", frameRate="30", width="800", height="600")]
	public class ExSetup extends PV3DTemplate
	{
		private var step:Number = 0;

		override protected function onInit():void
		{
			// lite
			scene.addChild(new Cube6(new WireColorMaterial(0xFF0000, .1)));

			// pv3d
			var _mats:MaterialsList = new MaterialsList();
			_mats.addMaterial(new WireframeMaterial, "all");
			_pv3d_root.addChild(new Cube(_mats, 100, 100, 100));
		}

		override protected function onPreRender():void
		{
			// lite
			++scene.rotationX;
			++scene.rotationY;
			++scene.rotationZ;

			camera.x = 1000 * Math.cos(step);
			camera.y = 10 * (300 - mouseY);
			camera.z = 1000 * Math.sin(step);
			
			camera.lookAt(new Vector3D());

			step += 0.01;
		}
	}
}