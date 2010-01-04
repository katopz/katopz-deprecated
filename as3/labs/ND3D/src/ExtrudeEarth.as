package 
{
	import de.nulldesign.nd3d.material.BitmapMaterial;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;

	import de.nulldesign.nd3d.events.MeshEvent;
	import de.nulldesign.nd3d.utils.ASEParser;
	import de.nulldesign.nd3d.geom.Face;
	import de.nulldesign.nd3d.geom.UV;
	import de.nulldesign.nd3d.geom.Vertex;
	import de.nulldesign.nd3d.material.Material;
	import de.nulldesign.nd3d.objects.Mesh;
	import de.nulldesign.nd3d.objects.PointCamera;
	import de.nulldesign.nd3d.objects.Sphere;
	import de.nulldesign.nd3d.renderer.Renderer;
	import de.nulldesign.nd3d.utils.MeshLoader;	

	public class ExtrudeEarth extends Sprite 
	{

		private var cam:PointCamera;
		private var renderer:Renderer;
		private var renderList:Array;
		private var renderStage:Sprite;

		[Embed(source = 'assets/starfield.jpg')]
		private const STARFIELD_TEXTURE:Class;

		[Embed("assets/EarthMap_bump.jpg")]
		private const EARTH_BUMP_TEXTURE:Class;

		private var earthBump:Bitmap;

		private var planet:Mesh;
		private var meshLoader:MeshLoader;
		private var meshLoader2:MeshLoader;

		public function ExtrudeEarth() 
		{
			
			//stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			renderStage = new Sprite();
			addChild(renderStage);

			renderer = new Renderer(renderStage);
			//renderer.wireFrameMode = true;
			//renderer.additiveMode = true;
			//renderer.dynamicLighting = true;
			cam = new PointCamera(600, 400);
			cam.zOffset = -150;
			renderList = [];
			
			earthBump = new EARTH_BUMP_TEXTURE();
			
			var textures:Array = [];
			textures.push("textures/EarthMap.jpg");
			textures.push("textures/EarthMap.jpg");

			meshLoader = new MeshLoader(new ASEParser());
			meshLoader.addEventListener(MeshEvent.MESH_LOADED, onMeshLoaded);
			meshLoader.loadMesh("models/sphere_l0.ASE", textures);
			
			var textures2:Array = [];
			textures2.push("textures/ringmap.png");
			textures2.push("textures/ringmap.png");
			
			meshLoader2 = new MeshLoader(new ASEParser());
			meshLoader2.addEventListener(MeshEvent.MESH_LOADED, onMeshLoaded2);
			meshLoader2.loadMesh("models/ring.ASE", textures2);			
			
			var starFieldMat:BitmapMaterial = new BitmapMaterial(new STARFIELD_TEXTURE().bitmapData, true);
			var starField:Sphere = new Sphere(10, 5000, starFieldMat);
			starField.flipNormals();
			
			renderList.push(starField);
			
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			addEventListener(Event.ENTER_FRAME, onLoop);
		}

		private function onMouseWheel(evt:MouseEvent):void 
		{
			cam.zOffset -= evt.delta * 10;
		}

		private function onMeshLoaded2(evt:MeshEvent):void 
		{
			renderList.push(evt.mesh);
			evt.mesh.scale(1.3, 1.3, 1.3);
		}

		private function onMeshLoaded(evt:MeshEvent):void 
		{
			renderList.push(evt.mesh);
			planet = evt.mesh;	
			
			var v:Vertex;
			var f:Face;
			var uv:UV;
			var bmp:BitmapData;
			
			for (var i:uint = 0;i < planet.faceList.length; i++) 
			{
				
				f = planet.faceList[i];
				//bmp = f.material.texture;
				bmp = earthBump.bitmapData;
				
				for (var j:uint = 0;j < f.vertexList.length; j++) 
				{
					
					uv = f.uvMap[j];
					v = f.vertexList[j];
					
					// get displacement pixel
					var xPos:uint = uv.u * bmp.width;
					var yPos:uint = uv.v * bmp.height;
					
					var pixelValue:uint = bmp.getPixel(xPos, yPos);
					var pixelBrightness:Number = pixelValue / 0xFFFFFF;
					
					/*
					var r:uint = pixelValue >> 16;
					var g:uint = pixelValue >> 8 & 255;
					var b:uint = pixelValue & 255;

					var pixelBrightness:Number = (r + g + b);
					 */
					v.length = v.length + pixelBrightness;
				}
			}
		}

		private function onLoop(evt:Event):void 
		{

			renderer.render(renderList, cam);
			
			cam.angleX += (mouseY - cam.vpY) * .001;
			cam.angleY += (mouseX - cam.vpX) * .001;
		}
	}
}