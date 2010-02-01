package com.cutecoma.engine3d.api.mesh.loader.max
{
    
    import flash.geom.*;
    import flash.utils.*;
    import com.cutecoma.engine3d.api.mesh.*;
    import com.cutecoma.engine3d.api.texture.*;
    import com.cutecoma.engine3d.common.bounding.*;
    import com.cutecoma.engine3d.common.vertex.*;

    public class Max3DS extends AbstractMaxParser
    {
        protected const ERROR_WRONG_FILE_FORMAT:String = "Wrong file format.";
        protected var _Mesh:Mesh = null;
        protected var _Texture:Texture = null;
        protected var _HMaterial:Object = null;
        protected var _VObjects:Vector.<MaxObject> = null;
        protected var _TextureFolder:String = null;
        public static const TRANSFORM:Matrix3D = new Matrix3D(Vector.<Number>([-1, 0, 0, 0, 0, 0, -1, 0, 0, 1, 0, 0, 0, 0, 0, 1]));

        function Max3DS(param1:String, param2:ByteArray)
        {
            this._TextureFolder = param1;
            param2.endian = Endian.LITTLE_ENDIAN;
            super(new Chunk(param2));
            
        }

        public function get mesh() : Mesh
        {
            return this._Mesh;
        }

        public function get texture() : Texture
        {
            return this._Texture;
        }

        override protected function initialize() : void
        {
            super.initialize();
            _AFunctions[Chunk.PRIMARY] = this.parsePrimary;
            _AFunctions[Chunk.SCENE] = enterChunk;
            _AFunctions[Chunk.MATERIAL] = this.parseMaterial;
            _AFunctions[Chunk.OBJECT] = this.parseObject;
            
        }

        protected function parsePrimary(param1:Chunk) : void
        {
            if (param1.identifier != Chunk.PRIMARY)
            {
                throw new Error(this.ERROR_WRONG_FILE_FORMAT);
            }
            this._HMaterial = new Object();
            this._VObjects = new Vector.<MaxObject>;
            
        }

        protected function parseObject(param1:Chunk) : void
        {
            var _loc_2:* = param1.readString();
            var _loc_3:MaxObject = null;
            param1 = new Chunk(param1.data);
            if (param1.identifier == Chunk.MESH)
            {
                _loc_3 = new MaxMesh(param1);
                _loc_3.name = _loc_2;
            }
            else
            {
                param1.skip();
            }
            this._VObjects.push(_loc_3);
            
        }

        protected function parseMaterial(param1:Chunk) : void
        {
            var _loc_2:* = new MaxMaterial(param1);
            this._HMaterial[_loc_2.name] = _loc_2;
            
        }

        override protected function finalize() : void
        {
            var _loc_8:MaxMaterial = null;
            var _loc_9:MaxObject = null;
            var _loc_10:MaxMesh = null;
            var _loc_11:Vector.<Vertex> = null;
            var _loc_12:Vector.<int> = null;
            var _loc_13:String = null;
            var _loc_14:int = 0;
            var _loc_15:int = 0;
            var _loc_16:MaxMaterial = null;
            var _loc_17:Vertex = null;
            var _loc_1:* = new Vector.<Vertex>;
            var _loc_2:* = new Vector.<int>;
            var _loc_3:int = 0;
            var _loc_4:int = 0;
            var _loc_5:* = new Array();
            var _loc_6:* = new Vector3D();
            var _loc_7:* = new Vector3D();
            for each (_loc_8 in this._HMaterial)
            {
                
                _loc_4++;
            }
            for each (_loc_9 in this._VObjects)
            {
                
                if (!(_loc_9 is MaxMesh))
                {
                    continue;
                }
                _loc_10 = _loc_9 as MaxMesh;
                _loc_11 = _loc_10.vertices;
                _loc_12 = _loc_10.indices;
                _loc_13 = _loc_10.materialName;
                _loc_14 = 0;
                if (_loc_13 && this._HMaterial[_loc_13])
                {
                    _loc_16 = this._HMaterial[_loc_13] as MaxMaterial;
                    for each (_loc_17 in _loc_11)
                    {
                        
                        _loc_17.u = (_loc_14 + _loc_17.u) / _loc_4;
                    }
                    _loc_5[_loc_14] = this._TextureFolder + "/" + _loc_16.textureFilename;
                }
                _loc_15 = 0;
                while (_loc_15 < _loc_12.length)
                {
                    
                    _loc_2.push(_loc_12[_loc_15] + _loc_3);
                    _loc_15++;
                }
                for each (_loc_17 in _loc_11)
                {
                    
                    _loc_1.push(_loc_17);
                    if (_loc_17.x < _loc_6.x)
                    {
                        _loc_6.x = _loc_17.x;
                    }
                    else if (_loc_17.x > _loc_7.x)
                    {
                        _loc_7.x = _loc_17.x;
                    }
                    if (_loc_17.y < _loc_6.y)
                    {
                        _loc_6.y = _loc_17.y;
                    }
                    else if (_loc_17.y > _loc_7.y)
                    {
                        _loc_7.y = _loc_17.y;
                    }
                    if (_loc_17.z < _loc_6.z)
                    {
                        _loc_6.z = _loc_17.z;
                        continue;
                    }
                    if (_loc_17.z > _loc_7.z)
                    {
                        _loc_7.z = _loc_17.z;
                    }
                }
                _loc_3 = _loc_1.length;
            }
            if (this._TextureFolder)
            {
                this._Texture = new TexturePool(_loc_5);
            }
            this._Mesh = new Mesh(_loc_1, Vector.<Vector.<int>>([_loc_2]));
            this._Mesh.boundingSphere = new BoundingSphere(_loc_6, _loc_7);
            
        }

    }
}
