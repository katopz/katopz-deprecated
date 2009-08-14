package structuresynth
{
	import com.si3d.render.*;
	import flash.geom.*;

	public class SSRuleCaller
	{
		public var ruleName:String, operations:Vector.<SSOperation>;

		function SSRuleCaller(name:String, ope:Array)
		{
			ruleName=name;
			if (ope.length == 0)
				ope=[new SSOperation(1, new Matrix3D())];
			operations=Vector.<SSOperation>(ope);
		}
	}
}