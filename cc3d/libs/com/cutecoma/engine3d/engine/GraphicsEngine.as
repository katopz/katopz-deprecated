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
        private var _time:int = 0;
        private var _elapsedTime:int = 0;
        private var _framerate:int = 0;
        private var _isRunning:Boolean = false;
        private var _device:Device;
        private var _static:Vector.<IDrawable3D>;
        private var _dynamic:Vector.<IDrawable3D>;
        private var _camera:AbstractCamera;
        private var _cameraSpeed:Vector3D;
        
        public static const DRAW_STATIC:int = 1;
        public static const DRAW_DYNAMIC:int = 2;
        public static const CAMERASPEED_LIMIT:Number = 0.0001;

        public function GraphicsEngine(viewport:Viewport)
        {
            _static = new Vector.<IDrawable3D>;
            _dynamic = new Vector.<IDrawable3D>;
            _camera = new AbstractCamera();
            _cameraSpeed = new Vector3D();
            _device = new Device(this, viewport);
            _isRunning = true;
        }

        protected function get device() : Device
        {
            return _device;
        }

        public function get elapsedTime() : int
        {
            return _elapsedTime;
        }

        public function get camera() : AbstractCamera
        {
            return _camera;
        }

        public function get cameraSpeed() : Vector3D
        {
            return _cameraSpeed;
        }

        public function get framerate() : int
        {
            return _framerate;
        }

        public function get lights() : Vector.<DirectionalLight>
        {
            return _device.lights;
        }

        public function set camera(value:AbstractCamera) : void
        {
            _camera = value;
        }

        public function set viewport(value:Viewport) : void
        {
            _device.viewport = value;
        }

        public function renderFrame() : void
        {
            var _loc_1:int = 0;
            var _loc_2:IDrawable3D;
            if (!_isRunning || !_static.length && !_dynamic.length)
                return;
            
            updateCamera();
            
            _device.transform.view = _camera.viewMatrix;
            _device.clear();
            _device.beginScene();
            _device.renderStates.clipping = Clipping.ZNEAR;
            
            for each (_loc_2 in _static)
                _loc_2.draw(_device);
            
            _device.renderStates.clipping = Clipping.IGNORE;
            _dynamic = _dynamic.sort(this.zSort);
            
            for each (_loc_2 in _dynamic)
                _loc_2.draw(_device);
           
            _device.endScene();
            _device.present();
            _dynamic.length = 0;
            _static.length = 0;
            _loc_1 = getTimer();
            _elapsedTime = _loc_1 - _time;
            _time = _loc_1;
            _framerate = 1000 / _elapsedTime;
        }

        public function draw(canvas3D:IDrawable3D, drawType:int = 2) : void
        {
            if (drawType & DRAW_DYNAMIC)
                _dynamic.push(canvas3D);
            else
                _static.push(canvas3D);
        }

        protected function cameraUpdateHandler(transformSignal:TransformSignal) : void
        {
            _device.transform.view = transformSignal.transform;
        }

        protected function updateCamera() : void
        {
            if (_cameraSpeed.x > -CAMERASPEED_LIMIT && _cameraSpeed.x < CAMERASPEED_LIMIT)
                _cameraSpeed.x = 0;
            if (_cameraSpeed.y > -CAMERASPEED_LIMIT && _cameraSpeed.y < CAMERASPEED_LIMIT)
                _cameraSpeed.y = 0;
            if (_cameraSpeed.z > -CAMERASPEED_LIMIT && _cameraSpeed.z < CAMERASPEED_LIMIT)
                _cameraSpeed.z = 0;
        }

        protected function zSort(a:IDrawable3D, b:IDrawable3D) : Number
        {
            var _distance:Number = Vector3D.distance(a.position, camera.position);
           // var _loc_4:* = Vector3D.distance(b.position, camera.position);
            return Vector3D.distance(b.position, camera.position) - _distance < 0 ? (-1) : (1);
        }
    }
}