package structuresynth
{
	import com.si3d.render.*;
	import flash.geom.*;

	public class SSOperation
	{
		public var repeat:int, matrix:Matrix3D;

		function SSOperation(rep:int, mat:Matrix3D)
		{
			repeat=rep;
			matrix=mat;
		}
	}
}