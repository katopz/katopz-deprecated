package de.nulldesign.nd3d.geom 
{
	/**
	 * Mathematical representation of a quaternion
	 * @author Lars Gerckens (lars@nulldesign.de)
	 */
	public class Quaternion 
	{

		public var x:Number;
		public var y:Number;
		public var z:Number;
		public var w:Number;

		public function Quaternion(a:Number = 0, b:Number = 0, c:Number = 0, d:Number = 1) 
		{
			init(a, b, c, d);
		}

		private function init(a:Number, b:Number, c:Number, d:Number):void 
		{
			x = a ? a : 0;
			y = b ? b : 0;
			z = c ? c : 0;
			w = d ? d : 1;
		}

		public function fromPoint(a:Number, b:Number, c:Number):void 
		{
			x = a;
			y = b;
			z = c;
			w = 0;
		}

		public function fromAxisAngle(a:Number, b:Number, c:Number, d:Number):void 
		{
			var ca:Number = Math.cos(d / 2); 
			var sa:Number = Math.sin(d / 2);
			var m:Number = Math.sqrt(a * a + b * b + c * c);
			x = a / m * sa;
			y = b / m * sa;
			z = c / m * sa;
			w = ca;
		}

		public function eulerToQuaternion(ax:Number, ay:Number, az:Number):void 
		{
			var sinZ:Number = Math.sin(az * 0.5);
			var cosZ:Number = Math.cos(az * 0.5);
			var sinY:Number = Math.sin(ay * 0.5);
			var cosY:Number = Math.cos(ay * 0.5);
			var sinX:Number = Math.sin(ax * 0.5);
			var cosX:Number = Math.cos(ax * 0.5);
			var cosYcosZ:Number = cosY * cosZ;
			var sinYsinZ:Number = sinY * sinZ;

			x = sinX * cosYcosZ - cosX * sinYsinZ;
			y = cosX * sinY * cosZ + sinX * cosY * sinZ;
			z = cosX * cosY * sinZ - sinX * sinY * cosZ;
			w = cosX * cosYcosZ + sinX * sinYsinZ;
		}

		public function normalize():void 
		{
			var l:Number = Math.sqrt(x * x + y * y + z * z + w * w);
			x = x / l;
			y = y / l;
			z = z / l;
			w = w / l;
		}

		public function concat(q:Quaternion):void 
		{
			var w1:Number = w; 
			var x1:Number = x; 
			var y1:Number = y; 
			var z1:Number = z;
			var w2:Number = q.w; 
			var x2:Number = q.x; 
			var y2:Number = q.y; 
			var z2:Number = q.z;
			w = w1 * w2 - x1 * x2 - y1 * y2 - z1 * z2;
			x = w1 * x2 + x1 * w2 + y1 * z2 - z1 * y2;
			y = w1 * y2 + y1 * w2 + z1 * x2 - x1 * z2;
			z = w1 * z2 + z1 * w2 + x1 * y2 - y1 * x2;
		}

		public function invert():void 
		{
			x = -x;
			y = -y;
			z = -z;
		}

		public function copy():Quaternion 
		{
			return new Quaternion(x, y, z, w);
		}
	}
}