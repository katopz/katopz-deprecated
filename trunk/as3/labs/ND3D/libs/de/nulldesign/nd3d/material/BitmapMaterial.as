package de.nulldesign.nd3d.material 
{
	import de.nulldesign.nd3d.utils.ColorUtil;

	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;

	/**
	 * BitmapMaterial, used to display textured 3d objects
	 * @author philippe.elsass*gmail.com
	 */
	public class BitmapMaterial extends Material
	{
		protected var transformedTexture:BitmapData;
		protected var _ct:ColorTransform;
		protected var isDirty:Boolean;
		
		/**
		 * Constructor of class BitmapMaterial
		 * @param	texture
		 * @param	whether the bitmap should be drawn smoothed or not
		 * @param	should lights be calculated for this texture
		 * @param	should this material be drawn on backfaces as well
		 * @param	use additive blending for this material
		 */
		public function BitmapMaterial(texture:BitmapData = null, smoothed:Boolean = false, calculateLights:Boolean = false, doubleSided:Boolean = false, additive:Boolean = false) 
		{
			super(0xffffff, 1, calculateLights, doubleSided, additive);
			this.texture = texture;
			this.smoothed = smoothed;
		}

		override public function clone():Material 
		{
			return new BitmapMaterial(texture, smoothed, calculateLights, doubleSided, additive);
		}

		// color-transform the bitmap
		public function update():void
		{
			if (!_texture) return;
			isDirty = false;
			
			if (_alpha == 1 && _color == 0xffffff && _ct == null) 
			{
				if (transformedTexture && transformedTexture != _texture) transformedTexture.dispose();
				transformedTexture = _texture;
				return;
			}
			
			if (!transformedTexture || transformedTexture == _texture)
			{
				transformedTexture = new BitmapData(_texture.width, _texture.height, true, 0);
			}
			else transformedTexture.fillRect(transformedTexture.rect, 0);
			
			var ct:ColorTransform = _ct || getDefaultTransform();
			transformedTexture.draw(_texture, new Matrix(), ct);
		}

		protected function getDefaultTransform():ColorTransform
		{
			var rgb:Object = ColorUtil.hex2rgb(color);
			return new ColorTransform(rgb.r / 0xff, rgb.g / 0xff, rgb.b / 0xff, _alpha);
		}

		override public function set color(value:uint):void 
		{
			if (_color == value) return;
			super.color = value;
			isDirty = true;
		}

		override public function set alpha(value:Number):void 
		{
			if (_alpha == value) return;
			super.alpha = value;
			isDirty = true;
		}

		override public function get texture():BitmapData 
		{
			if (isDirty) update();
			return transformedTexture; 
		}

		override public function set texture(value:BitmapData):void 
		{
			if (_texture == value) return;
			super.texture = value;
			isDirty = true;
		}

		public function get colorTransform():ColorTransform 
		{ 
			return _ct; 
		}

		public function set colorTransform(value:ColorTransform):void 
		{
			_ct = value;
			isDirty = true;
		}
	}
}