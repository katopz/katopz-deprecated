package com.cutecoma.engine3d.api.mesh.loader.max
{
    import flash.events.*;
    import flash.net.*;
    import flash.utils.*;

    public class Max3DSLoader extends EventDispatcher
    {
        protected var _textureFolder:String;
        protected var _Max3DS:Max3DS;

        public function Max3DSLoader(param1:String = null)
        {
            _textureFolder = param1;
            
        }

        public function get max3DS() : Max3DS
        {
            return _Max3DS;
        }

        public function load(param1:String) : void
        {
            var _loc_2:* = new URLLoader();
            _loc_2.addEventListener(Event.COMPLETE, this.complteHandler);
            _loc_2.dataFormat = URLLoaderDataFormat.BINARY;
            _loc_2.load(new URLRequest(param1));
            
        }

        public function loadAsset(param1:Class) : void
        {
            this.loadByteArray(new param1 as ByteArray);
            
        }

        public function loadByteArray(param1:ByteArray) : void
        {
            _Max3DS = new Max3DS(_textureFolder, param1);
            
        }

        private function complteHandler(event:Event) : void
        {
            _Max3DS = new Max3DS(_textureFolder, event.target.data as ByteArray);
            dispatchEvent(new Event(Event.COMPLETE));
            
        }

    }
}
