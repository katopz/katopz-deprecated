package de.nulldesign.nd3d.material 
{
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * ...
	 * @author philippe.elsass*gmail.com
	 */
	public class ReflectBitmapMaterial extends BitmapMaterial
	{
		protected var reference:BitmapMaterial;
		protected var ratio:Number;
		protected var topAlpha:Number;
		protected var tempBmp:BitmapData;
		protected var gradient:Shape;
		protected var isReflectDirty:Boolean;

		/**
		 * Create a material reflection.
		 * @param	reference	Material to reflect
		 * @param	ratio	Height ratio of the reflection
		 * @param	topAlpha	Maximum alpha of the reflection
		 */
		public function ReflectBitmapMaterial(reference:BitmapMaterial, ratio:Number = 0.3, topAlpha:Number = 0.3) 
		{
			super(null, reference.smoothed, reference.calculateLights, reference.doubleSided, reference.additive);
			this.reference = reference;
			this.ratio = ratio;
			this.topAlpha = topAlpha;
			isReflectDirty = true;
		}

		public function updateReflect():void
		{
			isReflectDirty = true;
			update();
		}

		override public function update():void
		{
			if (isReflectDirty)
			{
				isReflectDirty = false;
				var bmp:BitmapData = reference.texture;
				if (!bmp) return;
				
				var w:int = bmp.width;
				var h:int = Math.round(bmp.height * ratio);
				
				if (!gradient) createGradient(w, h);
				if (!tempBmp) tempBmp = new BitmapData(w, h, true, 0);
				else tempBmp.fillRect(tempBmp.rect, 0);
				tempBmp.draw(gradient);
				tempBmp.copyPixels(bmp, new Rectangle(0, bmp.height - h, w, h), new Point(0, 0), tempBmp, new Point(0, 0));
				
				var revMat:Matrix = new Matrix();
				revMat.scale(1, -1);
				revMat.translate(0, h);
				if (!_texture) _texture = new BitmapData(w, h, true, 0);
				else _texture.fillRect(_texture.rect, 0);
				_texture.draw(tempBmp, revMat);
				isDirty = true;
			}
			// inherit color transforms
			super.update();
		}

		protected function createGradient(w:int, h:int):void
		{
			var gradMat:Matrix = new Matrix();
			gradMat.createGradientBox(w, h, Math.PI / 2);
			gradient = new Shape();
			gradient.graphics.beginGradientFill("linear", [0xffffff, 0xffffff], [0, topAlpha], [0, 255], gradMat);
			gradient.graphics.drawRect(0, 0, w, h);
			gradient.graphics.endFill();
		}

		override public function get texture():BitmapData 
		{
			if (isReflectDirty) update();
			return super.texture; 
		}
	}
}