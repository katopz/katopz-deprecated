package de.nulldesign.nd3d.utils 
{
	import de.nulldesign.nd3d.material.Material;	
	import de.nulldesign.nd3d.events.MeshEvent;
	import de.nulldesign.nd3d.objects.Mesh;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;

	/**
	 * [broadcast event] Dispatched when the mesh and textures are fully loaded.
	 * @eventType de.nulldesign.nd3d.events.MeshEvent.MESH_LOADED
	 */
	[Event(name="meshLoaded", type="de.nulldesign.nd3d.events.MeshEvent")] 

	/**
	 * MeshLoader used to load meshes from external files
	 * @author Lars Gerckens (www.nulldesign.de), philippe.elsass*gmail.com
	 */
	public class MeshLoader extends EventDispatcher 
	{
		private var mesh:Mesh;

		private var meshUrl:String;
		private var textureList:Array;
		private var matList:Array;
		private var defaultMaterial:MaterialDefaults;

		private var parser:IMeshParser;
		private var loader:URLLoader;
		private var meshData:ByteArray;
		private var textureLoader:Loader;
		private var textureLoadIndex:Number = 0;
		/**
		 * Constructor of class MeshLoader
		 * @param Parser used to parse the loaded mesh
		 */
		public function MeshLoader(parser:IMeshParser) 
		{
			this.parser = parser;
		}
		/**
		 * Loads a mesh by given bytearray
		 * @param	meshData
		 * @param	textureList
		 * @param	defaultMaterial
		 */
		public function loadMeshBytes(meshData:ByteArray, textureList:Array, defaultMaterial:MaterialDefaults = null):void 
		{
			this.meshUrl = null;
			this.meshData = meshData;
			this.textureList = textureList;
			this.defaultMaterial = defaultMaterial || new MaterialDefaults();
			
			matList = [];
			if(textureList.length) loadNextTexture();
			else buildMesh();
		}
		/**
		 * Loads a mesh by an url
		 * @param	meshUrl
		 * @param	textureList
		 * @param	defaultMaterial
		 */
		public function loadMesh(meshUrl:String, textureList:Array, defaultMaterial:MaterialDefaults = null):void 
		{
			this.meshUrl = meshUrl;
			this.textureList = textureList;
			this.defaultMaterial = defaultMaterial || new MaterialDefaults();
			
			loader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			loader.addEventListener(Event.COMPLETE, onMeshLoaded);
			loader.load(new URLRequest(meshUrl));
		}

		private function onMeshLoaded(evt:Event):void 
		{
			meshData = evt.target.data;
			loader.removeEventListener(Event.COMPLETE, onMeshLoaded);
			loader = null;
			
			matList = [];
			if(textureList.length) loadNextTexture();
			else buildMesh();
		}

		private function buildMesh():void 
		{
			if(parser)
			{
				parser.addEventListener(MeshEvent.MESH_PARSED, onParseComplete);
				parser.parseFile(meshData, matList, defaultMaterial);
			}
		}

		private function onParseComplete(e:MeshEvent):void 
		{
			parser.removeEventListener(MeshEvent.MESH_PARSED, onParseComplete);
			mesh = e.mesh;
			
			dispatchEvent(new MeshEvent(MeshEvent.MESH_LOADED, mesh));
		}

		private function loadNextTexture():void 
		{
			textureLoader = new Loader();
			textureLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onTextureLoaded);
			
			var texture:* = textureList[textureLoadIndex];
			if (texture is ByteArray)
			{
				textureLoader.loadBytes(texture);
			}
			else if (texture is URLRequest)
			{
				textureLoader.load(texture);
			}
			else
			{
				var urlReq:URLRequest = new URLRequest(texture);
				textureLoader.load(urlReq);
			}
		}

		private function onTextureLoaded(evt:Event):void 
		{
			textureLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onTextureLoaded);
			++textureLoadIndex;
			
			var bmp:BitmapData;
			if (textureLoader.content is Bitmap)
			{
				bmp = (textureLoader.content as Bitmap).bitmapData;
			}
			else
			{
				bmp = new BitmapData(textureLoader.width, textureLoader.height, true, 0x00000000);
				bmp.draw(textureLoader);
			}
			
			matList.push(defaultMaterial.getMaterial(bmp));
			
			if(textureLoadIndex < textureList.length) loadNextTexture();
			else buildMesh();
		}
	}	
}
