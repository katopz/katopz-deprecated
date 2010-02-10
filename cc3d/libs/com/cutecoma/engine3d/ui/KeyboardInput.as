package com.cutecoma.engine3d.ui
{
    import flash.display.*;
    import flash.events.*;
    import flash.ui.*;
    import com.cutecoma.engine3d.engine.*;

    public class KeyboardInput extends Object
    {
        private var _layer:Sprite;
        private var _gfx:GraphicsEngine;

        public function KeyboardInput(param1:Sprite, param2:GraphicsEngine)
        {
            _gfx = param2;
            _layer = param1;
            this.enable();
            
        }

        public function enable() : void
        {
            _layer.addEventListener(KeyboardEvent.KEY_DOWN, this.keyDownHandler);
            
        }

        public function disable() : void
        {
            _layer.removeEventListener(KeyboardEvent.KEY_DOWN, this.keyDownHandler);
            
        }

        private function keyDownHandler(event:KeyboardEvent) : void
        {
            var _loc_2:Number = 0;
            var _loc_3:* = event.keyCode;
            var _loc_4:* = String.fromCharCode(event.charCode);
            if (_loc_3 == Keyboard.UP)
            {
                _gfx.cameraSpeed.x = _gfx.cameraSpeed.x - 0.001;
            }
            if (_loc_3 == Keyboard.DOWN)
            {
                _gfx.cameraSpeed.x = _gfx.cameraSpeed.x + 0.001;
            }
            else if (_loc_3 == Keyboard.RIGHT)
            {
                _gfx.cameraSpeed.y = _gfx.cameraSpeed.y + 0.001;
            }
            else if (_loc_3 == Keyboard.LEFT)
            {
                _gfx.cameraSpeed.y = _gfx.cameraSpeed.y - 0.001;
            }
            else if (_loc_3 == Keyboard.PAGE_UP)
            {
                _gfx.cameraSpeed.z = _gfx.cameraSpeed.z - 0.001;
            }
            else if (_loc_3 == Keyboard.PAGE_DOWN)
            {
                _gfx.cameraSpeed.z = _gfx.cameraSpeed.z + 0.001;
            }
            
        }

    }
}
