package com.cutecoma.engine3d.core.bsp
{
    
    import flash.geom.*;
    import com.cutecoma.engine3d.common.bounding.*;
    import com.cutecoma.engine3d.common.math.*;
    import com.cutecoma.engine3d.common.vertex.*;
    import com.cutecoma.engine3d.core.frustum.*;
	import com.cutecoma.engine3d.core.ZSortable;
	
    public class BspTree extends Object implements ZSortable
    {
        private var _Partition:Plane = null;
        private var _Colinear:Vector.<int>;
        private var _Opposite:Vector.<int>;
        private var _Normal:Vertex = null;
        private var _Front:BspTree = null;
        private var _Back:BspTree = null;
        private var _Parent:BspTree = null;
        private var _BoundingSphere:BoundingSphere = null;
        private var _IsInitialized:Boolean = false;
        private var _Visitor:ZSortingBspVisitor;
        private static const POLYGON_COINCIDING:int = Plane.POLYGON_COINCIDING;
        private static const POLYGON_BEHIND:int = Plane.POLYGON_BEHIND;
        private static const POLYGON_INFRONT:int = Plane.POLYGON_INFRONT;
        private static const COLINEAR:int = Plane.COLINEAR;
        private static const OPPOSITE:int = Plane.OPPOSITE;
        private static const A_BEHIND:int = Plane.A_BEHIND;
        private static const B_BEHIND:int = Plane.B_BEHIND;
        private static const C_BEHIND:int = 4;
        private static const AB_BEHIND:int = Plane.A_BEHIND | Plane.B_BEHIND;
        private static const BC_BEHIND:int = Plane.B_BEHIND | Plane.C_BEHIND;
        private static const CA_BEHIND:int = Plane.A_BEHIND | Plane.C_BEHIND;

        public function BspTree(param1:uint, param2:Vector.<Vertex>, param3:Vector.<int>)
        {
            this._Colinear = new Vector.<int>;
            this._Opposite = new Vector.<int>;
            this._Visitor = new ZSortingBspVisitor();
            this.build(param1, param2, param3);
            
        }

        public function get partition() : Plane
        {
            return this._Partition;
        }

        public function get colinear() : Vector.<int>
        {
            return this._Colinear;
        }

        public function get opposite() : Vector.<int>
        {
            return this._Opposite;
        }

        public function get front() : BspTree
        {
            return this._Front;
        }

        public function get back() : BspTree
        {
            return this._Back;
        }

        public function get parent() : BspTree
        {
            return this._Parent;
        }

        public function get boudingSphere() : BoundingSphere
        {
            return this._BoundingSphere;
        }

        private function build(param1:uint, param2:Vector.<Vertex>, param3:Vector.<int>) : void
        {
            var _loc_11:int = 0;
            var _loc_12:int = 0;
            var _loc_13:int = 0;
            var _loc_14:Vertex = null;
            var _loc_15:Vertex = null;
            var _loc_16:Vertex = null;
            var _loc_17:int = 0;
            var _loc_18:int = 0;
            var _loc_19:Number = NaN;
            var _loc_20:Number = NaN;
            var _loc_21:Number = NaN;
            var _loc_22:Number = NaN;
            var _loc_23:Number = NaN;
            var _loc_24:int = 0;
            var _loc_25:int = 0;
            var _loc_26:Vertex = null;
            var _loc_27:Vertex = null;
            var _loc_4:int = 0;
            var _loc_5:* = param3.length;
            var _loc_6:* = new Vector.<int>;
            var _loc_7:* = new Vector.<int>;
            var _loc_8:* = new Vector3D();
            var _loc_9:* = new Vector3D();
            var _loc_10:int = 0;
            while (_loc_4 < _loc_5)
            {
                
                _loc_11 = param3[_loc_4];
                _loc_12 = param3[int(_loc_4 + 1)];
                _loc_13 = param3[int(_loc_4 + 2)];
                _loc_14 = param2[_loc_11];
                _loc_15 = param2[_loc_12];
                _loc_16 = param2[_loc_13];
                _loc_4 = _loc_4 + 3;
                if (!this._Partition)
                {
                    this._Partition = Plane.fromPolygon(_loc_14, _loc_15, _loc_16);
                    this._Colinear.push(_loc_11, _loc_12, _loc_13);
                    continue;
                }
                _loc_17 = this._Partition.classifyPolygon(_loc_14, _loc_15, _loc_16);
                _loc_18 = _loc_17 & 16777215;
                if (_loc_18 == POLYGON_COINCIDING)
                {
                    if (_loc_17 & COLINEAR)
                    {
                        this._Colinear.push(_loc_11, _loc_12, _loc_13);
                    }
                    else
                    {
                        this._Opposite.push(_loc_11, _loc_12, _loc_13);
                    }
                    continue;
                }
                if (_loc_18 == (_loc_18 & POLYGON_COINCIDING | _loc_18 & POLYGON_INFRONT))
                {
                    _loc_6.push(_loc_11, _loc_12, _loc_13);
                    continue;
                }
                if (_loc_18 == (_loc_18 & POLYGON_COINCIDING | _loc_18 & POLYGON_BEHIND))
                {
                    _loc_7.push(_loc_11, _loc_12, _loc_13);
                    continue;
                }
                _loc_7.push(_loc_11, _loc_12, _loc_13);
                continue;
            }
            if (_loc_6.length)
            {
                this._Front = new BspTree(param1, param2, _loc_6);
            }
            if (_loc_7.length)
            {
                this._Back = new BspTree(param1, param2, _loc_7);
            }
            
        }

        public function zSort(param1:Vector3D, param2:Frustum) : Vector.<int>
        {
            this._Visitor.reset();
            return this._Visitor.visit(this, param1);
        }

        public function choosePartition(param1:Vector.<Vertex>, param2:Vector.<int>) : Plane
        {
            var _loc_7:int = 0;
            var _loc_8:int = 0;
            var _loc_9:int = 0;
            var _loc_10:Vertex = null;
            var _loc_11:Vertex = null;
            var _loc_12:Vertex = null;
            var _loc_13:Plane = null;
            var _loc_14:int = 0;
            var _loc_15:int = 0;
            var _loc_16:int = 0;
            var _loc_3:int = 0;
            var _loc_4:* = param2.length;
            var _loc_5:Plane = null;
            var _loc_6:* = int.MAX_VALUE;
            while (_loc_3 < _loc_4)
            {
                
                _loc_7 = param2[_loc_3];
                _loc_8 = param2[int(_loc_3 + 1)];
                _loc_9 = param2[int(_loc_3 + 2)];
                _loc_10 = param1[_loc_7];
                _loc_11 = param1[_loc_8];
                _loc_12 = param1[_loc_9];
                _loc_13 = Plane.fromPolygon(_loc_10, _loc_11, _loc_12);
                _loc_14 = 0;
                _loc_15 = 0;
                while (_loc_15 < _loc_4)
                {
                    
                    _loc_7 = param2[_loc_3];
                    _loc_8 = param2[int(_loc_3 + 1)];
                    _loc_9 = param2[int(_loc_3 + 2)];
                    _loc_10 = param1[_loc_7];
                    _loc_11 = param1[_loc_8];
                    _loc_12 = param1[_loc_9];
                    _loc_16 = _loc_13.classifyPolygon(_loc_10, _loc_11, _loc_12) & 16777215;
                    if (_loc_16 != POLYGON_BEHIND && _loc_16 != POLYGON_COINCIDING && _loc_16 != POLYGON_INFRONT)
                    {
                        _loc_14++;
                    }
                    if (_loc_14 < _loc_6)
                    {
                        _loc_6 = _loc_14;
                        _loc_5 = _loc_13;
                    }
                    _loc_15++;
                }
                _loc_3 = _loc_3 + 3;
            }
            return _loc_5;
        }

    }
}
