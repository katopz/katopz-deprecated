package  
{
	
	/**
	 * ...
	 * Petri Leskinen, Finland, Espoo, 31th May 2009
	 * leskinen[dot]petri[at]luukku[dot]com
	 */
	
	
	import MeshConnection;
	
	public class MeshParticle extends Object
	{
		
		public var x:Number = 0.0;
		public var y:Number = 0.0;
		public var z:Number = 0.0;
		
		//	default position
		public var xOrig:Number = 0.0;
		public var yOrig:Number = 0.0;
		public var zOrig:Number = 0.0;
		
		//	velocity
		public var vx:Number = 0.0;
		public var vy:Number = 0.0;
		public var vz:Number = 0.0;
		
		//	acceleration
		public var ax:Number = 0.0;
		public var ay:Number = 0.0;
		public var az:Number = 0.0;
		
		// 	physics, the spring constant, small = tar / large values = very fluid
		public var k:Number = 8.0; 
		
		//	id's used to ease searches for this in an array
		public var id:int = -1;
		
		public var uvIndex:int = 0;
		public var u:Number = 0.0;
		public var v:Number = 0.0;
		
		//	list of points connected to this:
		public var connections:Vector.<MeshConnection>;
		
		//	this is only needed when subdividing the mesh
		public var midPointTo:Object;
		
		internal var tmp:Number;
		
		public function MeshParticle(_x:Number=0.0, _y:Number=0.0, _z:Number=0.0, _id:int=0, _uvIndex:int=0 ) 
		{
			//super();
			
			x = _x;
			y = _y;
			z = _z;
			
			xOrig = _x;
			yOrig = _y;
			zOrig = _z;
			
			id = _id;
			uvIndex = _uvIndex;
			connections = new Vector.<MeshConnection>(); // [];
			midPointTo = { };
			
		}
		
		
		public function connect(p:MeshParticle):Boolean {
			//	connects two points, creates a new connection between
			//	first checks that it is not defined already
			if (p != this) {
				var check:Boolean = true;
				for each (var c:MeshConnection in connections) {
					if (c.point1 == p || c.point2 == p) {
						check = false;
						break;
					}
				}
				if (check) {
					var conn:MeshConnection = new MeshConnection(this, p);
					connections.push(conn);
					p.connections.push(conn);
				}
				return check;
			}	else return false;
			
		}
		
		
		//	'renew' is called at start of each step of animation
		//	sets the accelerations towards the original position
		public function renew():void {
		
			var dx:Number = x - xOrig,
				dy:Number = y - yOrig,
				dz:Number = z - zOrig;
				
			tmp = -0.33*k*Math.sqrt(1e-10+ dx * dx + dy * dy + dz * dz);
			
			ax = tmp * dx;
			ay = tmp * dy;
			az = tmp * dz;
		}
		
		//	'step' updates the velocity and position of this
		public function step(dtime:Number = 0.04):void {
			// dtime = time interval ^1/FPS
			var dt:Number = dtime;
			//	changing speed Dv = a Dt
			//	and position Dx = v Dt
			x += dt*(vx += dt*ax);
			y += dt*(vy += dt*ay);
			z += dt*(vz += dt*az);
			
			tmp = 0.985; // factor that slows down the motion
			vx *= tmp;
			vy *= tmp;
			vz *= tmp;
		}
		
		
		
		public function get distanceSquared():Number {
			return x * x + y * y + z * z;
		}
		
		public function get distance():Number {
			return Math.sqrt(x * x + y * y + z * z);
		}
		
		public function distanceFromOrig():Number {
			return Math.sqrt(
				(tmp = x - xOrig) * tmp + 
				(tmp = y - yOrig) * tmp +
				(tmp = z - zOrig) * tmp 
				);
		}
			
		public function translate(dx:Number = 0.0, dy:Number = 0.0, dz:Number = 0.0):void {
			x += dx;
			y += dy;
			z += dz;
		}
		
		public function setOriginalPosition():void {
			xOrig =x;
			yOrig =y;
			zOrig =z;
		}
		
		public function midPoint(p:MeshParticle):MeshParticle {
			//	'midPointTo' is a list for checking that each midpoint is defined only once
			var poNew:MeshParticle= this.midPointTo[p.id] = p.midPointTo[this.id]  = 
				new MeshParticle(0.5 * (x + p.x), 0.5 * (y + p.y), 0.5 * (z + p.z));
			return poNew;
		}
		
		public function normalize(length:Number = 1.0):void {
			x *= (tmp = length/Math.sqrt(x*x +y*y +z*z)); 
			y *= tmp;
			z *= tmp;
		}
		
		//	it's needed for passing coordinate data to graphics.drawTriangles:
		public function pushVertices(v:Vector.<Number>):void {
			v.push(x, y, z);
		}
		

	}
	
}