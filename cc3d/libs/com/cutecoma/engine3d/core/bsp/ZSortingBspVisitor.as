package com.cutecoma.engine3d.core.bsp
{
    
    import flash.geom.*;
    import com.cutecoma.engine3d.common.math.*;

    public class ZSortingBspVisitor extends Object
    {
        private var _VIndices:Vector.<int> = null;
        private var _CIndices:int = 0;
        private static const INFRONT:int = Plane.POINT_INFRONT;
        private static const COINCIDING:int = Plane.POINT_COINCIDING;
        private static const BEHIND:int = Plane.POINT_BEHIND;

        public function ZSortingBspVisitor()
        {
            _VIndices = new Vector.<int>;
            
        }

        public function reset() : void
        {
            _CIndices = 0;
            _VIndices.length = 0;
            
        }

        public function visit(param1:BspTree, param2:Vector3D) : Vector.<int>
        {
            var _loc_3:int = 0;
            var _loc_4:* = param1.partition.classifyPoint(param2);
            var _loc_5:* = param1.back;
            var _loc_6:* = param1.front;
            var _loc_9:ZSortingBspVisitor
            if (_loc_4 & INFRONT)
            {
                if (_loc_5)
                {
                    this.visit(_loc_5, param2);
                }
                for each (_loc_3 in param1.colinear)
                {
                    
                    _loc_9 = this;
                    _loc_9._CIndices = _CIndices++;
                    _VIndices[int(_CIndices++)] = _loc_3;
                }
                if (_loc_6)
                {
                    this.visit(_loc_6, param2);
                }
            }
            else if (_loc_4 & BEHIND)
            {
                if (_loc_6)
                {
                    this.visit(_loc_6, param2);
                }
                for each (_loc_3 in param1.opposite)
                {
                    
                    _loc_9 = this;
                    _loc_9._CIndices = _CIndices++;
                    _VIndices[int(_CIndices++)] = _loc_3;
                }
                if (_loc_5)
                {
                    this.visit(_loc_5, param2);
                }
            }
            else
            {
                if (_loc_5)
                {
                    this.visit(_loc_5, param2);
                }
                if (_loc_6)
                {
                    this.visit(_loc_6, param2);
                }
            }
            return _VIndices;
        }

    }
}
