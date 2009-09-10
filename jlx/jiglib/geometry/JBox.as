package jiglib.geometry
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import jiglib.data.SpanData;
	import jiglib.math.*;
	import jiglib.physics.PhysicsState;
	import jiglib.physics.RigidBody;
	import jiglib.plugin.ISkin3D;

	/**
	 * @author Muzer(muzerly@gmail.com)
	 * @link http://code.google.com/p/jiglibflash
	 */
	public class JBox extends RigidBody
	{
		private var _sideLengths:Vector3D;
		private var _points:Vector.<Vector3D>;
		private var _edges:Vector.<Object> = Vector.<Object>([
			{ind0: 0, ind1: 1}, {ind0: 3, ind1: 1}, {ind0: 2, ind1: 3},
			{ind0: 2, ind1: 0}, {ind0: 4, ind1: 5}, {ind0: 5, ind1: 7},
			{ind0: 6, ind1: 7}, {ind0: 4, ind1: 6}, {ind0: 7, ind1: 1},
			{ind0: 5, ind1: 3}, {ind0: 4, ind1: 2}, {ind0: 6, ind1: 0}]);

		private var _face:Vector.<Object> = Vector.<Object>([
			[6, 7, 1, 0], [5, 4, 2, 3],
			[3, 1, 7, 5], [4, 6, 0, 2],
			[1, 3, 2, 0], [7, 6, 4, 5]]);

		public function JBox(skin:ISkin3D, width:Number, depth:Number, height:Number)
		{
			super(skin);
			_type = "BOX";

			_sideLengths = new Vector3D(width, height, depth);
			_boundingSphere = 0.5 * _sideLengths.length;
			initPoint();
			mass = 1;
		}

		private function initPoint():void
		{
			var halfSide:Vector3D = getHalfSideLengths();
			_points = new Vector.<Vector3D>();
			_points[0] = new Vector3D(halfSide.x, -halfSide.y, halfSide.z);
			_points[1] = new Vector3D(halfSide.x, halfSide.y, halfSide.z);
			_points[2] = new Vector3D(-halfSide.x, -halfSide.y, halfSide.z);
			_points[3] = new Vector3D(-halfSide.x, halfSide.y, halfSide.z);
			_points[4] = new Vector3D(-halfSide.x, -halfSide.y, -halfSide.z);
			_points[5] = new Vector3D(-halfSide.x, halfSide.y, -halfSide.z);
			_points[6] = new Vector3D(halfSide.x, -halfSide.y, -halfSide.z);
			_points[7] = new Vector3D(halfSide.x, halfSide.y, -halfSide.z);
		}

		public function set sideLengths(size:Vector3D):void
		{
			_sideLengths = size.clone();
			_boundingSphere = 0.5 * _sideLengths.length;
			initPoint();
			setInertia(getInertiaProperties(mass));
			setActive();
		}

		public function get sideLengths():Vector3D
		{
			return _sideLengths;
		}

		public function get edges():Vector.<Object>
		{
			return _edges;
		}

		public function getVolume():Number
		{
			return (_sideLengths.x * _sideLengths.y * _sideLengths.z);
		}

		public function getSurfaceArea():Number
		{
			return 2 * (_sideLengths.x * _sideLengths.y + _sideLengths.x * _sideLengths.z + _sideLengths.y * _sideLengths.z);
		}

		public function getHalfSideLengths():Vector3D
		{
			return JNumber3D.getScaleVector(_sideLengths, 0.5);
		}

		public function getSpan(axis:Vector3D):SpanData
		{
			var obj:SpanData = new SpanData();
			var s:Number = Math.abs(axis.dotProduct(currentState.orientation.getCols()[0])) * (0.5 * _sideLengths.x);
			var u:Number = Math.abs(axis.dotProduct(currentState.orientation.getCols()[1])) * (0.5 * _sideLengths.y);
			var d:Number = Math.abs(axis.dotProduct(currentState.orientation.getCols()[2])) * (0.5 * _sideLengths.z);
			var r:Number = s + u + d;
			var p:Number = currentState.position.dotProduct(axis);
			obj.min = p - r;
			obj.max = p + r;

			return obj;
		}
		
		/*
		public function getCornerPoints(state:PhysicsState):Vector.<Vector3D>
		{
			var vertex:Vector3D;
			var arr:Vector.<Vector3D> = new Vector.<Vector3D>();
			var transform:JMatrix3D = JMatrix3D.multiply(
				JMatrix3D.getTranslationMatrix(state.position.x, state.position.y, state.position.z),
				state.orientation);
			
			for each (var _point:Vector3D in _points)
			{
				vertex = new Vector3D(_point.x, _point.y, _point.z);
				JMatrix3D.multiplyVector(transform, vertex);
				arr.push(vertex);
			}
			
			arr.fixed = true;
			return arr;
		}
		*/
		
		/*
		public function getCornerPoints(state:PhysicsState):Vector.<Vector3D>
		{
			var vertex:Vector3D;
			var arr:Vector.<Vector3D> = new Vector.<Vector3D>();
			
			//JMatrix3D.getTranslationMatrix
			var _matrix3d:Matrix3D = new Matrix3D();
			_matrix3d.appendTranslation(state.position.x, state.position.y, state.position.z);
			
			//JMatrix3D.multiply
			var transform:Matrix3D = new Matrix3D();
			transform.append(state.__orientation);
			transform.append(_matrix3d);
			
			for each (var _point:Vector3D in _points)
			{
				//JMatrix3D.multiplyVector
				arr.push(transform.transformVector(new Vector3D(_point.x, _point.y, _point.z)));
			}

			arr.fixed = true;
			return arr;
		}
		*/
		
		public function getCornerPoints(state:PhysicsState):Vector.<Vector3D>
		{
			var vertex:Vector3D;
			var arr:Vector.<Vector3D> = new Vector.<Vector3D>();
			
			var transform:Matrix3D = JMatrix3D.getTranslationMatrix(state.position.x, state.position.y, state.position.z);
			
			transform = JMatrix3D.getAppendMatrix3D(state.__orientation, transform);
			
			for each (var _point:Vector3D in _points)
				arr.push(transform.transformVector(new Vector3D(_point.x, _point.y, _point.z)));

			arr.fixed = true;
			return arr;
		}
		
		public function getSqDistanceToPoint(state:PhysicsState, closestBoxPoint:Object, point:Vector3D):Number
		{
			closestBoxPoint.pos = point.subtract(state.position);
			JMatrix3D.multiplyVector(JMatrix3D.getJMatrix3D(JMatrix3D.getTransposeMatrix(state.__orientation)), closestBoxPoint.pos);

			var delta:Number = 0;
			var sqDistance:Number = 0;
			var halfSideLengths:Vector3D = getHalfSideLengths();

			if (closestBoxPoint.pos.x < -halfSideLengths.x)
			{
				delta = closestBoxPoint.pos.x + halfSideLengths.x;
				sqDistance += (delta * delta);
				closestBoxPoint.pos.x = -halfSideLengths.x;
			}
			else if (closestBoxPoint.pos.x > halfSideLengths.x)
			{
				delta = closestBoxPoint.pos.x - halfSideLengths.x;
				sqDistance += (delta * delta);
				closestBoxPoint.pos.x = halfSideLengths.x;
			}

			if (closestBoxPoint.pos.y < -halfSideLengths.y)
			{
				delta = closestBoxPoint.pos.y + halfSideLengths.y;
				sqDistance += (delta * delta);
				closestBoxPoint.pos.y = -halfSideLengths.y;
			}
			else if (closestBoxPoint.pos.y > halfSideLengths.y)
			{
				delta = closestBoxPoint.pos.y - halfSideLengths.y;
				sqDistance += (delta * delta);
				closestBoxPoint.pos.y = halfSideLengths.y;
			}

			if (closestBoxPoint.pos.z < -halfSideLengths.z)
			{
				delta = closestBoxPoint.pos.z + halfSideLengths.z;
				sqDistance += (delta * delta);
				closestBoxPoint.pos.z = -halfSideLengths.z;
			}
			else if (closestBoxPoint.pos.z > halfSideLengths.z)
			{
				delta = (closestBoxPoint.pos.z - halfSideLengths.z);
				sqDistance += (delta * delta);
				closestBoxPoint.pos.z = halfSideLengths.z;
			}
			JMatrix3D.getMultiplyVector(state.__orientation, closestBoxPoint.pos);
			closestBoxPoint.pos = state.position.add(closestBoxPoint.pos);
			return sqDistance;
		}

		public function getDistanceToPoint(state:PhysicsState, closestBoxPoint:Object, point:Vector3D):Number
		{
			return Math.sqrt(getSqDistanceToPoint(state, closestBoxPoint, point));
		}

		public function pointIntersect(pos:Vector3D):Boolean
		{
			var p:Vector3D = pos.subtract(currentState.position);
			var h:Vector3D = JNumber3D.getScaleVector(_sideLengths, 0.5);
			var dirVec:Vector3D;
			for (var dir:int; dir < 3; dir++)
			{
				dirVec = currentState.orientation.getCols()[dir].clone();
				dirVec.normalize();
				if (Math.abs(dirVec.dotProduct(p)) > JNumber3D.toArray(h)[dir] + JNumber3D.NUM_TINY)
				{
					return false;
				}
			}
			return true;
		}

		public function getSupportVertices(axis:Vector3D):Vector.<Vector3D>
		{
			var vertices:Vector.<Vector3D> = new Vector.<Vector3D>();
			var d:Vector.<uint> = new Vector.<uint>(3, true);
			var H:Vector3D;
			var temp:Vector.<Vector3D> = Vector.<Vector3D>(currentState.orientation.getCols());
			temp[0].normalize();
			temp[1].normalize();
			temp[2].normalize();
			for (var i:uint = 0; i < 3; i++)
			{
				d[i] = axis.dotProduct(temp[i]);
				if (Math.abs(d[i]) > 1 - 0.001)
				{
					var f:int = (d[i] < 0) ? (i * 2) : (i * 2) + 1;
					for (var j:int = 0; j < 4; j++)
					{
						H = _points[_face[f][j]];
						var _vj:Vector3D = vertices[j] = currentState.position.clone();
						_vj = _vj.add(JNumber3D.getScaleVector(temp[0], H.x));
						_vj = _vj.add(JNumber3D.getScaleVector(temp[1], H.y));
						_vj = _vj.add(JNumber3D.getScaleVector(temp[2], H.z));
					}
					return vertices;
				}
			}

			for (i = 0; i < 3; i++)
			{
				if (Math.abs(d[i]) < 0.005)
				{
					var k:int;
					var m:int = (i + 1) % 3;
					var n:int = (i + 2) % 3;

					H = currentState.position.clone();
					k = (d[m] > 0) ? -1 : 1;
					H = H.add(JNumber3D.getScaleVector(temp[m], k * JNumber3D.toArray(_sideLengths)[m] / 2));
					k = (d[n] > 0) ? -1 : 1;
					H = H.add(JNumber3D.getScaleVector(temp[n], k * JNumber3D.toArray(_sideLengths)[n] / 2));

					vertices[0] = H.add(JNumber3D.getScaleVector(temp[i], JNumber3D.toArray(_sideLengths)[i] / 2));
					vertices[1] = H.add(JNumber3D.getScaleVector(temp[i], -JNumber3D.toArray(_sideLengths)[i] / 2));
					return vertices;
				}
			}

			var _v0:Vector3D =vertices[0] = currentState.position.clone();
			k = (d[0] > 0) ? -1 : 1;
			vertices[0] = _v0.add(JNumber3D.getScaleVector(temp[0], k * _sideLengths.x / 2));
			k = (d[1] > 0) ? -1 : 1;
			vertices[0] = _v0.add(JNumber3D.getScaleVector(temp[1], k * _sideLengths.y / 2));
			k = (d[2] > 0) ? -1 : 1;
			vertices[0] = _v0.add(JNumber3D.getScaleVector(temp[2], k * _sideLengths.z / 2));
			return vertices;
		}

		override public function segmentIntersect(out:Object, seg:JSegment, state:PhysicsState):Boolean
		{
			out.fracOut = 0;
			out.posOut = new Vector3D();
			out.normalOut = new Vector3D();

			var frac:Number = JNumber3D.NUM_HUGE;
			var min:Number = -JNumber3D.NUM_HUGE;
			var max:Number = JNumber3D.NUM_HUGE;
			var dirMin:Number = 0;
			var dirMax:Number = 0;
			var dir:Number = 0;
			var p:Vector3D = state.position.subtract(seg.origin);
			var h:Vector3D = JNumber3D.getScaleVector(_sideLengths, 0.5);

			//var tempV:Vector3D;
			var e:Number;
			var f:Number;
			var t:Number;
			var t1:Number;
			var t2:Number;
			for (dir = 0; dir < 3; dir++)
			{
				e = state.orientation.getCols()[dir].dotProduct(p);
				f = state.orientation.getCols()[dir].dotProduct(seg.delta);
				if (Math.abs(f) > JNumber3D.NUM_TINY)
				{
					t1 = (e + JNumber3D.toArray(h)[dir]) / f;
					t2 = (e - JNumber3D.toArray(h)[dir]) / f;
					if (t1 > t2)
					{
						t = t1;
						t1 = t2;
						t2 = t;
					}
					if (t1 > min)
					{
						min = t1;
						dirMin = dir;
					}
					if (t2 < max)
					{
						max = t2;
						dirMax = dir;
					}
					if (min > max)
						return false;
					if (max < 0)
						return false;
				}
				else if (-e - JNumber3D.toArray(h)[dir] > 0 || -e + JNumber3D.toArray(h)[dir] < 0)
				{
					return false;
				}
			}

			if (min > 0)
			{
				dir = dirMin;
				frac = min;
			}
			else
			{
				dir = dirMax;
				frac = max;
			}
			if (frac < 0)
				frac = 0;
			if (frac > 1)
				frac = 1;
			if (frac > 1 - JNumber3D.NUM_TINY)
			{
				return false;
			}
			out.fracOut = frac;
			out.posOut = seg.getPoint(frac);
			if (state.orientation.getCols()[dir].dotProduct(seg.delta) < 0)
			{
				out.normalOut = JNumber3D.getScaleVector(state.orientation.getCols()[dir], -1);
			}
			else
			{
				out.normalOut = state.orientation.getCols()[dir];
			}
			out.normalOut.normalize();
			return true;
		}

		override public function getInertiaProperties(m:Number):JMatrix3D
		{
			var inertiaTensor:JMatrix3D = new JMatrix3D();
			inertiaTensor.n11 = (m / 12) * (_sideLengths.y * _sideLengths.y + _sideLengths.z * _sideLengths.z);
			inertiaTensor.n22 = (m / 12) * (_sideLengths.x * _sideLengths.x + _sideLengths.z * _sideLengths.z);
			inertiaTensor.n33 = (m / 12) * (_sideLengths.x * _sideLengths.x + _sideLengths.y * _sideLengths.y);
			return inertiaTensor;
		}
	}
}
