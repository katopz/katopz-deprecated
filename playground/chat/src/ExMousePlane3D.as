package
{
	import away3dlite.core.math.Plane3D;
	import away3dlite.core.utils.Debug;
	import away3dlite.events.MouseEvent3D;
	import away3dlite.materials.ColorMaterial;
	import away3dlite.materials.WireColorMaterial;
	import away3dlite.primitives.Plane;
	import away3dlite.primitives.Sphere;
	import away3dlite.templates.PhysicsTemplate;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import jiglib.math.*;
	import jiglib.physics.*;
	import jiglib.physics.constraint.*;
	import jiglib.plugin.away3dlite.Away3DLiteMesh;
	
	[SWF(backgroundColor="#666666", frameRate="30", quality="MEDIUM", width="800", height="600")]
	/**
	 * Example : Mouse Control
	 *
	 * @see http://away3d.googlecode.com/svn/trunk/fp10/Away3DLite/src
	 * @see http://jiglibflash.googlecode.com/svn/trunk/fp10/src
	 *
	 * @author katopz
	 */
	public class ExMousePlane3D extends PhysicsTemplate
	{
		private var _isDrag:Boolean = false;
		
		private var _currDragBody:RigidBody;
		private var _dragConstraint:JConstraintWorldPoint;
		
		private var _sphere:Sphere;
		
		override protected function build():void
		{
			title += " | Mouse Control | Use mouse to drag red ball | ";
			
			camera.y = -1000;
			
			init3D();
			
			scene.addChild(_sphere = new Sphere(new WireColorMaterial(null, 0.5), 50));
			
			ground.rotationX = 15;
			ground.rotationY = 15;
			ground.rotationZ = 15;
		}
		
		private function init3D():void
		{
			Debug.active = true;
			
			_currDragBody = physics.createSphere(new ColorMaterial(0xFF0000), 25);
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		private function onMouseUp(event:MouseEvent):void
		{
			physics.engine.removeConstraint(_dragConstraint);
			_currDragBody.setActive();
		}
		
		private function onMouseDown(event:MouseEvent):void
		{
			var _startMousePos:Vector3D = _currDragBody.getTransform().position.clone();
			
			var _matrix3D:Matrix3D = ground.getTransform();
			var _normal:Vector3D = _matrix3D.deltaTransformVector(Vector3D.Y_AXIS);
			
			var objectPoint:Vector3D = _currDragBody.currentState.position;
			var bodyPoint:Vector3D = _startMousePos.subtract(objectPoint);
			
			// lite
			var _planeToDragOn:Vector3D = Plane3D.fromNormalAndPoint(_normal, new Vector3D(0, 0, 0));
			var _ray:Vector3D = camera.lens.unProject(view.mouseX, view.mouseY, camera.screenMatrix3D.position.z);
			_ray = camera.transform.matrix3D.transformVector(_ray);
			
			var _position:Vector3D = _sphere.transform.matrix3D.position = Plane3D.getIntersectionLine(_planeToDragOn, camera.position, _ray);
			
			_dragConstraint = new JConstraintWorldPoint(_currDragBody, bodyPoint, _position);
			physics.engine.addConstraint(_dragConstraint);
			
			// debug
			Debug.trace("! _sphere : " + _sphere.position);
		}
		
		override protected function onPreRender():void
		{
			//run
			physics.step();
			
			if (_currDragBody.currentState.position.y > 200)
				_currDragBody.moveTo(new Vector3D(0, -200, 0));
			
			//system
			camera.lookAt(ground.getTransform().position);
		}
	}
}