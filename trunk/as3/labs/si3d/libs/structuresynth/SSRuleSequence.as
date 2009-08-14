package structuresynth
{
	import com.si3d.render.*;
	import flash.geom.*;

	public class SSRuleSequence
	{
		public var callers:Vector.<SSRuleCaller>;
		public var weight:Number;
		public var maxdepth:int;
		public var finalRuleName:String;
		public var depth:int=0;

		function SSRuleSequence(callers:Vector.<SSRuleCaller>, option:*=undefined)
		{
			option=option || new Object();
			this.callers=callers;
			this.weight=option["w"] || option["weight"] || 1;
			this.maxdepth=option["md"] || option["maxdepth"] || int.MAX_VALUE;
			this.finalRuleName=option[">"] || null;
		}
	}
}