package
{
	import flash.events.MouseEvent;
	import flash.utils.getTimer;
	
	import jiglib.physics.RigidBody;
	import jiglib.plugin.away3dn.Away3DNMesh;
	import jiglib.plugin.away3dn.Away3DNPhysics;
	
	import open3d.materials.LineMaterial;
	import open3d.view.SimpleView;

	[SWF(width=800,height=600,backgroundColor=0x666666,frameRate=30)]
	/**
	 * ExFallingBalls
	 * @author bartekd
	 * @author katopz
	 */
	public class ExFallingBalls extends SimpleView
	{
		private var physics:Away3DNPhysics;
		private var cubes:Vector.<RigidBody>;

		override protected function create():void
		{
			physics = new Away3DNPhysics(renderer, 10);
			physics.createGround(new LineMaterial(), 1800, 200);

			cubes = new Vector.<RigidBody>(20, true);
			for (var i:int = 0; i < 20; i++)
			{
				var cube:RigidBody = physics.createCube(new LineMaterial(), 50, 50, 50);
				cube.material.restitution = .1;
				cubes[i] = cube;
			}
			
			camera.y = 500;
			camera.z = 2000;
			
			refresh();

			stage.addEventListener(MouseEvent.CLICK, refresh);
		}

		private function refresh(e:* = null):void
		{
			for each (var cube:RigidBody in cubes)
			{
				cube.x = Math.random() * 900 - Math.random() * 900;
				cube.y = 200 + Math.random() * 3000;
				cube.z = Math.random() * 900 - Math.random() * 900;
				cube.rotationX = 360 * Math.random();
				cube.rotationY = 360 * Math.random();
				cube.rotationZ = 360 * Math.random();
				cube.setActive();
			}
			maxtime = 0;
		}
		
		private var maxtime:int=0;
		override protected function draw():void
		{
			var time:int = getTimer();
			physics.step();

			camera.lookAt(Away3DNMesh(RigidBody(cubes[0]).skin).mesh);
			
			time = getTimer()-time;
			if(maxtime<time)maxtime=time;
			debugText.appendText(", ZSort : " + renderer.isMeshZSort + ", Right click for more option" + ", time : "+ time+"/"+maxtime);
		}
	}
}