package com.cutecoma.engine3d.engine
{
    import flash.display.*;
    import flash.geom.*;
    import com.cutecoma.engine3d.api.*;

    public interface IDrawable3D
    {

        public function IDrawable3D();

        function draw(param1:Device, param2:Sprite = null) : void;

        function get position() : Vector3D;

        function get rotation() : Vector3D;

        function get scale() : Vector3D;

    }
}
