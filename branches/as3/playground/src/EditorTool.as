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
			var _menu:SDDialog = new SDDialog(<question><![CDATA[Select Pant]]>
					<answer src="as:onUserSelect('pant_1')"><![CDATA[pant_1]]></answer>
					<answer src="as:onUserSelect('pant_2')"><![CDATA[pant_2]]></answer>
					</question>, this);
			_container.addChild(_menu);
			_menu.x = 10;
			
			var _menuAction:SDDialog = new SDDialog(<question><![CDATA[Select Action]]>
					<answer src="as:onUserSelectAction('talk')"><![CDATA[Talk]]></answer>
					<answer src="as:onUserSelectAction('walk')"><![CDATA[Walk]]></answer>
					</question>, this);
			_container.addChild(_menuAction);
			_menuAction.x = 10;
			_menuAction.y = _menu.y + _menu.height + 10;
		}
			
		public function onUserSelect(action:String):void
		{
			_meshes[0].stop();
			_meshes[1].stop();
			switch (action)
			{
				case "pant_1":
					_meshes[0].getChildByName("Pant").visible = true;
					_meshes[1].getChildByName("Pant").visible = false;
				break;
				case "pant_2":
					_meshes[0].getChildByName("Pant").visible = false;
					_meshes[1].getChildByName("Pant").visible = true;
				break;
			}
			_meshes[0].play(_meshes[0].currentLabel);
			_meshes[1].play(_meshes[1].currentLabel);
		}
		
		public function onUserSelectAction(action:String):void
		{
			_meshes[0].stop();
			_meshes[1].stop();
			
			_meshes[0].play(action);
			_meshes[1].play(action);
		}
		
		private var _totalModel:int = 0;
		private var _meshes:Vector.<MovieMeshContainer3D> = new Vector.<MovieMeshContainer3D>(); 
		public function activate(modelData:ModelData):void
		{
			_totalModel++;
			
			var _prototype:MovieMeshContainer3D = modelData.model as MovieMeshContainer3D;
			_container.scene.addChild(_prototype);
			
			_meshes.push(_prototype);
			
			if(_totalModel==2)
			{
				trace("Done");
				_meshes[0].play("talk");
				_meshes[1].play("talk");
				
				for each(var _mesh:MovieMesh in _meshes[1].children)
				{
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