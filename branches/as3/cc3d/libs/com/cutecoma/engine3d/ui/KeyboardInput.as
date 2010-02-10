package com.cutecoma.engine3d.ui
{
    import flash.display.*;
    import flash.events.*;
    import flash.ui.*;
    import com.cutecoma.engine3d.engine.*;

    public class KeyboardInput extends Object
    {
        private var _Layer:Sprite = null;
        private var _Gfx:GraphicsEngine = null;

        public function KeyboardInput(param1:Sprite, param2:GraphicsEngine)
        {
            _Gfx = param2;
            _Layer = param1;
            this.enable();
            
        }

        public function enable() : void
        {
            _Layer.addEventListener(KeyboardEvent.KEY_DOWN, this.keyDownHandler);
            
        }

        public function disable() : void
        {
            _Layer.removeEventListener(KeyboardEvent.KEY_DOWN, this.keyDownHandler);
            
        }

        private function keyDownHandler(event:KeyboardEvent) : void
        {
            var _loc_2:Number = 0;
            var _loc_3:* = event.keyCode;
            var _loc_4:* = String.fromCharCode(event.charCode);
            if (_loc_3 == Keyboard.UP)
            {
                _Gfx.cameraSpeed.x = _Gfx.cameraSpeed.x - 0.001;
            }
            if (_loc_3 == Keyboard.DOWN)
            {
                _Gfx.cameraSpeed.x = _Gfx.cameraSpeed.x + 0.001;
            }
            else if (_loc_3 == Keyboard.RIGHT)
            {
                _Gfx.cameraSpeed.y = _Gfx.cameraSpeed.y + 0.001;
            }
            else if (_loc_3 == Keyboard.LEFT)
            {
                _Gfx.cameraSpeed.y = _Gfx.cameraSpeed.y - 0.001;
            }
            else if (_loc_3 == Keyboard.PAGE_UP)
            {
                _Gfx.cameraSpeed.z = _Gfx.cameraSpeed.z - 0.001;
            }
            else if (_loc_3 == Keyboard.PAGE_DOWN)
            {
                _Gfx.cameraSpeed.z = _Gfx.cameraSpeed.z + 0.001;
            }
            
        }

    }
}
