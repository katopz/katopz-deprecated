package open3d.materials
{
	import __AS3__.vec.Vector;
	
	import flash.display.BitmapData;
	import flash.display.GraphicsBitmapFill;
	import flash.display.IGraphicsData;
	
	/**
	 * BitmapMaterial
	 * @author katopz
	 * 
	 */	
	public class BitmapMaterial extends Material
	{
		public function BitmapMaterial(bitmapData:BitmapData = null, smoothed:Boolean = false, color:uint=0xFFFFFF, alpha:Number = 1, doubleSided:Boolean = false) 
		{
			super(color, alpha);
			texture = bitmapData;
		}
		
		public function get texture():BitmapData 
		{ 
			return _texture; 
		}

		public function set texture(value:BitmapData):void
		{ 
			_texture = value;
			update();
		}
		
		override public function update():void
		{
			graphicsData = Vector.<IGraphicsData>([stroke, new GraphicsBitmapFill(_texture, null, false, true), triangles]);
		}  
	}
}