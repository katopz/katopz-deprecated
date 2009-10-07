package away3dlite.materials
{
	import flash.display.*;
	import flash.events.*;
	import flash.filters.BlurFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * Base particle material class.
	 */
	public class ParticleMaterial
	{
		private var _currentFrame:int = 0;
		private var _totalFrames:int = 0;
		
		public var frames:Vector.<BitmapData>;
		
		public var scales:Vector.<BitmapData>;
		public var matrixs:Vector.<Matrix>;
		public var buffered:Boolean;
		public var maxScale:int;
		public var quality:int;

		/**
		 * Creates a new <code>ParticleMaterial</code> object.
		 */
		public function ParticleMaterial(buffered:Boolean = false)
		{
			this.buffered = buffered;
		}
		
		/*
		public function nextFrame():BitmapData
		{
			var _bitmapData:BitmapData;
			if (++_currentFrame >= _totalFrames)
				_currentFrame = 0;
			_bitmapData = frames[int(_currentFrame)];
			
			return _bitmapData;
		}
		*/
		
		// TODO add MovieClip
		public function addFrame(bitmapData:BitmapData, maxScale:int = 2, quality:int = 10, smooth:Boolean = false):void
		{
			this.maxScale = maxScale = (maxScale < 1)?1:maxScale;
			this.quality = quality = (quality < 1)?1:quality;
			
			if (!frames)
				frames = new Vector.<BitmapData>();

			frames.fixed = false;
			frames.push(bitmapData);
			frames.fixed = true;
			
			_totalFrames = frames.length;
			
			// scale buffer
			if (buffered)
			{
				if(!scales)
				{
					scales = new Vector.<BitmapData>();
					matrixs = new Vector.<Matrix>();
				}else{
					scales.fixed = false;
					matrixs.fixed = false;
				}

				//bufferring
				var _bitmapData:BitmapData;
				var _matrix:Matrix = new Matrix();
				var _scale:Number;
				var _point:Point = new Point(0,0);
				
				var j:int=0;
				for (var i:int = 0; i < maxScale*quality; i++)
				{
					_scale = i/quality;
					_matrix.a = _matrix.d = _scale = (_scale<=0)?(i+1)/quality:_scale;
					
					_matrix.tx = int(4*(maxScale-_scale));
					_matrix.ty = int(4*(maxScale-_scale));
					
					var _w:int = int(2*_matrix.tx+bitmapData.width * _scale);
					var _h:int = int(2*_matrix.ty+bitmapData.height * _scale);
					 
					_bitmapData = new BitmapData((_w<1)?1:_w, (_h<1)?1:_h, true, 0x000000);
					
					_bitmapData.draw(bitmapData, _matrix, null, null, new Rectangle(0, 0, _bitmapData.width, _bitmapData.height), smooth);
					
					_bitmapData.applyFilter(_bitmapData, _bitmapData.rect, _point, new BlurFilter(_matrix.tx, _matrix.ty, 1));
					
					scales.push(_bitmapData);
					matrixs.push(_matrix.clone());
					
					j++;
				}
				
				scales.fixed = true;
				matrixs.fixed = true;
			}
		}
	}
}