package
{
	import away3dlite.containers.ObjectContainer3D;
	import away3dlite.core.base.Mesh;
	import away3dlite.events.Loader3DEvent;
	import away3dlite.loaders.Collada;
	import away3dlite.loaders.Loader3D;
	import away3dlite.materials.WireframeMaterial;
	import away3dlite.templates.ui.LiteKeyboard;
	
	import flash.events.KeyboardEvent;
	import flash.geom.Vector3D;
	import flash.ui.Keyboard;
	
	import jiglib.physics.RigidBody;
	import jiglib.plugin.away3dlite.Away3DLiteMesh;
	import jiglib.templates.PhysicsTemplate;
	import jiglib.vehicles.JCar;

	[SWF(backgroundColor="#666666", frameRate = "30", quality = "MEDIUM", width = "800", height = "600")]
	/**
	 * Example : Car Drive
	 *
	 * @see http://away3d.googlecode.com/svn/trunk/fp10/Away3DLite/src
	 * @see http://away3d.googlecode.com/svn/branches/JigLibLite/src
	 *
	 * @author katopz
	 */
	public class ExCarDrive extends PhysicsTemplate
	{
		private var carBody:JCar;

		private var steerFR:ObjectContainer3D;
		private var steerFL:ObjectContainer3D;
		
		private var wheelFR:Mesh;
		private var wheelFL:Mesh;
		private var wheelBR:Mesh;
		private var wheelBL:Mesh;

		override protected function build():void
		{
			//system
			title += " | Car Drive | Use Key Up, Down, Left, Right | ";
			camera.y = 1000;

			//event
			new LiteKeyboard(this.stage);

			//decor
			for (var i:int = 0; i < 10; i++)
			{
				var box:RigidBody = physics.createCube(new WireframeMaterial(0xFFFFFF * Math.random()), 25, 25, 25);
				box.moveTo(new Vector3D(500*Math.random()-500*Math.random(), 500 + (100 * i + 100), 500*Math.random()-500*Math.random()));
			}

			//player
			initCar();
		}

		private function initCar():void
		{
			var collada:Collada = new Collada();

			var loader:Loader3D = new Loader3D();
			loader.loadGeometry("assets/car.dae", collada);
			loader.addOnSuccess(onSuccess);
			scene.addChild(loader);
		}

		private function onSuccess(event:Loader3DEvent):void
		{
			var carSkin:ObjectContainer3D = event.loader.handle as ObjectContainer3D;

			carBody = new JCar(new Away3DLiteMesh(carSkin));
			carBody.setCar(40, 5, 500);
			carBody.chassis.moveTo(new Vector3D(0, 100, 0));
			carBody.chassis.rotationY = 90;
			carBody.chassis.mass = 9;
			carBody.chassis.sideLengths = new Vector3D(40, 20, 90);
			physics.addBody(carBody.chassis);

			carBody.setupWheel("WheelFL", new Vector3D(-20, -10, 25), 1.2, 1.5, 3, 8, 0.4, 0.5, 2);
			carBody.setupWheel("WheelFR", new Vector3D(20, -10, 25), 1.2, 1.5, 3, 8, 0.4, 0.5, 2);
			carBody.setupWheel("WheelBL", new Vector3D(-20, -10, -25), 1.2, 1.5, 3, 8, 0.4, 0.5, 2);
			carBody.setupWheel("WheelBR", new Vector3D(20, -10, -25), 1.2, 1.5, 3, 8, 0.4, 0.5, 2);

			steerFL = carSkin.getChildByName("WheelFL") as ObjectContainer3D;
			steerFR = carSkin.getChildByName("WheelFR") as ObjectContainer3D;
			
			wheelFL = carSkin.getChildByName("WheelFL_PIVOT") as Mesh;
			wheelFL.material = new WireframeMaterial();
			wheelFR = carSkin.getChildByName("WheelFR_PIVOT") as Mesh;
			wheelFR.material = new WireframeMaterial();
			
			wheelBL = carSkin.getChildByName("WheelBL") as Mesh;
			wheelBL.material = new WireframeMaterial();
			wheelBR = carSkin.getChildByName("WheelBR") as Mesh;
			wheelBR.material = new WireframeMaterial();
		}

		private function checkKey():void
		{
			var power:int = (LiteKeyboard.keyType == KeyboardEvent.KEY_DOWN) ? 1 : 0;
			title = String(LiteKeyboard.keyType+", "+ LiteKeyboard.keyCode);
			
			switch (LiteKeyboard.keyCode)
			{
				case Keyboard.UP:
					carBody.setAccelerate(1 * power);
					break;
				case Keyboard.DOWN:
					carBody.setAccelerate(-1 * power);
					break;
				case Keyboard.LEFT:
					carBody.setSteer(["WheelFL", "WheelFR"], -1 * power);
					break;
				case Keyboard.RIGHT:
					carBody.setSteer(["WheelFL", "WheelFR"], 1 * power);
					break;
				case Keyboard.SPACE:
					carBody.setHBrake(1* power);
					break;
			}
		}
		
		// TODO : fix and finish this
		/*
		private function updateWheelSkin():void
		{
			steerFL.rotationY = carBody.wheels["WheelFL"].getSteerAngle();
			steerFR.rotationY = carBody.wheels["WheelFR"].getSteerAngle();
			
			wheelFL.pitch(carBody.wheels["WheelFL"].getRollAngle());
			wheelFR.pitch(carBody.wheels["WheelFR"].getRollAngle());
			wheelBL.roll(carBody.wheels["WheelBL"].getRollAngle());
			wheelBR.roll(carBody.wheels["WheelBR"].getRollAngle());
			
			steerFL.y = carBody.wheels["WheelFL"].getActualPos().y;
			steerFR.y = carBody.wheels["WheelFR"].getActualPos().y;
			wheelBL.y = carBody.wheels["WheelBL"].getActualPos().y;
			wheelBR.y = carBody.wheels["WheelBR"].getActualPos().y;
		}
		*/

		override protected function onPreRender():void
		{
			//move
			checkKey();

			//run
			physics.step();

			//system
			camera.lookAt(new Vector3D(0, 0, 0), new Vector3D(0, 1, 0));
		}
	}
}