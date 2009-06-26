package
{

	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.Utils3D;
	import flash.geom.Vector3D;

	import open3d.objects.Mesh;

	/**
	 * @author kris@neuroproductions.be
	 */
	[SWF(width='400', height = '300', backgroundColor = '#000000', frameRate = '30')]

	public class Triangle3D extends Mesh
	{
		public var color:uint
		//public var _vout:Vector.<Number> = new Vector.<Number>();
		//private var _vin:Vector.<Number>;
		public var uvts:Vector.<Number>;
		public var normal:Vector.<Number> = new Vector.<Number>(3, true);
		//public var screenZ:Number =0
		private var vecZ:Vector3D
		private var vecMidle:Vector3D
		private static var colors:Array

		public function Triangle3D()
		{
			color = Math.random() * uint.MAX_VALUE
			uvts = new Vector.<Number>()
			if (colors == null)
			{
				colors = getGradientArray(0xffa126, 0xDD0000, 0x000000)
			}
		}

		public function setPoints(p0:Vector3D, p1:Vector3D, p2:Vector3D):void
		{
			_vin = new Vector.<Number>()
			_vin.push(p0.x, p0.y, p0.z)
			_vin.push(p1.x, p1.y, p1.z)
			_vin.push(p2.x, p2.y, p2.z)
			calculateNormal(_vin)
			vecMidle = new Vector3D((p0.x + p1.x + p2.x) / 3, (p0.y + p1.y + p2.y) / 3, (p0.z + p1.z + p2.z) / 3)
			vecZ = new Vector3D(p0.x + p1.x + p2.x, p0.y + p1.y + p2.y, p0.z + p1.z + p2.z)
		}

		public function project2(m:Matrix3D, lightVecN:Vector3D, lightVec:Vector3D):void
		{
			vout = _vout = new Vector.<Number>(_vin.length, true);

			var zd:Number = normal[0] * lightVecN.x + normal[1] * lightVecN.y + normal[2] * lightVecN.z
			var dist:Number = Vector3D.distance(vecMidle, lightVec)
			zd += 1
			zd /= dist / 100
			if (zd < 0)
			{
				zd = 0;
			}

			var zAngle:int = zd * 255 //*0xff;
			if (zAngle >= colors.length)
				zAngle = colors.length - 1
			color = colors[zAngle];

			var vec:Vector3D = Utils3D.projectVector(m, vecZ)
			screenZ = vec.z
			Utils3D.projectVectors(m, _vin, _vout, uvts)
		}

		public function calculateNormal(tVector:Vector.<Number>):void
		{
			//normal = (p1-p2) x (p3-p2)

			var dif1:Vector.<Number> = new Vector.<Number>()
			var dif2:Vector.<Number> = new Vector.<Number>()

			dif1.push(tVector[0] - tVector[3], tVector[1] - tVector[4], tVector[2] - tVector[5])
			dif2.push(tVector[6] - tVector[3], tVector[7] - tVector[4], tVector[8] - tVector[5])
			//


			//A x B = <Ay*Bz - Az*By, Az*Bx - Ax*Bz, Ax*By - Ay*Bx>
			normal[0] = ((dif1[1] * dif2[2]) - (dif1[2] * dif2[1]))
			normal[1] = ((dif1[0] * dif2[2]) - (dif1[2] * dif2[0]))
			normal[2] = ((dif1[0] * dif2[1]) - (dif1[1] * dif2[0]))
			var v:Vector3D = new Vector3D(normal[0], normal[1], normal[2])

			var distance:Number = Vector3D.distance(v, new Vector3D())
			normal[0] = (normal[0] / distance)
			normal[1] = (normal[1] / distance) * -1
			normal[2] = (normal[2] / distance)



		}

		public function getGradientArray(lightColor:int, materialColor:int, shadowColor:int):Array
		{
			var array:Array = new Array();
			var bmd:BitmapData = new BitmapData(510, 1, false, 0);
			var s:Sprite = new Sprite();
			var m:Matrix = new Matrix();
			m.createGradientBox(510, 1, 0, 0, 0);
			s.graphics.beginGradientFill(GradientType.LINEAR, [lightColor, materialColor, shadowColor], [1, 1, 1], [0, 127, 255], m);
			s.graphics.drawRect(0, 0, 510, 1);
			s.graphics.endFill();
			bmd.draw(s);

			var i:int = 510;
			while (i--)
			{
				array.push(bmd.getPixel(i, 0));
			}

			return array;
		}
	}
}