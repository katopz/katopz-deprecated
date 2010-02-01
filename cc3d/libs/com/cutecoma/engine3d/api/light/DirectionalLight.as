package com.cutecoma.engine3d.api.light
{
    import flash.geom.*;

    public class DirectionalLight extends Light
    {
        private var _MustUpdate:Boolean = true;
        private var _Direction:Vector3D = null;
        private var _Matrix:Matrix3D = null;

        public function DirectionalLight(param1:Vector3D = null)
        {
            this._Direction = param1;
            
        }

        public function get direction() : Vector3D
        {
            this._MustUpdate = true;
            return this._Direction;
        }

        public function get matrix() : Matrix3D
        {
            if (this._MustUpdate)
            {
                this._MustUpdate = false;
                this._Direction.normalize();
                this._Matrix = new Matrix3D(Vector.<Number>([-this._Direction.x, 0, 0, 0, -this._Direction.y, 0, 0, 0, -this._Direction.z, 0, 0, 0, 0, 0, 0, 0]));
            }
            return this._Matrix;
        }

        public function set direction(param1:Vector3D) : void
        {
            this._Direction = param1;
            this._MustUpdate = true;
            
        }

    }
}
