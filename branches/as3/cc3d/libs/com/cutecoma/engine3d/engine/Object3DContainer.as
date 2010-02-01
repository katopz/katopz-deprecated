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

        public function Object3DContainer(param1:Vector.<Object3D> = null, param2:Sprite = null)
        {
            this._Position = new Vector3D();
            this._Rotation = new Vector3D();
            this._Scale = new Vector3D(1, 1, 1);
            this._MWorld = new Matrix3D();
            this._Children = param1 ? (param1) : (new Vector.<Object3D>);
            this._Sprite = param2;
            
        }

        public function get children() : Vector.<Object3D>
        {
            return this._Children;
        }

        public function get sprite() : Sprite
        {
            return this._Sprite;
        }

        public function get position() : Vector3D
        {
            return this._Position;
        }

        public function get rotation() : Vector3D
        {
            return this._Rotation;
        }

        public function get scale() : Vector3D
        {
            return this._Scale;
        }

        public function set sprite(param1:Sprite) : void
        {
            this._Sprite = param1;
            
        }

        public function draw(param1:Device, param2:Sprite = null) : void
        {
            var _loc_3:Object3D = null;
            if (!this._Children.length)
            {
                return;
            }
            this._MWorld.recompose(Vector.<Vector3D>([this._Position, this._Rotation, this._Scale]));
            for each (_loc_3 in this._Children)
            {
                
                _loc_3.transform = this._MWorld;
                _loc_3.draw(param1, param2 != null ? (param2) : (this._Sprite));
            }
            
        }

    }
}
