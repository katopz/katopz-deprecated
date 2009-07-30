package open3d.materials.shaders 
{
	import open3d.objects.Light;

	import flash.display.BitmapData;
	import flash.geom.Matrix3D;

	/**
	 * @author kris@neuroproductions.be
	 */
	public class NormalMaterial extends VertexShaderMaterial implements IShader
	{
		public function NormalMaterial(light : Light,bitmapData : BitmapData = null)
		{
			super(light, bitmapData);
		}

		
		
		
	}
}
