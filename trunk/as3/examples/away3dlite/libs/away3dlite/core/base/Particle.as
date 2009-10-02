package away3dlite.core.base
{
	import away3dlite.containers.Particles;
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
		public var group:Particles;
		
		public var animated:Boolean = false;
		public var repeat:Boolean = false;
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
		
		/*
		TODO : dof
		var x:int = int( (p.screenZ-1000)/50);
		x = (x ^ (x >> 31)) - (x >> 31); // math.abs optimizer
		dofLevel = x>6 ? 6 : x;
		*/
		
		public function Particle(x:Number, y:Number, z:Number, material:ParticleMaterial)
		{
			super(x,y,z);
			
			_bitmapDatas = material.frames;
			_bitmapLength = _bitmapDatas.length;
			
			if(_bitmapLength>0)
				animated = true && material.animated;
			
			animate();
			
			_matrix = new Matrix();
			_center = new Point(_bitmapData.width*_scale/2, _bitmapData.height*_scale/2);
		}
		
		public function get position():Vector3D
		{
			return _position;
		}
		
		public function set position(position:Vector3D):void
		{
			// align center
			_center.x = _bitmapData_width*_scale*.5;
			_center.y = _bitmapData_height*_scale*.5;
			
			// position
			screenZ = position.w;
			_position = position.clone();
		}
		
		private function animate():void
		{
			// animate
			if(++_bitmapIndex>=_bitmapLength)
				_bitmapIndex = 0;
			_bitmapData = _bitmapDatas[int(_bitmapIndex)];
			
			// update
			_bitmapData_width = _bitmapData.width;
			_bitmapData_height = _bitmapData.height;
		}
		
		public function drawBitmapdata(graphics:Graphics, scale:Number):void
		{
			if(animated)
				animate();
				
			_matrix.a = _matrix.d = _scale = scale;
			_matrix.tx = position.x - _center.x;
			_matrix.ty = position.y - _center.y;
			
			graphics.beginBitmapFill(_bitmapData, _matrix, repeat, smooth);
			graphics.drawRect(_matrix.tx, _matrix.ty, _center.x*2, _center.y*2);
		}
		
		public function get layer():Sprite
		{
			return group.layer;
		}
	}
}