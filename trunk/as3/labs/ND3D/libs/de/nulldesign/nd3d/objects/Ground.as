package de.nulldesign.nd3d.objects 
{
	import de.nulldesign.nd3d.geom.UV;
	import de.nulldesign.nd3d.geom.Vertex;
	import de.nulldesign.nd3d.material.Material;	
	
	/**
	 * A plane that lies on the ground ;)
	 */
	public class Ground extends Mesh 
	{
		public function Ground(width:Number, height:Number, stepsX:uint, stepsY:uint, material:Material) 
		{
			super();
			createPlane(width, height, stepsX, stepsY, material);
		}

		private function createPlane(width:Number, height:Number, stepsX:uint, stepsY:uint, material:Material):void
		{
			var i:Number;
			var j:Number;
			var ar:Array = [];
			
			width *= 2;
			height *= 2;
			
			for(i = 0;i <= stepsX; i++)
			{
				ar.push([]);
				for(j = 0;j <= stepsX; j++)
				{
					var x:Number = i * (width / stepsX) - width * .5;
					var y:Number = j * (height / stepsY) - height * .5;
					ar[i].push(new Vertex(x, 0, y));
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
						var uv1:Array = [new UV((i - 1) * xscaling, 1 - ((j - 1) * yscaling)), 
										 new UV((i - 1) * xscaling, 1 - ((j) * yscaling)),
										 new UV((i) * xscaling, 1 - ((j) * yscaling))];
						
						var uv2:Array = [new UV((i - 1) * xscaling, 1 - ((j - 1) * yscaling)), 
										 new UV((i) * xscaling, 1 - ((j) * yscaling)),
										 new UV((i) * xscaling, 1 - ((j - 1) * yscaling))];

						addFace(ar[i - 1][j - 1], ar[i - 1][j], ar[i][j], material, uv1);
						addFace(ar[i - 1][j - 1], ar[i][j], ar[i][j - 1], material, uv2);
					}
				}
			}
			
			flipNormals();
		}
	}
}