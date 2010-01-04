package de.nulldesign.nd3d.geom 
{
	import de.nulldesign.nd3d.geom.CubicBezier3D;
	import de.nulldesign.nd3d.geom.Vertex;	
	/**
	 * A 3-dimensional Catmullrom curve
	 * @author Lars Gerckens (lars@nulldesign.de)
	 */
	public class CatmullRomCurve3D 
	{

		private var curveVertices:Array;
		private var controlVertices:Array;
		private var cubicCurves:Array;
		private var SMOOTHNESS:Number;

		public function CatmullRomCurve3D() 
		{
			curveVertices = [];
		}

		/**
		 * add a new controlvertex to the curve
		 * @param new control vertex
		 */
		public function addCurveVertex(p:Vertex):void 
		{
			curveVertices.push(p);
		}

		/**
		 * calulates the resulting curve
		 * @param closed
		 * @param smoothness
		 */
		public function finalize(closed:Boolean = false, smoothness:Number = 0.5):void 
		{
			SMOOTHNESS = smoothness;
			
			if(closed) 
			{
				calculateClosedCurve();
			} 
			else 
			{
				calculateCurve();
			}
		}
		/**
		 * returns a vertex of the curve
		 * @param begin: 0, end: 1
		 * @return current vertex of the curve at t
		 */
		public function getCurveAt(t:Number):Vertex 
		{

			var curCurveNum:Number = Math.floor(t * cubicCurves.length);
			if(curCurveNum >= cubicCurves.length) curCurveNum -= 1;
			
			t = t * cubicCurves.length;		
			var curveT:Number = (t - curCurveNum);

			var curve:CubicBezier3D = cubicCurves[curCurveNum];
			return curve.getCurveAt(curveT);
		}

		private function calculateCurve():void 
		{
			
			controlVertices = [];
			cubicCurves = [];
			var numVertices:uint = curveVertices.length;
			//var numcrtlVertices:uint = numVertices * 2 - 2;

			var tx:Number;
			var ty:Number;
			var tz:Number;
			
			for(var i:uint = 0;i < curveVertices.length;++i) 
			{
				
				//first ctrlVertexVertex
				if(i == 0) 
				{
					tx = 0.5 * (curveVertices[1].x - curveVertices[0].x);
					ty = 0.5 * (curveVertices[1].y - curveVertices[0].y);
					tz = 0.5 * (curveVertices[1].z - curveVertices[0].z);
					
					controlVertices.push(new Vertex(curveVertices[0].x + SMOOTHNESS * tx, curveVertices[0].y + SMOOTHNESS * ty, curveVertices[0].z + SMOOTHNESS * tz));
				}
				
				//last controlVertexVertex
				if(i == numVertices - 1) 
				{
					tx = 0.5 * (curveVertices[numVertices - 1].x - curveVertices[numVertices - 2].x);
					ty = 0.5 * (curveVertices[numVertices - 1].y - curveVertices[numVertices - 2].y);
					tz = 0.5 * (curveVertices[numVertices - 1].z - curveVertices[numVertices - 2].z);
					
					controlVertices.push(new Vertex(curveVertices[numVertices - 1].x - SMOOTHNESS * tx, curveVertices[numVertices - 1].y - SMOOTHNESS * ty, curveVertices[numVertices - 1].z - SMOOTHNESS * tz));
				}
				
				//the other Vertices...
				if(i > 0 && i < numVertices - 1) 
				{
					tx = 0.5 * (curveVertices[i + 1].x - curveVertices[i - 1].x);
					ty = 0.5 * (curveVertices[i + 1].y - curveVertices[i - 1].y);
					tz = 0.5 * (curveVertices[i + 1].z - curveVertices[i - 1].z);
					
					//left
					controlVertices.push(new Vertex(curveVertices[i].x - SMOOTHNESS * tx, curveVertices[i].y - SMOOTHNESS * ty, curveVertices[i].z - SMOOTHNESS * tz));
					//right
					controlVertices.push(new Vertex(curveVertices[i].x + SMOOTHNESS * tx, curveVertices[i].y + SMOOTHNESS * ty, curveVertices[i].z + SMOOTHNESS * tz));
				}
			}

			for(i = 0;i < numVertices - 1; i++) 
			{
				cubicCurves.push(new CubicBezier3D(curveVertices[i], controlVertices[i * 2], controlVertices[i * 2 + 1], curveVertices[i + 1]));
			}
		}

		private function calculateClosedCurve():void 
		{
			
			controlVertices = [];
			cubicCurves = [];
			var numVertices:uint = curveVertices.length;
			//var numcrtlVertices:uint = numVertices * 2;

			var tx:Number;
			var ty:Number;
			var tz:Number;
			
			for(var i:uint = 0;i < curveVertices.length; ++i) 
			{
				//first ctrlVertexVertex
				if(i == 0) 
				{
					tx = 0.5 * (curveVertices[1].x - curveVertices[numVertices - 1].x);
					ty = 0.5 * (curveVertices[1].y - curveVertices[numVertices - 1].y);
					tz = 0.5 * (curveVertices[1].z - curveVertices[numVertices - 1].z);
					//left
					controlVertices.push(new Vertex(curveVertices[i].x - SMOOTHNESS * tx, curveVertices[i].y - SMOOTHNESS * ty, curveVertices[i].z - SMOOTHNESS * tz));
					//right
					controlVertices.push(new Vertex(curveVertices[i].x + SMOOTHNESS * tx, curveVertices[i].y + SMOOTHNESS * ty, curveVertices[i].z + SMOOTHNESS * tz));
				}
				//last controlVertexVertex
				if(i == numVertices - 1) 
				{
					tx = 0.5 * (curveVertices[0].x - curveVertices[i - 1].x);
					ty = 0.5 * (curveVertices[0].y - curveVertices[i - 1].y);
					tz = 0.5 * (curveVertices[0].z - curveVertices[i - 1].z);
					//left
					controlVertices.push(new Vertex(curveVertices[i].x - SMOOTHNESS * tx, curveVertices[i].y - SMOOTHNESS * ty, curveVertices[i].z - SMOOTHNESS * tz));
					//right
					controlVertices.push(new Vertex(curveVertices[i].x + SMOOTHNESS * tx, curveVertices[i].y + SMOOTHNESS * ty, curveVertices[i].z + SMOOTHNESS * tz));
				}
				//the other Vertices...
				if(i > 0 && i < numVertices - 1) 
				{
					tx = 0.5 * (curveVertices[i + 1].x - curveVertices[i - 1].x);
					ty = 0.5 * (curveVertices[i + 1].y - curveVertices[i - 1].y);
					tz = 0.5 * (curveVertices[i + 1].z - curveVertices[i - 1].z);
					//left
					controlVertices.push(new Vertex(curveVertices[i].x - SMOOTHNESS * tx, curveVertices[i].y - SMOOTHNESS * ty, curveVertices[i].z - SMOOTHNESS * tz));
					//right
					controlVertices.push(new Vertex(curveVertices[i].x + SMOOTHNESS * tx, curveVertices[i].y + SMOOTHNESS * ty, curveVertices[i].z + SMOOTHNESS * tz));
				}
			}
			
			for(i = 0;i < numVertices - 1; i++) 
			{
				cubicCurves.push(new CubicBezier3D(curveVertices[i], controlVertices[i * 2 + 1], controlVertices[i * 2 + 2], curveVertices[i + 1]));
			}
			cubicCurves.push(new CubicBezier3D(curveVertices[numVertices - 1], controlVertices[controlVertices.length - 1], controlVertices[0], curveVertices[0]));
		}
	}
}