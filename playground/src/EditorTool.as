package
{
	import away3dlite.containers.Scene3D;
	import away3dlite.materials.WireframeMaterial;
	import away3dlite.primitives.LineSegment;
	
	import com.sleepydesign.events.RemovableEventDispatcher;
	
	import flash.geom.Vector3D;
	
	public class EditorTool extends RemovableEventDispatcher
	{
		public function EditorTool(scene:Scene3D, size:int = 500):void
		{
			// axis
			var _lines:Vector.<LineSegment> = new Vector.<LineSegment>(3, true);
			_lines[0] = new LineSegment(new WireframeMaterial(0xFF0000), new Vector3D(0, 0, 0), new Vector3D(size, 0, 0));
			_lines[1] = new LineSegment(new WireframeMaterial(0x00FF00), new Vector3D(0, 0, 0), new Vector3D(0, size, 0));
			_lines[2] = new LineSegment(new WireframeMaterial(0x0000FF), new Vector3D(0, 0, 0), new Vector3D(0, 0, size));
			
			for each(var _line:LineSegment in _lines)
				scene.addChild(_line);
		}
	}
}