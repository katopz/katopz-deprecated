package  
{
	import __AS3__.vec.Vector;
	
	import open3d.materials.BitmapFileMaterial;
	import open3d.objects.Object3D;
	import open3d.objects.Sphere;
	import open3d.view.SimpleView;
	
	[SWF(width=800, height=600, backgroundColor=0x666666, frameRate=30)]
	public class ExSphereCubic extends SimpleView
	{
		private var spheres		:Vector.<Sphere>;
		private var step		:Number=0;
		
		override protected function create():void
		{
			var segment:uint = 8;
			var amount:uint = 5;
			var radius:uint = 20;
			var gap:uint = amount;
			
			var sphere:Sphere;
			for(var i:int=-amount/2;i<amount/2;++i)
			for(var j:int=-amount/2;j<amount/2;++j)
			for(var k:int=-amount/2;k<amount/2;++k)
			{
				sphere = new Sphere(radius, segment, segment, new BitmapFileMaterial("assets/earth.jpg"));
				renderer.addChild(sphere);
				sphere.x = gap*radius*i;
				sphere.y = gap*radius*j;
				sphere.z = gap*radius*k;
			}
			isDebug = true;
			renderer.world.rotationX=30;
			start();
		}
		
		override protected function draw():void
		{
			var world:Object3D = renderer.world;
			//world.rotationX = (mouseX-stage.stageWidth/2)/5;
			//world.rotationZ = (mouseY-stage.stageHeight/2)/5;
			world.rotationY++;
		}
	}
}