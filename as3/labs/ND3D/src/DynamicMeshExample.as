package 
{
	import de.nulldesign.nd3d.material.BitmapMaterial;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.geom.ColorTransform;

	import de.nulldesign.nd3d.geom.Quaternion;
	import de.nulldesign.nd3d.geom.Vertex;
	import de.nulldesign.nd3d.material.Material;
	import de.nulldesign.nd3d.objects.PointCamera;
	import de.nulldesign.nd3d.objects.Ribbon;
	import de.nulldesign.nd3d.renderer.Renderer;	

	public class DynamicMeshExample extends Sprite 
	{

		private var cam:PointCamera;
		private var renderer:Renderer;
		private var renderList:Array;
		private var ribbon:Ribbon;
		private var ribbon2:Ribbon;
		//private var zValue:Number;
		private var renderStage:Sprite;

		private var modeChanger:Number = 0;

		private var stageCopy:BitmapData;

		[Embed("assets/cube_texture.png")]
		private var CUBE_TEXTURE:Class;		

		public function DynamicMeshExample() 
		{
			
			//stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;

			renderStage = new Sprite();
			addChild(renderStage);
			
			renderer = new Renderer(renderStage);
			//renderer.wireFrameMode = true;
			renderer.additiveMode = true;
			//renderer.dynamicLighting = true;
			cam = new PointCamera(700, 400);
			renderList = [];
			
			var texture:Bitmap = new CUBE_TEXTURE();
			
			var ribbonMat:BitmapMaterial = new BitmapMaterial(texture.bitmapData, false, false, true, true);
			ribbon = new Ribbon(0.3, 30, 10, ribbonMat);
			renderList.push(ribbon);

			var texture2:Bitmap = new CUBE_TEXTURE();
			texture2.bitmapData.colorTransform(texture2.bitmapData.rect, new ColorTransform(0.5, 1, 1, 1, 0, 0, 0, 0));
			
			var ribbonMat2:BitmapMaterial = new BitmapMaterial(texture2.bitmapData, false, false, true, true);
			ribbon2 = new Ribbon(0.3, 30, 10, ribbonMat2);
			renderList.push(ribbon2);
			
			stageCopy = new BitmapData(700, 400, true, 0x00000000);
			var b:Bitmap = new Bitmap(stageCopy);
			b.filters = [new BlurFilter(8, 8, 1)];
			b.blendMode = BlendMode.NORMAL;
			addChildAt(b, 0);
			
			//var cube:Mesh = MeshFactory.createCube(ribbonMat2, 30);
			//cube.angleX = 1;
			//renderList.push(cube);

			addEventListener(Event.ENTER_FRAME, onLoop);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseClick);
		}

		private function mouseClick(evt:MouseEvent):void 
		{
			
			++modeChanger;
			
			if(modeChanger == 3) 
			{
				modeChanger = 0;
			}
			
			getChildAt(0).visible = true;
			renderer.wireFrameMode = false;

			graphics.beginFill(0x000000, 1);
			graphics.drawRect(0, 0, 700, 400);
			graphics.endFill();
			
			if(modeChanger == 1) 
			{
				graphics.beginFill(0xFFFFFF, 1);
				graphics.drawRect(0, 0, 700, 400);
				graphics.endFill();
			} else if(modeChanger == 2) 
			{
				renderer.wireFrameMode = true;
				getChildAt(0).visible = false;
			}
		}

		private function onLoop(evt:Event):void 
		{
			
			stageCopy.fillRect(stageCopy.rect, 0x00000000);
			stageCopy.draw(renderStage);
			
			renderer.render(renderList, cam);

			//cam.angleX += (mouseY - cam.vpY) * .0001;
			//cam.angleY += (mouseX - cam.vpX) * .0001;
			//cam.angleX += 0.02;
			cam.angleY += 0.03;
			
			var xMouse:Number = (mouseX - 350);
			var yMouse:Number = (mouseY - 200);
			
			var v:Vertex = new Vertex(xMouse, yMouse, 0);
			var q:Quaternion = new Quaternion();
			q.eulerToQuaternion(0, cam.angleY, 0);
			v = v.rotatePoint(q);

			//zValue = Math.sin(getTimer()/1000) * 200;
			//ribbon.continueTo(xMouse, yMouse, zValue);
			//ribbon2.continueTo(-xMouse, -yMouse, zValue);

			ribbon.continueTo(v.x, v.y, v.z);
			ribbon2.continueTo(-v.x, -v.y, -v.z);
		}
	}
}
