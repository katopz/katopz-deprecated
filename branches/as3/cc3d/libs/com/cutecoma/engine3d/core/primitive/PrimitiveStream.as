package com.cutecoma.engine3d.core.primitive
{
    
    
    import com.cutecoma.engine3d.common.vertex.Vertex;
    import com.cutecoma.engine3d.core.*;

    public class PrimitiveStream extends Object
    {
        private var _PrimitiveType:uint = 0;
        private var _Indices:Vector.<int> = null;
        private var _Vertices:Vector.<Number> = null;
        private var _Normals:Vector.<Number> = null;
        private var _UvData:Vector.<Number> = null;
        private var _ZSorter:ZSortable = null;

        public function PrimitiveStream(param1:uint, param2:Vector.<Vertex>, param3:Vector.<int>, param4:Class)
        {
            var _loc_7:Vertex = null;
            var _loc_5:* = param2.length;
            var _loc_6:int = 0;
            this._PrimitiveType = param1;
            if (param3 == null)
            {
                param3 = new Vector.<int>(_loc_5);
                while (_loc_6 < _loc_5)
                {
                    
                    param3[_loc_6] = _loc_6++;
                }
            }
            this._Indices = param3;
            _loc_6 = 0;
            this._ZSorter = new param4(this._PrimitiveType, param2, this._Indices);
            _loc_5 = param2.length;
            this._Normals = new Vector.<Number>(_loc_5 * 3);
            this._UvData = new Vector.<Number>(_loc_5 * 3);
            this._Vertices = new Vector.<Number>(_loc_5 * 3);
            for each (_loc_7 in param2)
            {
                
                this._Vertices[_loc_6] = _loc_7.x;
                this._Vertices[int(_loc_6 + 1)] = _loc_7.y;
                this._Vertices[int(_loc_6 + 2)] = _loc_7.z;
                this._UvData[_loc_6] = _loc_7.u;
                this._UvData[int(_loc_6 + 1)] = _loc_7.v;
                this._UvData[int(_loc_6 + 2)] = 0;
                this._Normals[_loc_6] = _loc_7.nx;
                this._Normals[int(_loc_6 + 1)] = _loc_7.ny;
                this._Normals[int(_loc_6 + 2)] = _loc_7.nz;
                _loc_6 = _loc_6 + 3;
            }
            
        }

        public function get primitiveType() : int
        {
            return this._PrimitiveType;
        }

        public function get indices() : Vector.<int>
        {
            return this._Indices;
        }

        public function get vertices() : Vector.<Number>
        {
            return this._Vertices;
        }

        public function get normals() : Vector.<Number>
        {
            return this._Normals;
        }

        public function get uvData() : Vector.<Number>
        {
            return this._UvData;
        }

        public function get zSorter() : ZSortable
        {
            return this._ZSorter;
        }

    }
}
