package
{
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Vector3D;

	public class Vertex2D extends Point
	{
		public var next:Vertex2D;

		public function Vertex2D(x:Number=0, y:Number=0)
		{
			super(x, y);
		}
	}
}