package away3dlite.materials
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	/**
	 * Base particle material class.
	 */
	public class ParticleMaterial
	{
		public var frames:Vector.<BitmapData>;
		public var animated:Boolean;
		
		//public var scales:Vector.<BitmapData>;
		//public var matrixs:Vector.<Matrix>;
		//public var buffered:Boolean;
		//public var maxScale:int;
		//public var quality:int;

		/**
		 * Creates a new <code>ParticleMaterial</code> object.
		 */
		public function ParticleMaterial(animated:Boolean = false)//, buffered:Boolean = false)
		{
			this.animated = animated;
			//this.buffered = buffered;
		}

		public function addFrame(bitmapData:BitmapData):void//, maxScale:int = 2, quality:int = 10, smooth:Boolean = false):void
		{
			//this.maxScale = maxScale = (maxScale < 1)?1:maxScale;
			//this.quality = quality = (quality < 1)?1:quality;
			
			
			if (!frames)
				frames = new Vector.<BitmapData>();

			frames.fixed = false;
			frames.push(bitmapData);
			frames.fixed = true;

			// scale buffer
			/*
			if (buffered)
			{
				if (!scales)
				{
					scales = new Vector.<BitmapData>(maxScale*quality, true);
					matrixs = new Vector.<Matrix>(maxScale*quality, true);
				}

				//bufferring
				var _bitmapData:BitmapData;
				var _matrix:Matrix = new Matrix();
				var _scale:Number;
				
				var j:int=0;
				for (var i:int = 0; i < maxScale*quality; i++)
				{
					_matrix.a = _matrix.d = _scale = (i/quality>0)?(i/quality):0.1;
					
					_bitmapData = new BitmapData(bitmapData.width * _scale, bitmapData.height * _scale, true, 0x000000)
					_bitmapData.draw(bitmapData, _matrix, null, null, new Rectangle(0, 0, _bitmapData.width, _bitmapData.height), smooth);
					scales[j] = _bitmapData;
					matrixs[j] = _matrix.clone();
					j++;
				}
			}
			*/
		}
	}
}