package
{
	import flash.display.GradientType;
	import flash.display.Shader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Matrix;

	[SWF(backgroundColor="#666666",frameRate="30",width="640",height="480")]
	/**
	 * http://www.boostworthy.com/blog/?p=247
	 * @author katopz
	 */
	public class ExPBAlphaMatteComposite extends Sprite
	{
		[Embed(source="../pbj/AlphaMatteComposite.pbj",mimeType="application/octet-stream")]
		private var AlphaMatteComposite:Class;

		public function ExPBAlphaMatteComposite()
		{
			// Create a container for storing the background
			// and foreground objects.
			//
			// Note: Runtime bitmap caching must be enabled for
			// the container in order to avoid alpha being
			// pre-multiplied when the shader is applied to
			// it's child objects.

			var container:Sprite = new Sprite();
			container.cacheAsBitmap = true;
			addChild(container);

			// Create a 300 x 300 box with a color fill.
			var containerBackground:Shape = new Shape();
			containerBackground.graphics.beginFill(0x008822, 1);
			containerBackground.graphics.drawRect(0, 0, 300, 300);
			containerBackground.graphics.endFill();
			container.addChildAt(containerBackground, 0);

			// Create a matrix for defining the gradient region.
			var gradientMatrix:Matrix = new Matrix();
			gradientMatrix.createGradientBox(300, 300, 0, 0, 0);

			// Create a 300 x 300 box with a gradient fill.
			var containerForeground:Sprite = new Sprite();
			containerForeground.graphics.beginGradientFill(GradientType.LINEAR, [0xFFFFFF, 0x000000], [1, 1], [0, 255], gradientMatrix);
			containerForeground.graphics.drawRect(0, 0, 300, 300);
			containerForeground.graphics.endFill();
			container.addChildAt(containerForeground, 1);

			// Create a new shader for represnting the 'AlphaMatteComposite' byte code.
			var shader:Shader = new Shader(new AlphaMatteComposite());
			// Apply the shader to the foreground object. By doing this, the foreground
			// object will automatically be used as the source input and the background
			// object will automatically be used as the alphaMatte input.
			containerForeground.blendShader = shader;
		}
	}
}