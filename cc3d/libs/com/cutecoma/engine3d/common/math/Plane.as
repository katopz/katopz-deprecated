package com.cutecoma.engine3d.common.math
{
    import flash.geom.*;

    final public class Plane extends Vector3D
    {
        private var _Normal:Vector3D = null;
        public static const POINT_INFRONT:int = 1;
        public static const POINT_COINCIDING:int = 2;
        public static const POINT_BEHIND:int = 4;
        public static const POLYGON_INFRONT:int = POINT_INFRONT << 16 | POINT_INFRONT << 8 | POINT_INFRONT;
        public static const POLYGON_BEHIND:int = POINT_BEHIND << 16 | POINT_BEHIND << 8 | POINT_BEHIND;
        public static const POLYGON_COINCIDING:int = POINT_COINCIDING << 16 | POINT_COINCIDING << 8 | POINT_COINCIDING;
        public static const A_INFRONT:int = POINT_INFRONT << 16;
        public static const B_INFRONT:int = POINT_INFRONT << 8;
        public static const C_INFRONT:int = 1;
        public static const A_BEHIND:int = POINT_BEHIND << 16;
        public static const B_BEHIND:int = POINT_BEHIND << 8;
        public static const C_BEHIND:int = 4;
        public static const LINE_INFRONT:int = POINT_INFRONT << 8 | POINT_INFRONT;
        public static const LINE_BEHIND:int = POINT_BEHIND << 8 | POINT_BEHIND;
        public static const LINE_ENTERING:int = POINT_INFRONT << 8 | POINT_BEHIND;
        public static const LINE_LEAVING:int = POINT_BEHIND << 8 | POINT_INFRONT;
        public static const OPPOSITE:int = 1 << 24;
        public static const COLINEAR:int = 2 << 24;

        public function Plane(param1:Number = 0, param2:Number = 0, param3:Number = 0, param4:Number = 0)
        {
            super(param1, param2, param3, param4);
            this._Normal = new Vector3D(param1, param2, param3);
            this._Normal.normalize();
            
        }

        public function get normal() : Vector3D
        {
            return this._Normal;
        }

        public function classifyPoint(param1:Vector3D) : int
        {
            var _loc_2:* = x * param1.x + y * param1.y + z * param1.z + w;
            return _loc_2 == 0 ? (POINT_COINCIDING) : (_loc_2 < 0 ? (POINT_BEHIND) : (POINT_INFRONT));
        }

        public function classifyPolygon(param1:Vector3D, param2:Vector3D, param3:Vector3D) : int
        {
            var _loc_4:* = (this.classifyPoint(param1) << 16) + (this.classifyPoint(param2) << 8) + this.classifyPoint(param3);
            if ((this.classifyPoint(param1) << 16) + (this.classifyPoint(param2) << 8) + this.classifyPoint(param3) == POLYGON_COINCIDING)
            {
                _loc_4 = _loc_4 + (dotProduct(param1.subtract(param3).crossProduct(param1.subtract(param2))) >= 0 ? (COLINEAR) : (OPPOSITE));
            }
            return _loc_4;
        }

        public function classifyLine(param1:Vector3D, param2:Vector3D) : int
        {
            return (this.classifyPoint(param1) << 8) + this.classifyPoint(param2);
        }

        public static function fromPolygon(param1:Vector3D, param2:Vector3D, param3:Vector3D) : Plane
        {
            var _loc_4:* = param1.subtract(param3).crossProduct(param1.subtract(param2));
            var _loc_5:* = (-param1.x) * _loc_4.x - param1.y * _loc_4.y - param1.z * _loc_4.z;
            return new Plane(_loc_4.x, _loc_4.y, _loc_4.z, _loc_5);
        }

    }
}
