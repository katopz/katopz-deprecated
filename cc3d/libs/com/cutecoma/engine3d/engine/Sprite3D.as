package com.cutecoma.engine3d.engine
{
    import flash.display.*;
    import com.cutecoma.engine3d.api.mesh.*;

    public class Sprite3D extends Object3D
    {
        public function Sprite3D(sprite:Sprite = null)
        {
            super(Mesh.SQUARE, sprite);
            
        }
    }
}