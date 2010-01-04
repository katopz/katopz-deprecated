package de.nulldesign.nd3d.material 
{
	/**
	 * WireMaterial, used to render a 3D object as a wireframe w or w/o a fill
	 * @author Lars Gerckens (lars@nulldesign.de)
	 */
	public class WireMaterial extends Material 
	{
		public var fillColor:Number;
		public var fillAlpha:Number;

		public function WireMaterial(lineColor:Number = 0x00FF00, alpha:Number = 1, doubleSided:Boolean = false, fillColor:Number = 0, fillAlpha:Number = 0) 
		{
			super(lineColor, alpha, false, doubleSided, false);
			this.fillAlpha = fillAlpha;
			this.fillColor = fillColor;
		}
	}
}