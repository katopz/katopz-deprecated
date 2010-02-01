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
            return this._FillMode;
        }

        public function get textureSmoothing() : Boolean
        {
            return this._TextureSmoothing;
        }

        public function get clipping() : int
        {
            return this._Clipping;
        }

        public function get zSorting() : int
        {
            return this._ZSorting;
        }

        public function get triangleCulling() : String
        {
            return this._TriangleCulling;
        }

        public function set fillMode(param1:int) : void
        {
            this._FillMode = param1;
            
        }

        public function set textureSmoothing(param1:Boolean) : void
        {
            this._TextureSmoothing = param1;
            
        }

        public function set clipping(param1:int) : void
        {
            this._Clipping = param1;
            
        }

        public function set zSorting(param1:int) : void
        {
            this._ZSorting = param1;
            
        }

        public function set triangleCulling(param1:String) : void
        {
            this._TriangleCulling = param1;
            
        }

    }
}
