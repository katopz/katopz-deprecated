package com.cutecoma.engine3d.api.mesh.loader.max
{

    public class AbstractMaxParser extends Object
    {
        protected var _AFunctions:Array = null;

        public function AbstractMaxParser(param1:Chunk)
        {
            this.initialize();
            this.parseChunk(param1);
            this.finalize();
            
        }

        protected function initialize() : void
        {
            this._AFunctions = new Array();
            
        }

        protected function finalize() : void
        {
            
        }

        final protected function parseChunk(param1:Chunk) : void
        {
            var _loc_2:* = this._AFunctions[param1.identifier];
            if (_loc_2 == null)
            {
                param1.skip();
                return;
            }
            _loc_2(param1);
            this.enterChunk(param1);
            
        }

        final protected function enterChunk(param1:Chunk) : void
        {
            var _loc_2:Chunk = null;
            var _loc_3:Function = null;
            while (param1.bytesAvailable)
            {
                
                _loc_2 = new Chunk(param1.data);
                _loc_3 = this._AFunctions[_loc_2.identifier];
                if (_loc_3 == null)
                {
                    _loc_2.skip();
                    continue;
                }
                if (_loc_3 != this.enterChunk)
                {
                    _loc_3(_loc_2);
                }
            }
            
        }

    }
}
