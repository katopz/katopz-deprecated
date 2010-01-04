package de.nulldesign.nd3d.geom 
{
	import de.nulldesign.nd3d.geom.Vertex;		
	/**
	 * Mathematical representation of a cubic bezier curve used by CatmullRomCurve3D
	 * @author Lars Gerckens (lars@nulldesign.de)
	 */
	public class CubicBezier3D 
	{

		private var p0:Vertex;
		private var p1:Vertex;
		private var p2:Vertex;
		private var p3:Vertex;

		public function CubicBezier3D(p0:Vertex, p1:Vertex, p2:Vertex, p3:Vertex) 
		{
			this.p0 = p0;
			this.p1 = p1;
			this.p2 = p2;
			this.p3 = p3;
		}

		public function getCurveAt(t:Number):Vertex 
		{

			var x:Number = p0.x * (1 - t) * (1 - t) * (1 - t) + 3 * p1.x * t * (1 - t) * (1 - t) + 3 * p2.x * t * t * (1 - t) + p3.x * t * t * t;
			
			var y:Number = p0.y * (1 - t) * (1 - t) * (1 - t) + 3 * p1.y * t * (1 - t) * (1 - t) + 3 * p2.y * t * t * (1 - t) + p3.y * t * t * t;
							
			var z:Number = p0.z * (1 - t) * (1 - t) * (1 - t) + 3 * p1.z * t * (1 - t) * (1 - t) + 3 * p2.z * t * t * (1 - t) + p3.z * t * t * t;
							
			return new Vertex(x, y, z);
		}
	}
}