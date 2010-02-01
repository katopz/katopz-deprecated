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

        public function Object3D(param1:BaseMesh = null, param2:Sprite = null)
        {
            this._Material = new Material();
            this._Position = new Vector3D(0, 0, 0);
            this._Rotation = new Vector3D(0, 0, 0);
            this._Scale = new Vector3D(1, 1, 1);
            this._MWorld = new Matrix3D();
            this._Mesh = param1;
            this._Sprite = param2;
            
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

        public function get material() : Material
        {
            return this._Material;
        }

        public function get sprite() : Sprite
        {
            return this._Sprite;
        }

        public function get mesh() : BaseMesh
        {
            return this._Mesh;
        }

        public function get texture() : Texture
        {
            return this._Texture;
        }

        public function get visible() : Boolean
        {
            return this._Visible;
        }

        public function set position(param1:Vector3D) : void
        {
            this._Position = param1;
            
        }

        public function set rotation(param1:Vector3D) : void
        {
            this._Rotation = param1;
            
        }

        public function set scale(param1:Vector3D) : void
        {
            this._Scale = param1;
            
        }

        public function set material(param1:Material) : void
        {
            this._Material = param1;
            
        }

        public function set mesh(param1:BaseMesh) : void
        {
            this._Mesh = param1;
            
        }

        public function set texture(param1:Texture) : void
        {
            this._Texture = param1;
            
        }

        public function set visible(param1:Boolean) : void
        {
            this._Visible = param1;
            
        }

        public function set sprite(param1:Sprite) : void
        {
            this._Sprite = param1;
            
        }

        public function set transform(param1:Matrix3D) : void
        {
            this._Transform = param1;
            
        }

        public function set doubleSided(param1:Boolean) : void
        {
            this.mesh.subsets[1] = param1 ? (this.mesh.subsets[0].concat().reverse()) : (null);
            
        }

        protected function updateWorldMatrix(param1:Device) : void
        {
            this._MWorld.recompose(Vector.<Vector3D>([this._Position, this._Rotation, this._Scale]));
            
        }

        public function draw(param1:Device, param2:Sprite = null) : void
        {
            var _loc_3:Matrix3D = null;
            if (!this._Visible || this._Mesh == null)
            {
                return;
            }
            this.updateWorldMatrix(param1);
            param1.material = this._Material;
            param1.texture = this._Texture;
            if (this._Transform)
            {
                _loc_3 = this._MWorld.clone();
                _loc_3.append(this._Transform);
            }
            else
            {
                _loc_3 = this._MWorld;
            }
            param1.transform.world = _loc_3;
            this._Mesh.draw(param1, param2 ? (param2) : (this._Sprite));
            
        }

        public function clone() : IClonable
        {
            var _loc_1:* = new Object3D(this._Mesh, this._Sprite);
            _loc_1.position = this._Position.clone();
            _loc_1.rotation = this._Rotation.clone();
            _loc_1.scale = this._Scale.clone();
            _loc_1.texture = this._Texture;
            _loc_1.material = this._Material.clone() as Material;
            return _loc_1;
        }

    }
}
