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
		
		// culling
		public var w:Number, h:Number;
		public var ratio:Number;
		public var theta:Number;
		
		public function Camera3D(w:Number, h:Number)
		{
			this.w = w;
			this.h = h;
			
			projection = new PerspectiveProjection();
			matrix3D = transform.matrix3D = new Matrix3D();
			
			update();
		}
		
		// dirty : w, h, fieldOfView, focalLength
		// TODO : better replace with get/set?
		public function update():void
		{
			ratio = w/h;
			theta = Math.atan2(((w>h)?w:h)/2, projection.focalLength);
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