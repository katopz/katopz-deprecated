package de.nulldesign.nd3d.geom 
{
	import de.nulldesign.nd3d.geom.Quaternion;		
	/**
	 * A Vertex, the basic element of a face
	 * @author Lars Gerckens (lars@nulldesign.de)
	 */
	public class Vertex 
	{

		public var x:Number;
		public var y:Number;
		public var z:Number;

		public var screenX:Number;
		public var screenY:Number;
		public var scale:Number;

		public var x3d:Number;
		public var y3d:Number;
		public var z3d:Number;

		public function Vertex(x:Number, y:Number, z:Number) 
		{
			this.x = x;
			this.y = y;
			this.z = z;
		}

		public function toString():String 
		{
			return "Vertex: " + x + "/" + y + "/" + z;
		}

		public function add(v:Vertex):void 
		{
			x += v.x;
			y += v.y;
			z += v.z;
		}

		public function sub(v:Vertex):void 
		{
			x -= v.x;
			y -= v.y;
			z -= v.z;
		}

		public function mult(n:Number):void 
		{
			x *= n;
			y *= n;
			z *= n;
		}

		public function dot(v:Vertex):Number 
		{
			return (x * v.x + y * v.y + v.z * z);
		}

		public function cross(v:Vertex):Vertex 
		{
            
			var tmpX:Number = (v.y * z) - (v.z * y);
			var tmpY:Number = (v.z * x) - (v.x * z);
			var tmpZ:Number = (v.x * y) - (v.y * x);
			
			return new Vertex(tmpX, tmpY, tmpZ);
		}

		public function get length():Number 
		{
			return Math.sqrt(x * x + y * y + z * z);
		}

		public function set length(len:Number):void 
		{
			var curLength:Number = length;
			x = len * (x / curLength);
			y = len * (y / curLength);
			z = len * (z / curLength);
		}

		public function normalize():void 
		{

			var len:Number = length;
			
			x /= len;
			y /= len;
			z /= len;
		}

		public static function getDirectionVertexFromAngles(angleX:Number, angleY:Number):Vertex 
		{
			var sx:Number = Math.sin(angleX);
			var cx:Number = Math.cos(angleX);
			var sy:Number = Math.sin(angleY);
			var cy:Number = Math.cos(angleY);

			var xPos:Number = sy * cx;
			var yPos:Number = sx;
			var zPos:Number = cy * cx;
			
			return new Vertex(xPos, yPos, zPos);
		}

		public function rotateAround(angleX:Number = 0, angleY:Number = 0):void 
		{
			var len:Number = length;
			
			var sx:Number = Math.sin(angleX);
			var cx:Number = Math.cos(angleX);
			var sy:Number = Math.sin(angleY);
			var cy:Number = Math.cos(angleY);

			x = len * sy * cx;
			y = len * -sx;
			z = len * cy * cx;
		}

		public function clone():Vertex 
		{
			return new Vertex(x, y, z);
		}

		/**
		 * rotates a vertex by a quaterion (experimental)
		 * @param rotation as quaterion
		 * @return new rotated vertex
		 */
		public function rotatePoint(q:Quaternion):Vertex 
		{
			var q1:Quaternion;
			var q2:Quaternion;
			var q3:Quaternion;
			
			q1 = q.copy();
			q1.invert();
			q2 = new Quaternion();
			q2.fromPoint(x, y, z);
			q3 = q.copy();
			q2.concat(q1);
			q3.concat(q2);

			return new Vertex(q3.x, q3.y, q3.z);
		}
	}
}
