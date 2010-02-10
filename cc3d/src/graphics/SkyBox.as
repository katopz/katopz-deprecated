package graphics
{
    import flash.display.*;
    import com.cutecoma.engine3d.api.*;
    import com.cutecoma.engine3d.api.mesh.*;
    import com.cutecoma.engine3d.api.texture.*;
    import com.cutecoma.engine3d.common.*;
    import com.cutecoma.engine3d.engine.*;

    public class SkyBox extends Object3D
    {
        private var _Sun:Sprite3D;
        [Embed(source="assets/image3.png")]
		private var ASSET_TEXTURE_SUN : Class;
        //private static const ASSET_TEXTURE_SUN:Class = SkyBox_ASSET_TEXTURE_SUN;
        
        [Embed(source="assets/image1.jpg")]
		private var ASSET_TEXTURE_SKY : Class;
        //private static const ASSET_TEXTURE_SKY:Class = SkyBox_ASSET_TEXTURE_SKY;

        public function SkyBox()
        {
            _Sun = new Sprite3D();
            super(Mesh.CUBE.clone() as BaseMesh);
            mesh.vertexBuffer.reverse();
            scale.scaleBy(90);
            texture = Texture.fromAsset(ASSET_TEXTURE_SKY);
            _Sun.texture = Texture.fromAsset(ASSET_TEXTURE_SUN);
            _Sun.position.x = scale.x / 2;
            _Sun.rotation.z = Math.PI / 2;
            _Sun.rotation.y = Math.PI / 2;
            _Sun.scale.scaleBy(10);
        }

        override public function draw(device:Device, sprite:Sprite = null) : void
        {
            device.renderStates.clipping = Clipping.ZNEAR;
            super.draw(device, sprite);
            _Sun.draw(device, sprite);
            device.renderStates.clipping = Clipping.IGNORE;
        }
    }
}