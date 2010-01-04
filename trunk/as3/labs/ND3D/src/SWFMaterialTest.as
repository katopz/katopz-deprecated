package 
{
	import de.nulldesign.nd3d.events.Mouse3DEvent;
	import de.nulldesign.nd3d.geom.Face;
	import de.nulldesign.nd3d.geom.Vertex;
	import de.nulldesign.nd3d.material.BitmapMaterial;
	import de.nulldesign.nd3d.material.LineMaterial;
	import de.nulldesign.nd3d.material.Material;
	import de.nulldesign.nd3d.material.SWFMaterial;
	import de.nulldesign.nd3d.material.WireMaterial;
	import de.nulldesign.nd3d.objects.Cube;
	import de.nulldesign.nd3d.objects.Line3D;
	import de.nulldesign.nd3d.objects.PointCamera;
	import de.nulldesign.nd3d.objects.SimpleCube;
	import de.nulldesign.nd3d.objects.Sprite3D;
	import de.nulldesign.nd3d.renderer.Renderer;
	import de.nulldesign.nd3d.view.AbstractView;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Lars Gerckens (lars@nulldesign.de)
	 */
	public class SWFMaterialTest extends Sprite
	{
		[Embed("assets/ButtonsTest.swf")]
		private var MyTexture:Class;
		private var tex:MovieClip;
		private var mat:SWFMaterial;
		
		protected var cam:PointCamera;
		protected var renderer:Renderer;
		protected var renderList:Array;
		
		public function SWFMaterialTest() 
		{
			cam = new PointCamera(600, 400);
			renderList = [];

			var myStage:Sprite = new Sprite();
			addChild(myStage);
			renderer = new Renderer(myStage);
			renderer.addEventListener(Mouse3DEvent.MOUSE_MOVE, mouseMove);
			//renderer.wireFrameMode = true;
			
			tex = new MyTexture();
			tex.visible = true;
			// set this to a higher value to see how the fake texture clicking is done.
			tex.alpha = 0.0;
			addChild(tex);
			
			mat = new SWFMaterial(tex, true, false, false, false);
			mat.swfWidth = 500;
			mat.swfHeight = 376;
			mat.isInteractive = true;
			
			var cube:Cube = new Cube([mat, mat, mat, mat, mat, mat], 140, 8);
			renderList.push(cube);

			//cube.faceList = [cube.faceList[0]];
			
			addEventListener(Event.ENTER_FRAME, loop);
		}

		private function mouseMove(e:Mouse3DEvent):void 
		{
			// the real movieclip if placed directly under the mousecursor, so that you can click the real clip and interact with it.
			if(e.face.material.texture)
			{
				tex.x = mouseX - e.uv.u * e.face.material.texture.width;
				tex.y = mouseY - e.uv.v * e.face.material.texture.height;
			}
		}
		
		protected function loop(e:Event):void
		{
			renderer.render(renderList, cam);
			
			cam.angleX += (mouseY - cam.vpY) * .0001;
			cam.angleY += (mouseX - cam.vpX) * .0001;
			
			//cam.angleX = 0.25;
			//cam.angleY = -0.25;
			
			mat.update();
		}
		
	}
	
}