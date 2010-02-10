package com.cutecoma.engine3d.common.utils
{

    public class Color extends Object
    {
        protected var _a:int = 0;
        protected var _r:int = 0;
        protected var _g:int = 0;
        protected var _b:int = 0;
        public static const WHITE:Color = new Color(16777215);
        public static const BLACK:Color = new Color(0);
        public static const RED:Color = new Color(16711680);
        public static const GREEN:Color = new Color(65280);
        public static const BLUE:Color = new Color(255);
        public static const GREY:Color = new Color(7829367);
        public static const DARK_gREY:Color = new Color(2236962);
        public static const SKY_bLUE:Color = new Color(3714284);
        public static const NAVY_bLUE:Color = new Color(128);
        public static const ROYAL_bLUE:Color = new Color(4286945);
        public static const PURPLE:Color = new Color(10494192);
        public static const YELLOW:Color = new Color(16774656);
        public static const ORANGE:Color = new Color(16753152);
        public static const PINK:Color = new Color(16711896);

        public function Color(param1:int)
        {
            _a = param1 >> 24 & 255;
            _r = param1 >> 16 & 255;
            _g = param1 >> 8 & 255;
            _b = param1 & 255;
            
        }

        public function get a() : int
        {
            return _a;
        }

        public function get r() : int
        {
            return _r;
        }

        public function get g() : int
        {
            return _g;
        }

        public function get b() : int
        {
            return _b;
        }

        public function set a(value:int) : void
        {
            _a = value & 255;
            
        }

        public function set r(value:int) : void
        {
            _r = value & 255;
            
        }

        public function set g(value:int) : void
        {
            _g = value & 255;
            
        }

        public function set b(value:int) : void
        {
            _b = value & 255;
            
        }

        public function toInt() : int
        {
            return (_a << 24) + (_r << 16) + (_g << 8) + _b;
        }

        public static function fromArgb(param1:int, param2:int, param3:int, param4:int) : Color
        {
            var _loc_5:int = 0;
            _loc_5 = 0 + ((param1 & 255) << 24);
            _loc_5 = _loc_5 + ((param2 & 255) << 16);
            _loc_5 = _loc_5 + ((param3 & 255) << 8);
            _loc_5 = _loc_5 + (param4 & 255);
            return new Color(_loc_5);
        }

        public static function fromRgb(param1:int, param2:int, param3:int) : Color
        {
            var _loc_4:int = 0;
            _loc_4 = 0 + (param1 << 16);
            _loc_4 = _loc_4 + (param2 << 8);
            _loc_4 = _loc_4 + param3;
            return new Color(_loc_4);
        }

        public static function random() : Color
        {
            return new Color(Math.round(Math.random() * 16777215));
        }

    }
}
