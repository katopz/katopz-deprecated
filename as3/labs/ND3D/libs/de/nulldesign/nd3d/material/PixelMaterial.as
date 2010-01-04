package de.nulldesign.nd3d.material 
{

	/**
	 * PixelMaterial. Instead of whole faces, only the vertices are drawn as dots
	 * @author Lars Gerckens (lars@nulldesign.de)
	 */
	public class PixelMaterial extends Material 
	{
		public var thickness:Number;

		public function PixelMaterial(color:Number = 0xFFFFFF, alpha:Number = 1, thickness:Number = 1) 
		{
			super(color, alpha, false, true, false);
			this.thickness = thickness;
		}
	}
}