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
		
		public var m11 : Number = 0, m12 : Number = 0, m13 : Number = 0, m14 : Number = 0;
		public var m21 : Number = 0, m22 : Number = 0, m23 : Number = 0, m24 : Number = 0;
		public var m31 : Number = 0, m32 : Number = 0, m33 : Number = 0, m34 : Number = 0;
		public var m41 : Number = 0, m42 : Number = 0, m43 : Number = 0, m44 : Number = 0;
		
		// TODO : must use world matrix invert instead like OpenGL
		// not work when transfrom cam yet...fix later
		public function lookAt( target:Object3D ):void
		{
        	// compute the forward vector
        	var forward:Vector3D = target.position.subtract(matrix3D.position);
            forward.normalize();
            
            // compute the up vector
            var up:Vector3D = new Vector3D(0, 1, 0);
            
            // compute the left vector
    		var left:Vector3D = up.crossProduct(forward);
    		left.normalize();
    		
    		// re-calculate the orthonormal up vector
    		up = forward.crossProduct(left);
    		up.normalize();
    		
    		/*
			m14 = m24 = m34 = 0;
			m44 = 1;
			
			m11 = left.x;
			m12 = left.y;
			m13 = left.z;
			m14 = -left.dotProduct(matrix3D.position);
			
			m21 = up.x;
			m22 = up.y;
			m23 = up.z;
			m24 = -up.dotProduct(matrix3D.position);
			
			m31 = forward.x;
			m32 = forward.y;
			m33 = forward.z;
			m34 = -forward.dotProduct(matrix3D.position);
			
			matrix3D = new Matrix3D(Vector.<Number>([
								m11, m21, m31, m41,
								m12, m22, m32, m42,
								m13, m23, m33, m43,
								m14, 0, -500, m44]))
			*/
			
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