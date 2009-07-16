package
{
	import __AS3__.vec.Vector;
	
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	
	import jiglib.physics.RigidBody;
	import jiglib.plugin.*;
	import jiglib.plugin.away3dn.NativePhysics;
	
	import open3d.materials.LineMaterial;
	import open3d.objects.Object3D;
	import open3d.view.SimpleView;

	[SWF(width=800,height=600,backgroundColor=0x666666,frameRate=30)]
	/**
	 * @author bartekd
	 * @author katopz
	 */
	public class ExFallingBalls extends SimpleView
	{

		private var physics:NativePhysics;
		private var cubes:Array;

		override protected function create():void
		{
			var v:Object = {test:1};
			var vec : Vector.<Object> = Vector.<Object>(v);
			trace(vec[0].v);
			
			physics = new NativePhysics(renderer, 9);
			physics.createGround(new LineMaterial(), 1800, 200);
			cubes = [];
			for (var i:int = 0; i < 10; i++)
			{
//				var sphere:RigidBody = physics.createSphere(new WireframeMaterial(0xffffff), 30, 6, 6);
//				sphere.x = 100 - Math.random() * 200;
//				sphere.y = 700 + Math.random() * 3000;
//				sphere.z = 200 - Math.random() * 100;
				// sphere.rotationX, Y & Z coming soon!
//				sphere.material.restitution = 2; 

				// This is how to access the engine specific mesh/do3d
//				physics.getMesh(sphere).material = new WireframeMaterial(0xffffff);

				var cube:RigidBody = physics.createCube(new LineMaterial(), 60, 60, 60);

				cube.material.restitution = .2;
				//physics.getMesh(cube).material = new LineMaterial();

				cubes.push(cube);
			}

			refresh();

			/*
			   // Here's how to create a sphere without the shortcut method:
			   var manualSphere:Sphere = new Sphere(300, 8, 8, new LineMaterial());
			   renderer.addChild(manualSphere);

			   jmanualSphere = new JSphere(new NativeMesh(manualSphere), 300);
			   jmanualSphere.y = -Math.random() * 3000;
			   //jmanualSphere.movable = false;
			   physics.addBody(jmanualSphere);
			 */
			// = more code, but this is necessary for custom objects (ex. Collada)
			/*
			   var north:RigidBody = physics.createCube(new BitmapMaterial(), 1800, 50, 1800);
			   north.z = 850;
			   north.y = 700;
			   north.movable = false;

			   var south:RigidBody = physics.createCube(new BitmapMaterial(), 1800, 50, 1800);
			   south.z = -850;
			   south.y = 700;
			   south.movable = false;

			   var west:RigidBody = physics.createCube(new BitmapMaterial(), 50, 1800, 1800);
			   west.x = -850;
			   west.y = 700;
			   west.movable = false;

			   var east:RigidBody = physics.createCube(new BitmapMaterial(), 50, 1800, 1800);
			   east.x = 850;
			   east.y = 700;
			   east.movable = false;
			 */
			stage.addEventListener(MouseEvent.CLICK, refresh);
		}

		private function refresh(e:* = null):void
		{
			for (var i:int = 0; i < 10; i++)
			{
				var cube:RigidBody = cubes[i];
				cube.x = Math.random() * 900 - Math.random() * 900;
				cube.y = -200 - Math.random() * 3000;
				cube.y = -cube.y
				cube.z = Math.random() * 900 - Math.random() * 900;
				cube.rotationY = 10 * Math.random() * 2 * Math.PI;
				cube.rotationZ = 10 * Math.random() * 2 * Math.PI;
				cube.setActive();
			}
		}

		private var jmanualSphere:RigidBody

		override protected function prerender():void
		{
			physics.step();
			var world:Object3D = renderer.world;
			world.rotationY = 180 + (mouseX - stage.stageWidth / 2) / 5;
			//world.rotationZ = -(mouseY - stage.stageHeight / 2) / 5;
			world.rotationZ = 180
			//world.rotationY++;
			world.y = 500
			world.z = 2000
			world.rotationX = 10;

			for (var i:int = 0; i < 10; i++)
			{
				var cube:RigidBody = cubes[i];
				//cube.addBodyForce(new JNumber3D((mouseX - stage.stageWidth / 2)/10,0,(mouseY - stage.stageHeight / 2)/10), new JNumber3D(1,0,1));
			}
			//jmanualSphere.x = 2*(mouseX - stage.stageWidth / 2);
			//jmanualSphere.z = -2*(mouseY - (300+stage.stageHeight) / 2);

			debugText.appendText(", ZSort : " + renderer.isMeshZSort + ", Right click for more option");
		}
	}
}