package com.si3d.geom
{
	import __AS3__.vec.Vector;

	import flash.display.*;
	import flash.geom.*;

	public class Face
	{
		public var index:int, i0:int, i1:int, i2:int, i3:int, gpi:int, mat:int, x:Number, y:Number, z:Number, normal:Vector3D = new Vector3D();;
		static private var _freeList:Vector.<Face>=new Vector.<Face>();

		static public function free(face:Face):void
		{
			_freeList.push(face);
		}

		static public function alloc(index:int, i0:int, i1:int, i2:int=0, i3:int=0, mat:int=0):Face
		{
			var f:Face=_freeList.pop() || new Face();
			f.index=index;
			f.i0=i0;
			f.i1=i1;
			f.i2=i2;
			f.i3=i3;
			f.gpi=0;
			f.mat=mat;
			return f;
		}
	}
}