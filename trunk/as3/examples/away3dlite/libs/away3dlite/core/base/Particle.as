package away3dlite.core.base
{
	import away3dlite.materials.ParticleDofMaterial;
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
		public var animated				: Boolean = false;
		public var smooth				: Boolean = false;
		private var _dof				: Boolean = false;

		public var screenZ				: Number;
		public var next					: Particle;

		public var layer				: Sprite;

		// projected position
		private var _position			: Vector3D;

		private var _matrix				: Matrix;
		private var _center				: Point;

		private var _bitmapDatas		: Vector.<BitmapData>;
		private var _bitmapDatasDof		: Vector.<Vector.<BitmapData>>;
		private var _bitmapData			: BitmapData;
		private var _bitmapData_width	: Number;
		private var _bitmapData_height	: Number;
		
		private var _bitmapIndex		: int = 0;
		private var _bitmapLength		: int = 0;
		
		private var _scale				: Number = 1;

		public var material				: ParticleMaterial;
		public var materialDof			: ParticleDofMaterial;
		private var startCameraZ		: Number;

		// TODO: split material and materialdof
		// Doflevel at function animated - startCameraZ a other way?
		public function Particle(x:Number, y:Number, z:Number, material:ParticleMaterial = null, materialDof:ParticleDofMaterial = null, smooth:Boolean = false, startCameraZ: Number = -1000)
		{
			super(x, y, z);
			this.smooth = smooth;
			
			this.startCameraZ = startCameraZ; // todo
			
			if (materialDof) {
				trace("material is dof");
				this.materialDof = materialDof;
				_bitmapDatasDof = materialDof.framesDof;
				_dof = true;
			}
			else {
				this.material = material;
				_bitmapDatas = material.frames;
			}


			if (_dof) {
				_bitmapData = _bitmapDatasDof[0][0];
				_bitmapLength = _bitmapDatasDof.length;
				trace("lenght frames / doflevel:", _bitmapLength, materialDof.dofLevel);
			}
			else {
				_bitmapData = _bitmapDatas[0];
				_bitmapLength = _bitmapDatas.length;
			}

			_bitmapIndex = 0;
			_bitmapData_width = _bitmapData.width;
			_bitmapData_height = _bitmapData.height;

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

			if (_dof) {

				// TODO:
				// need to improve this and do different sorts of dof effects like front to back etc.
				// problem: camera.z is changing from positive to negative
				var x:int = int( (screenZ + startCameraZ) / materialDof.dofRange);
				x = (x ^ (x >> 31)) - (x >> 31); // faster math.abs
				var dofLevelZ:int = x>materialDof.dofLevel-1 ? materialDof.dofLevel-1 : x;
				//trace("doflevel / screenZ / startCameraZ / dofrange: ", dofLevelZ, screenZ, startCameraZ, materialDof.dofRange); 
				_bitmapData = _bitmapDatasDof[int(_bitmapIndex)][dofLevelZ];
			}
			else {
				_bitmapData = _bitmapDatas[int(_bitmapIndex)];
			}

			// update
			_bitmapData_width = _bitmapData.width;
			_bitmapData_height = _bitmapData.height;
		}

		// TODO : copyPixels + bmp layer via core render for DOF
		// TODO : collect command and render with drawPath
		public function drawBitmapdata(_target:Sprite, _zoom:Number, _focus:Number):void
		{
			// draw to view or layer
			if (layer && _target != layer)
				_target = layer;

			// clear line
			var _graphics:Graphics = _target.graphics;
			_graphics.lineStyle();

			// animated?
			if (animated)
				animate();

			_scale = _zoom / (1 + screenZ / _focus);
			if (_dof) {
				_matrix.a = _matrix.d = _scale;
				_matrix.tx = position.x - _center.x;
				_matrix.ty = position.y - _center.y;
			}
			else if (!material.buffered)
			{
				// align center
				_matrix.a = _matrix.d = _scale;
				_matrix.tx = position.x - _center.x;
				_matrix.ty = position.y - _center.y;
			}
			else
			{
				// OB
				var _bufferScale:Number = _scale > material.maxScale ? material.maxScale : _scale;
				
				// move to bitmap sector
				var index:Number = Math.floor(_bitmapIndex*material.maxScale* material.quality);
				// move to scale sector
				index += _bufferScale*material.quality;
				
				index = Math.round(index-1);
				
				_bitmapData = material.scales[int(index)];
				_matrix = material.matrixs[int(index)];

				// update
				_bitmapData_width = _bitmapData.width;
				_bitmapData_height = _bitmapData.height;
				_matrix.a = _matrix.d = 1;
				
				// align center
				_center.x = _bitmapData_width * .5;
				_center.y = _bitmapData_height * .5;
				_matrix.tx = position.x - _center.x;
				_matrix.ty = position.y - _center.y;
			}
			
			// draw
			_graphics.beginBitmapFill(_bitmapData, _matrix, false, smooth);
			_graphics.drawRect(_matrix.tx, _matrix.ty, _center.x*2, _center.y*2);
		}
	}
}