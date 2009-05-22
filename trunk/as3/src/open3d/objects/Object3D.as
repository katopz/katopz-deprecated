package open3d.objects
{
	import flash.display.Sprite;
	import flash.geom.Matrix3D;
	
	/**
	 * Object3D
	 * @author katopz
	 * 
	 */	
	public class Object3D extends Sprite
	{
		public function Object3D():void 
		{
			transform.matrix3D = new Matrix3D();
		}
	}
}