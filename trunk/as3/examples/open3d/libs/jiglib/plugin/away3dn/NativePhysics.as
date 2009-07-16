package jiglib.plugin.away3dn
{
	import jiglib.geometry.JBox;
	import jiglib.geometry.JPlane;
	import jiglib.geometry.JSphere;
	import jiglib.math.JMatrix3D;
	import jiglib.physics.RigidBody;
	import jiglib.plugin.AbstractPhysics;
	
	import open3d.materials.BitmapMaterial;
	import open3d.materials.Material;
	import open3d.objects.Object3D;
	import open3d.objects.Plane;
	import open3d.objects.SimpleCube;
	import open3d.objects.Sphere;
	import open3d.render.Renderer;

	/**
	 * @author bartekd
	 */
	public class NativePhysics extends AbstractPhysics
	{

		private var renderer:Renderer;

		public function NativePhysics(renderer:Renderer, speed:Number = 1)
		{
			super(speed);
			this.renderer = renderer;
		}

		public function getMesh(body:RigidBody):Object3D
		{
			return NativeMesh(body.skin).mesh;
		}

		public function createSphere(material:Material, radius:Number = 100, segmentsW:int = 8, segmentsH:int = 6):RigidBody
		{
			var sphere:Sphere = new Sphere(radius, segmentsW, segmentsH, material);
			renderer.addChild(sphere);
			var jsphere:JSphere = new JSphere(new NativeMesh(sphere), radius);
			addBody(jsphere);
			return jsphere;
		}

		public function createCube(material:Material, width:Number = 500, depth:Number = 500, height:Number = 500, segmentsS:int = 1, segmentsT:int = 1, segmentsH:int = 1, insideFaces:int = 0, excludeFaces:int = 0):RigidBody
		{
			var cube:SimpleCube = new SimpleCube(width, material);
			renderer.addChild(cube);
			var jbox:JBox = new JBox(new NativeMesh(cube), width, depth, height);
			addBody(jbox);
			return jbox;
		}

		public function createGround(material:Material, size:Number, level:Number):RigidBody
		{
			var ground:Plane = new Plane(size, size, material);
			ground.culling = "none";
			renderer.addChild(ground);
			var jGround:JPlane = new JPlane(new NativeMesh(ground));
			jGround.movable = false;
			jGround.setOrientation(JMatrix3D.rotationX(Math.PI / 2));
			jGround.y = level;
			addBody(jGround);
			return jGround;
		}
	}
}
