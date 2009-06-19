package  
{
	
	/**
	 * ...
	 * Petri Leskinen, Finland, Espoo, 31th May 2009
	 * leskinen[dot]petri[at]luukku[dot]com
	 */
	
	import MeshParticle;

	public class MeshTriangle 
	{
		public var point0:MeshParticle;
		public var point1:MeshParticle;
		public var point2:MeshParticle;
		
		//	z's needed for sorting in depth
		public var z:Number;
		
		public function MeshTriangle(
			p0:MeshParticle, 
			p1:MeshParticle,
			p2:MeshParticle,
			_z:Number = 0.0) 
		{
			point0 = p0;
			point1 = p1;
			point2 = p2;
			
			z = _z;
		}
		
		// for graphics.drawTriangles()
		public function pushIndices(v:Vector.<int>):void {
			v.push(point0.id, point1.id, point2.id);
		}
		
		public function get id0():int {
			return point0.id;
		}
		public function get id1():int {
			return point1.id;
		}
		public function get id2():int {
			return point2.id;
		}
	}
	
}