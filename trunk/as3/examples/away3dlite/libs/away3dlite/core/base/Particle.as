package away3dlite.core.base
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Utils3D;
	import flash.geom.Vector3D;

	public final class Particle extends Vector3D
	{
		public var repeat:Boolean = false;
		public var smooth:Boolean = false;
		
		public var original:Vector3D;
		private var _original:Vector3D;
		
		private var _matrix:Matrix;
		private var _center:Point;

		private var _bitmapDatas:Vector.<BitmapData>;
		private var _bitmapData:BitmapData;
		private var _bitmapIndex:int = 0;
		private var _bitmaplength:int = 0;

		private var _scale:Number = 1.0;

		//public var next:Particle;
		
		// by pass
		private var Utils3D_projectVector:Function = Utils3D.projectVector;

		public var index:int;

		public function Particle(i:int, x:Number, y:Number, z:Number, bitmapDatas:Vector.<BitmapData>)
		{
			super(x,y,z);
			
			index = i;
			
			_bitmapDatas = bitmapDatas;
			_bitmaplength = _bitmapDatas.length;
			_bitmapData = _bitmapDatas[_bitmapIndex];

			original = _original = new Vector3D(x, y, z);
			_matrix = new Matrix();
			_center = new Point(_bitmapData.width*_scale/2, _bitmapData.height*_scale/2);
		}
		
		public function render(_position:Vector3D, _screenZ:Number, zoom:Number, focus:Number):void
		{
			//var _position:Vector3D = Utils3D_projectVector(viewMatrix3D, _original);
			
			x = _position.x;
			y = _position.y;
			z = _position.z;
			w = _screenZ;

			_bitmapIndex = (_bitmapIndex + 1 == _bitmaplength) ? 0 : int(++_bitmapIndex);
			_bitmapData = _bitmapDatas[_bitmapIndex];
			
			_center.x = _bitmapData.width*_scale*.5;
			_center.y = _bitmapData.height*_scale*.5;
			
			_matrix.a = _matrix.d = _scale = zoom / (1 + w / focus);
			_matrix.tx = x - _center.x;
			_matrix.ty = y - _center.y;
		}

		public function drawBitmapdata(graphics:Graphics):void
		{
			graphics.beginBitmapFill(_bitmapData, _matrix, repeat, smooth);
			graphics.drawRect(_matrix.tx, _matrix.ty, _center.x*2, _center.y*2);
		}
	}
}