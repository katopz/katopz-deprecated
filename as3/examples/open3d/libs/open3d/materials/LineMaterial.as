package open3d.materials
{
	import flash.display.GraphicsSolidFill;
	import flash.display.GraphicsStroke;
	import flash.display.IGraphicsData;

	/**
	 * LineMaterial
	 * @author katopz
	 */
	public class LineMaterial extends Material
	{
		public var stroke:GraphicsStroke;

		public function LineMaterial(color:uint = 0xFFFFFF, alpha:Number = 1)
		{
			stroke = new GraphicsStroke(1, false, "normal", "none", "round", 0, new GraphicsSolidFill(color));
		}

		override public function update():void
		{
			graphicsData = Vector.<IGraphicsData>([stroke, triangles]);
			graphicsData.fixed = true;
		}
	}
}