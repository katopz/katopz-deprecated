package open3d.objects
{
	import flash.display.Shape;
	import flash.display.Sprite;
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

		// vector
		public var forward:Vector3D;
		public var up:Vector3D;
		public var left:Vector3D;
				
		// culling
		public var w:Number, h:Number;
		public var ratio:Number;
		public var angle:Number;
		
		public var view:Sprite;
		
		public function Camera3D(view:Sprite, w:Number, h:Number)
		{
			this.view = view;
			this.w = w;
			this.h = h;
			
			projection = new PerspectiveProjection();
			view.transform.matrix3D = new Matrix3D();
			matrix3D = transform.matrix3D = new Matrix3D();
			
			up = Vector3D.Y_AXIS;
			left = Vector3D.X_AXIS;
			
			update();
		}
		
		// dirty : w, h, fieldOfView, focalLength
		// TODO : better replace with get/set?
		public function update():void
		{
			ratio = w/h;
			angle = Math.atan2(w, Math.abs(matrix3D.position.z));
		}
		
		// TODO : must use world matrix invert instead like OpenGL
		// not work when transfrom cam yet...fix later
		public function lookAt( target:Object3D ):void
		{
        	// compute the forward vector
        	forward = target.position.subtract(matrix3D.position);
            forward.normalize();
            
            // compute the up vector
            up = new Vector3D(0, 1, 0);
            
            // compute the left vector
    		left = up.crossProduct(forward);
    		left.normalize();
    		
    		// re-calculate the orthonormal up vector
    		up = forward.crossProduct(left);
    		up.normalize();
    		
			matrix3D.pointAt(target.position, matrix3D.position, up);
			
			update();
		}
		
		public function get viewMatrix3D():Matrix3D
		{
			var _matrix3D:Matrix3D = matrix3D.clone();
			_matrix3D.invert();
			view.transform.matrix3D = _matrix3D;
			return _matrix3D;
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