package away3dlite.plugins
{
	import flash.geom.Matrix3D;

	import org.papervision3d.core.math.Matrix3D;
	import org.papervision3d.objects.DisplayObject3D;

	public class PV3D
	{
		public static function getTransformData(do3d:*):flash.geom.Matrix3D
		{
			var _camera:DisplayObject3D = new DisplayObject3D();
			_camera.x = do3d.x;
			_camera.y = do3d.y;
			_camera.z = do3d.z;

			_camera.rotationX = do3d.rotationX;
			_camera.rotationY = do3d.rotationY;
			_camera.rotationZ = do3d.rotationZ;

			_camera.updateTransform();

			return getTransform(_camera);
		}

		public static function getTransform(do3d:DisplayObject3D):flash.geom.Matrix3D
		{
			var _rawData:Vector.<Number> = new Vector.<Number>(16, true);

			_rawData[0] = do3d.transform.n11;
			_rawData[1] = -do3d.transform.n21;
			_rawData[2] = do3d.transform.n31;
			_rawData[3] = do3d.transform.n41;

			_rawData[4] = -do3d.transform.n12;
			_rawData[5] = do3d.transform.n22;
			_rawData[6] = -do3d.transform.n32;
			_rawData[7] = do3d.transform.n42;

			_rawData[8] = do3d.transform.n13;
			_rawData[9] = -do3d.transform.n23;
			_rawData[10] = do3d.transform.n33;
			_rawData[11] = do3d.transform.n43;

			_rawData[12] = do3d.transform.n14;
			_rawData[13] = -do3d.transform.n24;
			_rawData[14] = do3d.transform.n34;
			_rawData[15] = do3d.transform.n44;

			var tr:flash.geom.Matrix3D = new flash.geom.Matrix3D(_rawData);

			return tr;
		}

		public static function setTransform(do3d:DisplayObject3D, m:flash.geom.Matrix3D):void
		{
			var tr:org.papervision3d.core.math.Matrix3D = new org.papervision3d.core.math.Matrix3D();

			tr.n11 = m.rawData[0];
			tr.n21 = -m.rawData[1];
			tr.n31 = m.rawData[2];
			tr.n41 = m.rawData[3];

			tr.n12 = -m.rawData[4];
			tr.n22 = m.rawData[5];
			tr.n32 = -m.rawData[6];
			tr.n42 = m.rawData[7];

			tr.n13 = m.rawData[8];
			tr.n23 = -m.rawData[9];
			tr.n33 = m.rawData[10];
			tr.n43 = m.rawData[11];

			tr.n14 = m.rawData[12];
			tr.n24 = -m.rawData[13];
			tr.n34 = m.rawData[14];
			tr.n44 = m.rawData[15];

			var scale:org.papervision3d.core.math.Matrix3D = org.papervision3d.core.math.Matrix3D.scaleMatrix(do3d.scaleX, do3d.scaleY, do3d.scaleZ);
			tr = org.papervision3d.core.math.Matrix3D.multiply(tr, scale);
			do3d.transform = tr;
		}

		public static function setCamera(target_camera:*, src_camera:*):void
		{
			target_camera.focus = src_camera.focus; //100
			target_camera.zoom = src_camera.zoom; //10
		}
	}
}