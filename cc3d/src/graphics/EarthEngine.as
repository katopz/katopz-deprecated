package graphics
{
    import flash.events.*;
    import flash.geom.*;
    import com.cutecoma.engine3d.api.*;
    import com.cutecoma.engine3d.engine.*;
    import com.cutecoma.engine3d.engine.camera.*;

    public class EarthEngine extends GraphicsEngine
    {
        private static const CAMERA_SPEED_SCALE:Number = 0.85;

        public function EarthEngine(param1:Viewport)
        {
            super(param1);
            camera = new FreeChaseCamera();
            camera.distance = 5;
            
        }

        private function mouseMoveHandler(event:MouseEvent) : void
        {
            var _loc_2:* = event.stageX;
            var _loc_3:* = event.stageY;
            var _loc_4:* = Math.tan(Math.PI / 8);
            var _loc_5:* = Math.tan(Math.PI / 8) * (_loc_2 / (device.viewport.width / 2))-1 / 1.33333;
            var _loc_6:* = _loc_4 * (1 - _loc_3 / (device.viewport.height / 2));
            var _loc_7:* = device.transform.view.clone();
            var _loc_8:* = new Vector3D(_loc_5 * 0.01, _loc_6 * 0.01, 0.01);
            var _loc_9:* = new Vector3D(_loc_5 * 100, _loc_6 * 100, 100);
            var _loc_10:Vector3D = null;
            _loc_7.invert();
            _loc_8 = _loc_7.transformVector(_loc_8);
            _loc_9 = _loc_7.transformVector(_loc_9);
            _loc_10 = _loc_9.subtract(_loc_8);
            _loc_10.normalize();
            var _loc_11:* = _loc_7.position.length;
            var _loc_12:* = _loc_8.dotProduct(_loc_10);
            var _loc_14:* = _loc_12 * _loc_12 - _loc_8.dotProduct(_loc_8)-1;
            var _loc_15:* = -_loc_12 - Math.sqrt(_loc_14);
            var _loc_16:* = 1 - (_loc_11 - _loc_15) / _loc_11;
            var _loc_17:* = new Vector3D(_loc_8.x + _loc_16 * _loc_10.x, _loc_8.y + _loc_16 * _loc_10.y, _loc_8.z + _loc_16 * _loc_10.z);
            
        }

        override protected function updateCamera() : void
        {
            super.updateCamera();
            camera.yaw = camera.yaw + cameraSpeed.y * elapsedTime;
            camera.pitch = camera.pitch + cameraSpeed.x * elapsedTime;
            camera.distance = camera.distance + cameraSpeed.z * elapsedTime;
            if (camera.distance < 3)
            {
                camera.distance = 3;
            }
            else if (camera.distance > 7)
            {
                camera.distance = 7;
            }
            cameraSpeed.scaleBy(CAMERA_SPEED_SCALE);
            
        }

    }
}
