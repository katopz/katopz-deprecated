package
{
	import away3dlite.core.base.Object3D;
	
	import flash.geom.Matrix3D;
	
	import org.libspark.flartoolkit.core.FLARSquare;
	import org.libspark.flartoolkit.core.transmat.FLARTransMatResult;

	public class FLARResult
	{
		public var confidence:Number;
		public var cosine:Number;
		public var distance:Number;
		public var result:FLARTransMatResult;
		public var square:FLARSquare;
	
		public function FLARResult()
		{
			confidence = 0;
			result = new FLARTransMatResult;
		}
		
		public function setTransform(object3D:Object3D):void
		{
			var m:FLARTransMatResult = result;
			object3D.transform.matrix3D = new Matrix3D(Vector.<Number>([
				 m.m00, m.m10, m.m20, 0,
				 m.m01, m.m11, m.m21, 0,
				 m.m02, m.m12, m.m22, 0,
				 m.m03, m.m13, m.m23, 1
			]));
		}
	}
}