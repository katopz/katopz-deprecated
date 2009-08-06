package open3d.objects {
	import open3d.materials.ColorMaterial;
	import open3d.objects.Object3D;

	import flash.geom.Vector3D;

	/**
	 * @author kris
	 */
	public class Light extends Sphere {
		public var direction : Vector3D = new Vector3D();
		public var halfVector : Vector3D = new Vector3D();

		function Light() 
		{
		
			updatePosition();
			super(10,5,5,new ColorMaterial(0xFFFFFF));
		}
		
		override public function set x(value:Number):void
		{
			super.x = value;
			updatePosition();
		}
		override public function set y(value:Number):void
		{
			super.y = value;
			updatePosition();
		}
		override public function set z(value:Number):void
		{
			super.z = value;
			updatePosition();
		}
		public function updatePosition() : void {
			direction.x = this.x * -1;
			direction.y = this.y * -1;
			direction.z = this.z * -1; 
			direction.normalize();
			halfVector.x = direction.x;
			halfVector.y = direction.y;
			halfVector.z = direction.z + 1; 
			halfVector.normalize();
		}
	}
}
