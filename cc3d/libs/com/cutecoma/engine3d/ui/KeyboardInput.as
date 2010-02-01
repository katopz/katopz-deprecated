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
            this._Gfx = param2;
            this._Layer = param1;
            this.enable();
            
        }

        public function enable() : void
        {
            this._Layer.addEventListener(KeyboardEvent.KEY_DOWN, this.keyDownHandler);
            
        }

        public function disable() : void
        {
            this._Layer.removeEventListener(KeyboardEvent.KEY_DOWN, this.keyDownHandler);
            
        }

        private function keyDownHandler(event:KeyboardEvent) : void
        {
            var _loc_2:Number = 0;
            var _loc_3:* = event.keyCode;
            var _loc_4:* = String.fromCharCode(event.charCode);
            if (_loc_3 == Keyboard.UP)
            {
                this._Gfx.cameraSpeed.x = this._Gfx.cameraSpeed.x - 0.001;
            }
            if (_loc_3 == Keyboard.DOWN)
            {
                this._Gfx.cameraSpeed.x = this._Gfx.cameraSpeed.x + 0.001;
            }
            else if (_loc_3 == Keyboard.RIGHT)
            {
                this._Gfx.cameraSpeed.y = this._Gfx.cameraSpeed.y + 0.001;
            }
            else if (_loc_3 == Keyboard.LEFT)
            {
                this._Gfx.cameraSpeed.y = this._Gfx.cameraSpeed.y - 0.001;
            }
            else if (_loc_3 == Keyboard.PAGE_UP)
            {
                this._Gfx.cameraSpeed.z = this._Gfx.cameraSpeed.z - 0.001;
            }
            else if (_loc_3 == Keyboard.PAGE_DOWN)
            {
                this._Gfx.cameraSpeed.z = this._Gfx.cameraSpeed.z + 0.001;
            }
            
        }

    }
}
