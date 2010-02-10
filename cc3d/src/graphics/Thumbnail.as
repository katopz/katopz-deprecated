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
            _Back = new Sprite3D();
            super(null, new Sprite());
            _Back.scale = new Vector3D(1.5, 1.5, 1);
            _Back.position.y = 0.5;
            _Back.material = new Material(Color.WHITE, Color.WHITE);
            _Back.rotation.x = Math.PI;
            _Back.texture = TEXTURE_BACK;
            _Front = new Sprite3D();
            _Front.scale = _Back.scale;
            _Front.position = _Back.position;
            _Front.texture = Texture.fromFile(param1);
            children.push(_Back, _Front);
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
