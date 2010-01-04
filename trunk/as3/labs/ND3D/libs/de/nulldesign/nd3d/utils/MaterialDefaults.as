package de.nulldesign.nd3d.utils 
{
	import de.nulldesign.nd3d.material.BitmapMaterial;
	import de.nulldesign.nd3d.material.Material;

	import flash.display.BitmapData;

	/**
	 * ...
	 * @author philippe.elsass*gmail.com
	 */
	public class MaterialDefaults 
	{
		public var color:uint = 0xffffff;
		public var alpha:Number = 1;
		public var calculateLights:Boolean = true;
		public var smoothed:Boolean;
		public var doubleSided:Boolean = false;
		public var additive:Boolean = false;
		public var texture:BitmapData;

		public function MaterialDefaults(calculateLights:Boolean = false, smoothed:Boolean = false, doubleSided:Boolean = false, additive:Boolean = false) 
		{
			this.calculateLights = calculateLights;
			this.smoothed = smoothed;
			this.doubleSided = doubleSided;
			this.additive = additive;
		}

		public function getMaterial(texture:BitmapData = null):Material
		{
			if(texture)
			{
				return new BitmapMaterial(texture, smoothed, calculateLights, doubleSided, additive);
			}
			else
			{
				return new Material(color, alpha, calculateLights, doubleSided, additive);
			}
		}
	}
}