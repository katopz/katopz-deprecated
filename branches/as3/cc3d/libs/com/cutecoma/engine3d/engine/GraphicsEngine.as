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
            _Static = new Vector.<IDrawable3D>;
            _Dynamic = new Vector.<IDrawable3D>;
            _Camera = new AbstractCamera();
            _CameraSpeed = new Vector3D();
            _Device = new Device(this, param1);
            _IsRunning = true;
            
        }

        protected function get device() : Device
        {
            return _Device;
        }

        public function get elapsedTime() : int
        {
            return _ElapsedTime;
        }

        public function get camera() : AbstractCamera
        {
            return _Camera;
        }

        public function get cameraSpeed() : Vector3D
        {
            return _CameraSpeed;
        }

        public function get framerate() : int
        {
            return _Framerate;
        }

        public function get lights() : Vector.<DirectionalLight>
        {
            return _Device.lights;
        }

        public function set camera(value:AbstractCamera) : void
        {
            _Camera = value;
            
        }

        public function set viewport(value:Viewport) : void
        {
            _Device.viewport = value;
            
        }

        public function renderFrame() : void
        {
            var _loc_1:int = 0;
            var _loc_2:IDrawable3D = null;
            if (!_IsRunning || !_Static.length && !_Dynamic.length)
            {
                return;
            }
            this.updateCamera();
            _Device.transform.view = _Camera.viewMatrix;
            _Device.clear();
            _Device.beginScene();
            _Device.renderStates.clipping = Clipping.ZNEAR;
            for each (_loc_2 in _Static)
            {
                
                _loc_2.draw(_Device);
            }
            _Device.renderStates.clipping = Clipping.IGNORE;
            _Dynamic = _Dynamic.sort(this.zSort);
            for each (_loc_2 in _Dynamic)
            {
                
                _loc_2.draw(_Device);
            }
            _Device.endScene();
            _Device.present();
            _Dynamic.length = 0;
            _Static.length = 0;
            _loc_1 = getTimer();
            _ElapsedTime = _loc_1 - _Time;
            _Time = _loc_1;
            _Framerate = 1000 / _ElapsedTime;
            
        }

        public function draw(param1:IDrawable3D, param2:int = 2) : void
        {
            if (param2 & DRAW_DYNAMIC)
            {
                _Dynamic.push(param1);
            }
            else
            {
                _Static.push(param1);
            }
            
        }

        protected function cameraUpdateHandler(param1:TransformSignal) : void
        {
            _Device.transform.view = param1.transform;
            
        }

        protected function updateCamera() : void
        {
            if (_CameraSpeed.x > -CAMERASPEED_LIMIT && _CameraSpeed.x < CAMERASPEED_LIMIT)
            {
                _CameraSpeed.x = 0;
            }
            if (_CameraSpeed.y > -CAMERASPEED_LIMIT && _CameraSpeed.y < CAMERASPEED_LIMIT)
            {
                _CameraSpeed.y = 0;
            }
            if (_CameraSpeed.z > -CAMERASPEED_LIMIT && _CameraSpeed.z < CAMERASPEED_LIMIT)
            {
                _CameraSpeed.z = 0;
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
