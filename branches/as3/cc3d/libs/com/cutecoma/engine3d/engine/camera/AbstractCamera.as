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
            this._Position = new Vector3D();
            this._Direction = new Vector3D();
            this._Rotation = new Vector3D();
            this._ViewMatrix = new Matrix3D();
            this._MustUpdate = true;
            
        }

        public function get position() : Vector3D
        {
            this._MustUpdate = true;
            return this._Position;
        }

        public function get direction() : Vector3D
        {
            this._MustUpdate = true;
            return this._Direction;
        }

        public function get viewMatrix() : Matrix3D
        {
            if (this._MustUpdate)
            {
                this.updateMatrix();
            }
            return this._ViewMatrix;
        }

        public function get yaw() : Number
        {
            return this._Rotation.y;
        }

        public function get pitch() : Number
        {
            return this._Rotation.x;
        }

        public function get distance() : Number
        {
            return this._Distance;
        }

        public function get rotation() : Vector3D
        {
            return this._Rotation;
        }

        public function set viewMatrix(param1:Matrix3D) : void
        {
            this._MustUpdate = false;
            this._ViewMatrix = param1;
            
        }

        public function set position(param1:Vector3D) : void
        {
            this._Position = param1;
            this._MustUpdate = true;
            
        }

        public function set direction(param1:Vector3D) : void
        {
            this._Direction = param1;
            this._MustUpdate = true;
            
        }

        public function set yaw(param1:Number) : void
        {
            this._Rotation.y = param1 % (Math.PI * 2);
            this._MustUpdate = true;
            
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
            this._Rotation.x = param1;
            this._MustUpdate = true;
            
        }

        public function set distance(param1:Number) : void
        {
            this._Distance = param1;
            this._MustUpdate = true;
            
        }

        public function set rotation(param1:Vector3D) : void
        {
            this._Rotation = param1;
            this._MustUpdate = true;
            
        }

        protected function updateMatrix() : void
        {
            this._MustUpdate = false;
            
        }

    }
}
