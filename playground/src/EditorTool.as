package
{
	import away3dlite.animators.BonesAnimator;
	import away3dlite.animators.MovieMesh;
	import away3dlite.animators.MovieMeshContainer3D;
	import away3dlite.builders.MDJBuilder;
	import away3dlite.core.utils.Debug;
	import away3dlite.materials.BitmapFileMaterial;
	import away3dlite.materials.WireframeMaterial;
	import away3dlite.primitives.LineSegment;
	import away3dlite.templates.BasicTemplate;
	import away3dlite.templates.Template;

	import com.adobe.serialization.json.JSON;
	import com.cutecoma.playground.data.ModelData;
	import com.sleepydesign.components.SDDialog;
	import com.sleepydesign.events.RemovableEventDispatcher;
	import com.sleepydesign.utils.FileUtil;
	import com.sleepydesign.utils.LoaderUtil;

	import flash.events.Event;
	import flash.geom.Vector3D;
	import flash.net.FileReference;
	import flash.utils.*;

	import org.osflash.signals.Signal;

	/*
	   TODO : open and read from model pool
	 */
	public class EditorTool extends RemovableEventDispatcher
	{
		private var _currentModel:MovieMeshContainer3D;
		private var _bonesAnimator:BonesAnimator;

		private var _container:Template;
		private var _loadedModel:int = 0;
		private var _totalModel:int = 4;

		private var _meshes:Vector.<MovieMeshContainer3D>;

		public static var initSignal:Signal = new Signal(XMLList);
		private var _xmlData:XML;
		
		private var _jasonData:Object;

		public function EditorTool(container:BasicTemplate, size:int = 500)
		{
			_container = container;

			// axis
			var _lines:Vector.<LineSegment> = new Vector.<LineSegment>(3, true);
			_lines[0] = new LineSegment(new WireframeMaterial(0xFF0000), new Vector3D(0, 0, 0), new Vector3D(size, 0, 0));
			_lines[1] = new LineSegment(new WireframeMaterial(0x00FF00), new Vector3D(0, 0, 0), new Vector3D(0, size, 0));
			_lines[2] = new LineSegment(new WireframeMaterial(0x0000FF), new Vector3D(0, 0, 0), new Vector3D(0, 0, size));

			for each (var _line:LineSegment in _lines)
				_container.scene.addChild(_line);
		}

		public function initXML(src:String):void
		{
			LoaderUtil.loadXML(src, function(event:Event):void
				{
					if (event.type == "complete")
						buildFromXML(event.target.data);
				});
		}

		private var _menuCharactor:SDDialog;
		private var _textureMenu:SDDialog;
		private var _menuPart:SDDialog;

		private function buildFromXML(xmlData:XML):void
		{
			_xmlData = xmlData;
			_menuCharactor = new SDDialog(<question><![CDATA[Select Charactor]]>
					<answer src="as:onSelectCharactor('man')"><![CDATA[Man]]></answer>
					<answer src="as:onSelectCharactor('woman')"><![CDATA[Women]]></answer>
				</question>, this);
			_container.addChild(_menuCharactor);
			_menuCharactor.x = 10;
			_menuCharactor.y = 80;
		}

		public function onSelectCharactor(charType:String):void
		{
			var _xmlPrototype:XMLList = _xmlData.chars.model.(@type == charType);

			reset();

			initSignal.dispatch(_xmlPrototype);

			initMenu(charType);

			_container.mouseEnabled = _container.mouseChildren = false;
		}

		private var _menuAction:SDDialog;
		private var _menu:SDDialog;
		private var _charType:String;

		private function initMenu(charType:String):void
		{
			_charType = charType;

			if (_menuAction)
			{
				_container.removeChild(_menuAction);
				_menuAction = null;
			}

			if (_menu)
			{
				_container.removeChild(_menu);
				_menu = null;
			}

			if (_menuPart)
			{
				_container.removeChild(_menuPart);
				_menuPart = null;
			}

			_menuAction = new SDDialog(<question><![CDATA[Select Action]]>
					<answer src="as:onSelectAction('talk')"><![CDATA[Talk]]></answer>
					<answer src="as:onSelectAction('walk')"><![CDATA[Walk]]></answer>
				</question>, this);
			_container.addChild(_menuAction);
			_menuAction.x = 10;
			_menuAction.y = _menuCharactor.y + _menuCharactor.height + 10;

			_menu = new SDDialog(<question><![CDATA[Menu]]>
					<answer src="as:onSelectMenu('open')"><![CDATA[Open]]></answer>
					<answer src="as:onSelectMenu('save')"><![CDATA[Save]]></answer>
				</question>, this);
			_container.addChild(_menu);
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
					_container.addChild(_menuPart);
					_menuPart.x = 10;
					_menuPart.y = _menu.y + _menu.height + 10;
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
					_container.addChild(_menuPart);
					_menuPart.x = 10;
					_menuPart.y = _menu.y + _menu.height + 10;
					break;
			}
		}

		public function createTextureMenu(meshType:String, meshID:int, x:int = 0, y:int = 0):void
		{
			if (_textureMenu)
			{
				_container.removeChild(_textureMenu);
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
			_container.addChild(_textureMenu);
			_textureMenu.x = x || _textureMenu.x;
			_textureMenu.y = y || _textureMenu.y;
		}

		public function reset():void
		{
			_loadedModel = 0;

			for each (var _meshContainer:MovieMeshContainer3D in _meshes)
				_meshContainer.destroy();

			_meshes = new Vector.<MovieMeshContainer3D>();
		}

		public function onSelectMenu(action:String):void
		{
			switch (action)
			{
				case "open":
					FileUtil.open(["*.mdj"], onMDJOpen);
					break;
				case "save":
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
					new FileReference().save(_mdjBuilder.getMDJ(_saveMeshes), "user.mdj");
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

		private function openJSON(jasonData:Object):void
		{
			// not done yet leave _jasonData as is
			_jasonData = jasonData;

			// check charactor type
			if (String(_jasonData.meshes[0]).indexOf("/" + _charType + "/") == -1)
			{
				// reload protype e.g. "chars/man/meshes/shirt_1.md2"
				onSelectCharactor(_jasonData.meshes[0].split("/")[1]);
			}
			else
			{
				var _meshList:Array = _jasonData.meshes;
				var _materialList:Array = _jasonData.textures;

				for (var i:int = 0; i < _meshList.length; i++)
				{
					var src:String = _meshList[i];
					var _part:String = src.split(".")[0];
					_part = _part.slice(src.lastIndexOf("/") + 1);

					onSelectMesh(_part);
					onSelectTexture(_materialList[i]);
				}

				// it's done
				_jasonData = null;
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

		public function onSelectAction(action:String):void
		{
			var _meshContainer:MovieMeshContainer3D;

			for each (_meshContainer in _meshes)
				_meshContainer.stop();

			for each (_meshContainer in _meshes)
				_meshContainer.play(action);
		}

		public function activate(modelData:ModelData):void
		{
			_loadedModel++;

			var _prototype:MovieMeshContainer3D = modelData.model as MovieMeshContainer3D;
			_meshes.push(_prototype);

			var _mesh:MovieMesh;

			for each (_mesh in _prototype.children)
				_mesh.visible = false;

			Debug.trace(_loadedModel + "/" + _totalModel);

			if (_loadedModel == _totalModel)
			{
				for each (var _meshContainer:MovieMeshContainer3D in _meshes)
				{
					_container.scene.addChild(_meshContainer);
					_meshContainer.visible = true;
					for each (_mesh in _meshContainer.children)
						_mesh.visible = (_meshContainer == _meshes[0]);
				}

				_container.mouseEnabled = _container.mouseChildren = true;

				// reload for _jasonData?
				if (_jasonData)
					openJSON(_jasonData);
			}
		}
	}
}