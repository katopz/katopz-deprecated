package open3d.objects {
	import open3d.objects.Object3D;

	import flash.geom.Vector3D;

	/**
	 * @author kris
	 */
	public class Light extends Object3D {
		public var direction : Vector3D = new Vector3D();
		public var halfVector : Vector3D = new Vector3D();

		function Light(showLight:Boolean =false) 
		{
			if (showLight)
			{
				this.graphics.beginFill(0x00FF00);
				this.graphics.drawCircle(0, 0, 50);
			}
			updatePosition();
			super();
		}
		override public function project(camera:Camera3D):void
		{
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
