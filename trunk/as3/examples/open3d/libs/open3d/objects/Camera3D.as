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
		//public var matrix3D:Matrix3D;

		// vector
		public var forward:Vector3D;
		public var up:Vector3D;
		public var left:Vector3D;
				
		// culling
		public var w:Number, h:Number;
		public var ratio:Number;
		public var angle:Number;
		
		public var view:Object3D;
		
		public function Camera3D(w:Number, h:Number)
		{
			this.view = new Object3D();
			
			this.w = w;
			this.h = h;
			
			projection = new PerspectiveProjection();
			transform.matrix3D = new Matrix3D();
			
			up = Vector3D.Y_AXIS;
			left = Vector3D.X_AXIS;
			
			update();
		}
		
		// dirty : w, h, fieldOfView, focalLength
		// TODO : better replace with get/set?
		public function update():void
		{
			ratio = w/h;
			angle = Math.atan2(w, Math.abs(transform.matrix3D.position.z));
			
			var _matrix3D:Matrix3D = transform.matrix3D.clone();
			_matrix3D.invert();
			//view.transform.matrix3D = _matrix3D;
			view.setMatrix3D(_matrix3D);
		}
		
		// TODO : not work when transfrom cam yet...add later
		public function lookAt( target:Object3D ):void
		{
    		var position:Vector3D = target.position.clone();
    		position.negate();
        	
        	// compute the forward vector
        	forward = position.subtract(transform.matrix3D.position);
            forward.normalize();
            
            // compute the up vector
            up = new Vector3D(0, 1, 0);
            
            // compute the left vector
    		left = up.crossProduct(forward);
    		left.normalize();
    		
    		// re-calculate the orthonormal up vector
    		up = forward.crossProduct(left);
    		up.normalize();
    		
    		// TODO : fix this ;p
			transform.matrix3D.pointAt(position, transform.matrix3D.position, up);
			update();
		}
		
		public function get viewMatrix3D():Matrix3D
		{
			return view.transform.matrix3D;
		}
		
		override public function set z(value:Number):void
		{
			super.z = value;
			update();
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