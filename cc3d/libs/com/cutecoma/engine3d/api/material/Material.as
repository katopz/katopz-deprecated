package com.cutecoma.engine3d.api.material
{
	import com.cutecoma.engine3d.common.*;
	import com.cutecoma.engine3d.common.utils.*;

	public class Material extends Object implements IClonable
	{
		public var ambient:Color;
		public var diffuse:Color;
		public var specular:Color;

		public function Material(ambient:Color = null, diffuse:Color = null, specular:Color = null)
		{
			this.ambient = ambient || Color.BLACK;
			this.diffuse = diffuse || Color.BLACK;
			this.specular = specular || Color.BLACK;
		}

		public function clone():IClonable
		{
			return new Material(ambient, diffuse, specular);
		}
	}
}