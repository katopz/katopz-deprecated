package de.nulldesign.nd3d.objects 
{
	import de.nulldesign.nd3d.geom.UV;
	import de.nulldesign.nd3d.geom.Vertex;
	import de.nulldesign.nd3d.material.Material;	
	/**
	 * A plane
	 * @author Lars Gerckens (lars@nulldesign.de)
	 */
	public class Plane extends Mesh 
	{
		/**
		 * Constructor of class plane
		 * @param	width
		 * @param	height
		 * @param	stepsX
		 * @param	stepsY
		 * @param	material
		 */
		public function Plane(width:Number, height:Number, stepsX:Number, stepsY:Number, material:Material) 
		{
			super();
			createPlane(width, height, stepsX, stepsY, material);
		}

		protected function createPlane(width:Number, height:Number, stepsX:Number, stepsY:Number, material:Material):void
		{
			var i:Number;
			var j:Number;
			var ar:Array = [];
			
			width *= 2;
			height *= 2;
			
			for(i = 0;i <= stepsX; i++)
			{
				ar.push([]);
				for(j = 0;j <= stepsY; j++)
				{
					var x:Number = i * (width / stepsX) - width / 2;
					var y:Number = j * (height / stepsY) - height / 2;
					ar[i].push(new Vertex(x, y, 0));
				}
			}

			var xscaling:Number = 1 / stepsX;
			var yscaling:Number = 1 / stepsY;
			
			for(i = 0;i < ar.length; i++)
			{
				for(j = 0;j < ar[i].length; j++)
				{
					if(i > 0 && j > 0)
					{
						var uv1:Array = [new UV((i - 1) * xscaling, (j - 1) * yscaling), 
										 new UV((i - 1) * xscaling, (j) * yscaling),
										 new UV((i) * xscaling, (j) * yscaling)];
						
						var uv2:Array = [new UV((i - 1) * xscaling, (j - 1) * yscaling), 
										 new UV((i) * xscaling, (j) * yscaling),
										 new UV((i) * xscaling, (j - 1) * yscaling)];
										 
						addFace(ar[i - 1][j - 1], ar[i - 1][j], ar[i][j], material, uv1);
						addFace(ar[i - 1][j - 1], ar[i][j], ar[i][j - 1], material, uv2);
					}
				}
			}
		}
	}
}