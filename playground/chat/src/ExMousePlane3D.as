package
{
	import away3dlite.materials.ColorMaterial;
	import away3dlite.materials.WireframeMaterial;
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
		private var onDraging:Boolean = false;

		private var currDragBody:RigidBody;
		private var dragConstraint:JConstraintWorldPoint;
		private var planeToDragOn:Vector3D;

		override protected function build():void
		{
			title += " | Mouse Control | Use mouse to drag red ball | ";

			camera.y = -1000;

			init3D();

			stage.addEventListener(MouseEvent.MOUSE_UP, handleMouseRelease);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
			
			alpha=.1
		}

		private function init3D():void
		{
			// Layer
			var layer:Sprite = new Sprite();
			view.addChild(layer);

			var color:uint;
			for (var i:int = 0; i < 3; i++)
			{
				color = (i == 0) ? 0xff8888 : 0xeeee00;

				var ball:RigidBody;
				if (i == 2)
				{
					ball = physics.createSphere(new ColorMaterial(0xFF0000), 25);

					// draggable
					currDragBody = ball;
					Away3DLiteMesh(ball.skin).mesh.layer = layer;
				}
				else
				{
					ball = physics.createSphere(new WireframeMaterial(), 25);
				}
				ball.mass = 5;
				ball.moveTo(new Vector3D(-100, -500 - (100 * i + 100), -100));
			}

			layer.addEventListener(MouseEvent.MOUSE_DOWN, handleMousePress);
		}

		private function handleMousePress(event:MouseEvent):void
		{
			onDraging = true;
			var layer:Sprite = event.target as Sprite;

			var _startMousePos:Vector3D = currDragBody.getTransform().position.clone();
			
			var _matrix3D:Matrix3D = ground.getTransform();
			var _normal:Vector3D = _matrix3D.deltaTransformVector(Vector3D.Y_AXIS);
				
			planeToDragOn = JMath3D.fromNormalAndPoint(_normal, new Vector3D(0, 0, 0));

			var p:Vector3D = currDragBody.currentState.position;
			var bodyPoint:Vector3D = _startMousePos.subtract(p);

			dragConstraint = new JConstraintWorldPoint(currDragBody, bodyPoint, _startMousePos);
			physics.engine.addConstraint(dragConstraint);
		}

		// TODO:clean up/by pass
		private function handleMouseMove(event:MouseEvent):void
		{
			if (onDraging)
			{
				var ray:Vector3D = JMath3D.unproject(camera.transform.matrix3D, camera.focus, camera.zoom, view.mouseX, -view.mouseY);
				dragConstraint.worldPosition = JMath3D.getIntersectionLine(planeToDragOn, view.camera.position, ray);
			}
		}

		private function handleMouseRelease(event:MouseEvent):void
		{
			if (onDraging)
			{
				onDraging = false;
				physics.engine.removeConstraint(dragConstraint);
				currDragBody.setActive();
			}
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