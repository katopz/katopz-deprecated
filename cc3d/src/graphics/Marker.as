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
            this._Thumbnail = new Thumbnail(param1);
            this._Longitude = param3 * DEG_TO_RAD;
            this._Latitude = param2 * DEG_TO_RAD;
            this._Thumbnail.rotation.y = -this._Longitude + Math.PI / 2;
            this._Thumbnail.rotation.x = this._Latitude - Math.PI / 2;
            this._Thumbnail.position.x = Math.cos(_loc_4) * Math.cos(this._Latitude);
            this._Thumbnail.position.y = Math.sin(this._Latitude);
            this._Thumbnail.position.z = Math.sin(_loc_4) * Math.cos(this._Latitude);
            this._Position = this._Thumbnail.position.clone();
            this._Rotation = this._Thumbnail.rotation.clone();
            this._Thumbnail.scale.scaleBy(0.2);
            TweenLite.from(this._Thumbnail.position, 2, {x:this._Thumbnail.position.x * 5, y:this._Thumbnail.position.y * 5, z:this._Thumbnail.position.z * 5});
            this._Thumbnail.sprite.addEventListener(MouseEvent.CLICK, this.mouseClickHandler);
            
        }

        private function mouseClickHandler(event:MouseEvent) : void
        {
            dispatchEvent(event);
            
        }

        public function get position() : Vector3D
        {
            return this._Position;
        }

        public function get thumbnail() : Thumbnail
        {
            return this._Thumbnail;
        }

        public function get longitude() : Number
        {
            return this._Longitude;
        }

        public function get latitude() : Number
        {
            return this._Latitude;
        }

        public function get rotation() : Vector3D
        {
            return this._Rotation;
        }

    }
}
