package com.cutecoma.engine3d.engine
{
    
    import flash.display.*;
    import flash.geom.*;
    import com.cutecoma.engine3d.api.*;

    public class Object3DContainer extends Object implements IDrawable3D
    {
        private var _Children:Vector.<Object3D> = null;
        private var _Sprite:Sprite = null;
        private var _Position:Vector3D;
        private var _Rotation:Vector3D;
        private var _Scale:Vector3D;
        private var _MWorld:Matrix3D;

        public function Object3DContainer(param1:Vector.<Object3D> = null, sprite:Sprite = null)
        {
            _Position = new Vector3D();
            _Rotation = new Vector3D();
            _Scale = new Vector3D(1, 1, 1);
            _MWorld = new Matrix3D();
            _Children = param1 ? (param1) : (new Vector.<Object3D>);
            _Sprite = sprite;
            
        }

        public function get children() : Vector.<Object3D>
        {
            return _Children;
        }

        public function get sprite() : Sprite
        {
            return _Sprite;
        }

        public function get position() : Vector3D
        {
            return _Position;
        }

        public function get rotation() : Vector3D
        {
            return _Rotation;
        }

        public function get scale() : Vector3D
        {
            return _Scale;
        }

        public function set sprite(value:Sprite) : void
        {
            _Sprite = value;
            
        }

        public function draw(device:Device, sprite:Sprite = null) : void
        {
            var _loc_3:Object3D = null;
            if (!_Children.length)
            {
                return;
            }
            _MWorld.recompose(Vector.<Vector3D>([_Position, _Rotation, _Scale]));
            for each (_loc_3 in _Children)
            {
                
                _loc_3.transform = _MWorld;
                _loc_3.draw(device, sprite != null ? (sprite) : (_Sprite));
            }
        }
    }
}