package open3d.objects
{
	import flash.display.*;
	import flash.geom.*;
	
	import open3d.materials.Material;
	
	/**
	 * Object3D
	 * @author katopz
	 */	
	public class Object3D extends Sprite
	{
		protected var triangles:GraphicsTrianglePath;
		protected var vin:Vector.<Number>;
		protected var vout:Vector.<Number>;
		
		public function Object3D():void 
		{
			vin = new Vector.<Number>();
			transform.matrix3D = new Matrix3D();
		}
		
		public function project(projectionMatrix3D:Matrix3D, matrix3D:Matrix3D):void
		{
			vout = new Vector.<Number>(vin.length, true);
			
			// local
			transform.matrix3D.transformVectors(vin, vout);
				
			// global
			matrix3D.transformVectors(vout, vout);

			// project
			Utils3D.projectVectors(projectionMatrix3D, vout, triangles.vertices, triangles.uvtData);
		}
		
		protected var _material:Material;
		public function set material(value:Material):void
		{
			_material = value?value: new Material();
			_material.triangles = triangles;
		}
		
		public function get material():Material
		{
			return _material;
		}
		
		public function get graphicsData():Vector.<IGraphicsData>
		{
			return _material.graphicsData;
		}
		
		public function set stroke(value:GraphicsStroke):void
		{
			_material.stroke = value;
		}
		
		public function get stroke():GraphicsStroke
		{
			return _material.stroke;
		}
	}
}