package com.cutecoma.engine3d.api.mesh.loader.max
{

    public class MaxMaterial extends AbstractMaxParser
    {
        protected var _Name:String = null;
        protected var _TextureFilename:String = null;

        function MaxMaterial(param1:Chunk)
        {
            super(param1);
            
        }

        public function get name() : String
        {
            return this._Name;
        }

        public function get textureFilename() : String
        {
            return this._TextureFilename;
        }

        override protected function initialize() : void
        {
            super.initialize();
            _AFunctions[Chunk.MATERIAL] = enterChunk;
            _AFunctions[Chunk.MATERIAL_NAME] = this.parseName;
            _AFunctions[Chunk.MATERIAL_TEXMAP] = enterChunk;
            _AFunctions[Chunk.MATERIAL_MAPNAME] = this.parseTextureFilename;
            
        }

        protected function parseName(param1:Chunk) : void
        {
            this._Name = param1.readString();
            
        }

        protected function parseTextureFilename(param1:Chunk) : void
        {
            this._TextureFilename = param1.readString();
            
        }

    }
}
