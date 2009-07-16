package jiglib.plugin.away3dn
{
	import __AS3__.vec.Vector;

	import flash.geom.Matrix3D;

	import jiglib.math.JMatrix3D;
	import jiglib.plugin.ISkin3D;

	import open3d.objects.Object3D;

	/**
	 * TODO : we don't need need proxy if jiglib go f10 ;p
	 * @author katopz
	 */
	public class Away3DNMesh implements ISkin3D
	{
		private var do3d:Object3D;
		private var _matrix3D:Matrix3D;

		public var mesh:Object3D;

		public function Away3DNMesh(do3d:Object3D)
		{
			mesh = this.do3d = do3d;
			_matrix3D = do3d.transform.matrix3D;
		}

		public function get transform():JMatrix3D
		{
			var _rawData:Vector.<Number> = do3d.transform.matrix3D.rawData;
			var tr:JMatrix3D = new JMatrix3D([
			_rawData[0],
			_rawData[1],
			_rawData[2],
			_rawData[3],
			_rawData[4],
			_rawData[5],
			_rawData[6],
			_rawData[7],
			_rawData[8],
			_rawData[9],
			_rawData[10],
			_rawData[11],
			_rawData[12],
			_rawData[13],
			_rawData[14],
			_rawData[15]]);

			return tr;
		}

		public function set transform(m:JMatrix3D):void
		{
			var _rawData:Vector.<Number> = do3d.transform.matrix3D.rawData;
			_rawData[0] = m.n11;
			_rawData[1] = m.n21;
			_rawData[2] = m.n31;
			_rawData[3] = m.n41;
			_rawData[4] = m.n12;
			_rawData[5] = m.n22;
			_rawData[6] = m.n32;
			_rawData[7] = m.n42;
			_rawData[8] = m.n13;
			_rawData[9] = m.n23;
			_rawData[10] = m.n33;
			_rawData[11] = m.n43;
			_rawData[12] = m.n14;
			_rawData[13] = m.n24;
			_rawData[14] = m.n34;
			_rawData[15] = m.n44;
			
			_matrix3D.rawData = _rawData; 
		}
	}
}
