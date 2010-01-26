package net.badimon.five3D.display
{
	import flash.geom.Vector3D;
	
	import net.badimon.five3D.materials.ClipMaterial;

	public class Clip2D extends Vector3D
	{
		public var material:ClipMaterial;
		
		public function Clip2D(x:Number, y:Number, z:Number, material:ClipMaterial, width:Number, height:Number)
		{
			super(x, y, z);
			this.material = material;
		}
	}
}