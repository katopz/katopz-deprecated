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

package com.derschmale.wick3d.display3D
{
	import com.derschmale.display.io.PCXLoader;
	import com.derschmale.events.ImageLoaderEvent;
	import com.derschmale.wick3d.cameras.Camera3D;
	import com.derschmale.wick3d.core.data.GeometryData;
	import com.derschmale.wick3d.core.geometry.Triangle3D;
	import com.derschmale.wick3d.core.geometry.Vertex3D;
	import com.derschmale.wick3d.core.imagemaps.UVCoords;
	import com.derschmale.wick3d.core.io.MD2.MD2Parser;
	import com.derschmale.wick3d.core.io.MD2.vo.FrameMD2;
	import com.derschmale.wick3d.core.io.MD2.vo.VertexMD2;
	import com.derschmale.wick3d.core.math.Transformation3D;
	import com.derschmale.wick3d.core.objects.Model3D;
	import com.derschmale.wick3d.materials.ColourMaterial;
	import com.derschmale.wick3d.materials.TextureMaterial;
	
	import flash.events.Event;
	import flash.utils.clearTimeout;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	/**
	 * The MD2Model class is a Model3D generated from a MD2 file. MD2 is a file format used in the IDTech2 engine (used in Quake II, Heretic II, ...).
	 * 
	 * @author David Lenaerts
	 */
	public class MD2Model extends Model3D
	{
		private var _parser : MD2Parser
		private var _meshes : Array;
		private var _frameVertices : Vector.<Vector.<Vertex3D>>;
		private var _filename : String;
	
		private var _currentFrame : int = 0;
		private var _timePerFrame : Number = 100;
		
		private var _frameLookUp : Array;
		
		private var _startFrame : int = 0;
		private var _endFrame : int;
		private var _timeout : int;
		private var _isPlaying : Boolean;
		private var _interpolate : Boolean;
		
		private var _interpolationStartTime : int;
		
		/**
		 * Creates a MD2Model from a MD2 file.
		 * 
		 * @param filename The location of the file to be loaded.
		 * @param autoPlay Defines whether or not the model should start animating once loaded.
		 * @param timePerFrame The amount of time in milliseconds between keyframes.
		 * @param interpolate Defines whether the animation should be interpolated between keyframes.
		 */
		public function MD2Model(filename : String, autoPlay : Boolean = true, timePerFrame : Number = 100, interpolate : Boolean = true)
		{
			super(new ColourMaterial(0xff0000));
			_filename = filename;
			_parser = new MD2Parser();
			_parser.addEventListener(Event.COMPLETE, handleParseComplete);
			_parser.parse(filename);
			_isPlaying = autoPlay;
			_timePerFrame = timePerFrame;
			_interpolate = interpolate;
		}
		
		/**
		 * Immediately shows the next keyframe of the animation.
		 */
		public function nextFrame() : void
		{
			if (_frameVertices) {
				if (++_currentFrame > _endFrame) {
					_currentFrame = _startFrame;
				}
				_vertices = _frameVertices[_currentFrame];
			}
		}
		
		/**
		 * Starts the animation of the model.
		 */
		public function play() : void
		{
			if (_timeout) clearTimeout(_timeout);
			if (_interpolate) _interpolationStartTime = getTimer();
			else _timeout = setTimeout(nextFrameAuto, _timePerFrame);
		}
		
		/**
		 * Stops the animation of the model.
		 */
		public function stop() : void
		{
			_isPlaying = false;
			if (!_interpolate) clearTimeout(_timeout);
			_timeout = 0;
		}
		
		/**
		 * Returns the frame index (order of the frame in the total animation loop).
		 */
		public function getFrameIndex(name : String) : int
		{
			return _frameLookUp[name];
		}
		
		/**
		 * Defines the range of frames to play when animating, based on the frame name.
		 * 
		 * @param name The base name of the frames to use for the animation loop. Frames typically have names linked to an action (such as standing001, standing002, ...). Passing "standing" causes only this action to show.
		 */
		public function setFrameRangeSet(name : String) : void
		{
			var start : int = _frameVertices.length;
			var end : int = 0;
			
			for (var frameName : String in _frameLookUp) {
				if (frameName.indexOf(name) == 0) {
					if (_frameLookUp[frameName] < start)
						start = _frameLookUp[frameName];
					if (_frameLookUp[frameName] > end)
						end = _frameLookUp[frameName];
				}
			} 
			_currentFrame = start;
			_startFrame = start;
			_endFrame = end;
		}
		
		/**
		 * Defines the range of frames to play when animating, based on the frame indices.
		 * 
		 * @param start The first frame index in the loop.
		 * @param start The last frame index in the loop.
		 */
		public function setFrameRange(start : int, end : int) : void
		{
			_startFrame = start;
			_endFrame = end;
		}
		
		/**
		 * Updates the object's transformation if necessary and transforms the vertices to view coordinates
		 * 
		 * @param recursive If true (default), the current's objects children will also be transformed into world coordinates. The whole hierarchical tree is traversed starting from this object until no children are found.
		 */
		override public function transformToViewCoords(geometryData:GeometryData, camera:Camera3D, parentTransform:Transformation3D=null, recursive:Boolean=true):void
		{
			super.transformToViewCoords(geometryData, camera, parentTransform, recursive);
			
			if (_frameVertices && _interpolate && _isPlaying) updateInterpolation();
		}
		
		/**
		 * Updates the object's transformation if necessary and transforms the vertices to world coordinates
		 * 
		 * @param recursive If true (default), the current's objects children will also be transformed into world coordinates. The whole hierarchical tree is traversed starting from this object until no children are found.
		 */
		override public function transformToWorldCoords(geometryData:GeometryData, parentTransform:Transformation3D=null, recursive:Boolean=true):void
		{
			super.transformToWorldCoords(geometryData, parentTransform, recursive);
			
			if (_frameVertices && _interpolate && _isPlaying) updateInterpolation();
		}
		
		private function updateInterpolation() : void
		{
			var nextFrame : int = _currentFrame + 1;
			var timeRatio : Number;
			var i : int = _vertices.length;
			var vertex : Vertex3D, srcVtx : Vertex3D, destVtx : Vertex3D;
			var currentTime : int = getTimer();
			
			timeRatio = (currentTime-_interpolationStartTime)/_timePerFrame;
			
			while (timeRatio > 1) {
				_interpolationStartTime += _timePerFrame;
				timeRatio = (currentTime-_interpolationStartTime)/_timePerFrame;
				_currentFrame++;
				nextFrame++;
				if (_currentFrame > _endFrame) _currentFrame = _startFrame; 
				if (nextFrame > _endFrame) nextFrame = _startFrame;
			}
			
			if (nextFrame > _endFrame) nextFrame = _startFrame;
			
			while ((i>0) && (vertex = _vertices[--i] as Vertex3D)) {
				srcVtx = _frameVertices[_currentFrame][i];
				destVtx = _frameVertices[nextFrame][i];
				vertex.x = timeRatio*destVtx.x+(1-timeRatio)*srcVtx.x;
				vertex.y = timeRatio*destVtx.y+(1-timeRatio)*srcVtx.y; 
				vertex.z = timeRatio*destVtx.z+(1-timeRatio)*srcVtx.z;
			}
		}
		
		private function nextFrameAuto() : void
		{
			_timeout = setTimeout(nextFrameAuto, _timePerFrame);
			nextFrame();
		}
		
		private function handleParseComplete(event : Event) : void
		{
			convertVertices();
			convertTriangles();
			loadSkin();
			if (_isPlaying) play();
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function convertVertices() : void
		{
			var vertex : Vertex3D;
			var vertexMD2 : VertexMD2;
			var frames : Array = _parser.frames;
			var frame : FrameMD2;
			
			_frameLookUp = [];
			_frameVertices = new Vector.<Vector.<Vertex3D>>();
			_endFrame = _parser.numFrames-1;
			for (var f : uint = 0; f < _parser.numFrames; f++) {
				frame = frames[f];
				_frameLookUp[frame.name] = f;
				_frameVertices[f] = Vector.<Vertex3D>([]);
				
				for (var i : uint = 0; i < _parser.numVertices; i++) {
					vertexMD2 = frame.getTransformedVertex(i);
					_frameVertices[f][i] = new Vertex3D(vertexMD2.coords[0], vertexMD2.coords[1], vertexMD2.coords[2]);
				}
			}
			if (!_interpolate) _vertices = _frameVertices[0];
			
			for (i = 0; i < _parser.numVertices; i++) {
				if (_interpolate) _vertices[i] = new Vertex3D();
				_trVertices[i] = new Vertex3D();
			} 
		}
		
		private function convertTriangles() : void
		{
			var vertexIndices : Array = _parser.triangleVertexIndices;
			var uvIndices : Array = _parser.triangleUVIndices;
			var triangle : Triangle3D;
			var uvCoords : Vector.<UVCoords> = _parser.uvCoords;
			
			for (var i : int = 0; i < _parser.numTriangles; i++) {
				triangle = new Triangle3D(_trVertices[vertexIndices[i][2]], _trVertices[vertexIndices[i][1]], _trVertices[vertexIndices[i][0]]);
				triangle.material = material;
				// local coords not needed
				triangle.setParent(this, null, null, null);
				triangle.uv1 = uvCoords[uvIndices[i][2]];
				triangle.uv2 = uvCoords[uvIndices[i][1]];
				triangle.uv3 = uvCoords[uvIndices[i][0]];
				_triangles.push(triangle);
			}
		}
		
		private function loadSkin() : void
		{
			var pcxLoader : PCXLoader;
			var skinFile : String = _parser.skinNames[0];
			var path : String;
			var index : int = skinFile.lastIndexOf("/")+1;
			
			if (index != -1) skinFile = skinFile.substr(index);
			
			index = _filename.lastIndexOf("/")+1;
			
			if (index == -1)
				path = _filename;
			else
				path = _filename.substr(0, index);
				 
			pcxLoader = new PCXLoader();
			pcxLoader.addEventListener(ImageLoaderEvent.IMAGE_LOADED, handlePCXLoaded);
			pcxLoader.loadPCX(path+skinFile);
		}
		
		private function handlePCXLoaded(event : ImageLoaderEvent) : void
		{
			material = new TextureMaterial(event.bitmapData);
			material.doubleSided = true;
		}
	}
}