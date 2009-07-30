package open3d.materials.shaders {

	import flash.geom.Matrix3D;
	/**
	 * @author kris@neuroproductions.be
	 */
	public interface IShader 
	{
		function calculateNormals(verticesIn:Vector.<Number>,indices:Vector.<int>):void
		function getUVData(m:Matrix3D):Vector.<Number>
	}
}
