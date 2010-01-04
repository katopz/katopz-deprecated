package de.nulldesign.nd3d.material 
{
	import flash.display.BitmapData;		
	/**
	 * LineMaterial
	 * @author Lars Gerckens (lars@nulldesign.de)
	 */
	public class LineMaterial extends Material 
	{
		public var thickness:uint;
		/**
		 * Constructor of class LineMaterial
		 * @param	color
		 * @param	alpha
		 * @param	thickness
		 * @param	use additive blending for this material
		 * @param	should lights be calculated for this material
		 */
		public function LineMaterial(color:uint = 0x000000, alpha:Number = 1, thickness:uint = 1, additive:Boolean = false, calculateLights:Boolean = false) 
		{
			super(color, alpha, calculateLights, false, additive);
			this.thickness = thickness;
		}
	}
}