package away3dlite.core.base
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.Utils3D;
	import flash.geom.Vector3D;
	
	public final class Particle extends Vector3D
	{
		private var _matrix:Matrix;
		private var _original:Vector3D;
		
		private var _bitmapDatas:Vector.<BitmapData>;
		private var _bitmapData:BitmapData;
		private var _bitmapIndex:int = 0;
		private var _bitmaplength:int = 0;
		
		private var _scale: Number = 1.0;
		
		public var next: Particle;
		
		//private use
		private var Utils3D_projectVector:Function;
		
		public function Particle(x:Number, y:Number, z:Number, bitmapDatas:Vector.<BitmapData>)
		{
			_bitmapDatas = bitmapDatas;
			_bitmaplength = _bitmapDatas.length; 
			_bitmapData = _bitmapDatas[_bitmapIndex];
			
			_original = new Vector3D(x, y, z);
			_matrix = new Matrix();
			
			Utils3D_projectVector = Utils3D.projectVector;
		}
		
		public function render(parentSceneMatrix3D:Matrix3D, screenZ:Number, zoom:Number, focus:Number):void
		{
			var _position:Vector3D = Utils3D_projectVector(parentSceneMatrix3D, _original);
			
			x = int(_position.x);
			y = int(_position.y);
			z = int(_position.z);
			
			_matrix.a = _matrix.d = _scale = zoom / (1 + (screenZ+z) / focus);
			_matrix.tx = x;
			_matrix.ty = y;
			
			_bitmapIndex = (_bitmapIndex+1==_bitmaplength)?0:int(++_bitmapIndex);
			_bitmapData = _bitmapDatas[_bitmapIndex];
		}
		
		public function drawGraphic(graphics:Graphics):void
		{
			graphics.beginBitmapFill(_bitmapData, _matrix, true);
			graphics.drawRect(x, y, _bitmapData.width*_scale, _bitmapData.height*_scale);
		}
	}
}