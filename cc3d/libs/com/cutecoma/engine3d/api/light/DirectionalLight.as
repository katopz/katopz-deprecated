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
            _Direction = param1;
            
        }

        public function get direction() : Vector3D
        {
            _MustUpdate = true;
            return _Direction;
        }

        public function get matrix() : Matrix3D
        {
            if (_MustUpdate)
            {
                _MustUpdate = false;
                _Direction.normalize();
                _Matrix = new Matrix3D(Vector.<Number>([-_Direction.x, 0, 0, 0, -_Direction.y, 0, 0, 0, -_Direction.z, 0, 0, 0, 0, 0, 0, 0]));
            }
            return _Matrix;
        }

        public function set direction(value:Vector3D) : void
        {
            _Direction = value;
            _MustUpdate = true;
            
        }

    }
}
