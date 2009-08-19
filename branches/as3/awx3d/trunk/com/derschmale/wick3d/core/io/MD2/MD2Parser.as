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

package com.derschmale.wick3d.core.io.MD2
{
	import com.derschmale.wick3d.core.imagemaps.UVCoords;
	import com.derschmale.wick3d.core.io.MD2.vo.FrameMD2;
	import com.derschmale.wick3d.core.io.MD2.vo.VertexMD2;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	/**
	 * The MD2Parser class parses a MD2 file into data  more easily interpreted by ActionScript projects. MD2 files contain 3D models as used in the IDTech2 engine (used in games such as Quake II, Heretic II, ...).
	 * 
	 * @author David Lenaerts
	 */
	public class MD2Parser extends EventDispatcher
	{
		private const MD2_IDENT : String = "IDP2";
		private const MD2_VERSION : int = 8;
		
		private var _filename : String;
		private var _loader : URLLoader;
		private var _byteArray : ByteArray;
		
		/* header properties */
		private var _id : String;
		private var _version : int;
		
		private var _skinWidth : int;
		private var _skinHeight : int;
		private var _frameSize : int;
		
		private var _numSkins : int;
		private var _numVertices : int;
		private var _numUV : int;
		private var _numTriangles : int;
		private var _numGLCmds : int;	// unused?
		private var _numFrames : int;
		
		private var _offsetSkins : int;
		private var _offsetUV : int;
		private var _offsetTriangles : int;
		private var _offsetFrames : int;
		private var _offsetGLCmds : int;	// unused?
		private var _offsetEOF : int;
		
		/**
		 * Skin data
		 */
		private var _skinNames : Array;
		
		/**
		 * Texture coordinates
		 */
		private var _uvCoords : Vector.<UVCoords>;
		
		/**
		 * Triangle data
		 */
		private var _triangleVertexIndices : Array;	// first index = frame, second = triangle, third = vertex
		private var _triangleUVIndices : Array;		// first index = frame, second = triangle, third = vertex
		
		/**
		 * Frame data
		 */
		private var _frames : Array;
		
		/**
		 * Loads and parses an MD2 file. When finished, Event.COMPLETE is dispatched.
		 * 
		 * @param filename The location of the MD2 file to be loaded.
		 */
		public function parse(filename : String) : void
		{
			trace ("loading MD2 file "+filename);
			_filename = filename;
			_loader = new URLLoader();
			_loader.addEventListener(Event.COMPLETE, handleFileLoaded);
			_loader.dataFormat = URLLoaderDataFormat.BINARY;
			_loader.load(new URLRequest(filename));
		}
		
		/**
		 * An Array containing the file names of the skins used in this model.
		 */
		public function get skinNames() : Array
		{
			return _skinNames;
		}
		
		/**
		 * An Array containing the UV texture coordinates for the vertices in this model.
		 */
		public function get uvCoords() : Vector.<UVCoords>
		{
			return _uvCoords;
		}
		
		/**
		 * Retrieves the vertices for a specific frame.
		 * 
		 * @param frame The frame index of which the vertices are requested.
		 * @return An Array containing the vertices for the frame.
		 * 
		 * @see com.derschmale.wick3d.core.io.MD2.vo.VertexMD2
		 */
		public function getVertices(frame : int) : Vector.<VertexMD2>
		{
			return FrameMD2(_frames[frame]).vertices;
		}
		
		/**
		 * Retrieves the indices for the vertices per triangle.
		 * 
		 * @return The indices for the vertices per triangle. The index represents the position in the vertex Array for a frame.
		 */
		public function get triangleVertexIndices() : Array
		{
			return _triangleVertexIndices;
		}
		
		/**
		 * Retrieves the indices for the UV texture coordinates per triangle .
		 * 
		 * @return The UV texture coordinates for the vertices per triangle. The index represents the position in the UV Array for a frame.
		 */
		public function get triangleUVIndices() : Array
		{
			return _triangleUVIndices;
		}
		
		/**
		 * The amount of frames used in the loaded model.
		 */
		public function get numFrames() : int
		{
			return _numFrames;
		}
		
		/**
		 * The amount of vertices used in the loaded model.
		 */
		public function get numVertices() : int
		{
			return _numVertices;
		}
		
		/**
		 * The amount of triangle faces used in the loaded model.
		 */
		public function get numTriangles() : int
		{
			return _numTriangles;
		}
		
		/**
		 * An Array containing the data for all frames used in this model.
		 * 
		 * @see com.derschmale.wick3d.core.io.MD2.vo.FrameMD2
		 */
		public function get frames() : Array
		{
			return _frames;
		}
		
		private function handleFileLoaded(event : Event) : void
		{
			
			trace ("MD2 file "+_filename+ "loaded ("+_loader.bytesLoaded+" bytes )");
			_byteArray = _loader.data;
			_byteArray.endian = Endian.LITTLE_ENDIAN;
			parseHeader();
			parseSkins();
			parseUVCoords();
			parseTriangles();
			parseFrames();
			dispatchEvent(new Event(Event.COMPLETE));
		}	
				
		private function parseHeader() : void
		{
			trace ("Parsing header for "+_filename);
			_id = _byteArray.readUTFBytes(4);
			_version = _byteArray.readInt();
			_skinWidth = _byteArray.readInt();
			_skinHeight = _byteArray.readInt();
			_frameSize = _byteArray.readInt();
			_numSkins = _byteArray.readInt();
			_numVertices = _byteArray.readInt();
			_numUV = _byteArray.readInt();
			_numTriangles = _byteArray.readInt();
			_numGLCmds = _byteArray.readInt();
			_numFrames = _byteArray.readInt();
			_offsetSkins = _byteArray.readInt();
			_offsetUV = _byteArray.readInt();
			_offsetTriangles = _byteArray.readInt();
			_offsetFrames = _byteArray.readInt();
			_offsetGLCmds = _byteArray.readInt();
			_offsetEOF = _byteArray.readInt();
			trace ("ident: "+_id);
			trace ("MD2 Version: "+_version);
			trace ("skin width: "+_skinWidth);
			trace ("skin height: "+_skinHeight);
			trace ("frame size: "+_frameSize);
			trace ("numSkins: "+_numSkins);
			trace ("numVertices: "+_numVertices);
			trace ("numUV: "+_numUV);
			trace ("numTriangles: "+_numTriangles);
			trace ("numGLCmds: "+_numGLCmds);
			trace ("numFrames: "+_numFrames);
			trace ("offsetSkins: "+_offsetSkins);
			trace ("offsetUV: "+_offsetUV);
			trace ("offsetTriangles: "+_offsetTriangles);
			trace ("offsetFrames: "+_offsetFrames);
			trace ("offsetGLCmds: "+_offsetGLCmds);
			trace ("offsetEOF: "+_offsetEOF);
		}
		
		private function parseSkins() : void
		{
			trace ();
			_skinNames = [];
			_byteArray.position = _offsetSkins;
			for (var i : int = 0; i < _numSkins; i++) {  
				_skinNames.push(_byteArray.readUTFBytes(64));
				trace ("Skin FileName #1: "+_skinNames[i]);
			}
		}
		
		private function parseUVCoords() : void
		{
			var uv : UVCoords;
			
			_uvCoords = new Vector.<UVCoords>();
			_byteArray.position = _offsetUV;
			
			for (var i : int = 0; i < _numUV; i++) {
				uv = new UVCoords();
				uv.u = _byteArray.readUnsignedShort()/_skinWidth;
				uv.v = _byteArray.readUnsignedShort()/_skinHeight;
				_uvCoords.push(uv);
			}
			
			trace ("UV Coordinates parsed");
		}
		
		private function parseTriangles() : void
		{
			_triangleVertexIndices = [];
			_triangleUVIndices = [];
			
			_byteArray.position = _offsetTriangles;
			
			for (var i : int = 0; i < _numTriangles; i++) {
				_triangleVertexIndices[i] = [];
				_triangleVertexIndices[i].push(_byteArray.readUnsignedShort());
				_triangleVertexIndices[i].push(_byteArray.readUnsignedShort());
				_triangleVertexIndices[i].push(_byteArray.readUnsignedShort());
				
				_triangleUVIndices[i] = [];
				_triangleUVIndices[i].push(_byteArray.readUnsignedShort());
				_triangleUVIndices[i].push(_byteArray.readUnsignedShort());
				_triangleUVIndices[i].push(_byteArray.readUnsignedShort());
			}
			
			trace ("Triangles parsed");
		}
		
		private function parseFrames() : void
		{
			var frame : FrameMD2;
			var vertex : VertexMD2;
			
			_frames = [];
		//	trace ();
			for (var i : int = 0; i < _numFrames; i++) {
				frame = new FrameMD2();
				
				frame.scale[2] = _byteArray.readFloat();
				frame.scale[0] = _byteArray.readFloat();
				frame.scale[1] = _byteArray.readFloat(); 
				frame.translate[2] = _byteArray.readFloat();
				frame.translate[0] = _byteArray.readFloat();
				frame.translate[1] = _byteArray.readFloat();
				
				frame.name = _byteArray.readUTFBytes(16);
				
				for (var j : int = 0; j < _numVertices; j++) {
					vertex = new VertexMD2();
					
					vertex.coords[2] = _byteArray.readUnsignedByte();
					vertex.coords[0] = _byteArray.readUnsignedByte();
					vertex.coords[1] = _byteArray.readUnsignedByte();
					
					vertex.lightNormalIndex = _byteArray.readUnsignedByte();
					
					frame.vertices.push(vertex);
				}
				_frames.push(frame);
				/* trace ("parsed frame #"+i+ ": "+frame.name); */
			}
			trace ("parsed Frames ("+_numFrames+")");
		}
	}
}