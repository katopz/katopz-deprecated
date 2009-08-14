package structuresynth
{
	import com.si3d.render.*;
	import com.si3d.geom.*;
	import flash.geom.*;
	
	public class StructureSynth
	{
		private var _mesh:Mesh;
		private var _rules:*=new Object();
		private var _depthLimit:int, _objectsLimit:int;
		private var _maxDepth:int, _maxObjects:int;
		private var _depth:int, _objects:int;
		private var _core:Render3D=new Render3D();
		private var _rootSequence:SSRuleSequence=new SSRuleSequence(new Vector.<SSRuleCaller>());
		static private var _rexContent:RegExp=/((\d+)[\s*]*)?\{(.*?)\}\s*|([^{},\s]+)\s*/g;
		static private var _rexOption:RegExp=/([a-zA-Z]+|>)[\s=:()]*([\-\d.]+|\w+)/g;
		static private var _rexRootOpt:RegExp=/(set)?[\s=:()]*([a-z]+)[\s=:()]*([\-\d.]+)/g;
		static private var _rexOperate:RegExp=/(r?[x-z]|s)([\-\d.\s,:=()]*)/g;

		/** constructor. do nothing */
		function StructureSynth(depthLimit:int=512, objectsLimit:int=4096)
		{
			_depthLimit=depthLimit;
			_objectsLimit=objectsLimit;
		}

		/** register primitive */
		public function primitive(name:String, mesh:Mesh):StructureSynth
		{
			if (!(name in _rules))
				_rules[name]=new SSRule(name);
			_rules[name].newMesh(mesh);
			return this;
		}

		/** register rule */
		public function rule(name:String, option:String, content:String):StructureSynth
		{
			var opt:*=new Object(), res:*;
			res=_rexOption.exec(option);
			while (res)
			{
				opt[res[1]]=res[2];
				res=_rexOption.exec(option);
			}
			if (!(name in _rules))
				_rules[name]=new SSRule(name);
			_rules[name].newRule(parseContent(new Vector.<SSRuleCaller>(), content), opt);
			return this;
		}

		/** register root rule */
		public function root(option:String, content:String, initialize:Boolean=true):StructureSynth
		{
			if (initialize)
			{
				_rootSequence.callers.length=0;
				_maxDepth=_depthLimit;
				_maxObjects=_objectsLimit;
			}
			var opt:*=new Object(), res:*;
			res=_rexRootOpt.exec(option);
			while (res)
			{
				switch (res[2])
				{
					case "maxdepth":
					case "md":
						_maxDepth=int(res[3]);
						break;
					case "maxobjects":
					case "mo":
						_maxObjects=int(res[3]);
						break;
					case "background":
					case "seed":
						break;
				}
				res=_rexRootOpt.exec(option);
			}
			_rootSequence.callers=parseContent(_rootSequence.callers, content);
			return this;
		}

		/** execute */
		public function exec(mesh:Mesh):Mesh
		{
			_mesh=mesh;
			for each (var rule:SSRule in _rules)
				rule.init();
			_depth=_objects=0;
			_core.id();
			_exec(_rootSequence);
			return mesh;
		}

		/** parse contents of rule. */
		static public function parseContent(rcList:Vector.<SSRuleCaller>, content:String):Vector.<SSRuleCaller>
		{
			var res:*, operations:Array=[];
			res=_rexContent.exec(content);
			while (res)
			{
				if (res[3])
				{
					operations.unshift(new SSOperation(res[2] || 1, parseOperation(new Matrix3D(), res[3])));
				}
				else if (res[4])
				{
					rcList.push(new SSRuleCaller(res[4], operations));
					operations=[];
				}
				res=_rexContent.exec(content);
			}
			return rcList;
		}

		/** parse matrix opreations. */
		static public function parseOperation(matrix:Matrix3D, operation:String):Matrix3D
		{
			var res:*, param:Array, p0:Number, p1:Number, p2:Number;
			res=_rexOperate.exec(operation);
			while (res)
			{
				param=res[2].match(/[\-\d.]+/g);
				if (param)
				{
					p0=Number(param[0]);
					switch (res[1])
					{
						case 'x':
							matrix.prependTranslation(p0, 0, 0);
							break;
						case 'y':
							matrix.prependTranslation(0, p0, 0);
							break;
						case 'z':
							matrix.prependTranslation(0, 0, p0);
							break;
						case 'rx':
							matrix.prependRotation(p0, Vector3D.X_AXIS);
							break;
						case 'ry':
							matrix.prependRotation(p0, Vector3D.Y_AXIS);
							break;
						case 'rz':
							matrix.prependRotation(p0, Vector3D.Z_AXIS);
							break;
						case 's':
							p1=(param.length < 2) ? p0 : Number(param[1]), p2=(param.length < 3) ? p1 : Number(param[2]);
							matrix.prependScale(p0, p1, p2);
							break;
						case 'm':
							if (param.length >= 9)
							{
								matrix.prepend(new Matrix3D(Vector.<Number>([Number(param[0]), Number(param[1]), Number(param[2]), 0, Number(param[3]), Number(param[4]), Number(param[5]), 0, Number(param[6]), Number(param[7]), Number(param[8]), 0, 0, 0, 0, 1])));
							}
							break;
					}
				}
				res=_rexOperate.exec(operation);
			}
			return matrix;
		}

		private function _exec(seq:SSRuleSequence):void
		{
			if (_depth < _maxDepth)
			{
				_depth++;
				if (seq.depth < seq.maxdepth)
				{
					seq.depth++;
					for each (var rc:SSRuleCaller in seq.callers)
						$s(rc, rc.operations.length - 1);
					--seq.depth;
				}
				else
				{
					if (seq.finalRuleName)
						$r(seq.finalRuleName);
				}
				--_depth;
			}
			function $s(rc:SSRuleCaller, index:int):void
			{
				var imax:int=rc.operations[index].repeat, mat:Matrix3D=rc.operations[index].matrix;
				_core.push();
				for (var i:int=0; i < imax; i++)
				{
					_core.mult(mat);
					if (index)
						$s(rc, index - 1);
					else
						$r(rc.ruleName);
				}
				_core.pop();
			}
			function $r(ruleName:String):void
			{
				var rule:SSRule=_rules[ruleName];
				if (rule.mesh)
				{
					if (++_objects == _maxObjects)
						_depth=int.MAX_VALUE;
					_core.project(rule.mesh);
					_mesh.put(rule.mesh);
				}
				else
				{
					_exec(rule.getSequence());
				}
			}
		}
	}
}