package com.cutecoma.engine3d.engine
{
    import flash.display.*;
    import flash.geom.*;
    import com.cutecoma.engine3d.api.*;
    import com.cutecoma.engine3d.api.material.*;
    import com.cutecoma.engine3d.api.mesh.*;
    import com.cutecoma.engine3d.api.texture.*;
    import com.cutecoma.engine3d.common.*;

    public class Object3D extends Object implements IDrawable3D, IClonable
    {
        protected var _Mesh:BaseMesh = null;
        protected var _Texture:Texture = null;
        protected var _Material:Material;
        protected var _Sprite:Sprite = null;
        protected var _Position:Vector3D;
        protected var _Rotation:Vector3D;
        protected var _Scale:Vector3D;
        protected var _MWorld:Matrix3D;
        protected var _Transform:Matrix3D = null;
        private var _Visible:Boolean = true;

        public function Object3D(param1:BaseMesh = null, sprite:Sprite = null)
        {
            _Material = new Material();
            _Position = new Vector3D(0, 0, 0);
            _Rotation = new Vector3D(0, 0, 0);
            _Scale = new Vector3D(1, 1, 1);
            _MWorld = new Matrix3D();
            _Mesh = param1;
            _Sprite = sprite;
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

        public function get material() : Material
        {
            return _Material;
        }

        public function get sprite() : Sprite
        {
            return _Sprite;
        }

        public function get mesh() : BaseMesh
        {
            return _Mesh;
        }

        public function get texture() : Texture
        {
            return _Texture;
        }

        public function get visible() : Boolean
        {
            return _Visible;
        }

        public function set position(value:Vector3D) : void
        {
            _Position = value;
        }

        public function set rotation(value:Vector3D) : void
        {
            _Rotation = value;
        }

        public function set scale(value:Vector3D) : void
        {
            _Scale = value;
        }

        public function set material(value:Material) : void
        {
            _Material = value;
        }

        public function set mesh(value:BaseMesh) : void
        {
            _Mesh = value;
        }

        public function set texture(value:Texture) : void
        {
            _Texture = value;
        }

        public function set visible(value:Boolean) : void
        {
            _Visible = value;
        }

        public function set sprite(value:Sprite) : void
        {
            _Sprite = value;
        }

        public function set transform(value:Matrix3D) : void
        {
            _Transform = value;
        }

        public function set doubleSided(value:Boolean) : void
        {
            this.mesh.subsets[1] = value ? (this.mesh.subsets[0].concat().reverse()) : (null);
        }

        protected function updateWorldMatrix(device:Device) : void
        {
            _MWorld.recompose(Vector.<Vector3D>([_Position, _Rotation, _Scale]));
        }

        public function draw(device:Device, sprite:Sprite = null) : void
        {
            var _loc_3:Matrix3D = null;
            if (!_Visible || _Mesh == null)
            {
                return;
            }
            this.updateWorldMatrix(device);
            device.material = _Material;
            device.texture = _Texture;
            if (_Transform)
            {
                _loc_3 = _MWorld.clone();
                _loc_3.append(_Transform);
            }
            else
            {
                _loc_3 = _MWorld;
            }
            device.transform.world = _loc_3;
            _Mesh.draw(device, sprite ? (sprite) : (_Sprite));
            
        }

        public function clone() : IClonable
        {
            var _loc_1:* = new Object3D(_Mesh, _Sprite);
            _loc_1.position = _Position.clone();
            _loc_1.rotation = _Rotation.clone();
            _loc_1.scale = _Scale.clone();
            _loc_1.texture = _Texture;
            _loc_1.material = _Material.clone() as Material;
            return _loc_1;
        }
    }
}