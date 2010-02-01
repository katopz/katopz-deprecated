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
            this._Sun = new Sprite3D();
            super(Mesh.CUBE.clone() as BaseMesh);
            mesh.vertexBuffer.reverse();
            scale.scaleBy(90);
            texture = Texture.fromAsset(ASSET_TEXTURE_SKY);
            this._Sun.texture = Texture.fromAsset(ASSET_TEXTURE_SUN);
            this._Sun.position.x = scale.x / 2;
            this._Sun.rotation.z = Math.PI / 2;
            this._Sun.rotation.y = Math.PI / 2;
            this._Sun.scale.scaleBy(10);
            
        }

        override public function draw(param1:Device, param2:Sprite = null) : void
        {
            param1.renderStates.clipping = Clipping.ZNEAR;
            super.draw(param1, param2);
            this._Sun.draw(param1, param2);
            param1.renderStates.clipping = Clipping.IGNORE;
            
        }

    }
}
