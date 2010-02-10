package com.cutecoma.engine3d.ui
{
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import com.cutecoma.engine3d.engine.*;

    public class MouseInput extends Object
    {
        private var _Layer:Sprite = null;
        private var _Position:Point;
        private var _GFX:GraphicsEngine = null;

        public function MouseInput(param1:Sprite, param2:GraphicsEngine)
        {
            _Position = new Point();
            _Layer = param1;
            _GFX = param2;
            this.enable();
            
        }

        public function enable() : void
        {
            _Layer.addEventListener(MouseEvent.MOUSE_MOVE, this.mouseMoveHandler);
            _Layer.addEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownHandler);
            _Layer.addEventListener(MouseEvent.MOUSE_WHEEL, this.mouseWheelHandler);
            
        }

        protected function mouseWheelHandler(event:MouseEvent) : void
        {
            _GFX.cameraSpeed.z = _GFX.cameraSpeed.z - 1e-005 * _GFX.elapsedTime * event.delta;
            
        }

        protected function mouseDownHandler(event:MouseEvent) : void
        {
            _Position.x = event.stageX;
            _Position.y = event.stageY;
            _GFX.cameraSpeed.x = 0;
            _GFX.cameraSpeed.y = 0;
            _GFX.cameraSpeed.z = 0;
            
        }

        protected function mouseMoveHandler(event:MouseEvent) : void
        {
            var _loc_2:int = 0;
            var _loc_3:int = 0;
            if (event.buttonDown)
            {
                _loc_2 = event.stageX - _Position.x;
                _loc_3 = event.stageY - _Position.y;
                _GFX.cameraSpeed.x = _GFX.cameraSpeed.x - 5e-005 * _loc_3;
                _GFX.cameraSpeed.y = _GFX.cameraSpeed.y - 5e-005 * _loc_2;
                _Position.x = event.stageX;
                _Position.y = event.stageY;
            }
            
        }

        public function disable() : void
        {
            _Layer.removeEventListener(MouseEvent.MOUSE_MOVE, this.mouseMoveHandler);
            _Layer.removeEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownHandler);
            _Layer.removeEventListener(MouseEvent.MOUSE_WHEEL, this.mouseWheelHandler);
            
        }

    }
}
