package open3d.materials
{
	import __AS3__.vec.Vector;
	
	import flash.display.BitmapData;
	import flash.display.GraphicsBitmapFill;
	import flash.display.IGraphicsData;
	import flash.geom.Matrix;

	/**
	 * ColorMaterial
	 * @author katopz
	 */	
	public class ColorMaterial extends Material
	{
		//private var _stroke:GraphicsStroke;
		private var _fill:GraphicsBitmapFill;
		
		private var _color:uint;
		private var _alpha:Number;
		
		public function ColorMaterial(color:uint=0xFFFFFF, alpha:Number = 1) 
		{
			_color = color;
			_alpha = alpha;
			
			//_stroke = new GraphicsStroke(1, false, "normal", "none", "round", 0, new GraphicsSolidFill(_color, _alpha));
			_fill = new GraphicsBitmapFill(new BitmapData(100,100,false,color), new Matrix(), false, true)
		}
		
		public function get color():uint
		{ 
			return _color;
		}

		public function set color(value:uint):void 
		{ 
			_color = value;
			update();
		}

		public function get alpha():Number 
		{ 
			return _alpha;
		}

		public function set alpha(value:Number):void 
		{ 
			_alpha = value;
			update();
		}
		
		override public function update():void
		{
			graphicsData = Vector.<IGraphicsData>([_fill, triangles]);
			graphicsData.fixed = true;
		}
	}
}