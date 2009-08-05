package open3d.objects
{
	import flash.display.Shape;
	import flash.geom.Matrix3D;
	import flash.geom.PerspectiveProjection;
	import flash.geom.Vector3D;

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
		public var angle:Number;
		
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
			angle = Math.atan2(w/2, Math.abs(matrix3D.position.length));
		}
		
		// TODO : must use world matrix invert instead like OpenGL
		// not work when transfrom cam yet...fix later
		public function lookAt( target:Object3D ):void
		{
        	// compute the forward vector
        	var forward:Vector3D = target.position.subtract(matrix3D.position);
            forward.normalize();
            
            var up:Vector3D = new Vector3D(0, 1, 0);
            var left:Vector3D = new Vector3D(1, 0, 0);
            
            // compute the left vector
    		left = up.crossProduct(forward);
    		left.normalize();
    		
    		// re-calculate the orthonormal up vector
    		up = forward.crossProduct(left);
    		up.normalize();
    		
            matrix3D.pointAt(target.position, matrix3D.position, up);
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