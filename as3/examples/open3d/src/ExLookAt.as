package
{
	import flash.events.MouseEvent;
	
	import open3d.materials.BitmapFileMaterial;
	import open3d.objects.Object3D;
	import open3d.objects.Sphere;
	import open3d.view.SimpleView;

	[SWF(width=800, height = 600, backgroundColor = 0x666666, frameRate = 30)]

	/**
	 * ExLookAt
	 * @author katopz
	 */
	public class ExLookAt extends SimpleView
	{
		private var sphere0:Sphere;
		private var sphere1:Sphere;
		
		private var step:Number = 0;
		
		private var isLookAt:Boolean = false;
		
		override protected function create():void
		{
			var segment:uint = 10;

			sphere0 = new Sphere(100, segment, segment, new BitmapFileMaterial("assets/earth.jpg"));
			sphere0.name = "sphere0";
			renderer.view.addChild(sphere0);
			
			sphere1 = new Sphere(50, segment, segment, new BitmapFileMaterial("assets/earth.jpg"));
			sphere1.name = "sphere1";
			renderer.view.addChild(sphere1);
			
			//sphere1.isFrustumCulling = true;
			
			//sphere1.x = 250;
			
			stage.addEventListener(MouseEvent.CLICK, onMouse);
		}
		
		private function onMouse(event:MouseEvent):void
		{
			isLookAt = !isLookAt;
		}
		
		private var target:Object3D;
		
		override protected function draw():void
		{
			//sphere0.rotationY += 2;
			//sphere1.rotationY -= 2;

			sphere1.x = 200 * Math.sin(step);
			//camera.y = 200 * Math.cos(step);

			step += 0.1;
			
			if(isLookAt)
			{
				target = sphere0;
			}else{
				target = sphere1;
			}
			camera.lookAt(target);
			
			debugText.appendText(" click to toggle lookAt : "+target.name);
		}
	}
}