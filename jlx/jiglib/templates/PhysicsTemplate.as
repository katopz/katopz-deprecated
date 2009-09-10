package jiglib.templates
{
	import away3dlite.core.render.*;
	import away3dlite.materials.WireframeMaterial;
	import away3dlite.primitives.Cube6;
	import away3dlite.templates.FastTemplate;
	
	import jiglib.physics.RigidBody;
	import jiglib.plugin.away3dlite.Away3DLitePhysics;
	
	/**
	 * Physics Template
	 * 
 	 * @see http://away3d.googlecode.com/svn/branches/JigLibLite/src
 	 * @see http://away3d.googlecode.com/svn/trunk/fp10/Examples/JigLibLite
 	 * 
	 * @author katopz
	 */
	public class PhysicsTemplate extends FastTemplate
	{
		protected var physics:Away3DLitePhysics;
		protected var ground:RigidBody;
		
		protected override function onInit():void
		{
			title += " | JigLibLite Physics";
			
			physics = new Away3DLitePhysics(scene, 10);
			ground = physics.createGround(new WireframeMaterial(), 1000, 0);
			ground.movable = false;
			ground.friction = 0.2;
			ground.restitution = 0.8;
			
			// debug cube, to be remove
			var length:int = 300;
			var oCube:Cube6 = new Cube6(new WireframeMaterial(0xFFFFFF), 10, 10, 10);
			scene.addChild(oCube);

			var xCube:Cube6 = new Cube6(new WireframeMaterial(0xFF0000), 10, 10, 10);
			xCube.x = length;
			scene.addChild(xCube);

			var yCube:Cube6 = new Cube6(new WireframeMaterial(0x00FF00), 10, 10, 10);
			yCube.y = length;
			scene.addChild(yCube);

			var zCube:Cube6 = new Cube6(new WireframeMaterial(0x0000FF), 10, 10, 10);
			zCube.z = length;
			scene.addChild(zCube);
			
			var _zCube:Cube6 = new Cube6(new WireframeMaterial(0x000033), 10, 10, 10);
			_zCube.z = -length;
			scene.addChild(_zCube);
			
			build();
		}
		
		protected function build():void
		{
			// override me
		}
	}
}