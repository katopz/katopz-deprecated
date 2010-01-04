package de.nulldesign.nd3d.objects 
{
	import de.nulldesign.nd3d.geom.Face;
	import de.nulldesign.nd3d.geom.Vertex;
	import de.nulldesign.nd3d.material.Material;
	import de.nulldesign.nd3d.objects.Object3D;	
	/**
	 * Sprite3D represents a sprite in the 3D world. The sprite can be a bitmap or a pixel
	 * @author Lars Gerckens (lars@nulldesign.de)
	 */
	public class Sprite3D extends Object3D 
	{
		public var material:Material;
		/**
		 * Constructor of class Sprite3D
		 * @param	BitmapMaterial or PixelMaterial
		 * @param	centerX
		 * @param	centerY
		 * @param	centerZ
		 */
		public function Sprite3D(mat:Material, centerX:Number = 0, centerY:Number = 0, centerZ:Number = 0) 
		{
			super();
			
			material = mat;
			material.isSprite = true;

			positionAsVertex.x = centerX;
			positionAsVertex.y = centerY;
			positionAsVertex.z = centerZ;
			
			var face:Face = new Face(this, positionAsVertex, positionAsVertex, positionAsVertex, mat);
			faceList = [face];
		}
	}
}
