package graphics
{
	import flash.display.*;
	
	import com.cutecoma.engine3d.api.*;
	import com.cutecoma.engine3d.api.mesh.shape.*;
	import com.cutecoma.engine3d.api.texture.*;
	import com.cutecoma.engine3d.common.*;
	import com.cutecoma.engine3d.engine.*;

	public class Planisphere extends Object3D
	{
		[Embed(source="assets/image2.jpg")]
		private var ASSET_TEXTURE_EARTH:Class;

		public function Planisphere()
		{
			super(new Sphere(10, 10));
			texture = Texture.fromAsset(ASSET_TEXTURE_EARTH);
		}

		override public function draw(param1:Device, param2:Sprite = null):void
		{
			param1.renderStates.clipping = Clipping.NONE;
			param1.renderStates.textureSmoothing = true;
			super.draw(param1, param2);
			param1.renderStates.textureSmoothing = false;
			param1.renderStates.clipping = Clipping.IGNORE;
		}
	}
}