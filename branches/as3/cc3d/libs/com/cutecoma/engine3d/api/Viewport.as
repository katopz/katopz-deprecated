package com.cutecoma.engine3d.api
{
    public class Viewport extends Object
    {
        private var _width:int = 0;
        private var _height:int = 0;

        public function Viewport(width:int, height:int)
        {
            _width = width;
            _height = height;
        }

        public function get width() : int
        {
            return _width;
        }

        public function get height() : int
        {
            return _height;
        }
    }
}