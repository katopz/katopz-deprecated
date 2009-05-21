package open3d.objects
{
	import flash.display.Shape;
	import flash.geom.Matrix3D;
	
	/**
	 * Camera3D
	 * @author katopz
	 * 
	 */	
	public class Object3D extends Shape
	{
		public function Object3D():void 
		{
			transform.matrix3D = new Matrix3D();
		}
	}
}