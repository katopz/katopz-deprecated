package away3dlite.core.base
{
	import away3dlite.materials.ParticleMaterial;
	
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Vector3D;

	/**
	 * Particle
	 * @author katopz
	 */
	public final class Particle extends Vector3D
	{
		public var layer:Sprite;

		public var animated:Boolean = false;
		public var smooth:Boolean = false;
		public var screenZ:Number;
		public var next:Particle;

		// projected position
		private var _position:Vector3D;

		private var _matrix:Matrix;
		private var _center:Point;

		// TODO : particle material
		private var _bitmapDatas:Vector.<BitmapData>;
		private var _bitmapData:BitmapData;
		private var _bitmapData_width:Number;
		private var _bitmapData_height:Number;
		private var _bitmapIndex:int = 0;
		private var _bitmapLength:int = 0;
		private var _scale:Number = 1.0;

		public var material:ParticleMaterial;
		
		public function Particle(x:Number, y:Number, z:Number, material:ParticleMaterial, smooth:Boolean = false)
		{
			super(x, y, z);

			this.material = material;
			this.smooth = smooth;

			_bitmapDatas = material.frames;
			_bitmapLength = _bitmapDatas.length;

			if (_bitmapLength > 0)
				animated = true && material.animated;

			animate();

			_matrix = new Matrix();
			_center = new Point(_bitmapData.width * _scale / 2, _bitmapData.height * _scale / 2);
		}

		public function get position():Vector3D
		{
			return _position;
		}

		public function set position(position:Vector3D):void
		{
			// align center
			_center.x = _bitmapData_width * _scale * .5;
			_center.y = _bitmapData_height * _scale * .5;

			// position
			screenZ = position.w;
			_position = position.clone();
		}

		private function animate():void
		{
			// animate
			if (++_bitmapIndex >= _bitmapLength)
				_bitmapIndex = 0;
			_bitmapData = _bitmapDatas[int(_bitmapIndex)];

			// update
			_bitmapData_width = _bitmapData.width;
			_bitmapData_height = _bitmapData.height;
		}

		public function drawBitmapdata(_target:Sprite, _zoom:Number, _focus:Number):void
		{
			if (_target != layer)
			{
				if (layer)
					_target = layer;
				_target.graphics.lineStyle();
			}

			if (animated)
				animate();

			var _graphics:Graphics = _target.graphics;
			_scale = _zoom / (1 + screenZ / _focus);
			
			//if (!material.buffered)
			//{
				_matrix.a = _matrix.d = _scale;
				_matrix.tx = position.x - _center.x;
				_matrix.ty = position.y - _center.y;
				
				_graphics.beginBitmapFill(_bitmapData, _matrix, false, smooth);
				_graphics.drawRect(_matrix.tx, _matrix.ty, _center.x * 2, _center.y * 2);
			//}
			/*else
			{
				_scale = _scale<=0?0.1:_scale;
				_scale = _scale>material.maxScale?material.maxScale:_scale;
				
				var index:int = int(_scale*material.quality)-1;
				
				_bitmapData = material.scales[index];
				_matrix = material.matrixs[index];
				
				_bitmapData_width = _bitmapData.width;
				_bitmapData_height = _bitmapData.height;
				
				_matrix.a = _matrix.d = 1;
				_matrix.tx = position.x - _bitmapData_width * _scale * .5;
				_matrix.ty = position.y - _bitmapData_height * _scale * .5;
				
				_graphics.beginBitmapFill(_bitmapData, _matrix, false, smooth);
				_graphics.drawRect(_matrix.tx, _matrix.ty, _bitmapData_width, _bitmapData_height);
			}*/
		}
	}
}