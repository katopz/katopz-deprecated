package graphics
{
    import flash.display.*;
    import flash.events.*;
    import flash.filters.*;
    import flash.geom.*;
    import com.cutecoma.engine3d.api.material.*;
    import com.cutecoma.engine3d.api.texture.*;
    import com.cutecoma.engine3d.common.utils.*;
    import com.cutecoma.engine3d.engine.*;

    public class Thumbnail extends Object3DContainer
    {
        private var _Back:Sprite3D;
        private var _Front:Sprite3D = null;
        
        [Embed(source="assets/image4.jpg")]
		private var ASSET_TEXTURE_BACK : Class;
		
        //private static const ASSET_TEXTURE_BACK:Class = Thumbnail_ASSET_TEXTURE_BACK;
        private var TEXTURE_BACK:Texture = Texture.fromAsset(ASSET_TEXTURE_BACK);
        private static const GLOW:GlowFilter = new GlowFilter(1048575);

        public function Thumbnail(param1:String)
        {
            this._Back = new Sprite3D();
            super(null, new Sprite());
            this._Back.scale = new Vector3D(1.5, 1.5, 1);
            this._Back.position.y = 0.5;
            this._Back.material = new Material(Color.WHITE, Color.WHITE);
            this._Back.rotation.x = Math.PI;
            this._Back.texture = TEXTURE_BACK;
            this._Front = new Sprite3D();
            this._Front.scale = this._Back.scale;
            this._Front.position = this._Back.position;
            this._Front.texture = Texture.fromFile(param1);
            children.push(this._Back, this._Front);
            sprite.addEventListener(MouseEvent.MOUSE_OVER, this.mouseOverHandler);
            sprite.addEventListener(MouseEvent.MOUSE_OUT, this.mouseOutHandler);
            
        }

        private function mouseOverHandler(event:Event) : void
        {
            sprite.filters = [GLOW];
            
        }

        private function mouseOutHandler(event:Event) : void
        {
            sprite.filters = [];
            
        }

    }
}
