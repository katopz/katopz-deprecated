package
{
	import away3dlite.core.base.Mesh;
	import away3dlite.core.utils.Debug;
	import away3dlite.events.MouseEvent3D;
	import away3dlite.materials.ColorMaterial;
	import away3dlite.materials.WireColorMaterial;
	import away3dlite.materials.WireframeMaterial;
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
	public class ExMousePlane3D2 extends PhysicsTemplate
	{
		private var onDraging:Boolean = false;

		private var currDragBody:RigidBody;
		private var dragConstraint:JConstraintWorldPoint;
		
		private var _sphere:Sphere;
		private var _sphere2:Sphere;
		private var _plane:Plane;

		override protected function build():void
		{
			title += " | Mouse Control | Use mouse to drag red ball | ";

			camera.y = -1000;

			init3D();

			scene.addChild(_sphere = new Sphere(new WireColorMaterial(null, 0.5)));
			scene.addChild(_sphere2 = new Sphere(new WireColorMaterial(null, 0.5)));
			scene.addChild(_plane = new Plane(new WireColorMaterial(null,0.5),1000,1000));
			
			ground.rotationX = 15;
			ground.rotationY = 15;
			ground.rotationZ = 15;
			
			_plane.rotationX = 15;
			_plane.rotationY = 15;
			_plane.rotationZ = 15;
			
			scene.addEventListener(MouseEvent3D.MOUSE_DOWN, onSceneMouseUp);
		}
		
		private function onSceneMouseUp(e:MouseEvent3D):void
		{
			Debug.trace("---"+e.scenePosition);
			_sphere2.x = e.scenePosition.x;
			_sphere2.z = e.scenePosition.z;
		}

		private function init3D():void
		{
			// Layer
			var layer:Sprite = new Sprite();
			view.addChild(layer);
			
			Debug.active = true;
			
			//currDragBody = physics.createSphere(new ColorMaterial(0xFF0000), 25);
			//Away3DLiteMesh(ball.skin).mesh.layer = layer;

			stage.addEventListener(MouseEvent.MOUSE_DOWN, handleMousePress);
		}

		private function handleMousePress(event:MouseEvent):void
		{
			//var layer:Sprite = event.target as Sprite;

			/*var _startMousePos:Vector3D = currDragBody.getTransform().position.clone();
			
			var _matrix3D:Matrix3D = ground.getTransform();
			var _normal:Vector3D = _matrix3D.deltaTransformVector(Vector3D.Y_AXIS);
				
			planeToDragOn = JMath3D.fromNormalAndPoint(_normal, new Vector3D(0, 0, -_startMousePos.z));

			var p:Vector3D = currDragBody.currentState.position;
			var bodyPoint:Vector3D = _startMousePos.subtract(p);

			dragConstraint = new JConstraintWorldPoint(currDragBody, bodyPoint, _startMousePos);
			physics.engine.addConstraint(dragConstraint);*/
			
			// plane3D
			var _matrix3D:Matrix3D = ground.getTransform();
			var _normal:Vector3D = _matrix3D.deltaTransformVector(Vector3D.Y_AXIS);
			var planeToDragOn:Vector3D = JMath3D.fromNormalAndPoint(_normal, new Vector3D(0, 0, 0));
			
			//update camera position
			var _cameraPosition:Vector3D = view.camera.position;
			
			//get the direction vector of the mouse position
			var ray:Vector3D = unproject(camera.transform.matrix3D, camera.focus, camera.zoom, view.mouseX, -view.mouseY);
			
			//convert ray to a 3d point in the ray direction from the camera
			//ray = ray.add(_cameraPosition);
			
			//find the intersection of the line defined by the camera and the ray position with the plane3D
			var intersect:Vector3D = JMath3D.getIntersectionLine(planeToDragOn, _cameraPosition, ray);
			
			_sphere.x = intersect.x;
			_sphere.z = intersect.z;
			
			Debug.trace("***"+intersect);
		}
		
		private function unproject(matrix3D:Matrix3D, focus:Number, zoom:Number, mX:Number, mY:Number):Vector3D
		{
			/*
			var persp:Number = (focus * zoom) / focus;
			var vector:Vector3D = new Vector3D(mX / persp, -mY / persp, focus);
			return matrix3D.transformVector(vector);
			*/
			var persp:Number = -0.84908;//(focus * zoom) / matrix3D.position.z;
			var vector:Vector3D = new Vector3D(mX / persp, -mY / persp, matrix3D.position.z - focus);
			return matrix3D.transformVector(vector);
		}

		override protected function onPreRender():void
		{
			//run
			physics.step();

			//system
			camera.lookAt(Away3DLiteMesh(ground.skin).mesh.position);
		}
	}
}