package com.sleepydesign.utils
{
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class MatrixUtil
	{
		public static function rotateAroundInternalPoint(m:Matrix, x:Number, y:Number, angleDegrees:Number):void
		{
			var point:Point = new Point(x, y);
			point = m.transformPoint(point);
			m.tx -= point.x;
			m.ty -= point.y;
			m.rotate(angleDegrees * (Math.PI / 180));
			m.tx += point.x;
			m.ty += point.y;
		}

		public static function scaleAroundInternalPoint(objToScale:DisplayObject, regX:int, regY:int, scaleX:Number, scaleY:Number):void
		{
			if (!objToScale)
				return;

			var transformedVector:Point = new Point((regX - objToScale.x) * scaleX, (regY - objToScale.y) * scaleY);

			objToScale.x = regX - (transformedVector.x);
			objToScale.y = regY - (transformedVector.y);
			objToScale.scaleX = objToScale.scaleX * (scaleX);
			objToScale.scaleY = objToScale.scaleY * (scaleY);
		}

	/*
	   //http://code.google.com/p/lodgamebox/source/browse/trunk/com/lordofduct/util/LoDMatrixTransformer.as
	   public static function scaleAroundInternalPoint(mat:Matrix, x:Number, y:Number, sx:Number, sy:Number, respect:Boolean = true):void
	   {
	   var intPnt:Point = new Point(x,y);
	   var extPnt:Point = mat.transformPoint( intPnt );

	   if(respect)
	   {
	   mat.a *= sx;
	   mat.b *= sx;
	   mat.c *= sy;
	   mat.d *= sy;
	   } else {
	   mat.scale(sx,sy);
	   }

	   matchInternalPointWithExternal( mat, intPnt, extPnt );
	   }

	   public static function matchInternalPointWithExternal(mat:Matrix, interPnt:Point, extPnt:Point):void
	   {
	   var pntT:Point = mat.transformPoint(interPnt);
	   var dx:Number = extPnt.x - pntT.x;
	   var dy:Number = extPnt.y - pntT.y;
	   mat.tx += dx;
	   mat.ty += dy;
	   }
	 */
	}
}