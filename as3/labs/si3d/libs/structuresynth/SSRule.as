package structuresynth
{
	import com.si3d.render.*;
	import com.si3d.geom.*;
	import flash.geom.*;

	public class SSRule
	{
		public var name:String;
		public var mesh:ProjectionMesh=null;
		private var _totalWeight:Number=0;
		private var _sequences:Vector.<SSRuleSequence>=new Vector.<SSRuleSequence>();

		function SSRule(name:String)
		{
			this.name=name;
		}

		public function newMesh(mesh:Mesh):void
		{
			this.mesh=new ProjectionMesh(mesh);
		}

		public function newRule(callers:Vector.<SSRuleCaller>, option:*):void
		{
			var seq:SSRuleSequence=new SSRuleSequence(callers, option);
			_sequences.push(seq);
			_totalWeight+=seq.weight;
			mesh=null;
		}

		public function init():void
		{
			for each (var seq:SSRuleSequence in _sequences)
				seq.depth=0;
		}

		public function getSequence():SSRuleSequence
		{
			var w:Number=0, rand:Number=Math.random() * _totalWeight;
			for each (var seq:SSRuleSequence in _sequences)
			{
				w+=seq.weight;
				if (rand <= w)
					return seq;
			}
			throw new Error("no sequences in rule:" + name);
		}
	}
}