/*
Copyright (c) 2008 David Lenaerts.  See:
    http://code.google.com/p/wick3d
    http://www.derschmale.com

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/

package com.derschmale.display.io
{
	import com.derschmale.events.ImageLoaderEvent;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	/**
	 * The PCXLoader class loads a PCX image file into a BitmapData object. Currently, only files with a maximum of 256 colours are supported.
	 * 
	 * @author David Lenaerts
	 */
	public class PCXLoader extends EventDispatcher
	{
		private var _loader : URLLoader;
		private var _filename : String;
		private var _bitmapData : BitmapData;
		
		private var _byteArray : ByteArray;
		private var _version : int;
		private var _bpp : int;
		private var _xMin : int;
		private var _yMin : int;
		private var _xMax : int;
		private var _yMax : int;
		private var _height : int;
		private var _width : int;
		private var _vertDPI : int;
		private var _palette : Array;
		private var _colorPlanes : int;
		private var _bytesPerLine : int;
		private var _paletteType : int;
		
		
		private static const PCX_MANUFACTURER : int = 0x0a; 
		private static const PCX_VERSION_2_5 : int = 0; 
		private static const PCX_VERSION_2_8_PALETTE : int = 2;
		private static const PCX_VERSION_2_8_DEFAULT_PALETTE : int = 3;
		private static const PCX_VERSION_3 : int = 5;
		private static const PCX_ENCODING : int = 0x01;
		private static const PCX_COLOR_PLANES_16 : int = 4;
		private static const PCX_COLOR_PLANES_24bit : int = 3;
		
		/**
		 * Creates a new PCXLoader instance.
		 */
		public function PCXLoader()
		{
			super();
			_loader = new URLLoader();
			_loader.dataFormat = URLLoaderDataFormat.BINARY;
		}
		
		/**
		 * Loads a PCX file. When the image has finished loading, ImageLoaderEvent.IMAGE_LOADED will be dispatched.
		 * 
		 * @param filename The filename of the pcx file.
		 */
		public function loadPCX(filename : String) : void
		{
			_filename = filename;
			_loader.addEventListener(Event.COMPLETE, handlePCXLoaded);
			_loader.load(new URLRequest(filename));
		}
		
		/**
		 * The loaded image as BitmapData. This value is null until ImageLoaderEvent.IMAGE_LOADED is dispatched.
		 */
		public function get bitmapData() : BitmapData
		{
			return _bitmapData;
		}
		
		private function handlePCXLoaded(event : Event) : void
		{
			_loader.removeEventListener(Event.COMPLETE, handlePCXLoaded);
			_byteArray = _loader.data;
			_byteArray.endian = Endian.LITTLE_ENDIAN;
			parseHeader();
			parseData();
			
			dispatchEvent(new ImageLoaderEvent(ImageLoaderEvent.IMAGE_LOADED, _bitmapData));
		}
		
		private function parseHeader() : void
		{
			var manufacturer : int;
			var encoding : int;
			var r : int, g : int, b : int;
			manufacturer = _byteArray.readByte();
			if (manufacturer != PCX_MANUFACTURER) throw new Error("Invaldig PCX File "+_filename+" (header info 'manufacturer' invalid)");
			
			_version = _byteArray.readByte();
			encoding = _byteArray.readByte();
			if (encoding != PCX_ENCODING) throw new Error("Invaldig PCX File "+_filename+" (header info 'encoding' invalid)");
			
			_bpp = _byteArray.readByte();
			_xMin = _byteArray.readShort();
			_yMin = _byteArray.readShort();
			_xMax = _byteArray.readShort();
			_yMax = _byteArray.readShort();
			_width = _xMax-_xMin+1;
			_height = _yMax-_yMin+1;
			
			_vertDPI = _byteArray.readShort();
			_palette = [];
			
			if (_bpp <= 4) {
				for (var i : int = 0; i < 16; i++) {
					// only in the header with <16 colours, otherwise before EOF
					r = _byteArray.readUnsignedByte();
					g = _byteArray.readUnsignedByte();
					b = _byteArray.readUnsignedByte();
					_palette.push((r<<16)+(g<<8)+b);
				}
			}
			else _byteArray.position += 48;
			
			// reserved
			_byteArray.position++;
			
			_colorPlanes = _byteArray.readByte();
			_bytesPerLine = _byteArray.readShort();
			_paletteType = _byteArray.readShort();
			
			if (_bpp == 8) {
				_byteArray.position = _byteArray.length-769;
				_byteArray.readUnsignedByte();
				for (i = 0; i < 256; i++) {
					r = _byteArray.readUnsignedByte();
					g = _byteArray.readUnsignedByte();
					b = _byteArray.readUnsignedByte();
					_palette.push((r<<16)+(g<<8)+b);
				}
			}
		}
		
		// currently only parses images using a palette
		private function parseData() : void
		{
			var colour : int;
			var filledArray : ByteArray = new ByteArray();
			var byte : int;
			var length : int;
			var i : int = _width*_height;
			
			_bitmapData = new BitmapData(_width, _height, false, 0xffffff);
			_byteArray.position = 128;
			
			while (i > 0)
			{
				byte = _byteArray.readUnsignedByte();
				
				if ((byte & 0xc0) == 0xc0) {	// byte is length byte
					length = byte & 0x3f;
					byte = _byteArray.readUnsignedByte();
					colour = 0xff000000+_palette[byte];
					
					for (var j : int = 0; j < length; j++) {
						filledArray.writeUnsignedInt(colour);
						i--;
					}
				}
				else { 	// byte is a colour byte 
					colour = 0xff000000+_palette[byte];
					filledArray.writeUnsignedInt(colour);
					i--
				}
			}
			filledArray.position = 0;
			_bitmapData.setPixels(new Rectangle(0, 0, _width, _height), filledArray);
		}
	}
}