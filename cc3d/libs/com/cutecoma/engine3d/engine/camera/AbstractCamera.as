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
        private var _Position:Vector3D;
        private var _Direction:Vector3D;
        private var _Rotation:Vector3D;
        private var _ViewMatrix:Matrix3D;
        private var _Distance:Number = 1;
        private var _MustUpdate:Boolean = true;

        public function AbstractCamera()
        {
            this.MATRIX_FACTORY = Matrix3DFactory.instance;
            this.LOOK_AT_LH = this.MATRIX_FACTORY.lookAtLH;
            this.COS = Math.cos;
            this.SIN = Math.sin;
            this.TAN = Math.tan;
            _Position = new Vector3D();
            _Direction = new Vector3D();
            _Rotation = new Vector3D();
            _ViewMatrix = new Matrix3D();
            _MustUpdate = true;
            
        }

        public function get position() : Vector3D
        {
            _MustUpdate = true;
            return _Position;
        }

        public function get direction() : Vector3D
        {
            _MustUpdate = true;
            return _Direction;
        }

        public function get viewMatrix() : Matrix3D
        {
            if (_MustUpdate)
            {
                this.updateMatrix();
            }
            return _ViewMatrix;
        }

        public function get yaw() : Number
        {
            return _Rotation.y;
        }

        public function get pitch() : Number
        {
            return _Rotation.x;
        }

        public function get distance() : Number
        {
            return _Distance;
        }

        public function get rotation() : Vector3D
        {
            return _Rotation;
        }

        public function set viewMatrix(value:Matrix3D) : void
        {
            _MustUpdate = false;
            _ViewMatrix = value;
            
        }

        public function set position(value:Vector3D) : void
        {
            _Position = value;
            _MustUpdate = true;
            
        }

        public function set direction(value:Vector3D) : void
        {
            _Direction = value;
            _MustUpdate = true;
            
        }

        public function set yaw(value:Number) : void
        {
            _Rotation.y = value % (Math.PI * 2);
            _MustUpdate = true;
            
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
            _Rotation.x = param1;
            _MustUpdate = true;
            
        }

        public function set distance(value:Number) : void
        {
            _Distance = value;
            _MustUpdate = true;
            
        }

        public function set rotation(value:Vector3D) : void
        {
            _Rotation = value;
            _MustUpdate = true;
            
        }

        protected function updateMatrix() : void
        {
            _MustUpdate = false;
            
        }

    }
}
