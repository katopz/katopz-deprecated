package open3d.materials
{
	import __AS3__.vec.Vector;
	
	import flash.display.BitmapData;
	import flash.display.GraphicsSolidFill;
	import flash.display.GraphicsStroke;
	import flash.display.GraphicsTrianglePath;
	import flash.display.IGraphicsData;
	
	/**
	 * Material : texture
	 * @author katopz
	 */	
	public class Material
	{
		public static const DEFAULT_MATERIAL:GraphicsStroke = new GraphicsStroke
		(
			1, false, "normal", "none", "round", 0, new GraphicsSolidFill(0xFF00FF)
		);
		
		protected var _color:uint = 0xffffff;
		protected var _alpha:Number = 1;
		protected var _texture:BitmapData;
		
		public var stroke:GraphicsStroke;
		public var graphicsData:Vector.<IGraphicsData>;
		
		// referer to triangles
		public var triangles:GraphicsTrianglePath;
		
		public function Material(color:uint=0x000000, alpha:Number = 1, doubleSided:Boolean = false) 
		{
			this.color = color;
			this.alpha = alpha;
			stroke = stroke?stroke:DEFAULT_MATERIAL;
			graphicsData = Vector.<IGraphicsData>([stroke, triangles]);
		}
		
		public function get color():uint
		{ 
			return _color;
		}

		public function set color(value:uint):void 
		{ 
			_color = value;
		}

		public function get alpha():Number 
		{ 
			return _alpha;
		}

		public function set alpha(value:Number):void 
		{ 
			_alpha = value;
		}
		
		public function update():void
		{
			// do it when dirty
		}
	}
}