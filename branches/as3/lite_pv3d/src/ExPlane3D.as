package
{
	import away3dlite.core.math.Plane3D;
	import away3dlite.core.utils.Debug;
	import away3dlite.materials.WireframeMaterial;
	import away3dlite.primitives.Cube6;
	import away3dlite.primitives.Trident;
	import away3dlite.templates.PV3DTemplate;

	import flash.events.MouseEvent;
	import flash.geom.Vector3D;

	import org.papervision3d.core.geom.renderables.Vertex3D;
	import org.papervision3d.core.math.Number3D;
	import org.papervision3d.materials.ColorMaterial;
	import org.papervision3d.materials.utils.MaterialsList;
	import org.papervision3d.objects.primitives.Cube;

	[SWF(backgroundColor="#CCCCCC", frameRate="30", width="640", height="480")]
	public class ExPlane3D extends PV3DTemplate
	{
		private var _red_cube:Cube6;
		private var _green_cube:Cube6;
		private var _pv3d_cube:Cube;

		override protected function onInit():void
		{
			// debug
			Debug.active = true;
			scene.addChild(new Trident);

			// lite
			scene.addChild(_red_cube = new Cube6(new WireframeMaterial(0xFF0000)));
			scene.addChild(_green_cube = new Cube6(new WireframeMaterial(0x00FF00)));

			// pv3d
			var _mats:MaterialsList = new MaterialsList();
			_mats.addMaterial(new ColorMaterial(0x0000FF, .5), "all");
			_pv3d_root.addChild(_pv3d_cube = new Cube(_mats, 100, 100, 100));

			// camera
			camera.y = -1000;
			camera.lookAt(new Vector3D);

			// event
			stage.addEventListener(MouseEvent.CLICK, clickHandler);
		}

		private function clickHandler(event:MouseEvent):void
		{
			// pv3d
			var _pv3d_intersect:Vector3D = PV3DProxy.getRayPosition(_pv3d_camera, _pv3d_viewport.containerSprite.mouseX, _pv3d_viewport.containerSprite.mouseY);

			_red_cube.x = _pv3d_cube.x = _pv3d_intersect.x;
			_red_cube.y = _pv3d_cube.y = _pv3d_intersect.y;
			_red_cube.z = _pv3d_cube.z = _pv3d_intersect.z;

			// lite
			var _planeToDragOn:Vector3D = Plane3D.fromNormalAndPoint(Vector3D.Y_AXIS, new Vector3D(0, 0, 0));
			var _ray:Vector3D = camera.lens.unProject(view.mouseX, view.mouseY, camera.screenMatrix3D.position.z);
			_ray = camera.transform.matrix3D.transformVector(_ray);

			_green_cube.transform.matrix3D.position = Plane3D.getIntersectionLine(_planeToDragOn, camera.position, _ray);

			// debug
			Debug.trace("! red : " + _red_cube.position);
			Debug.trace("! green : " + _green_cube.position);
		}
	}
}

import flash.geom.Vector3D;

import org.papervision3d.cameras.Camera3D;
import org.papervision3d.core.geom.renderables.Vertex3D;
import org.papervision3d.core.math.Number3D;
import org.papervision3d.core.math.Plane3D;

internal class PV3DProxy
{
	public static function getRayPosition(pv3d_camera:Camera3D, x:Number, y:Number):Vector3D
	{
		var plane3D:Plane3D = new Plane3D(new Number3D(0, 1, 0), Number3D.ZERO);
		var pv3d_ray:Number3D = pv3d_camera.unproject(x, y);
		pv3d_ray = Number3D.add(pv3d_ray, pv3d_camera.position);

		var cameraVertex3D:Vertex3D = new Vertex3D(pv3d_camera.x, pv3d_camera.y, pv3d_camera.z);
		var rayVertex3D:Vertex3D = new Vertex3D(pv3d_ray.x, pv3d_ray.y, pv3d_ray.z);

		var _position:Vertex3D = plane3D.getIntersectionLine(cameraVertex3D, rayVertex3D);

		return new Vector3D(_position.x, _position.y, _position.z);
	}
}