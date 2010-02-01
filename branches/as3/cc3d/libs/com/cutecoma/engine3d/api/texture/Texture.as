package com.cutecoma.engine3d.api.texture
{
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import mx.core.*;

    public class Texture extends EventDispatcher
    {
        protected var _Bitmap:Bitmap = null;
        protected var _Repeat:Boolean = false;

        public function Texture(param1:BitmapData = null)
        {
            this._Bitmap = new Bitmap(param1);
            
        }

        public function get bitmap() : Bitmap
        {
            return this._Bitmap;
        }

        public function get bitmapData() : BitmapData
        {
            return this._Bitmap.bitmapData;
        }

        public function get repeat() : Boolean
        {
            return this._Repeat;
        }

        public function set bitmapData(param1:BitmapData) : void
        {
            this._Bitmap.bitmapData = param1;
            
        }

        public function set repeat(param1:Boolean) : void
        {
            this._Repeat = param1;
            
        }

        public function loadBitmapData(param1:BitmapData) : void
        {
            this._Bitmap.bitmapData = param1;
            
        }

        public function loadFile(param1:String) : void
        {
            var _loc_2:* = new Loader();
            _loc_2.contentLoaderInfo.addEventListener(Event.COMPLETE, this.loadCompleteHandler);
            _loc_2.load(new URLRequest(param1));
            
        }

        private function loadCompleteHandler(event:Event) : void
        {
            this.loadBitmapData(event.target.content.bitmapData);
            dispatchEvent(new Event(Event.COMPLETE));
            
        }

        public static function fromBitmap(param1:Bitmap) : Texture
        {
            return new Texture(param1.bitmapData);
        }

        public static function fromAsset(param1:Class) : Texture
        {
            var _loc_2:* = new param1 as DisplayObject;
            var _loc_3:Texture = null;
            if (_loc_2 is BitmapAsset)
            {
                _loc_3 = new Texture((_loc_2 as Bitmap).bitmapData);
            }
            else if (_loc_2 is SpriteAsset)
            {
                _loc_3 = new Texture;
                _loc_3.bitmapData = new BitmapData(int(_loc_2.width), int(_loc_2.height), true, 0);
                _loc_3.bitmapData.draw(_loc_2);
            }
            return _loc_3;
        }

        public static function fromFile(param1:String) : Texture
        {
            var new_texture:Texture;
            var myFilename:* = param1;
            new_texture = new Texture;
            var loader:* = new Loader();
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function (event:Event) : void
            {
                new_texture.loadBitmapData(event.target.content.bitmapData);
                
            }
            );
            loader.load(new URLRequest(myFilename));
            return new_texture;
        }

    }
}
