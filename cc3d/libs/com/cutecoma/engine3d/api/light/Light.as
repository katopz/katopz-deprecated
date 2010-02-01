package com.cutecoma.engine3d.api.light
{
    import com.cutecoma.engine3d.common.utils.*;

    public class Light extends Object
    {
        protected var _Enabled:Boolean = false;
        protected var _Diffuse:Color;
        protected var _Ambient:Color;

        public function Light()
        {
            this._Diffuse = Color.WHITE;
            this._Ambient = Color.WHITE;
            
        }

        public function get ambient() : Color
        {
            return this._Ambient;
        }

        public function get diffuse() : Color
        {
            return this._Diffuse;
        }

        public function get enabled() : Boolean
        {
            return this._Enabled;
        }

        public function set ambient(param1:Color) : void
        {
            this._Ambient = param1;
            
        }

        public function set diffuse(param1:Color) : void
        {
            this._Diffuse = param1;
            
        }

        public function set enabled(param1:Boolean) : void
        {
            this._Enabled = param1;
            
        }

    }
}
