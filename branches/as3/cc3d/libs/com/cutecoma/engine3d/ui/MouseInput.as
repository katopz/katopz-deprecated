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
            this._Position = new Point();
            this._Layer = param1;
            this._GFX = param2;
            this.enable();
            
        }

        public function enable() : void
        {
            this._Layer.addEventListener(MouseEvent.MOUSE_MOVE, this.mouseMoveHandler);
            this._Layer.addEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownHandler);
            this._Layer.addEventListener(MouseEvent.MOUSE_WHEEL, this.mouseWheelHandler);
            
        }

        protected function mouseWheelHandler(event:MouseEvent) : void
        {
            this._GFX.cameraSpeed.z = this._GFX.cameraSpeed.z - 1e-005 * this._GFX.elapsedTime * event.delta;
            
        }

        protected function mouseDownHandler(event:MouseEvent) : void
        {
            this._Position.x = event.stageX;
            this._Position.y = event.stageY;
            this._GFX.cameraSpeed.x = 0;
            this._GFX.cameraSpeed.y = 0;
            this._GFX.cameraSpeed.z = 0;
            
        }

        protected function mouseMoveHandler(event:MouseEvent) : void
        {
            var _loc_2:int = 0;
            var _loc_3:int = 0;
            if (event.buttonDown)
            {
                _loc_2 = event.stageX - this._Position.x;
                _loc_3 = event.stageY - this._Position.y;
                this._GFX.cameraSpeed.x = this._GFX.cameraSpeed.x - 5e-005 * _loc_3;
                this._GFX.cameraSpeed.y = this._GFX.cameraSpeed.y - 5e-005 * _loc_2;
                this._Position.x = event.stageX;
                this._Position.y = event.stageY;
            }
            
        }

        public function disable() : void
        {
            this._Layer.removeEventListener(MouseEvent.MOUSE_MOVE, this.mouseMoveHandler);
            this._Layer.removeEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownHandler);
            this._Layer.removeEventListener(MouseEvent.MOUSE_WHEEL, this.mouseWheelHandler);
            
        }

    }
}
