package
{
	import away3dlite.animators.BonesAnimator;
	import away3dlite.core.base.Object3D;
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
		public var currentModel:Object3D;
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
			var _menu:SDDialog = new SDDialog("test");
			_container.addChild(_menu);
		}

		public function activate(modelData:ModelData):void
		{
			// data ready let's bring editor out
			trace("activate");
			currentModel = modelData.model;
			_container.scene.addChild(currentModel);
			
			skinAnimation = currentModel.animationLibrary.getAnimation("default").animation as BonesAnimator;
		}
	}
}