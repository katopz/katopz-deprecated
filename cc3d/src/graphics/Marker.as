package graphics
{
    import flash.events.*;
    import flash.geom.*;
    import gs.*;

    public class Marker extends EventDispatcher
    {
        private var _Position:Vector3D = null;
        private var _Latitude:Number = 0;
        private var _Thumbnail:Thumbnail = null;
        private var _Longitude:Number = 0;
        private var _Rotation:Vector3D = null;
        private static const DEG_TO_RAD:Number = 0.0174533;

        public function Marker(param1:String, param2:Number = 0, param3:Number = 0)
        {
            var _loc_4:* = param3 * DEG_TO_RAD + Math.PI;
            _Thumbnail = new Thumbnail(param1);
            _Longitude = param3 * DEG_TO_RAD;
            _Latitude = param2 * DEG_TO_RAD;
            _Thumbnail.rotation.y = -_Longitude + Math.PI / 2;
            _Thumbnail.rotation.x = _Latitude - Math.PI / 2;
            _Thumbnail.position.x = Math.cos(_loc_4) * Math.cos(_Latitude);
            _Thumbnail.position.y = Math.sin(_Latitude);
            _Thumbnail.position.z = Math.sin(_loc_4) * Math.cos(_Latitude);
            _Position = _Thumbnail.position.clone();
            _Rotation = _Thumbnail.rotation.clone();
            _Thumbnail.scale.scaleBy(0.2);
            TweenLite.from(_Thumbnail.position, 2, {x:_Thumbnail.position.x * 5, y:_Thumbnail.position.y * 5, z:_Thumbnail.position.z * 5});
            _Thumbnail.sprite.addEventListener(MouseEvent.CLICK, this.mouseClickHandler);
            
        }

        private function mouseClickHandler(event:MouseEvent) : void
        {
            dispatchEvent(event);
            
        }

        public function get position() : Vector3D
        {
            return _Position;
        }

        public function get thumbnail() : Thumbnail
        {
            return _Thumbnail;
        }

        public function get longitude() : Number
        {
            return _Longitude;
        }

        public function get latitude() : Number
        {
            return _Latitude;
        }

        public function get rotation() : Vector3D
        {
            return _Rotation;
        }

    }
}
