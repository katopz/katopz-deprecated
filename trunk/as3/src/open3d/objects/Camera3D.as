package open3d.objects 
{
	import flash.display.Shape;
	import flash.geom.Matrix3D;
	import flash.geom.PerspectiveProjection;
	
	/**
	 * Camera3D
	 * @author katopz
	 */
	public class Camera3D extends Shape
	{
		public var projection:PerspectiveProjection; 
		public var matrix3D : Matrix3D;
		
		public function Camera3D() 
		{
			projection = new PerspectiveProjection();
			matrix3D = transform.matrix3D = new Matrix3D();
		}
	}
}