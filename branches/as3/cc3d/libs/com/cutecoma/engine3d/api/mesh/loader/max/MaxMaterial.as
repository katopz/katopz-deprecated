package com.cutecoma.engine3d.api.mesh.loader.max
{

    public class MaxMaterial extends AbstractMaxParser
    {
        protected var _name:String;
        protected var _textureFilename:String;

        function MaxMaterial(param1:Chunk)
        {
            super(param1);
            
        }

        public function get name() : String
        {
            return _name;
        }

        public function get textureFilename() : String
        {
            return _textureFilename;
        }

        override protected function initialize() : void
        {
            super.initialize();
            _aFunctions[Chunk.MATERIAL] = enterChunk;
            _aFunctions[Chunk.MATERIAL_nAME] = this.parseName;
            _aFunctions[Chunk.MATERIAL_tEXMAP] = enterChunk;
            _aFunctions[Chunk.MATERIAL_MAPNAME] = this.parseTextureFilename;
            
        }

        protected function parseName(param1:Chunk) : void
        {
            _name = param1.readString();
            
        }

        protected function parseTextureFilename(param1:Chunk) : void
        {
            _textureFilename = param1.readString();
            
        }

    }
}
