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
		public var matrix3D:Matrix3D;
		
		public function Camera3D()
		{
			projection = new PerspectiveProjection();
			matrix3D = transform.matrix3D = new Matrix3D();
		}
		
		/*
		public function set fieldOfView(value:Number):void
		{
			_projection.fieldOfView = value;
		}

		public function get focalLength():Number
		{
			return _projection.focalLength;
		}
		
		public function set focalLength(value:Number):void
		{
			_projection.focalLength = value;
			matrix3D = _projection.toMatrix3D();
		}
		
		public function get projectionMatrix3D():Matrix3D
		{
			return _projection.toMatrix3D();
		}
		*/
	}
}