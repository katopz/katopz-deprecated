package
{
	import away3dlite.animators.BonesAnimator;
	import away3dlite.animators.MovieMesh;
	import away3dlite.animators.MovieMeshContainer3D;
	import away3dlite.core.base.Mesh;
	import away3dlite.core.base.Object3D;
	import away3dlite.core.utils.Debug;
	import away3dlite.materials.BitmapFileMaterial;
	import away3dlite.materials.BitmapMaterial;
	import away3dlite.materials.WireframeMaterial;
	import away3dlite.primitives.LineSegment;
	import away3dlite.templates.BasicTemplate;
	import away3dlite.templates.Template;
	
	import com.cutecoma.playground.data.ModelData;
	import com.sleepydesign.components.SDDialog;
	import com.sleepydesign.events.RemovableEventDispatcher;
	import com.sleepydesign.utils.LoaderUtil;
	
	import flash.events.Event;
	import flash.geom.Vector3D;
	import flash.utils.*;

	public class EditorTool extends RemovableEventDispatcher
	{
		private var _container:Template;
		public var currentModel:MovieMeshContainer3D;
		public var skinAnimation:BonesAnimator;

		public function EditorTool(container:BasicTemplate, size:int = 500)
		{
			_container = container;

			// axis
			var _lines:Vector.<LineSegment> = new Vector.<LineSegment>(3, true);
			_lines[0] = new LineSegment(new WireframeMaterial(0xFF0000), new Vector3D(0, 0, 0), new Vector3D(size, 0, 0));
			_lines[1] = new LineSegment(new WireframeMaterial(0x00FF00), new Vector3D(0, 0, 0), new Vector3D(0, size, 0));
			_lines[2] = new LineSegment(new WireframeMaterial(0x0000FF), new Vector3D(0, 0, 0), new Vector3D(0, 0, size));

			for each (var _line:LineSegment in _lines)
				container.scene.addChild(_line);

			// add menu open, save, compress
		}

		public function initXML(src:String):void
		{
			LoaderUtil.loadXML(src, function(event:Event):void
				{
					if (event.type == "complete")
						buildFromXML(event.target.data);
				});
		}

		private function buildFromXML(xml:XML):void
		{
			var _menu:SDDialog = new SDDialog(<question><![CDATA[Menu]]>
					<answer src="as:onUserSelectMenu('Save')"><![CDATA[Save]]></answer>
					</question>, this);
			_container.addChild(_menu);
			_menu.x = 10;
			_menu.y = 150;
			
			var _menuPart:SDDialog = new SDDialog(<question><![CDATA[Select Part]]>
					<answer src="as:onUserSelect('hair_1')"><![CDATA[hair_1]]></answer>
					<answer src="as:onUserSelect('hair_2')"><![CDATA[hair_2]]></answer>
					<answer src="as:onUserSelect('hair_3')"><![CDATA[hair_3]]></answer>
					<answer src="as:onUserSelect('hair_4')"><![CDATA[hair_4]]></answer>
					<answer src="as:onUserSelect('head_1')"><![CDATA[head_1]]></answer>
					<answer src="as:onUserSelect('shirt_1')"><![CDATA[shirt_1]]></answer>
					<answer src="as:onUserSelect('shirt_2')"><![CDATA[shirt_2]]></answer>
					<answer src="as:onUserSelect('shirt_3')"><![CDATA[shirt_3]]></answer>
					<answer src="as:onUserSelect('shirt_4')"><![CDATA[shirt_4]]></answer>
					<answer src="as:onUserSelect('pant_1')"><![CDATA[pant_1]]></answer>
					<answer src="as:onUserSelect('pant_2')"><![CDATA[pant_2]]></answer>
					<answer src="as:onUserSelect('pant_3')"><![CDATA[pant_3]]></answer>
					<answer src="as:onUserSelect('shoes_1')"><![CDATA[shoes_1]]></answer>
					<answer src="as:onUserSelect('shoes_2')"><![CDATA[shoes_2]]></answer>
					</question>, this);
			_container.addChild(_menuPart);
			_menuPart.x = 10;
			_menuPart.y = _menu.y + _menu.height + 10;
			
			var _textureMenu:SDDialog = new SDDialog(<question><![CDATA[Select Texture]]>
					<answer src="as:onUserSelectTexture('hair','chars/man/texture_1/hair_1.png')"><![CDATA[hair_1]]></answer>
					<answer src="as:onUserSelectTexture('hair','chars/man/texture_1/hair_2.png')"><![CDATA[hair_2]]></answer>
					<answer src="as:onUserSelectTexture('hair','chars/man/texture_1/hair_3.png')"><![CDATA[hair_3]]></answer>
					<answer src="as:onUserSelectTexture('hair','chars/man/texture_1/hair_4.png')"><![CDATA[hair_4]]></answer>
					</question>, this);
			_container.addChild(_textureMenu);
			_textureMenu.x = _menuPart.width + 20;
			_textureMenu.y = _menu.y + _menu.height + 10;
			
			var _menuAction:SDDialog = new SDDialog(<question><![CDATA[Select Action]]>
					<answer src="as:onUserSelectAction('talk')"><![CDATA[Talk]]></answer>
					<answer src="as:onUserSelectAction('walk')"><![CDATA[Walk]]></answer>
					</question>, this);
			_container.addChild(_menuAction);
			_menuAction.x = 10;
			_menuAction.y = _menuPart.y + _menuPart.height + 10;
		}
		
		public function reset():void
		{
			_loadedModel = 0;
			
			for each(var _meshContainer:MovieMeshContainer3D in _meshes)
				_meshContainer.destroy();
				
			_meshes = new Vector.<MovieMeshContainer3D>();
		}
			
		public function onUserSelectMenu(action:String):void
		{
			// collect mesh from visibility
			
			// pack and save
			
		}
		
		public function onUserSelectTexture(part:String, src:String):void
		{
			var _meshContainer:MovieMeshContainer3D;
			var _type:String = part.split("_")[0];
			var _id:int = int(part.split("_")[1])-1;
			
			for each(_meshContainer in _meshes)
			{
				var _mesh:MovieMesh = _meshContainer.getChildByName(_type) as MovieMesh;
				_mesh.material = new BitmapFileMaterial(src);
			}
		}
		
		public function onUserSelect(action:String):void
		{
			var _meshContainer:MovieMeshContainer3D;
			
			// hold
			for each(_meshContainer in _meshes)
				_meshContainer.stop();
			
			var _type:String = action.split("_")[0];
			var _id:int = int(action.split("_")[1])-1;
			
			// reset
			for each(_meshContainer in _meshes)
				_meshContainer.getChildByName(_type).visible = false;
			
			// pick one
			_meshes[_id].getChildByName(_type).visible = true;
			
			// resume
			for each(_meshContainer in _meshes)
				_meshContainer.play(_meshContainer.currentLabel);
		}
		
		public function onUserSelectAction(action:String):void
		{
			var _meshContainer:MovieMeshContainer3D;
			/*
			for each(_meshContainer in _meshes)
				_meshContainer.stop();
			*/
			
			for each(_meshContainer in _meshes)
				_meshContainer.play(action);
		}
		
		private var _loadedModel:int = 0;
		private var _totalModel:int = 4;
		
		private var _meshes:Vector.<MovieMeshContainer3D>; 
		
		public function activate(modelData:ModelData):void
		{
			_loadedModel++;
			
			var _prototype:MovieMeshContainer3D = modelData.model as MovieMeshContainer3D;
			_container.scene.addChild(_prototype);
			
			_meshes.push(_prototype);
			
			if(_loadedModel==_totalModel)
			{
				for each(var _meshContainer:MovieMeshContainer3D in _meshes)
				{
					//_meshContainer.play("walk");
					if(_meshContainer!=_meshes[0])
						for each(var _mesh:MovieMesh in _meshContainer.children)
							_mesh.visible = false;
				}
			}
		}
	}
}