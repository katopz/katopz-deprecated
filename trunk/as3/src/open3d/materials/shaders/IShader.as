package open3d.materials.shaders {

	import flash.geom.Matrix3D;
	/**
	 * @author kris
	 */
	public interface IShader 
	{
		function calculateNormals(_vout:Vector.<Number>,indices:Vector.<int>):void
		function getUVData(m:Matrix3D):Vector.<Number>
	}
}
