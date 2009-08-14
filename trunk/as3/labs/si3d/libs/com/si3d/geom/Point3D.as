package com.si3d.geom
{
	import __AS3__.vec.Vector;

	import flash.display.*;
	import flash.geom.*;

	public class Point3D extends Vector3D
	{
		public var world:Vector3D;

		function Point3D(x:Number=0, y:Number=0, z:Number=0, w:Number=1)
		{
			super(x, y, z, w);
			world=clone();
		}
	}
}