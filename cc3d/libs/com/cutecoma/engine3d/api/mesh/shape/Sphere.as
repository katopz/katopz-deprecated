package com.cutecoma.engine3d.api.mesh.shape
{
    import flash.display.*;
    import com.cutecoma.engine3d.api.*;
    import com.cutecoma.engine3d.api.mesh.*;
    import com.cutecoma.engine3d.common.vertex.*;

    public class Sphere extends BaseMesh
    {

        public function Sphere(param1:int = 16, param2:int = 16)
        {
            this.init(param1, param2);
            
        }

        private function init(param1:int = 16, param2:int = 16) : void
        {
            var _loc_6:Number = NaN;
            var _loc_7:int = 0;
            var _loc_8:Number = NaN;
            var _loc_9:Number = NaN;
            var _loc_10:Number = NaN;
            var _loc_11:Number = NaN;
            var _loc_12:Number = NaN;
            var _loc_13:Number = NaN;
            var _loc_14:Vertex = null;
            var _loc_3:int = 0;
            var _loc_4:* = new Vector.<int>;
            vertexBuffer = new Vector.<Vertex>;
            var _loc_5:int = 0;
            while (_loc_5 != param1)
            {
                
                _loc_6 = _loc_5 / (param1-1) * Math.PI * 2;
                _loc_7 = 0;
                while (_loc_7 != param2)
                {
                    
                    _loc_8 = (_loc_7 / (param2-1) - 0.5) * Math.PI;
                    _loc_9 = Math.cos(_loc_8) * Math.cos(_loc_6);
                    _loc_10 = -Math.sin(_loc_8);
                    _loc_11 = Math.cos(_loc_8) * Math.sin(_loc_6);
                    _loc_12 = _loc_5 / (param1-1);
                    _loc_13 = _loc_7 / (param2-1);
                    _loc_14 = new Vertex(_loc_9, _loc_10, _loc_11, _loc_12, _loc_13, _loc_9, _loc_10, _loc_11);
                    vertexBuffer.push(_loc_14);
                    _loc_7++;
                }
                _loc_5++;
            }
            subsets.push(_loc_4);
            _loc_5 = 0;
            while (_loc_5 != param1-1)
            {
                
                _loc_7 = 0;
                while (_loc_7 != param2-1)
                {
                    
                    _loc_4.push(_loc_3 + 1, _loc_3 + param2 + 1, _loc_3, _loc_3, _loc_3 + param2 + 1, _loc_3 + param2);
                    _loc_7++;
                    _loc_3++;
                }
                _loc_5++;
                _loc_3++;
            }
            
        }

        override public function draw(param1:Device, param2:Sprite = null) : void
        {
            super.draw(param1, param2);
            
        }

    }
}