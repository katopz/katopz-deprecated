package
{
	import away3dlite.core.base.Mesh;
	import away3dlite.materials.ColorMaterial;
	import away3dlite.materials.WireframeMaterial;
	import away3dlite.templates.PhysicsTemplate;
	import away3dlite.ui.Keyboard3D;
	
	import flash.geom.Vector3D;
	
	import jiglib.physics.RigidBody;
	import jiglib.plugin.away3dlite.Away3DLiteMesh;

	[SWF(backgroundColor="#666666", frameRate="30", quality="MEDIUM", width="800", height="600")]
	/**
	 * Example : First Person Control
	 *
	 * @see http://away3d.googlecode.com/svn/trunk/fp10/Away3DLite/src
	 * @see http://jiglibflash.googlecode.com/svn/trunk/fp10/src
	 *
	 * @author katopz
	 */
	public class ExFirstPersonControl extends PhysicsTemplate
	{
		private var _camearaRigidBody:RigidBody;
		
		override protected function build():void
		{
			//system
			title += " | Keyboard Control | Use Arrow Key to move, C to fly | ";

			camera.y = -1000;

			//event
			new Keyboard3D(stage);
			
			//decor
			for (var i:int = 0; i < 16; i++)
			{
				var box:RigidBody = physics.createCube(new WireframeMaterial(0xFFFFFF * Math.random()), 25, 25, 25);
				box.moveTo(new Vector3D(1000* Math.random() - 1000* Math.random(), -50, 1000* Math.random() - 1000* Math.random()));
			}
			
			//camera instance
			_camearaRigidBody = physics.createSphere(new WireframeMaterial, 50);
			Away3DLiteMesh(_camearaRigidBody.skin).mesh.visible = false;
			_camearaRigidBody.moveTo(new Vector3D(0, -100, 0));
			_camearaRigidBody.mass = 3;
			
			alpha = .25;
		}

		override protected function onPreRender():void
		{
			// move instance
			var _position:Vector3D = Keyboard3D.position.clone();
			_position.scaleBy(10);

			var _f:Vector3D = _position.clone();
			_f.normalize();
			_camearaRigidBody.addWorldForce(_position, _camearaRigidBody.currentState.position);
			
			// camera position
			var _currentPosition:Vector3D = _camearaRigidBody.getTransform().position;
			camera.x = _currentPosition.x;
			camera.y = _currentPosition.y;
			camera.z = _currentPosition.z;
			
			// camera look
			camera.rotationX -= view.mouseY/300;
			camera.rotationY += view.mouseX/400;
			
			// run
			physics.step();
		}
	}
}