package com.cutecoma.engine3d.engine.camera
{
    import flash.geom.*;
    import com.cutecoma.engine3d.common.math.*;

    public class AbstractCamera extends Object
    {
        protected var MATRIX_FACTORY:Matrix3DFactory;
        protected var LOOK_AT_LH:Function;
        protected var COS:Function;
        protected var SIN:Function;
        protected var TAN:Function;
        private var _position:Vector3D;
        private var _direction:Vector3D;
        private var _rotation:Vector3D;
        private var _viewMatrix:Matrix3D;
        private var _Distance:Number = 1;
        private var _dirty:Boolean = true;

        public function AbstractCamera()
        {
            this.MATRIX_FACTORY = Matrix3DFactory.instance;
            this.LOOK_AT_LH = this.MATRIX_FACTORY.lookAtLH;
            this.COS = Math.cos;
            this.SIN = Math.sin;
            this.TAN = Math.tan;
            
            _position = new Vector3D();
            _direction = new Vector3D();
            _rotation = new Vector3D();
            _viewMatrix = new Matrix3D();
            _dirty = true;
        }

        public function get position() : Vector3D
        {
            _dirty = true;
            return _position;
        }

        public function get direction() : Vector3D
        {
            _dirty = true;
            return _direction;
        }

        public function get viewMatrix() : Matrix3D
        {
            if (_dirty)
            {
                this.updateMatrix();
            }
            return _viewMatrix;
        }

        public function get yaw() : Number
        {
            return _rotation.y;
        }

        public function get pitch() : Number
        {
            return _rotation.x;
        }

        public function get distance() : Number
        {
            return _Distance;
        }

        public function get rotation() : Vector3D
        {
            return _rotation;
        }

        public function set viewMatrix(value:Matrix3D) : void
        {
            _dirty = false;
            _viewMatrix = value;
        }

        public function set position(value:Vector3D) : void
        {
            _position = value;
            _dirty = true;
        }

        public function set direction(value:Vector3D) : void
        {
            _direction = value;
            _dirty = true;
        }

        public function set yaw(value:Number) : void
        {
            _rotation.y = value % (Math.PI * 2);
            _dirty = true;
        }

        public function set pitch(param1:Number) : void
        {
            if (param1 >= Math.PI / 2)
            {
                param1 = Math.PI / 2 - 0.0001;
            }
            else if (param1 <= (-Math.PI) / 2)
            {
                param1 = (-Math.PI) / 2 + 0.0001;
            }
            _rotation.x = param1;
            _dirty = true;
        }

        public function set distance(value:Number) : void
        {
            _Distance = value;
            _dirty = true;
        }

        public function set rotation(value:Vector3D) : void
        {
            _rotation = value;
            _dirty = true;
        }

        protected function updateMatrix() : void
        {
            _dirty = false;
        }
    }
}