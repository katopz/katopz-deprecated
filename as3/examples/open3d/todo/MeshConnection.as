package  
{
	
	/**
	 * ...
	 * Petri Leskinen, Finland, Espoo, 31th May 2009
	 * leskinen[dot]petri[at]luukku[dot]com
	 * 
	 */
	
	import MeshParticle;
	
	public class MeshConnection 
	{
		public var point1:MeshParticle;
		public var point2:MeshParticle;
		
		public var restDistance:Number;
		internal var tmp:Number;
		
		public function MeshConnection(p1:MeshParticle, p2:MeshParticle) 
		{
			point1 = p1;
			point2 = p2;
			restDistance = this.distance();
		}
		
		public function distance():Number {
			return Math.sqrt(
				(tmp = point1.x - point2.x) * tmp + 
				(tmp = point1.y - point2.y) * tmp +
				(tmp = point1.z - point2.z) * tmp +1e-10
				);
		}
		
		public function evaluate():void {
			
			var dx:Number = point2.x - point1.x,
				dy:Number = point2.y - point1.y,
				dz:Number = point2.z - point1.z;
				
			tmp = Math.sqrt(
				dx * dx + 
				dy * dy +
				dz * dz 
				) - restDistance;
			
			tmp *= point1.k;
			point1.ax += tmp * dx;
			point1.ay += tmp * dy;
			point1.az += tmp * dz;
			tmp *= -point2.k / point1.k;
			point2.ax += tmp * dx;
			point2.ay += tmp * dy;
			point2.az += tmp * dz;
		}
		
	}
	
}