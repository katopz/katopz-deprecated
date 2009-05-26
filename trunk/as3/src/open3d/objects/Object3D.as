package open3d.objects
{
	import __AS3__.vec.Vector;
	
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
		
		// public var faster than get/set view
		public var vin:Vector.<Number>;
		protected var _vin:Vector.<Number>;
		
		protected var vout:Vector.<Number>;
		protected var _material:Material;
		
		public function Object3D():void 
		{
			vin = _vin = new Vector.<Number>();
			transform.matrix3D = new Matrix3D();
		}
		
		/**
		 * must do this when vin is dirty before project or using vertices
		 */
		public function update():void
		{
			_vin.fixed = true;
			triangles.uvtData.fixed = true;
			triangles.indices.fixed = true;
		}
		
		public function project(projectionMatrix3D:Matrix3D, matrix3D:Matrix3D):void
		{
			vout = new Vector.<Number>(_vin.length, true);
			
			// local
			transform.matrix3D.transformVectors(_vin, vout);
				
			// global
			matrix3D.transformVectors(vout, vout);

			// project
			Utils3D.projectVectors(projectionMatrix3D, vout, triangles.vertices, triangles.uvtData);
		}
		
		public function set material(value:Material):void
		{
			_material = value?value: new Material();
			_material.triangles = triangles;
			_material.update();
		}
		
		public function get material():Material
		{
			return _material;
		}
		
		public function get graphicsData():Vector.<IGraphicsData>
		{
			return _material.graphicsData;
		}
		
		// TODO : more friendly use
		public function getVertices(index:int):Vector3D
		{
			return new Vector3D
			(
				_vin[3*index+0],
				_vin[3*index+1],
				_vin[3*index+2]
			);
		}
		
		// TODO : more friendly use
		public function setVertices(index:int, axis:String, value:Number):void
		{
			if(axis=="x"){
				_vin[3*index+0] = value;
			}else if(axis=="y"){
				_vin[3*index+1] = value;
			}else if(axis=="z"){
				_vin[3*index+2] = value;
			}
		}
	}
}