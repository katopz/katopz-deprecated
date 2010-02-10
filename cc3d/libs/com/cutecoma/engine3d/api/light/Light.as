package com.cutecoma.engine3d.api.light
{
    import com.cutecoma.engine3d.common.utils.*;

    public class Light extends Object
    {
        protected var _Enabled:Boolean = false;
        protected var _Diffuse:Color;
        protected var _ambient:Color;

        public function Light()
        {
            _Diffuse = Color.WHITE;
            _ambient = Color.WHITE;
            
        }

        public function get ambient() : Color
        {
            return _ambient;
        }

        public function get diffuse() : Color
        {
            return _Diffuse;
        }

        public function get enabled() : Boolean
        {
            return _Enabled;
        }

        public function set ambient(value:Color) : void
        {
            _ambient = value;
            
        }

        public function set diffuse(value:Color) : void
        {
            _Diffuse = value;
            
        }

        public function set enabled(value:Boolean) : void
        {
            _Enabled = value;
            
        }

    }
}
