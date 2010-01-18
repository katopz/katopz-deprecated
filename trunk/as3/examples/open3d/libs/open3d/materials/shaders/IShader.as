package open3d.materials.shaders {

	import flash.geom.Matrix3D;
	/**
	 * @author kris@neuroproductions.be
	 */
	public interface IShader 
	{
		function calculateNormals(verticesIn:Vector.<Number>,indices:Vector.<int>,uvtData:Vector.<Number> =null,vertexNormals:Vector.<Number> =null):void
		function getUVData(m:Matrix3D):Vector.<Number>
	}
}
