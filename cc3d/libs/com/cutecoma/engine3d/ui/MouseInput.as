package com.cutecoma.engine3d.ui
{
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import com.cutecoma.engine3d.engine.*;

    public class MouseInput extends Object
    {
        private var _layer:Sprite;
        private var _position:Point;
        private var _gFX:GraphicsEngine;

        public function MouseInput(param1:Sprite, param2:GraphicsEngine)
        {
            _position = new Point();
            _layer = param1;
            _gFX = param2;
            this.enable();
            
        }

        public function enable() : void
        {
            _layer.addEventListener(MouseEvent.MOUSE_MOVE, this.mouseMoveHandler);
            _layer.addEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownHandler);
            _layer.addEventListener(MouseEvent.MOUSE_WHEEL, this.mouseWheelHandler);
            
        }

        protected function mouseWheelHandler(event:MouseEvent) : void
        {
            _gFX.cameraSpeed.z = _gFX.cameraSpeed.z - 1e-005 * _gFX.elapsedTime * event.delta;
            
        }

        protected function mouseDownHandler(event:MouseEvent) : void
        {
            _position.x = event.stageX;
            _position.y = event.stageY;
            _gFX.cameraSpeed.x = 0;
            _gFX.cameraSpeed.y = 0;
            _gFX.cameraSpeed.z = 0;
            
        }

        protected function mouseMoveHandler(event:MouseEvent) : void
        {
            var _loc_2:int = 0;
            var _loc_3:int = 0;
            if (event.buttonDown)
            {
                _loc_2 = event.stageX - _position.x;
                _loc_3 = event.stageY - _position.y;
                _gFX.cameraSpeed.x = _gFX.cameraSpeed.x - 5e-005 * _loc_3;
                _gFX.cameraSpeed.y = _gFX.cameraSpeed.y - 5e-005 * _loc_2;
                _position.x = event.stageX;
                _position.y = event.stageY;
            }
            
        }

        public function disable() : void
        {
            _layer.removeEventListener(MouseEvent.MOUSE_MOVE, this.mouseMoveHandler);
            _layer.removeEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownHandler);
            _layer.removeEventListener(MouseEvent.MOUSE_WHEEL, this.mouseWheelHandler);
            
        }

    }
}
