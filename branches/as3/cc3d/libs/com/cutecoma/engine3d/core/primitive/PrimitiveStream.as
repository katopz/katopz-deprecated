package com.cutecoma.engine3d.core.primitive
{
    
    import com.cutecoma.engine3d.common.vertex.Vertex;
    import com.cutecoma.engine3d.core.*;

    public class PrimitiveStream extends Object
    {
        private var _primitiveType:uint = 0;
        private var _indices:Vector.<int>;
        private var _vertices:Vector.<Number>;
        private var _normals:Vector.<Number>;
        private var _uvData:Vector.<Number>;
        private var _zSorter:ZSortable;

        public function PrimitiveStream(primitiveType:uint, vertices:Vector.<Vertex>, param3:Vector.<int>, bspTree:Class)
        {
            var _vertex:Vertex;
            var _vertices_length:int = vertices.length;
            var _index:int = 0;
            _primitiveType = primitiveType;
            
            if (param3 == null)
            {
                param3 = new Vector.<int>(_vertices_length);
                while (_index < _vertices_length)
                    param3[_index] = _index++;
            }
            
            _indices = param3;
            _index = 0;
            _zSorter = new bspTree(_primitiveType, vertices, _indices);
            _vertices_length = vertices.length;
            _normals = new Vector.<Number>(_vertices_length * 3);
            _uvData = new Vector.<Number>(_vertices_length * 3);
            _vertices = new Vector.<Number>(_vertices_length * 3);
            
            for each (_vertex in vertices)
            {
                _vertices[_index] = _vertex.x;
                _vertices[int(_index + 1)] = _vertex.y;
                _vertices[int(_index + 2)] = _vertex.z;
                
                _uvData[_index] = _vertex.u;
                _uvData[int(_index + 1)] = _vertex.v;
                _uvData[int(_index + 2)] = 0;
                
                _normals[_index] = _vertex.nx;
                _normals[int(_index + 1)] = _vertex.ny;
                _normals[int(_index + 2)] = _vertex.nz;
                
                _index = _index + 3;
            }
        }

        public function get primitiveType() : int
        {
            return _primitiveType;
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
            return _normals;
        }

        public function get uvData() : Vector.<Number>
        {
            return _uvData;
        }

        public function get zSorter() : ZSortable
        {
            return _zSorter;
        }
    }
}