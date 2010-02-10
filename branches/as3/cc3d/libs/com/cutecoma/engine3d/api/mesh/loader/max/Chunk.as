package com.cutecoma.engine3d.api.mesh.loader.max
{
    import flash.utils.*;

    public class Chunk extends Object
    {
        protected var _identifier:int = 0;
        protected var _length:int = 0;
        protected var _endOffset:int = 0;
        protected var _data:ByteArray;
        public static const PRIMARY:int = 19789;
        public static const SCENE:int = 15677;
        public static const OBJECT:int = 16384;
        public static const MESH:int = 16640;
        public static const MESH_vERTICES:int = 16656;
        public static const MESH_iNDICES:int = 16672;
        public static const MESH_MATERIAL:int = 16688;
        public static const MESH_MAPPING:int = 16704;
        public static const MATERIAL:int = 45055;
        public static const MATERIAL_nAME:int = 40960;
        public static const MATERIAL_tEXMAP:int = 41472;
        public static const MATERIAL_MAPNAME:int = 41728;

        function Chunk(param1:ByteArray)
        {
            _data = param1;
            _endOffset = _data.position;
            _identifier = _data.readUnsignedShort();
            _length = _data.readUnsignedInt();
            _endOffset = _endOffset + _length;
            
        }

        public function get identifier() : int
        {
            return _identifier;
        }

        public function get length() : int
        {
            return _length;
        }

        public function get data() : ByteArray
        {
            return _data;
        }

        public function get bytesAvailable() : int
        {
            return _endOffset > _data.position ? (_endOffset - _data.position) : (0);
        }

        public function skip() : void
        {
            _data.position = _data.position + (_length - 6);
            
        }

        public function readString() : String
        {
            var _loc_1:String = "";
            var _loc_2:int = 0;
            do
            {
                
                _loc_1 = _loc_1 + String.fromCharCode(_loc_2);
                var _loc_3:* = _data.readByte();
                _loc_2 = _data.readByte();
            }while (_loc_3 != 0)
            return _loc_1;
        }

    }
}
