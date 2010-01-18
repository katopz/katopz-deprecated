package jiglib.plugin.away3dlite
{
	import away3dlite.core.base.Object3D;
	import away3dlite.core.render.Renderer;
	import away3dlite.materials.Material;
	import away3dlite.primitives.Plane;
	import away3dlite.primitives.SimpleCube;
	import away3dlite.primitives.Sphere;
	
	import jiglib.geometry.JBox;
	import jiglib.geometry.JPlane;
	import jiglib.geometry.JSphere;
	import jiglib.math.JMatrix3D;
	import jiglib.physics.RigidBody;
	import jiglib.plugin.AbstractPhysics;

	/**
	 * @author bartekd
	 * @author katopz
	 */
	public class Away3DLPhysics extends AbstractPhysics
	{
		private var renderer:Renderer;

		public function Away3DLPhysics(renderer:Renderer, speed:Number = 1)
		{
			super(speed);
			this.renderer = renderer;
		}

		public function getMesh(body:RigidBody):Object3D
		{
			return Away3DLMesh(body.skin).mesh;
		}

		public function createSphere(material:Material, radius:Number = 100, segmentsW:int = 8, segmentsH:int = 6):RigidBody
		{
			var sphere:Sphere = new Sphere().create(material, radius, segmentsW, segmentsH);
			renderer.view.scene.addChild(sphere);
			var jsphere:JSphere = new JSphere(new Away3DLMesh(sphere), radius);
			addBody(jsphere);
			return jsphere;
		}

		public function createCube(material:Material, width:Number = 100, depth:Number = 100, height:Number = 100):RigidBody
		{
			var cube:SimpleCube = new SimpleCube(width, material);
			renderer.view.scene.addChild(cube);
			var jbox:JBox = new JBox(new Away3DLMesh(cube), width, depth, height);
			addBody(jbox);
			return jbox;
		}

		public function createGround(material:Material, size:Number, level:Number):RigidBody
		{
			var ground:Plane = new Plane().create(material, size, size);
			renderer.view.scene.addChild(ground);
			var jGround:JPlane = new JPlane(new Away3DLMesh(ground));
			jGround.movable = false;
			jGround.setOrientation(JMatrix3D.rotationX(Math.PI / 2));
			jGround.y = level;
			addBody(jGround);
			return jGround;
		}
	}
}
