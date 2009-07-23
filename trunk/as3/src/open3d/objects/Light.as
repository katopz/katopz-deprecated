package open3d.objects {
	import open3d.objects.Object3D;

	import flash.geom.Vector3D;

	/**
	 * @author kris
	 */
	public class Light extends Object3D {
		private var _direction : Vector3D = new Vector3D();
		private var _halfVector : Vector3D = new Vector3D();

		public function get direction() : Vector3D { 
			return _direction; 
		}

		public function get halfVector() : Vector3D { 
			return _halfVector; 
		}

		public var xPos : Number
		public var yPos : Number
		public var zPos : Number

		function Light(x : Number = 1, y : Number = 1, z : Number = 1) {
			this.xPos = x;
			this.yPos= y;
			this.zPos = z;
			setPosition(x, y, z); 
		}

		public function setPosition(x : Number, y : Number, z : Number) : void {
			_direction.x = -x;
			_direction.y = -y;
			_direction.z = -z; 
			_direction.normalize();
			_halfVector.x = _direction.x;
			_halfVector.y = _direction.y;
			_halfVector.z = _direction.z + 1; 
			_halfVector.normalize();
		}
	}
}
