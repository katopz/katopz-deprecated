package com.cutecoma.playground.editors
{
	import away3dlite.animators.BonesAnimator;
	import away3dlite.animators.MovieMesh;
	import away3dlite.animators.MovieMeshContainer3D;
	import away3dlite.builders.MDJBuilder;
	import away3dlite.materials.BitmapFileMaterial;
	import away3dlite.primitives.Trident;
	import away3dlite.templates.BasicTemplate;
	
	import com.adobe.serialization.json.JSON;
	import com.cutecoma.playground.data.ModelData;
	import com.sleepydesign.components.SDDialog;
	import com.sleepydesign.net.FileUtil;
	import com.sleepydesign.net.LoaderUtil;
	
	import flash.events.Event;
	import flash.geom.Vector3D;
	import flash.net.FileReference;
	import flash.utils.*;
	
	import org.osflash.signals.Signal;
	
	public class CharacterEditor extends BasicTemplate
	{
		private var _currentModel:MovieMeshContainer3D;
		private var _bonesAnimator:BonesAnimator;
		
		private var _meshes:Vector.<MovieMeshContainer3D>;
		
		public static var initSignal:Signal = new Signal();
		public static var changeSignal:Signal = new Signal(Object);
		
		private var _xmlData:XML;
		
		private var _jsonData:Object;
		
		public var trident:Trident;
		
		public function CharacterEditor()
		{
			
		}
		
		override protected function onInit():void
		{
			view.mouseEnabled3D = false;
			scene.addChild(trident = new Trident);
			
			camera.y = -200;
			camera.lookAt(new Vector3D);
			
			initXML("config.xml");
		}
		
		override protected function onPreRender():void
		{
			scene.rotationY+=0.5;
		}
		
		public function initXML(src:String):void
		{
			LoaderUtil.loadXML(src, function(event:Event):void
			{
				if (event.type == "complete")
					buildFromXML(event.target.data);
			});
		}
		
		private var _menuCharacter:SDDialog;
		private var _textureMenu:SDDialog;
		private var _menuPart:SDDialog;
		
		private function buildFromXML(xmlData:XML):void
		{
			_xmlData = xmlData;
			_menuCharacter = new SDDialog(<question><![CDATA[Select Character]]>
					<answer src="as:onSelectCharacter('man')"><![CDATA[Man]]></answer>
					<answer src="as:onSelectCharacter('woman')"><![CDATA[Women]]></answer>
				</question>, this);
			addChild(_menuCharacter);
			_menuCharacter.x = 10;
			_menuCharacter.y = 80;
			
			initSignal.dispatch();
		}
		
		public function onSelectCharacter(charType:String = ""):void
		{
			// reset
			if(charType=="")
				charType = _charType;
			
			var _xmlPrototype:XMLList = _xmlData.chars[charType];
			
			reset();
			
			// no click while load 
			mouseEnabled = mouseChildren = false;
			
			if(!_modelPool)
			{
				_modelPool = new ModelPool();
				_modelPool.path = String(_xmlData.chars.@path);
				ModelPool.signalModel.add(activate);
			}
			
			_modelPool.initXML(_xmlPrototype);
			
			initMenu(charType);
		}
		
		private var  _modelPool:ModelPool;
		private var _menuAction:SDDialog;
		private var _menu:SDDialog;
		private var _charType:String;
		
		private function initMenu(charType:String):void
		{
			_charType = charType;
			
			if (_menuAction)
			{
				removeChild(_menuAction);
				_menuAction = null;
			}
			
			if (_menu)
			{
				removeChild(_menu);
				_menu = null;
			}
			
			if (_menuPart)
			{
				removeChild(_menuPart);
				_menuPart = null;
			}
			
			_menuAction = new SDDialog(<question><![CDATA[Select Action]]>
					<answer src="as:onSelectAction('talk')"><![CDATA[Talk]]></answer>
					<answer src="as:onSelectAction('walk')"><![CDATA[Walk]]></answer>
				</question>, this);
			addChild(_menuAction);
			_menuAction.x = 10;
			_menuAction.y = _menuCharacter.y + _menuCharacter.height + 10;
			
			_menu = new SDDialog(<question><![CDATA[File (from disk)]]>
					<answer src="as:onSelectMenu('open')"><![CDATA[Open]]></answer>
					<answer src="as:onSelectMenu('save')"><![CDATA[Save]]></answer>
				</question>, this);
			addChild(_menu);
			_menu.x = 10;
			_menu.y = _menuAction.y + _menuAction.height + 10;
			
			switch (_charType)
			{
				case "man":
					_menuPart = new SDDialog(<question><![CDATA[Select Part]]>
							<answer src="as:onSelectMesh('hair_1')"><![CDATA[hair_1]]></answer>
							<answer src="as:onSelectMesh('hair_2')"><![CDATA[hair_2]]></answer>
							<answer src="as:onSelectMesh('hair_3')"><![CDATA[hair_3]]></answer>
							<answer src="as:onSelectMesh('hair_4')"><![CDATA[hair_4]]></answer>
							<answer src="as:onSelectMesh('head_1')"><![CDATA[head_1]]></answer>
							<answer src="as:onSelectMesh('shirt_1')"><![CDATA[shirt_1]]></answer>
							<answer src="as:onSelectMesh('shirt_2')"><![CDATA[shirt_2]]></answer>
							<answer src="as:onSelectMesh('shirt_3')"><![CDATA[shirt_3]]></answer>
							<answer src="as:onSelectMesh('shirt_4')"><![CDATA[shirt_4]]></answer>
							<answer src="as:onSelectMesh('pant_1')"><![CDATA[pant_1]]></answer>
							<answer src="as:onSelectMesh('pant_2')"><![CDATA[pant_2]]></answer>
							<answer src="as:onSelectMesh('pant_3')"><![CDATA[pant_3]]></answer>
							<answer src="as:onSelectMesh('shoes_1')"><![CDATA[shoes_1]]></answer>
							<answer src="as:onSelectMesh('shoes_2')"><![CDATA[shoes_2]]></answer>
						</question>, this);
					break;
				case "woman":
					_menuPart = new SDDialog(<question><![CDATA[Select Part]]>
							<answer src="as:onSelectMesh('hair_1')"><![CDATA[hair_1]]></answer>
							<answer src="as:onSelectMesh('hair_2')"><![CDATA[hair_2]]></answer>
							<answer src="as:onSelectMesh('hair_3')"><![CDATA[hair_3]]></answer>
							<answer src="as:onSelectMesh('hair_4')"><![CDATA[hair_4]]></answer>
							<answer src="as:onSelectMesh('head_1')"><![CDATA[head_1]]></answer>
							<answer src="as:onSelectMesh('shirt_1')"><![CDATA[shirt_1]]></answer>
							<answer src="as:onSelectMesh('shirt_2')"><![CDATA[shirt_2]]></answer>
							<answer src="as:onSelectMesh('shirt_3')"><![CDATA[shirt_3]]></answer>
							<answer src="as:onSelectMesh('shirt_4')"><![CDATA[shirt_4]]></answer>
							<answer src="as:onSelectMesh('pant_1')"><![CDATA[pant_1]]></answer>
							<answer src="as:onSelectMesh('pant_2')"><![CDATA[pant_2]]></answer>
							<answer src="as:onSelectMesh('pant_3')"><![CDATA[pant_3]]></answer>
							<answer src="as:onSelectMesh('pant_4')"><![CDATA[pant_4]]></answer>
							<answer src="as:onSelectMesh('shoes_1')"><![CDATA[shoes_1]]></answer>
							<answer src="as:onSelectMesh('shoes_2')"><![CDATA[shoes_2]]></answer>
							<answer src="as:onSelectMesh('shoes_3')"><![CDATA[shoes_3]]></answer>
						</question>, this);
					break;
			}
			addChild(_menuPart);
			_menuPart.x = 10;
			_menuPart.y = _menu.y + _menu.height + 10;
		}
		
		public function createTextureMenu(meshType:String, meshID:int, x:int = 0, y:int = 0):void
		{
			if (_textureMenu)
			{
				removeChild(_textureMenu);
				x = _textureMenu.x;
				y = _textureMenu.y;
				_textureMenu = null;
			}
			
			var _xml:XML;
			switch (_charType)
			{
				case "man":
					_xml = <question><![CDATA[Select Texture]]>
							<answer type="hair" src="as:onSelectTexture('chars/man/texture_$meshID/hair_1.png')"><![CDATA[hair_1]]></answer>
							<answer type="hair" src="as:onSelectTexture('chars/man/texture_$meshID/hair_2.png')"><![CDATA[hair_2]]></answer>
							<answer type="hair" src="as:onSelectTexture('chars/man/texture_$meshID/hair_3.png')"><![CDATA[hair_3]]></answer>
							<answer type="hair" src="as:onSelectTexture('chars/man/texture_$meshID/hair_4.png')"><![CDATA[hair_4]]></answer>
							<answer type="head" src="as:onSelectTexture('chars/man/texture_$meshID/head_1.png')"><![CDATA[head_1]]></answer>
							<answer type="head" src="as:onSelectTexture('chars/man/texture_$meshID/head_2.png')"><![CDATA[head_2]]></answer>
							<answer type="head" src="as:onSelectTexture('chars/man/texture_$meshID/head_3.png')"><![CDATA[head_3]]></answer>
							<answer type="shirt" src="as:onSelectTexture('chars/man/texture_$meshID/shirt_1.png')"><![CDATA[shirt_1]]></answer>
							<answer type="shirt" src="as:onSelectTexture('chars/man/texture_$meshID/shirt_2.png')"><![CDATA[shirt_2]]></answer>
							<answer type="shirt" src="as:onSelectTexture('chars/man/texture_$meshID/shirt_3.png')"><![CDATA[shirt_3]]></answer>
							<answer type="shirt" src="as:onSelectTexture('chars/man/texture_$meshID/shirt_4.png')"><![CDATA[shirt_4]]></answer>
							<answer type="pant" src="as:onSelectTexture('chars/man/texture_$meshID/pant_1.png')"><![CDATA[pant_1]]></answer>
							<answer type="pant" src="as:onSelectTexture('chars/man/texture_$meshID/pant_2.png')"><![CDATA[pant_2]]></answer>
							<answer type="pant" src="as:onSelectTexture('chars/man/texture_$meshID/pant_3.png')"><![CDATA[pant_3]]></answer>
							<answer type="shoes" src="as:onSelectTexture('chars/man/texture_$meshID/shoes_1.png')"><![CDATA[shoes_1]]></answer>
							<answer type="shoes" src="as:onSelectTexture('chars/man/texture_$meshID/shoes_2.png')"><![CDATA[shoes_2]]></answer>
						</question>;
					break;
				case "woman":
					_xml = <question><![CDATA[Select Texture]]>
							<answer type="hair" src="as:onSelectTexture('chars/woman/texture_$meshID/hair_1.png')"><![CDATA[hair_1]]></answer>
							<answer type="hair" src="as:onSelectTexture('chars/woman/texture_$meshID/hair_2.png')"><![CDATA[hair_2]]></answer>
							<answer type="hair" src="as:onSelectTexture('chars/woman/texture_$meshID/hair_3.png')"><![CDATA[hair_3]]></answer>
							<answer type="hair" src="as:onSelectTexture('chars/woman/texture_$meshID/hair_4.png')"><![CDATA[hair_4]]></answer>
							<answer type="head" src="as:onSelectTexture('chars/woman/texture_$meshID/head_1.png')"><![CDATA[head_1]]></answer>
							<answer type="head" src="as:onSelectTexture('chars/woman/texture_$meshID/head_2.png')"><![CDATA[head_2]]></answer>
							<answer type="shirt" src="as:onSelectTexture('chars/woman/texture_$meshID/shirt_1.png')"><![CDATA[shirt_1]]></answer>
							<answer type="shirt" src="as:onSelectTexture('chars/woman/texture_$meshID/shirt_2.png')"><![CDATA[shirt_2]]></answer>
							<answer type="shirt" src="as:onSelectTexture('chars/woman/texture_$meshID/shirt_3.png')"><![CDATA[shirt_3]]></answer>
							<answer type="shirt" src="as:onSelectTexture('chars/woman/texture_$meshID/shirt_4.png')"><![CDATA[shirt_4]]></answer>
							<answer type="pant" src="as:onSelectTexture('chars/woman/texture_$meshID/pant_1.png')"><![CDATA[pant_1]]></answer>
							<answer type="pant" src="as:onSelectTexture('chars/woman/texture_$meshID/pant_2.png')"><![CDATA[pant_2]]></answer>
							<answer type="pant" src="as:onSelectTexture('chars/woman/texture_$meshID/pant_3.png')"><![CDATA[pant_3]]></answer>
							<answer type="pant" src="as:onSelectTexture('chars/woman/texture_$meshID/pant_4.png')"><![CDATA[pant_4]]></answer>
							<answer type="shoes" src="as:onSelectTexture('chars/woman/texture_$meshID/shoes_1.png')"><![CDATA[shoes_1]]></answer>
							<answer type="shoes" src="as:onSelectTexture('chars/woman/texture_$meshID/shoes_2.png')"><![CDATA[shoes_2]]></answer>
							<answer type="shoes" src="as:onSelectTexture('chars/woman/texture_$meshID/shoes_3.png')"><![CDATA[shoes_3]]></answer>
							<answer type="shoes" src="as:onSelectTexture('chars/woman/texture_$meshID/shoes_4.png')"><![CDATA[shoes_4]]></answer>
						</question>;
					break;
			}
			
			_xml = new XML("<question><![CDATA[Select Texture]]>" + _xml.answer.(@type == meshType).toString() + "</question>");
			
			_xml = new XML(_xml.toString().split("$meshID").join(String(meshID)));
			
			_textureMenu = new SDDialog(_xml, this);
			addChild(_textureMenu);
			_textureMenu.x = x || _textureMenu.x;
			_textureMenu.y = y || _textureMenu.y;
		}
		
		public function reset():void
		{
			for each (var _meshContainer:MovieMeshContainer3D in _meshes)
			_meshContainer.destroy();
			
			_meshes = new Vector.<MovieMeshContainer3D>();
		}
		
		public function getCurrentJSON():Object
		{
			return _mdjBuilder.getJSON(getCurrentSaveMeshes(), {type: _charType});
		}
		
		public function getCurrentMDJ():String
		{
			return _mdjBuilder.getMDJ(getCurrentSaveMeshes(), {type: _charType});
		}
		
		public function onSelectMenu(action:String):void
		{
			switch (action)
			{
				case "open":
					FileUtil.open(["*.mdj"], onMDJOpen);
					break;
				case "save":
					/*
					// collect mesh from visibility
					var _saveMeshes:Vector.<MovieMesh> = new Vector.<MovieMesh>();
					for each (var _meshContainer:MovieMeshContainer3D in _meshes)
					{
					for each (var _mesh:MovieMesh in _meshContainer.children)
					if (_mesh.visible)
					{
					_saveMeshes.push(_mesh);
					Debug.trace(_mesh.url);
					}
					}
					
					// save
					var _mdjBuilder:MDJBuilder = new MDJBuilder();
					*/
					new FileReference().save(getCurrentMDJ(), "user.mdj");
					break;
			}
		}
		
		private function onMDJOpen(event:Event):void
		{
			if (event.type != "complete")
				return;
			
			var _byteArray:ByteArray = event.target["data"] as ByteArray;
			var _data:String = _byteArray.readUTFBytes(_byteArray.length);
			
			openJSON(JSON.decode(_data));
		}
		
		public function openJSON(jsonData:Object):void
		{
			if (_jsonData == jsonData)
				return;
			
			// not done yet leave _jsonData as is
			_jsonData = jsonData;
			
			// check charactor type
			if (_jsonData.type != _charType)
			{
				// prevent rapid call
				_charType = _jsonData.type;
				
				onSelectCharacter(_jsonData.type);
			}
			else
			{
				applyJSON(_jsonData);
				
				// it's done
				_jsonData = null;
			}
		}
		
		private function applyJSON(jsonData:Object):void
		{
			var _meshList:Array = jsonData.meshes;
			var _materialList:Array = jsonData.textures;
			
			for (var i:int = 0; i < _meshList.length; i++)
			{
				var src:String = _meshList[i];
				var _part:String = src.slice(src.lastIndexOf("/") + 1);
				_part = _part.split(".")[0];
				
				onSelectMesh(_part);
				onSelectTexture(_materialList[i]);
			}
		}
		
		public function onSelectTexture(src:String):void
		{
			var _meshContainer:MovieMeshContainer3D;
			var _part:String = src.split(".")[0];
			_part = _part.slice(src.lastIndexOf("/") + 1);
			var _type:String = _part.split("_")[0];
			var _id:int = int(_part.split("_")[1]) - 1;
			
			for each (_meshContainer in _meshes)
			{
				var _mesh:MovieMesh = _meshContainer.getChildByName(_type) as MovieMesh;
				if (_mesh.visible)
					_mesh.material = new BitmapFileMaterial(src);
			}
		}
		
		public function onSelectMesh(action:String):void
		{
			var _meshContainer:MovieMeshContainer3D;
			
			// hold
			for each (_meshContainer in _meshes)
			_meshContainer.stop();
			
			var _type:String = action.split("_")[0];
			var _id:int = int(action.split("_")[1]) - 1;
			var _currentTime:Number = 0;
			
			// reset
			for each (_meshContainer in _meshes)
			{
				_meshContainer.getChildByName(_type).visible = false;
				_currentTime = MovieMesh(_meshContainer.getChildByName(_type)).currentTime;
			}
			
			// pick one
			var _mesh:MovieMesh = _meshes[_id].getChildByName(_type) as MovieMesh;
			_mesh.visible = true;
			
			// seek
			MovieMesh(_meshes[_id].getChildByName(_type)).seek(_currentTime, _currentTime);
			
			// resume
			if (_meshContainer.currentLabel)
				for each (_meshContainer in _meshes)
				_meshContainer.play(_meshContainer.currentLabel);
			
			// change texture type
			createTextureMenu(_type, _id + 1, _menuPart.width + 20, _menuPart.y);
		}
		
		private var _mdjBuilder:MDJBuilder = new MDJBuilder();
		private var _saveMeshes:Vector.<MovieMesh>;
		
		public function getCurrentSaveMeshes():Vector.<MovieMesh>
		{
			// collect mesh from visibility
			_saveMeshes = new Vector.<MovieMesh>();
			for each (var _meshContainer:MovieMeshContainer3D in _meshes)
			{
				for each (var _mesh:MovieMesh in _meshContainer.children)
				if (_mesh.visible)
					_saveMeshes.push(_mesh);
			}
			//var _mdjBuilder:MDJBuilder = new MDJBuilder();
			//changeSignal.dispatch({char: JSON.decode(_mdjBuilder.getMDJ(_saveMeshes, {type:_charType}))});
			
			return _saveMeshes;
		}
		
		public function onSelectAction(action:String):void
		{
			var _meshContainer:MovieMeshContainer3D;
			
			for each (_meshContainer in _meshes)
			_meshContainer.stop();
			
			for each (_meshContainer in _meshes)
			_meshContainer.play(action);
		}
		
		public function newAll():void
		{
			var _mesh:MovieMesh;
			
			// MDJ
			for each (var _meshContainer:MovieMeshContainer3D in _meshes)
			{
				_meshContainer.stop();
				
				//MD2
				for each (_mesh in _meshContainer.children)
				_mesh.visible = (_meshContainer == _meshes[0]);
			}
		}
		
		public function activate(modelDatas:Vector.<ModelData>):void
		{
			// all prototype loaded
			for each (var modelData:ModelData in modelDatas)
			{
				// MDJ
				var _meshContainer:MovieMeshContainer3D = modelData.model as MovieMeshContainer3D;
				_meshes.push(_meshContainer);
				scene.addChild(_meshContainer);
				_meshContainer.visible = true;
				
				//MD2
				for each (var _mesh:MovieMesh in _meshContainer.children)
				_mesh.visible = (modelData.id == "0");
			}
			
			// loading done
			mouseEnabled = mouseChildren = true;
			
			// reload for _jsonData?
			if (_jsonData)
			{
				applyJSON(_jsonData);
				
				// clean up
				_jsonData = null;
			}
		}
	}
}