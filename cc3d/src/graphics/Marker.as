package graphics
{
    import flash.events.*;
    import flash.geom.*;
    import gs.*;

    public class Marker extends EventDispatcher
    {
        private var _position:Vector3D;
        private var _latitude:Number = 0;
        private var _thumbnail:Thumbnail;
        private var _longitude:Number = 0;
        private var _rotation:Vector3D;
        private static const DEG_tO_rAD:Number = 0.0174533;

        public function Marker(param1:String, param2:Number = 0, param3:Number = 0)
        {
            var _loc_4:* = param3 * DEG_tO_rAD + Math.PI;
            _thumbnail = new Thumbnail(param1);
            _longitude = param3 * DEG_tO_rAD;
            _latitude = param2 * DEG_tO_rAD;
            _thumbnail.rotation.y = -_longitude + Math.PI / 2;
            _thumbnail.rotation.x = _latitude - Math.PI / 2;
            _thumbnail.position.x = Math.cos(_loc_4) * Math.cos(_latitude);
            _thumbnail.position.y = Math.sin(_latitude);
            _thumbnail.position.z = Math.sin(_loc_4) * Math.cos(_latitude);
            _position = _thumbnail.position.clone();
            _rotation = _thumbnail.rotation.clone();
            _thumbnail.scale.scaleBy(0.2);
            TweenLite.from(_thumbnail.position, 2, {x:_thumbnail.position.x * 5, y:_thumbnail.position.y * 5, z:_thumbnail.position.z * 5});
            _thumbnail.sprite.addEventListener(MouseEvent.CLICK, this.mouseClickHandler);
            
        }

        private function mouseClickHandler(event:MouseEvent) : void
        {
            dispatchEvent(event);
            
        }

        public function get position() : Vector3D
        {
            return _position;
        }

        public function get thumbnail() : Thumbnail
        {
            return _thumbnail;
        }

        public function get longitude() : Number
        {
            return _longitude;
        }

        public function get latitude() : Number
        {
            return _latitude;
        }

        public function get rotation() : Vector3D
        {
            return _rotation;
        }

    }
}
