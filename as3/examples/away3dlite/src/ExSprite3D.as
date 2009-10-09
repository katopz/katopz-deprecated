package
{
	import away3dlite.materials.*;
	import away3dlite.primitives.*;
	import away3dlite.sprites.Sprite3D;
	import away3dlite.templates.*;
	
	import flash.display.*;
	import flash.events.*;

	[SWF(backgroundColor="#000000",frameRate="30",quality="MEDIUM",width="800",height="600")]
	/**
	 * Sprite3D Example
	 * @author katopz
	 */
	public class ExSprite3D extends BasicTemplate
	{
		private const radius:uint = 200;
		private const max:int = 2000;
		private const size:uint = 10;

		private const numFrames:uint = 30;

		private var step:Number = 0;
		private var segment:Number;
		 
		override protected function onInit():void
		{
			title = "Away3DLite | Sprite3D " + max + " | ";

			// speed up
			view.mouseEnabled = false;

			segment = (size+5) + 2*Math.PI/size;

			var i:Number = 0;
			for (var j:int = 0; j < max; j++)
			{
				var sprite3D:Sprite3D = new Sprite3D(new ColorMaterial())
				sprite3D.width = sprite3D.height = size;
				sprite3D.x = radius * Math.cos(segment * j);
				sprite3D.y = 0.25 * (-max / 2) + i;
				sprite3D.z = radius * Math.sin(segment * j);
				scene.addSprite(sprite3D);
				i += 0.25;
			}

			// center
			scene.addChild(new Sphere(null, 100, 6, 6));

			// orbit
			for (j = 0; j < 6; j++)
			{
				var sphere:Sphere = new Sphere(null, 25, 6, 6);
				scene.addChild(sphere);
				sphere.x = (radius + 50) * Math.cos(i);
				sphere.z = (radius + 50) * Math.sin(i);
				i += 2 * Math.PI / 6;
			}
		}
		
		override protected function onPreRender():void
		{
			//scene.rotationX += .5;
			scene.rotationY += .5;
			//scene.rotationZ += .5;

			//camera.x = 1000 * Math.cos(step);
			//camera.y = 10 * (300 - mouseY);
			//camera.z = 1000 * Math.sin(step);
			//camera.lookAt(new Vector3D(0, 0, 0));
			
			//step += .01
		}
	}
}