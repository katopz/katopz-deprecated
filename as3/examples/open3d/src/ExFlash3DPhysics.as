package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	
	import jiglib.cof.JConfig;
	import jiglib.math.*;
	import jiglib.physics.*;
	import jiglib.physics.constraint.*;
	import jiglib.plugin.away3dn.Away3DNMesh;
	import jiglib.plugin.away3dn.Away3DNPhysics;
	
	import open3d.materials.LineMaterial;
	import open3d.view.SimpleView;

	[SWF(width=800,height=600,backgroundColor=0x666666,frameRate=30)]
	public class ExFlash3DPhysics extends SimpleView
	{
		private var ground:RigidBody;
		private var ballBody:Dictionary;
		private var boxBody:Array;

		private var onDraging:Boolean = false;

		private var _ball:RigidBody;
		private var currDragBody:RigidBody;
		private var dragConstraint:JConstraintWorldPoint;
		//private var planeToDragOn:Plane3D;

		private var keyRight:Boolean = false;
		private var keyLeft:Boolean = false;
		private var keyForward:Boolean = false;
		private var keyReverse:Boolean = false;
		private var keyUp:Boolean = false;

		private var physics:Away3DNPhysics;

		override protected function create():void
		{
			renderer.mouseEnable = true;
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, handleMouseRelease);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
			
			stage.addEventListener(MouseEvent.MOUSE_UP, handleMouse);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, handleMouse);
			
			init3D();
		}

		private function init3D():void
		{
			JConfig.angVelThreshold = 5;
			JConfig.posThreshold = 0.2;
			JConfig.deactivationTime = 0.5;
			JConfig.numCollisionIterations = 4;
			JConfig.numContactIterations = 8;

			physics = new Away3DNPhysics(renderer, 10);
			ground = physics.createGround(new LineMaterial(), 1000, 0);
			Away3DNMesh(ground.skin).mesh.addEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
			
			//mouse3D = viewport.interactiveSceneManager.mouse3D;
			//viewport.containerSprite.sortMode = ViewportLayerSortMode.INDEX_SORT;

			ground.movable = false;
			ground.friction = 0.2;
			ground.restitution = 0.8;
			//viewport.getChildLayer(physics.getMesh(ground)).layerIndex = 1;

			/*ground = physics.createGround(shadeMateria, 500, 0);
			   ground.friction = 0.2;
			   ground.restitution = 0.8;
			   viewport.getChildLayer(physics.getMesh(ground)).layerIndex = 1;
			 */

			ballBody = new Dictionary(true);
			var color:uint;
			for (var i:int = 0; i < 3; i++)
			{
				color = (i == 0) ? 0xff8888 : 0xeeee00;
				var ball:RigidBody = physics.createSphere(new LineMaterial());
				Away3DNMesh(ball.skin).mesh.addEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
				ball.mass = 3;
				ball.moveTo(new JNumber3D(-100, 500 + (50 * i + 50), -100));
				
				_ball = ballBody[Away3DNMesh(ball.skin).mesh] = ball;
			}

			boxBody = [];
			for (i = 0; i < 3; i++)
			{
				boxBody[i] = physics.createCube(new LineMaterial(), 100, 100, 100);
				//boxBody[i].skin.mesh.addEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
				boxBody[i].moveTo(new JNumber3D(0, 500 + (50 * i + 50), 0));
			}
		}

		/*
		   private function findSkinBody(skin:Object3D):int
		   {
		   for (var i:String in PhysicsSystem.getInstance().bodys)
		   {
		   if (skin == PhysicsSystem.getInstance().bodys[i].skin.mesh)
		   {
		   return int(i);
		   }
		   }
		   return -1;
		   }
		 */
		
		private var isDown:Boolean = false;
		private function handleMouse(event:MouseEvent):void
		{
			switch(event.type)
			{
				case MouseEvent.MOUSE_DOWN:
					isDown = true;
				break;
				case MouseEvent.MOUSE_UP:
					isDown = false;
				break;
			}
		}
		
		private function handleMousePress(event:Event):void
		{
			trace(handleMousePress);
		/*
		   onDraging = true;
		   startMousePos = new JNumber3D(mouse3D.x, mouse3D.y, mouse3D.z);
		   currDragBody = PhysicsSystem.getInstance().bodys[findSkinBody(event.target)];
		   planeToDragOn = new Plane3D(new Number3D(0, 0, -1), new Number3D(0, 0, -startMousePos.z));

		   var bodyPoint:JNumber3D = JNumber3D.sub(startMousePos, currDragBody.currentState.position);
		   dragConstraint = new JConstraintWorldPoint(currDragBody, bodyPoint, startMousePos);
		   PhysicsSystem.getInstance().addConstraint(dragConstraint);
		 */
		}

		private function handleMouseMove(event:MouseEvent):void
		{
			trace("handleMouseMove:"+event.target, renderer.viewPort.mouseX);
			if(isDown)
			{
				var ball:RigidBody = ballBody[event.target];
				if(ball)
				{
					trace("ball:"+ball);
				}
			}
		/*
		   if (onDraging)
		   {
		   var ray:Number3D = camera.unproject(viewport.containerSprite.mouseX, viewport.containerSprite.mouseY);
		   ray = Number3D.add(ray, new Number3D(camera.x, camera.y, camera.z));

		   var cameraVertex3D:Vertex3D = new Vertex3D(camera.x, camera.y, camera.z);
		   var rayVertex3D:Vertex3D = new Vertex3D(ray.x, ray.y, ray.z);
		   var intersectPoint:Vertex3D = planeToDragOn.getIntersectionLine(cameraVertex3D, rayVertex3D);

		   dragConstraint.worldPosition = new JNumber3D(intersectPoint.x, intersectPoint.y, intersectPoint.z);
		   }
		 */
		 
		}

		private function handleMouseRelease(event:MouseEvent):void
		{
			if (onDraging)
			{
				onDraging = false;
				PhysicsSystem.getInstance().removeConstraint(dragConstraint);
				currDragBody.setActive();
			}
		}

		private function keyDownHandler(event:KeyboardEvent):void
		{
			switch (event.keyCode)
			{
				case Keyboard.UP:
					keyForward = true;
					keyReverse = false;
					break;

				case Keyboard.DOWN:
					keyReverse = true;
					keyForward = false;
					break;

				case Keyboard.LEFT:
					keyLeft = true;
					keyRight = false;
					break;

				case Keyboard.RIGHT:
					keyRight = true;
					keyLeft = false;
					break;
				case Keyboard.SPACE:
					keyUp = true;
					break;
			}
		}

		private function keyUpHandler(event:KeyboardEvent):void
		{
			switch (event.keyCode)
			{
				case Keyboard.UP:
					keyForward = false;
					break;

				case Keyboard.DOWN:
					keyReverse = false;
					break;

				case Keyboard.LEFT:
					keyLeft = false;
					break;

				case Keyboard.RIGHT:
					keyRight = false;
					break;
				case Keyboard.SPACE:
					keyUp = false;
			}
		}

		override protected function draw():void
		{
			if (keyLeft)
			{
				_ball.addWorldForce(new JNumber3D(-100, 0, 0), _ball.currentState.position);
			}
			if (keyRight)
			{
				_ball.addWorldForce(new JNumber3D(100, 0, 0), _ball.currentState.position);
			}
			if (keyForward)
			{
				_ball.addWorldForce(new JNumber3D(0, 0, -100), _ball.currentState.position);
			}
			if (keyReverse)
			{
				_ball.addWorldForce(new JNumber3D(0, 0, 100), _ball.currentState.position);
			}
			if (keyUp)
			{
				_ball.addWorldForce(new JNumber3D(0, 100, 0), _ball.currentState.position);
			}
			
			physics.step();

			var view:Sprite = renderer.view;
			view.rotationY = 180;// + (mouseX - stage.stageWidth / 2) / 5;
			view.rotationZ = 180;// + (mouseY - stage.stageHeight / 2) / 10;
			//world.rotationY++;

			view.y = 500;
			view.z = 2000;
			view.rotationX = 10;
		}
	}
}