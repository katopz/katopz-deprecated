package com.cutecoma.engine3d.common.math
{
    import flash.geom.*;

    public class Matrix3DFactory extends Object
    {
        protected var TAN:Function;
        public static var _Instance:Matrix3DFactory = null;

        public function Matrix3DFactory()
        {
            this.TAN = Math.tan;
            if (_Instance != null)
            {
                throw new Error("Matrix3DFactory is a singleton : it can not be instantiated. Use Matrix3DFactory.INSTANCE instead.");
            }
            
        }

        public function perspectiveFovLH(param1:Number, param2:Number, param3:Number, param4:Number) : Matrix3D
        {
            var _loc_5:* = 1 / this.TAN(param1 / 2);
            var _loc_6:* = 1 / this.TAN(param1 / 2) / param2;
            var _loc_7:* = param4 / (param4 - param3);
            var _loc_8:* = (-param3) * param4 / (param4 - param3);
            return new Matrix3D(Vector.<Number>([_loc_6, 0, 0, 0, 0, _loc_5, 0, 0, 0, 0, _loc_7, 1, 0, 0, _loc_8, 0]));
        }

        public function perspectiveFovRH(param1:Number, param2:Number, param3:Number, param4:Number) : Matrix3D
        {
            var _loc_5:* = 1 / this.TAN(param1 / 2);
            var _loc_6:* = 1 / this.TAN(param1 / 2) / param2;
            var _loc_7:* = param4 / (param4 - param3);
            var _loc_8:* = param3 * param4 / (param4 - param3);
            return new Matrix3D(Vector.<Number>([_loc_6, 0, 0, 0, 0, _loc_5, 0, 0, 0, 0, _loc_7, -1, 0, 0, _loc_8, 0]));
        }

        public function lookAtLH(param1:Vector3D, param2:Vector3D, param3:Vector3D) : Matrix3D
        {
            var _loc_4:* = param2.subtract(param1);
            var _loc_5:Vector3D = null;
            var _loc_6:Vector3D = null;
            var _loc_7:Number = 0;
            var _loc_8:Number = 0;
            var _loc_9:Number = 0;
            _loc_4.normalize();
            _loc_5 = param3.crossProduct(_loc_4);
            _loc_5.normalize();
            _loc_6 = _loc_4.crossProduct(_loc_5);
            _loc_6.normalize();
            _loc_7 = -_loc_5.dotProduct(param1);
            _loc_8 = -_loc_6.dotProduct(param1);
            _loc_9 = -_loc_4.dotProduct(param1);
            return new Matrix3D(Vector.<Number>([_loc_5.x, _loc_6.x, _loc_4.x, 0, _loc_5.y, _loc_6.y, _loc_4.y, 0, _loc_5.z, _loc_6.z, _loc_4.z, 0, _loc_7, _loc_8, _loc_9, 1]));
        }

        public function lookAtRH(param1:Vector3D, param2:Vector3D, param3:Vector3D) : Matrix3D
        {
            var _loc_4:* = param1.subtract(param2);
            var _loc_5:Vector3D = null;
            var _loc_6:Vector3D = null;
            var _loc_7:Number = 0;
            var _loc_8:Number = 0;
            var _loc_9:Number = 0;
            _loc_4.normalize();
            _loc_5 = param3.crossProduct(_loc_4);
            _loc_5.normalize();
            _loc_6 = _loc_4.crossProduct(_loc_5);
            _loc_6.normalize();
            _loc_7 = -_loc_5.dotProduct(param1);
            _loc_8 = -_loc_6.dotProduct(param1);
            _loc_9 = -_loc_4.dotProduct(param1);
            return new Matrix3D(Vector.<Number>([_loc_5.x, _loc_6.x, _loc_4.x, 0, _loc_5.y, _loc_6.y, _loc_4.y, 0, _loc_5.z, _loc_6.z, _loc_4.z, 0, _loc_7, _loc_8, _loc_9, 1]));
        }

        public static function get instance() : Matrix3DFactory
        {
            if (_Instance == null)
            {
                _Instance = new Matrix3DFactory;
            }
            return _Instance;
        }

    }
}
