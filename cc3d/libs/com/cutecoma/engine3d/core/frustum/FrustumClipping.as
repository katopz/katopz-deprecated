package com.cutecoma.engine3d.core.frustum
{
    
    import com.cutecoma.engine3d.common.*;
    import com.cutecoma.engine3d.common.math.*;
    import com.cutecoma.engine3d.common.vertex.*;

    public class FrustumClipping extends Object
    {
        private var _frustum:Frustum;
        private var _nearPlane:Plane;
        
        public static const POLYGON_COINCIDING:int = Plane.POLYGON_COINCIDING;
        public static const POLYGON_BEHIND:int = Plane.POLYGON_BEHIND;
        public static const POLYGON_INFRONT:int = Plane.POLYGON_INFRONT;
        public static const A_BEHIND:int = Plane.A_BEHIND | Plane.B_INFRONT | Plane.C_INFRONT;
        public static const B_BEHIND:int = Plane.A_INFRONT | Plane.B_BEHIND | Plane.C_INFRONT;
        public static const C_BEHIND:int = Plane.A_INFRONT | Plane.B_INFRONT | Plane.C_BEHIND;
        public static const AB_BEHIND:int = Plane.A_BEHIND | Plane.B_BEHIND | Plane.C_INFRONT;
        public static const BC_BEHIND:int = Plane.A_INFRONT | Plane.B_BEHIND | Plane.C_BEHIND;
        public static const CA_BEHIND:int = Plane.A_BEHIND | Plane.B_INFRONT | Plane.C_BEHIND;
        public static const CLIPPING_NONED:int = 1;
        public static const CLIPPING_IGNORE:int = 2;
        public static const CLIPPING_ZNEAR:int = 4;

        public function FrustumClipping(param1:Frustum)
        {
            _nearPlane = new Plane();
            _frustum = param1;
        }

        public function clipVertices(param1:Vector.<Number>, param2:Vector.<int>, param3:Vector.<Number>, param4:int) : Vector.<int>
        {
            var _loc_12:int = 0;
            var _loc_13:int = 0;
            var _loc_14:int = 0;
            var _loc_15:int = 0;
            var _loc_16:Number = NaN;
            var _loc_17:Number = NaN;
            var _loc_18:Number = NaN;
            var _loc_19:Number = NaN;
            var _loc_20:Number = NaN;
            var _loc_21:int = 0;
            var _loc_22:int = 0;
            var _loc_5:* = _frustum.nearPlane;
            var _loc_6:* = param2.length;
            var _loc_7:int = 0;
            var _loc_8:* = new Vector.<int>;
            var _loc_9:* = new Vertex();
            var _loc_10:* = new Vertex();
            var _loc_11:* = new Vertex();
            while (_loc_7 < _loc_6)
            {
                _loc_12 = param2[_loc_7] * 3;
                _loc_13 = param2[int(_loc_7 + 1)] * 3;
                _loc_14 = param2[int(_loc_7 + 2)] * 3;
                _loc_15 = 0;
                _loc_9.x = param1[_loc_12];
                _loc_9.y = param1[int(_loc_12 + 1)];
                _loc_9.z = param1[int(_loc_12 + 2)];
                _loc_10.x = param1[_loc_13];
                _loc_10.y = param1[int(_loc_13 + 1)];
                _loc_10.z = param1[int(_loc_13 + 2)];
                _loc_11.x = param1[_loc_14];
                _loc_11.y = param1[int(_loc_14 + 1)];
                _loc_11.z = param1[int(_loc_14 + 2)];
                if (param3 != null)
                {
                    _loc_9.u = param3[_loc_12];
                    _loc_9.v = param3[int(_loc_12 + 1)];
                    _loc_10.u = param3[_loc_13];
                    _loc_10.v = param3[int(_loc_13 + 1)];
                    _loc_11.u = param3[_loc_14];
                    _loc_11.v = param3[int(_loc_14 + 1)];
                }
                _loc_15 = _loc_5.classifyPolygon(_loc_9, _loc_10, _loc_11);
                _loc_7 = _loc_7 + 3;
                if (_loc_15 == POLYGON_INFRONT)
                {
                    _loc_8.push(int(_loc_12 / 3), int(_loc_13 / 3), int(_loc_14 / 3));
                    continue;
                }
                if (_loc_15 == POLYGON_BEHIND && param4 & CLIPPING_IGNORE)
                {
                    continue;
                    continue;
                }
                _loc_16 = _loc_9.dotProduct(_loc_5) + _loc_5.w;
                _loc_17 = _loc_10.dotProduct(_loc_5) + _loc_5.w;
                _loc_18 = _loc_11.dotProduct(_loc_5) + _loc_5.w;
                _loc_19 = 0;
                _loc_20 = 0;
                _loc_21 = param1.length / 3;
                _loc_22 = _loc_21 + 1;
                if (_loc_15 == A_BEHIND)
                {
                    _loc_8.push(_loc_21, int(_loc_13 / 3), int(_loc_14 / 3));
                    _loc_8.push(_loc_21, int(_loc_14 / 3), _loc_22);
                    _loc_19 = _loc_16 / (_loc_16 - _loc_17);
                    _loc_20 = _loc_16 / (_loc_16 - _loc_18);
                    param1.push(_loc_9.x + _loc_19 * (_loc_10.x - _loc_9.x), _loc_9.y + _loc_19 * (_loc_10.y - _loc_9.y), _loc_9.z + _loc_19 * (_loc_10.z - _loc_9.z), _loc_9.x + _loc_20 * (_loc_11.x - _loc_9.x), _loc_9.y + _loc_20 * (_loc_11.y - _loc_9.y), _loc_9.z + _loc_20 * (_loc_11.z - _loc_9.z));
                    if (param3 != null)
                    {
                        param3.push(_loc_9.u + _loc_19 * (_loc_10.u - _loc_9.u), _loc_9.v + _loc_19 * (_loc_10.v - _loc_9.v), 0, _loc_9.u + _loc_20 * (_loc_11.u - _loc_9.u), _loc_9.v + _loc_20 * (_loc_11.v - _loc_9.v), 0);
                    }
                    continue;
                }
                if (_loc_15 == B_BEHIND)
                {
                    _loc_8.push(int(_loc_12 / 3), _loc_21, int(_loc_14 / 3));
                    _loc_8.push(_loc_21, _loc_22, int(_loc_14 / 3));
                    _loc_19 = _loc_17 / (_loc_17 - _loc_16);
                    _loc_20 = _loc_17 / (_loc_17 - _loc_18);
                    param1.push(_loc_10.x + _loc_19 * (_loc_9.x - _loc_10.x), _loc_10.y + _loc_19 * (_loc_9.y - _loc_10.y), _loc_10.z + _loc_19 * (_loc_9.z - _loc_10.z), _loc_10.x + _loc_20 * (_loc_11.x - _loc_10.x), _loc_10.y + _loc_20 * (_loc_11.y - _loc_10.y), _loc_10.z + _loc_20 * (_loc_11.z - _loc_10.z));
                    if (param3 != null)
                    {
                        param3.push(_loc_10.u + _loc_19 * (_loc_9.u - _loc_10.u), _loc_10.v + _loc_19 * (_loc_9.v - _loc_10.v), 0, _loc_10.u + _loc_20 * (_loc_11.u - _loc_10.u), _loc_10.v + _loc_20 * (_loc_11.v - _loc_10.v), 0);
                    }
                    continue;
                }
                if (_loc_15 == C_BEHIND)
                {
                    _loc_8.push(int(_loc_12 / 3), int(_loc_13 / 3), _loc_21);
                    _loc_8.push(int(_loc_13 / 3), _loc_22, _loc_21);
                    _loc_19 = _loc_18 / (_loc_18 - _loc_16);
                    _loc_20 = _loc_18 / (_loc_18 - _loc_17);
                    param1.push(_loc_11.x + _loc_19 * (_loc_9.x - _loc_11.x), _loc_11.y + _loc_19 * (_loc_9.y - _loc_11.y), _loc_11.z + _loc_19 * (_loc_9.z - _loc_11.z), _loc_11.x + _loc_20 * (_loc_10.x - _loc_11.x), _loc_11.y + _loc_20 * (_loc_10.y - _loc_11.y), _loc_11.z + _loc_20 * (_loc_10.z - _loc_11.z));
                    if (param3 != null)
                    {
                        param3.push(_loc_11.u + _loc_19 * (_loc_9.u - _loc_11.u), _loc_11.v + _loc_19 * (_loc_9.v - _loc_11.v), 0, _loc_11.u + _loc_20 * (_loc_10.u - _loc_11.u), _loc_11.v + _loc_20 * (_loc_10.v - _loc_11.v), 0);
                    }
                    continue;
                }
                if (_loc_15 == AB_BEHIND)
                {
                    _loc_8.push(_loc_21, _loc_22, int(_loc_14 / 3));
                    _loc_19 = _loc_16 / (_loc_16 - _loc_18);
                    _loc_20 = _loc_17 / (_loc_17 - _loc_18);
                    param1.push(_loc_9.x + _loc_19 * (_loc_11.x - _loc_9.x), _loc_9.y + _loc_19 * (_loc_11.y - _loc_9.y), _loc_9.z + _loc_19 * (_loc_11.z - _loc_9.z), _loc_10.x + _loc_20 * (_loc_11.x - _loc_10.x), _loc_10.y + _loc_20 * (_loc_11.y - _loc_10.y), _loc_10.z + _loc_20 * (_loc_11.z - _loc_10.z));
                    if (param3 != null)
                    {
                        param3.push(_loc_9.u + _loc_19 * (_loc_11.u - _loc_9.u), _loc_9.v + _loc_19 * (_loc_11.v - _loc_9.v), 0, _loc_10.u + _loc_20 * (_loc_11.u - _loc_10.u), _loc_10.v + _loc_20 * (_loc_11.v - _loc_10.v), 0);
                    }
                    continue;
                }
                if (_loc_15 == BC_BEHIND)
                {
                    _loc_8.push(int(_loc_12 / 3), _loc_21, _loc_22);
                    _loc_19 = _loc_17 / (_loc_17 - _loc_16);
                    _loc_20 = _loc_18 / (_loc_18 - _loc_16);
                    param1.push(_loc_10.x + _loc_19 * (_loc_9.x - _loc_10.x), _loc_10.y + _loc_19 * (_loc_9.y - _loc_10.y), _loc_10.z + _loc_19 * (_loc_9.z - _loc_10.z), _loc_11.x + _loc_20 * (_loc_9.x - _loc_11.x), _loc_11.y + _loc_20 * (_loc_9.y - _loc_11.y), _loc_11.z + _loc_20 * (_loc_9.z - _loc_11.z));
                    if (param3 != null)
                    {
                        param3.push(_loc_10.u + _loc_19 * (_loc_9.u - _loc_10.u), _loc_10.v + _loc_19 * (_loc_9.v - _loc_10.v), 0, _loc_11.u + _loc_20 * (_loc_9.u - _loc_11.u), _loc_11.v + _loc_20 * (_loc_9.v - _loc_11.v), 0);
                    }
                    continue;
                }
                if (_loc_15 == CA_BEHIND)
                {
                    _loc_8.push(_loc_21, int(_loc_13 / 3), _loc_22);
                    _loc_19 = _loc_16 / (_loc_16 - _loc_17);
                    _loc_20 = _loc_18 / (_loc_18 - _loc_17);
                    param1.push(_loc_9.x + _loc_19 * (_loc_10.x - _loc_9.x), _loc_9.y + _loc_19 * (_loc_10.y - _loc_9.y), _loc_9.z + _loc_19 * (_loc_10.z - _loc_9.z), _loc_11.x + _loc_20 * (_loc_10.x - _loc_11.x), _loc_11.y + _loc_20 * (_loc_10.y - _loc_11.y), _loc_11.z + _loc_20 * (_loc_10.z - _loc_11.z));
                    if (param3 != null)
                    {
                        param3.push(_loc_9.u + _loc_19 * (_loc_10.u - _loc_9.u), _loc_9.v + _loc_19 * (_loc_10.v - _loc_9.v), 0, _loc_11.u + _loc_20 * (_loc_10.u - _loc_11.u), _loc_11.v + _loc_20 * (_loc_10.v - _loc_11.v), 0);
                    }
                }
            }
            return _loc_8;
        }
    }
}