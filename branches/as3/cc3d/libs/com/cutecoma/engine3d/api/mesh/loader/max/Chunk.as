package com.cutecoma.engine3d.api.mesh.loader.max
{
    import flash.utils.*;

    public class Chunk extends Object
    {
        protected var _Identifier:int = 0;
        protected var _Length:int = 0;
        protected var _EndOffset:int = 0;
        protected var _Data:ByteArray = null;
        public static const PRIMARY:int = 19789;
        public static const SCENE:int = 15677;
        public static const OBJECT:int = 16384;
        public static const MESH:int = 16640;
        public static const MESH_VERTICES:int = 16656;
        public static const MESH_INDICES:int = 16672;
        public static const MESH_MATERIAL:int = 16688;
        public static const MESH_MAPPING:int = 16704;
        public static const MATERIAL:int = 45055;
        public static const MATERIAL_NAME:int = 40960;
        public static const MATERIAL_TEXMAP:int = 41472;
        public static const MATERIAL_MAPNAME:int = 41728;

        function Chunk(param1:ByteArray)
        {
            this._Data = param1;
            this._EndOffset = this._Data.position;
            this._Identifier = this._Data.readUnsignedShort();
            this._Length = this._Data.readUnsignedInt();
            this._EndOffset = this._EndOffset + this._Length;
            
        }

        public function get identifier() : int
        {
            return this._Identifier;
        }

        public function get length() : int
        {
            return this._Length;
        }

        public function get data() : ByteArray
        {
            return this._Data;
        }

        public function get bytesAvailable() : int
        {
            return this._EndOffset > this._Data.position ? (this._EndOffset - this._Data.position) : (0);
        }

        public function skip() : void
        {
            this._Data.position = this._Data.position + (this._Length - 6);
            
        }

        public function readString() : String
        {
            var _loc_1:String = "";
            var _loc_2:int = 0;
            do
            {
                
                _loc_1 = _loc_1 + String.fromCharCode(_loc_2);
                var _loc_3:* = this._Data.readByte();
                _loc_2 = this._Data.readByte();
            }while (_loc_3 != 0)
            return _loc_1;
        }

    }
}
