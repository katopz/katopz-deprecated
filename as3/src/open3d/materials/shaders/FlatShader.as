package open3d.materials.shaders 
{
	import open3d.objects.Light;
	
	import open3d.materials.shaders.IShader;

	import flash.display.BitmapData;
	

	/**
	 * @author kris@neuroproductions.be
	 */
	public class FlatShader extends NormalMaterial implements IShader 
	{
		public function FlatShader(light:Light)
		{
			// TODO: make me!		
			var bmd:BitmapData =new BitmapData(0,0)
			super(light,bmd);
		}
		
		
	}
}
