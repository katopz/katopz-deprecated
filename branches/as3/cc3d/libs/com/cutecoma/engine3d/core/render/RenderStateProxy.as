package com.cutecoma.engine3d.core.render
{

    public class RenderStateProxy extends Object
    {
        private var _FillMode:int = 1;
        private var _TextureSmoothing:Boolean = false;
        private var _Clipping:int = 4;
        private var _ZSorting:int = 2;
        private var _TriangleCulling:String = "positive";

        public function RenderStateProxy()
        {
            
        }

        public function get fillMode() : int
        {
            return _FillMode;
        }

        public function get textureSmoothing() : Boolean
        {
            return _TextureSmoothing;
        }

        public function get clipping() : int
        {
            return _Clipping;
        }

        public function get zSorting() : int
        {
            return _ZSorting;
        }

        public function get triangleCulling() : String
        {
            return _TriangleCulling;
        }

        public function set fillMode(value:int) : void
        {
            _FillMode = value;
        }

        public function set textureSmoothing(value:Boolean) : void
        {
            _TextureSmoothing = value;
        }

        public function set clipping(value:int) : void
        {
            _Clipping = value;
        }

        public function set zSorting(value:int) : void
        {
            _ZSorting = value;
        }

        public function set triangleCulling(value:String) : void
        {
            _TriangleCulling = value;
        }
    }
}