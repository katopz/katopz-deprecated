package open3d.materials
{
	import __AS3__.vec.Vector;

	import flash.display.*;
	import flash.display.BitmapData;
	import flash.display.GraphicsBitmapFill;
	import flash.display.IGraphicsData;

	/**
	 * BitmapMaterial : embed image as texture
	 * @author katopz
	 */
	public class BitmapMaterial extends Material
	{
		protected var _texture:BitmapData;
		protected var _graphicsBitmapFill:GraphicsBitmapFill;

		public function BitmapMaterial(bitmapData:BitmapData = null)
		{
			_texture = bitmapData ? bitmapData : new BitmapData(100, 100, false, 0x000000);
			_graphicsBitmapFill = new GraphicsBitmapFill(_texture, null, false, true);
		}

		public function get texture():BitmapData
		{
			return _texture;
		}

		public function set texture(value:BitmapData):void
		{
			_texture = value;
			_graphicsBitmapFill.bitmapData = value;
		}

		override public function update():void
		{
			graphicsData = Vector.<IGraphicsData>([_graphicsBitmapFill, triangles]);
			graphicsData.fixed = true;
			super.update();
		}
	}
}