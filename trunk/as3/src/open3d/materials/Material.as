package open3d.materials
{
	import flash.display.GraphicsSolidFill;
	import flash.display.GraphicsStroke;
	import flash.display.GraphicsTrianglePath;
	import flash.display.IGraphicsData;
	
	/**
	 * Material
	 * @author katopz
	 */	
	public class Material
	{
		public const DEBUG_STROKE:GraphicsStroke = new GraphicsStroke
		(
			1, false, "normal", "none", "round", 0, new GraphicsSolidFill(0xFF00FF)
		);
		
		public var graphicsData:Vector.<IGraphicsData>;
		protected var _isDebug:Boolean = false;
		
		// referer to triangles
		public var triangles:GraphicsTrianglePath;
		
		public function Material() 
		{
			graphicsData = new Vector.<IGraphicsData>();
		}
		
		public function update():void
		{
			graphicsData.fixed = false;
			if(_isDebug)
			{
				graphicsData.unshift(DEBUG_STROKE);
			}else{
				var _index:int = graphicsData.indexOf(DEBUG_STROKE);
				if(_index>-1)
					graphicsData.splice(_index, 1);
			}
			graphicsData.fixed = true;
		}
		
		public function get isDebug():Boolean
		{
			return _isDebug;
		}
		
		public function set isDebug(value:Boolean):void
		{
			_isDebug = value;
			update();
		}
	}
}