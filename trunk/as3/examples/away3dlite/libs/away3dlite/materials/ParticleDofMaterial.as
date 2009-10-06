package away3dlite.materials
{
	import flash.display.*;
	import flash.events.*;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * Base particle dof material class.
	 */
	public class ParticleDofMaterial
	{
		private var _currentFrame		: int = 0;
		private var _totalFrames		: int = 0;
		private var _dofLevelMultiplier	: Number;
		private var _dofBlurQuality		: int;
		
		public var frames				: Vector.<BitmapData>;
		public var dof					: Vector.<BitmapData>;
		public var quality				: int;
		public var dofLevel				: int;

		/**
		 * Creates a new <code>ParticleDofMaterial</code> object.
		 * Depth of field based on X levels
		 */
		public function ParticleDofMaterial(dofLevel:int = 5, dofLevelMultiplier:Number = 2 , dofBlurQuality:int = 1)
		{
			this.dofLevel = dofLevel;
			this._dofLevelMultiplier  = dofLevelMultiplier;
			this._dofBlurQuality = dofBlurQuality;
		}
		
		// TODO add MovieClip
		public function addFrame(bitmapData:BitmapData, smooth:Boolean = false):void
		{
			if (!frames)
				frames = new Vector.<BitmapData>();

			frames.fixed = false;
			frames.push(bitmapData);
			frames.fixed = true;
			
			_totalFrames = frames.length;
			
			dof = new Vector.<BitmapData>();
			dof.fixed = false;
			
			//storing
			var _bitmapData:BitmapData;

			// making dof levels			
			for (var i:int = 0; i < dofLevel; i++)
			{
				_bitmapData = new BitmapData(bitmapData.width,bitmapData.height, true, 0x00);
				_bitmapData.draw(bitmapData, null, null, null, new Rectangle(0, 0, _bitmapData.width, _bitmapData.height), smooth);
				_bitmapData.applyFilter(_bitmapData,_bitmapData.rect,new Point(0,0), new BlurFilter(dofLevel*dofLevelMultiplier,dofLevel*dofLevelMultiplier,dofBlurQuality));

				dof.push(_bitmapData);
			}
			
			dof.fixed = true;
		}
	}
}