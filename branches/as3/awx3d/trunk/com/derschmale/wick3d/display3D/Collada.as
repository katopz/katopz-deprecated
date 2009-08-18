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
	import com.derschmale.wick3d.cameras.Camera3D;
	import com.derschmale.wick3d.core.data.GeometryData;
	import com.derschmale.wick3d.core.io.collada.ColladaModel;
	import com.derschmale.wick3d.core.math.Transformation3D;
	import com.derschmale.wick3d.core.objects.Model3D;
	import com.derschmale.wick3d.materials.AbstractMaterial;
	import com.derschmale.wick3d.materials.ColourMaterial;
	import com.derschmale.wick3d.materials.TextureMaterial;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	/**
	 * The Collada class is a Model3D generated from a Collada (DAE) file.
	 * 
	 * @author David Lenaerts
	 */
	public class Collada extends Model3D
	{
		// move to custom events
		public static const IMAGES_LOADED : String = "imagesLoaded";
		
		private var _loaded : Boolean;
		private var _loader : URLLoader;
		private var _xml : XML;
		private var _path : String;
		private var _imageFileNames : Array;
		private var _imageIds : Array;
		private var _images : Array;
		private var _materials : Array;
		private var _bitmapLoader : Loader;
		private var _loadingIndex : int = 0;
		
		/**
		 * Creates a Collada instance from a specified collada file. This class is very much in development, and as such, functionality is instable and limited.
		 * 
		 * @param filename The filename of the collada (DAE) file to be loaded.
		 */
		public function Collada(filename : String)
		{
			var slashOccurence : int;
			super(new ColourMaterial(0xff00ff));
			
			slashOccurence = filename.lastIndexOf("/");
			if (slashOccurence == -1) slashOccurence = filename.lastIndexOf("\\");
			if (slashOccurence != -1) _path = filename.substr(0, slashOccurence+1);
			else _path = "";
						
			_loader = new URLLoader();
			_loader.addEventListener(Event.COMPLETE, handleDAELoadComplete);
			_loader.load(new URLRequest(filename));
		}
		
		/**
		 * Updates the object's transformation if necessary and transforms the vertices to view coordinates
		 * 
		 * @param recursive If true (default), the current's objects children will also be transformed into world coordinates. The whole hierarchical tree is traversed starting from this object until no children are found.
		 */
		override public function transformToViewCoords(geometryData:GeometryData, camera:Camera3D, parentTransform:Transformation3D=null, recursive:Boolean=true):void
		{
			if (_loaded) super.transformToViewCoords(geometryData, camera, parentTransform, recursive);
		}
		
		/**
		 * Updates the object's transformation if necessary and transforms the vertices to world coordinates
		 * 
		 * @param recursive If true (default), the current's objects children will also be transformed into world coordinates. The whole hierarchical tree is traversed starting from this object until no children are found.
		 */
		override public function transformToWorldCoords(geometryData:GeometryData, parentTransform:Transformation3D=null, recursive:Boolean=true):void
		{
			if (_loaded) super.transformToWorldCoords(geometryData, parentTransform, recursive);
		}
		
		private function handleDAELoadComplete(event : Event) : void
		{
			_xml = new XML(_loader.data);
			
			parseImages();
			loadImages();
			
			addEventListener(IMAGES_LOADED, handleImagesLoaded);
			
			_loaded = true;
		}
		
		private function handleImagesLoaded(event : Event) : void
		{
			removeEventListener(IMAGES_LOADED, handleImagesLoaded);
			parseMaterials();
			parseScene();
		}
		
		private function parseImages() : void
		{
			var ns : Namespace = _xml.namespace();
			default xml namespace = ns;
			var images : XMLList = _xml.library_images.image;
			var id : String;
			var occurence : int;
			
			_imageFileNames = [];
			_images = [];
			_imageIds = [];
			
			for (var i : uint = 0; i < images.length(); i++) {
				id = images[i].@id;
				/* occurence = String(images[i].init_from).indexOf("./");
				if (occurence == -1) */
					_imageFileNames[i] = _path+images[i].init_from;
				/* else
					_imageFileNames[i] = _path+String(images[i].init_from).substr(occurence+2); */
				_imageIds[i] = id;
			}
		}
		
		private function loadImages(event : Event = null) : void
		{
			var loader : Loader;
			
			if (event) {
				_bitmapLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loadImages);
				_images[_imageIds[_loadingIndex-1]] = Bitmap(_bitmapLoader.content).bitmapData;
				trace ("loaded "+_imageFileNames[_loadingIndex-1]);
			}
			if (_loadingIndex == _imageFileNames.length)
				dispatchEvent(new Event(IMAGES_LOADED));
			else {
				trace ("loading "+_imageFileNames[_loadingIndex] +" ...");
				_bitmapLoader = new Loader();
				_bitmapLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadImages);
				_bitmapLoader.load(new URLRequest(_imageFileNames[_loadingIndex]));
			}
				
			_loadingIndex++;
		}
		
		private function parseMaterials() : void
		{
			var ns : Namespace = _xml.namespace();
			default xml namespace = ns;
			var materials : XMLList = _xml.library_materials.material;
			var id : String;
			var idTo : String;
			var effect : XMLList;
			var technique : XMLList;
			var textureId : String;
			var surfaceId : String;
			var imageId : String;
			var material : AbstractMaterial;
			
			_materials = [];
			
			for (var i : int = 0; i < materials.length(); i++) {
				textureId = "";
				id = materials[i].@id;
				
				idTo = String(materials[i].instance_effect.@url).substr(1);
				effect = _xml.library_effects.effect.(@id == idTo);
				technique = effect.profile_COMMON.technique.(@sid == "common");
				
				if (technique.hasOwnProperty("blinn")) {
					if (technique.blinn.diffuse.hasOwnProperty("texture")) {
						textureId = technique.blinn.diffuse.texture.@texture;
						surfaceId = effect.profile_COMMON.newparam.(@sid == textureId).sampler2D.source;
						imageId = effect.profile_COMMON.newparam.(@sid == surfaceId).surface.init_from;
						material = new TextureMaterial(_images[imageId]);
						_materials[id] = material;
					}
				}
				else if (technique.hasOwnProperty("phong")) {
					if (technique.phong.hasOwnProperty("texture")) {
						textureId = technique.phong.texture.@texture;
					}
					else if (technique.phong.diffuse.hasOwnProperty("texture")) {
						textureId = technique.phong.diffuse.texture.@texture;
					}
					if (textureId != "") {
						surfaceId = effect.profile_COMMON.newparam.(@sid == textureId).sampler2D.source;
						imageId = effect.profile_COMMON.newparam.(@sid == surfaceId).surface.init_from;
						material = new TextureMaterial(_images[imageId]);
						_materials[id] = material;
					}
				}
			}
		}
		
		private function parseScene() : void
		{
			var ns : Namespace = _xml.namespace();
			default xml namespace = ns;
			
			var sceneId : String = String(_xml.scene.instance_visual_scene.@url).substr(1);
			var scene : XMLList = _xml.library_visual_scenes.visual_scene.(@id == sceneId);
			
			for (var i : uint; i < scene.node.length(); i++) {
				parseGeometryNode(scene.node[i], this);
			}
		}
		
		/* fix */
		private function parseGeometryNode(node : XML, parent : Model3D) : void
		{
			var ns : Namespace = _xml.namespace();
			default xml namespace = ns;
			var newObject : Model3D;
			var material : AbstractMaterial;
			var materialId : String;
			
			if (node.hasOwnProperty("instance_geometry")) {
				trace ("adding ColladaModel "+node.@id);
				materialId = node.instance_geometry.bind_material.technique_common.instance_material.@target;
				materialId = materialId.substr(1);
				
				material = _materials[materialId];
				
				newObject = new ColladaModel(_xml, node.@id, material);
				parent.addChild(newObject);
			}
			else if (!node.hasOwnProperty("instance_camera")) {
				trace ("adding ColladaGroup "+node.@id);
				// change to Model group
				newObject = new Model3D(null);
				parent.addChild(newObject);
			}
			
			if (node.hasOwnProperty("node")) {
				var subNodes : XMLList = node.node;
				for (var i : uint = 0; i < subNodes.length(); i++) {
					trace ("parsing subnodes in "+node.@id);
					parseGeometryNode(subNodes[i], newObject);
				}
			}
		}
	}
}