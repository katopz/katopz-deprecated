package com.cutecoma.engine3d.engine
{
    
    
    import flash.display.*;
    import flash.geom.*;
    import flash.utils.*;
    
    import com.cutecoma.engine3d.api.*;
    import com.cutecoma.engine3d.api.light.DirectionalLight;
    import com.cutecoma.engine3d.common.*;
    import com.cutecoma.engine3d.core.signal.*;
    import com.cutecoma.engine3d.engine.camera.*;

    public class GraphicsEngine extends Sprite
    {
        private var _Time:int = 0;
        private var _ElapsedTime:int = 0;
        private var _Framerate:int = 0;
        private var _IsRunning:Boolean = false;
        private var _Device:Device = null;
        private var _Static:Vector.<IDrawable3D>;
        private var _Dynamic:Vector.<IDrawable3D>;
        private var _Camera:AbstractCamera;
        private var _CameraSpeed:Vector3D;
        public static const DRAW_STATIC:int = 1;
        public static const DRAW_DYNAMIC:int = 2;
        public static const CAMERASPEED_LIMIT:Number = 0.0001;

        public function GraphicsEngine(param1:Viewport)
        {
            this._Static = new Vector.<IDrawable3D>;
            this._Dynamic = new Vector.<IDrawable3D>;
            this._Camera = new AbstractCamera();
            this._CameraSpeed = new Vector3D();
            this._Device = new Device(this, param1);
            this._IsRunning = true;
            
        }

        protected function get device() : Device
        {
            return this._Device;
        }

        public function get elapsedTime() : int
        {
            return this._ElapsedTime;
        }

        public function get camera() : AbstractCamera
        {
            return this._Camera;
        }

        public function get cameraSpeed() : Vector3D
        {
            return this._CameraSpeed;
        }

        public function get framerate() : int
        {
            return this._Framerate;
        }

        public function get lights() : Vector.<DirectionalLight>
        {
            return this._Device.lights;
        }

        public function set camera(param1:AbstractCamera) : void
        {
            this._Camera = param1;
            
        }

        public function set viewport(param1:Viewport) : void
        {
            this._Device.viewport = param1;
            
        }

        public function renderFrame() : void
        {
            var _loc_1:int = 0;
            var _loc_2:IDrawable3D = null;
            if (!this._IsRunning || !this._Static.length && !this._Dynamic.length)
            {
                return;
            }
            this.updateCamera();
            this._Device.transform.view = this._Camera.viewMatrix;
            this._Device.clear();
            this._Device.beginScene();
            this._Device.renderStates.clipping = Clipping.ZNEAR;
            for each (_loc_2 in this._Static)
            {
                
                _loc_2.draw(this._Device);
            }
            this._Device.renderStates.clipping = Clipping.IGNORE;
            this._Dynamic = this._Dynamic.sort(this.zSort);
            for each (_loc_2 in this._Dynamic)
            {
                
                _loc_2.draw(this._Device);
            }
            this._Device.endScene();
            this._Device.present();
            this._Dynamic.length = 0;
            this._Static.length = 0;
            _loc_1 = getTimer();
            this._ElapsedTime = _loc_1 - this._Time;
            this._Time = _loc_1;
            this._Framerate = 1000 / this._ElapsedTime;
            
        }

        public function draw(param1:IDrawable3D, param2:int = 2) : void
        {
            if (param2 & DRAW_DYNAMIC)
            {
                this._Dynamic.push(param1);
            }
            else
            {
                this._Static.push(param1);
            }
            
        }

        protected function cameraUpdateHandler(param1:TransformSignal) : void
        {
            this._Device.transform.view = param1.transform;
            
        }

        protected function updateCamera() : void
        {
            if (this._CameraSpeed.x > -CAMERASPEED_LIMIT && this._CameraSpeed.x < CAMERASPEED_LIMIT)
            {
                this._CameraSpeed.x = 0;
            }
            if (this._CameraSpeed.y > -CAMERASPEED_LIMIT && this._CameraSpeed.y < CAMERASPEED_LIMIT)
            {
                this._CameraSpeed.y = 0;
            }
            if (this._CameraSpeed.z > -CAMERASPEED_LIMIT && this._CameraSpeed.z < CAMERASPEED_LIMIT)
            {
                this._CameraSpeed.z = 0;
            }
            
        }

        protected function zSort(param1:IDrawable3D, param2:IDrawable3D) : Number
        {
            var _loc_3:* = Vector3D.distance(param1.position, this.camera.position);
            var _loc_4:* = Vector3D.distance(param2.position, this.camera.position);
            return Vector3D.distance(param2.position, this.camera.position) - _loc_3 < 0 ? (-1) : (1);
        }

    }
}
