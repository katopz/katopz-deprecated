package open3d.materials
{
	import __AS3__.vec.Vector;
	
	import flash.display.GraphicsTrianglePath;
	import flash.display.IGraphicsData;
	
	/**
	 * Material
	 * @author katopz
	 */	
	public class Material
	{
		public var graphicsData:Vector.<IGraphicsData>;
		
		// referer to triangles
		public var triangles:GraphicsTrianglePath;
		
		public function Material() 
		{
			
		}
		
		public function update():void
		{
			
		}
	}
}