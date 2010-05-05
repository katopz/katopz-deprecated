package com.cutecoma.playground.components
{
	
	import org.papervision3d.core.geom.Lines3D;
	import org.papervision3d.core.geom.renderables.Line3D;
	import org.papervision3d.core.geom.renderables.Vertex3D;
	import org.papervision3d.materials.special.LineMaterial;
	import org.papervision3d.objects.DisplayObject3D;
	
	public class Grid extends DisplayObject3D
	{
		private var gridLine	:Lines3D 
		
		public function Grid(size:Number=100, col:uint=10, row:uint=10, lineColor:Number=0xCCCCCC)
		{
			super("grid");
			
			var lineMaterial:LineMaterial = new LineMaterial(lineColor, 1)
			gridLine = new Lines3D(new LineMaterial(0x000000));
			
			var gridWidth	:Number = size * col;
			var gridHeight	:Number = size * row;
			
			//x
			for (var i:int = 0; i <= col; i++) 
			{
				gridLine.addLine(new Line3D(gridLine, lineMaterial, 1, 
				new Vertex3D( i*size-gridWidth*.5, 0, -gridHeight*.5), 
				new Vertex3D( i*size-gridWidth*.5, 0,  gridHeight*.5)));
			}
			
			//z
			for (var j:int = 0; j <= row; j++) 
			{
				gridLine.addLine(new Line3D(gridLine, lineMaterial, 1, 
				new Vertex3D( -gridHeight*.5, 0, j*size-gridHeight*.5), 
				new Vertex3D(  gridHeight*.5, 0, j*size-gridHeight*.5)));
			}
			
			addChild(gridLine);
		}
		
		override public function destroy():void
		{
			removeChild(gridLine);
			gridLine = null;
			
			super.destroy();
		}
	}
}