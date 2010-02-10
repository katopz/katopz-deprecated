package com.cutecoma.engine3d.core.primitive
{
    
    
    import com.cutecoma.engine3d.common.vertex.Vertex;
    import com.cutecoma.engine3d.core.*;

    public class PrimitiveStream extends Object
    {
        private var _PrimitiveType:uint = 0;
        private var _indices:Vector.<int> = null;
        private var _vertices:Vector.<Number> = null;
        private var _Normals:Vector.<Number> = null;
        private var _UvData:Vector.<Number> = null;
        private var _ZSorter:ZSortable = null;

        public function PrimitiveStream(param1:uint, param2:Vector.<Vertex>, param3:Vector.<int>, param4:Class)
        {
            var _loc_7:Vertex = null;
            var _loc_5:* = param2.length;
            var _loc_6:int = 0;
            _PrimitiveType = param1;
            if (param3 == null)
            {
                param3 = new Vector.<int>(_loc_5);
                while (_loc_6 < _loc_5)
                {
                    
                    param3[_loc_6] = _loc_6++;
                }
            }
            _indices = param3;
            _loc_6 = 0;
            _ZSorter = new param4(_PrimitiveType, param2, _indices);
            _loc_5 = param2.length;
            _Normals = new Vector.<Number>(_loc_5 * 3);
            _UvData = new Vector.<Number>(_loc_5 * 3);
            _vertices = new Vector.<Number>(_loc_5 * 3);
            for each (_loc_7 in param2)
            {
                
                _vertices[_loc_6] = _loc_7.x;
                _vertices[int(_loc_6 + 1)] = _loc_7.y;
                _vertices[int(_loc_6 + 2)] = _loc_7.z;
                _UvData[_loc_6] = _loc_7.u;
                _UvData[int(_loc_6 + 1)] = _loc_7.v;
                _UvData[int(_loc_6 + 2)] = 0;
                _Normals[_loc_6] = _loc_7.nx;
                _Normals[int(_loc_6 + 1)] = _loc_7.ny;
                _Normals[int(_loc_6 + 2)] = _loc_7.nz;
                _loc_6 = _loc_6 + 3;
            }
            
        }

        public function get primitiveType() : int
        {
            return _PrimitiveType;
        }

        public function get indices() : Vector.<int>
        {
            return _indices;
        }

        public function get vertices() : Vector.<Number>
        {
            return _vertices;
        }

        public function get normals() : Vector.<Number>
        {
            return _Normals;
        }

        public function get uvData() : Vector.<Number>
        {
            return _UvData;
        }

        public function get zSorter() : ZSortable
        {
            return _ZSorter;
        }

    }
}
