package customRenderer 
{
	import de.nulldesign.nd3d.geom.Vertex;
	import de.nulldesign.nd3d.material.PixelMaterial;
	import de.nulldesign.nd3d.renderer.TextureRenderer;
	import de.nulldesign.nd3d.utils.ColorUtil;
	import flash.display.Graphics;
	
	/**
	 * Quick'n'dirty custom renderer...
	 * @author Lars Gerckens (lars@nulldesign.de)
	 */
	public class MyPixelRenderer extends TextureRenderer
	{
		private var scaleMin:Number = 1000000;
		private var scaleMax:Number = -1000000;
		
		override public function renderPixel(gfx:Graphics, material:PixelMaterial, a:Vertex):void 
		{
			if(a.z3d < scaleMin) scaleMin = a.z3d;
			if(a.z3d > scaleMax) scaleMax = a.z3d;

			var scaleRange:Number = Math.abs(scaleMax - scaleMin);
			var factor:Number = 1 - ((a.z3d - scaleMin) / scaleRange);
			
			var beginColor:Number = 0x00FF00;
			var endColor:Number = 0xff3c00;
			var beginColObj:Object = ColorUtil.hex2rgb(beginColor);
			var endColObj:Object = ColorUtil.hex2rgb(endColor);
			var finalColObj:Object = {};

			finalColObj.r = beginColObj.r * (factor) + endColObj.r * (1 - factor);
			finalColObj.g = beginColObj.g * (factor) + endColObj.g * (1 - factor);
			finalColObj.b = beginColObj.b * (factor) + endColObj.b * (1 - factor);

			gfx.beginFill(0xFFFFFF, 0.2);
			gfx.drawCircle(a.screenX, a.screenY, material.thickness * a.scale + 5);
			gfx.endFill();
			
			gfx.beginFill(ColorUtil.rgb2hex(finalColObj.r, finalColObj.g, finalColObj.b), 1);
			gfx.drawCircle(a.screenX, a.screenY, material.thickness * a.scale);
			gfx.endFill();
		}
		
		public function resetMeasure():void
		{
			scaleMin = 1000000;
			scaleMax = -1000000;
		}
	}
	
}