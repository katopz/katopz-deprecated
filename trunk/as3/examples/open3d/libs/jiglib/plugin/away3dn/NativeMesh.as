package jiglib.plugin.away3dn
{
	import __AS3__.vec.Vector;
	
	import flash.geom.Matrix3D;
	
	import jiglib.math.JMatrix3D;
	import jiglib.plugin.ISkin3D;
	
	import open3d.objects.Object3D;

	/**
	 * @author bartekd
	 */
	public class NativeMesh implements ISkin3D
	{

		private var do3d:Object3D;

		public function NativeMesh(do3d:Object3D)
		{
			this.do3d = do3d;
		}

		public function get transform():JMatrix3D
		{
			var tr:JMatrix3D = new JMatrix3D();
			//var matrix3D:Matrix3D = do3d.transform.matrix3D;
			var rawData:Vector.<Number> = do3d.transform.matrix3D.rawData;

			tr.n11 = rawData[0];
			tr.n12 = rawData[1];
			tr.n13 = rawData[2];
			tr.n14 = rawData[3];
			tr.n21 = rawData[4];
			tr.n22 = rawData[5];
			tr.n23 = rawData[6];
			tr.n24 = rawData[7];
			tr.n31 = rawData[8];
			tr.n32 = rawData[9];
			tr.n33 = rawData[10];
			tr.n34 = rawData[11];
			tr.n41 = rawData[12];
			tr.n42 = rawData[13];
			tr.n43 = rawData[14];
			tr.n44 = rawData[15];

			return tr;
		}

		public function set transform(m:JMatrix3D):void
		{
			
			/*
			var tr:Matrix3D = new Matrix3D(Vector.<Number>([
				m.n11,
				m.n12,
				m.n13,
				m.n14,
				m.n21,
				m.n22,
				m.n23,
				m.n24,
				m.n31,
				m.n32,
				m.n33,
				m.n34,
				m.n41,
				m.n42,
				m.n43,
				m.n44
			]));
			
			do3d.transform.matrix3D = tr
			do3d.transform.matrix3D.appendTranslation(m.n14,m.n24,m.n34);
			*/
			
			var rawData:Vector.<Number> = do3d.transform.matrix3D.rawData;
			
			rawData[0] = m.n11;
			rawData[1] = m.n12;
			rawData[2] = m.n13;
			rawData[3] = m.n14;
			rawData[4] = m.n21;
			rawData[5] = m.n22;
			rawData[6] = m.n23;
			rawData[7] = m.n24;
			rawData[8] = m.n31;
			rawData[9] = m.n32;
			rawData[10] = m.n33;
			rawData[11] = m.n34;
			rawData[12] = m.n41;
			rawData[13] = m.n42;
			rawData[14] = m.n43;
			rawData[15] = m.n44;
			
			do3d.transform.matrix3D.rawData = rawData;
			
			// why i need this line???
			do3d.transform.matrix3D.appendTranslation(m.n14,m.n24,m.n34);
			
			//do3d.transform.matrix3D.appendScale(do3d.scaleX, do3d.scaleY, do3d.scaleZ);
			//var scale:Matrix3D = Matrix3D.scaleMatrix(do3d.scaleX, do3d.scaleY, do3d.scaleZ);
			//tr = Matrix3D.multiply(tr, scale);
			//tr.appendScale(do3d.scaleX, do3d.scaleY, do3d.scaleZ);
			//do3d.transform.matrix3D = tr;
			//do3d.updateMatrix();
			//trace(m);// do3d.x, do3d.y, do3d.z);
		}

		public function get mesh():Object3D
		{
			return do3d;
		}
	}
}
