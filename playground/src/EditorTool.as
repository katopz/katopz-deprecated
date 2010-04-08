package
{
	import away3dlite.animators.BonesAnimator;
	import away3dlite.animators.MovieMesh;
	import away3dlite.animators.MovieMeshContainer3D;
	import away3dlite.core.base.Mesh;
	import away3dlite.core.base.Object3D;
	import away3dlite.core.utils.Debug;
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
					<answer src="as:onUserSelect('Hair_1')"><![CDATA[Hair_1]]></answer>
					<answer src="as:onUserSelect('Hair_2')"><![CDATA[Hair_2]]></answer>
					<answer src="as:onUserSelect('Hair_3')"><![CDATA[Hair_3]]></answer>
					<answer src="as:onUserSelect('Hair_4')"><![CDATA[Hair_4]]></answer>
					<answer src="as:onUserSelect('Head_1')"><![CDATA[Head_1]]></answer>
					<answer src="as:onUserSelect('Shirt_1')"><![CDATA[Shirt_1]]></answer>
					<answer src="as:onUserSelect('Shirt_2')"><![CDATA[Shirt_2]]></answer>
					<answer src="as:onUserSelect('Shirt_3')"><![CDATA[Shirt_3]]></answer>
					<answer src="as:onUserSelect('Shirt_4')"><![CDATA[Shirt_4]]></answer>
					<answer src="as:onUserSelect('Pant_1')"><![CDATA[Pant_1]]></answer>
					<answer src="as:onUserSelect('Pant_2')"><![CDATA[Pant_2]]></answer>
					<answer src="as:onUserSelect('Pant_3')"><![CDATA[Pant_3]]></answer>
					<answer src="as:onUserSelect('Shoes_1')"><![CDATA[Shoes_1]]></answer>
					<answer src="as:onUserSelect('Shoes_2')"><![CDATA[Shoes_2]]></answer>
					</question>, this);
			_container.addChild(_menuPart);
			_menuPart.x = 10;
			_menuPart.y = _menu.y + _menu.height + 10;
			
			var _menuAction:SDDialog = new SDDialog(<question><![CDATA[Select Action]]>
					<answer src="as:onUserSelectAction('talk')"><![CDATA[Talk]]></answer>
					<answer src="as:onUserSelectAction('walk')"><![CDATA[Walk]]></answer>
					</question>, this);
			_container.addChild(_menuAction);
			_menuAction.x = 10;
			_menuAction.y = _menuPart.y + _menuPart.height + 10;
		}
			
		public function onUserSelectMenu(action:String):void
		{
			// collect mesh from visibility
			
			// pack and save
			
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
			var _meshContainer:MovieMeshContainer3D
			for each(_meshContainer in _meshes)
				_meshContainer.stop();
			
			for each(_meshContainer in _meshes)
				_meshContainer.play(action);
		}
		
		private var _loadedModel:int = 0;
		private var _totalModel:int = 4;
		
		private var _meshes:Vector.<MovieMeshContainer3D> = new Vector.<MovieMeshContainer3D>(); 
		
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
					_meshContainer.play("walk");
					if(_meshContainer!=_meshes[0])
						for each(var _mesh:MovieMesh in _meshContainer.children)
							_mesh.visible = false;
				}
			}
			
			/*
			_totalModel++;
			trace("_totalModel:"+_totalModel);
			
			var _prototype:MovieMeshContainer3D = modelData.model as MovieMeshContainer3D;
			//_container.scene.addChild(man_1);
			
			// prepare dummy
			if(!currentModel)
			{
				currentModel = _prototype.clone() as MovieMeshContainer3D;
				_container.scene.addChild(currentModel);
				currentModel.play("talk");
			}
			
			if(_totalModel==2)
			{
				trace("Done");
				var _pant1:MovieMesh = currentModel.getChildByName("Pant") as MovieMesh;
				var _pant2:MovieMesh = _prototype.getChildByName("Pant") as MovieMesh;
				
				_pant1.visible = false;
				currentModel.removeChild(_pant1);
				
				_prototype.removeChild(_pant2);
				currentModel.addChild(_pant2);
			}
			*/
		}
	}
}