package com.cutecoma.engine3d.api
{

    public class Viewport extends Object
    {
        private var _Width:int = 0;
        private var _Height:int = 0;

        public function Viewport(param1:int, param2:int)
        {
            this._Width = param1;
            this._Height = param2;
            
        }

        public function get width() : int
        {
            return this._Width;
        }

        public function get height() : int
        {
            return this._Height;
        }

    }
}
