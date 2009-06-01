package
{
	import flash.display.*;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.*;
	
	import open3d.materials.BitmapMaterial;
	import open3d.materials.ColorMaterial;
	import open3d.objects.Sphere;
	import open3d.view.SimpleView;
	
	[SWF(width=800, height = 600, backgroundColor = 0x666666, frameRate = 30)]
	
	/**
	 * forked from psyark's BumpyPlanet 
	 * @author katopz
	 * 
	 */
	public class ExFakeLightBump extends SimpleView
	{
		private var sphere:Sphere;
		private var lightSphere:Sphere;
		
		private var step:Number = 0;

		private var heightMap:BitmapData = new HeightMap(512, 512);
		private var normalMap:BitmapData = new NormalMap(heightMap, 0x80, 25);
		private var texture:BitmapData = new Texture(heightMap, 0x80);
		private var tmp1:BitmapData = new BitmapData(256, 128, false, 0);
		private var tmp2:BitmapData = new BitmapData(256, 128, false, 0);

		override protected function create():void
		{
			var segment:uint = 38;
			sphere = new Sphere(100, segment, segment, new BitmapMaterial(tmp2));
			renderer.addChild(sphere);
			
			lightSphere = new Sphere(10, 4, 4, new ColorMaterial(0x00FFFF));
			renderer.addChild(lightSphere);
		}

		override protected function draw():void
		{
			sphere.rotationY += 2;
			
			var light:Vector3D = new Vector3D();
			light.x = (mouseX-400) / 400 / Math.SQRT2;
            light.y = (mouseY-300) / 300 / Math.SQRT2;
            light.z = -Math.sqrt(1 - light.x * light.x - light.y * light.y);
			
			lightSphere.x = light.x*200;
			lightSphere.y = light.y*200;
			lightSphere.z = light.z*200;

			step += 0.1;

			var lighting:ColorMatrixFilter = new ColorMatrixFilter([
					2 * light.x, 2 * light.y, 2 * light.z, 0, (light.x + light.y + light.z) * -0xFF,
					2 * light.x, 2 * light.y, 2 * light.z, 0, (light.x + light.y + light.z) * -0xFF,
					2 * light.x, 2 * light.y, 2 * light.z, 0, (light.x + light.y + light.z) * -0xFF,
					0, 0, 0, 1, 0
				]);

			// 2-3fps lost here in single core, maybe Pixel Bender should be faster?
			// notice : biger sphere size -> lost more fps
			tmp1.applyFilter(normalMap, normalMap.rect, normalMap.rect.topLeft, lighting);
			tmp2.copyPixels(texture, texture.rect, texture.rect.topLeft);
			tmp2.draw(tmp1, null, null, BlendMode.MULTIPLY);
		}
	}
}
import flash.display.BitmapData;
import flash.geom.ColorTransform;
import flash.geom.Vector3D;
import flash.geom.Matrix3D;

class HeightMap extends BitmapData
{
	public function HeightMap(width:uint, height:uint)
	{
		super(width, height, false, 0);
		perlinNoise(80, 120, 10, Math.random() * 100, true, true, 0, true);
		colorTransform(rect, new ColorTransform(1.5, 1.5, 1.5, 1, -0x40, -0x40, -0x40));
	}
}

class NormalMap extends BitmapData
{
	public function NormalMap(heightMap:BitmapData, seaHeight:uint, multiplier:Number)
	{
		super(heightMap.width, heightMap.height, false);
		var vec:Vector3D = new Vector3D();
		var mtx:Matrix3D = new Matrix3D();
		for (var y:int = 0; y < heightMap.height; y++)
		{
			for (var x:int = 0; x < heightMap.width; x++)
			{
				var height:uint = heightMap.getPixel(x, y) & 0xFF;
				if (height >= seaHeight)
				{
					vec.x = (height - (heightMap.getPixel((x + 1) % heightMap.width, y) & 0xFF)) / 0xFF * multiplier;
					vec.y = (height - (heightMap.getPixel(x, (y + 1) % heightMap.height) & 0xFF)) / 0xFF * multiplier;
				}
				else
				{
					vec.x = vec.y = 0;
				}
				vec.y *= -1;
				vec.z = 0;
				if (vec.lengthSquared > 1)
				{
					vec.normalize();
				}
				vec.z = Math.sqrt(1 - vec.lengthSquared);
				mtx.identity();
				mtx.appendRotation(y / heightMap.height * 180 - 90, Vector3D.X_AXIS);
				mtx.appendRotation(x / heightMap.width * 360, Vector3D.Y_AXIS);
				vec = mtx.transformVector(vec);
				setPixel(x, y, (vec.x * 0x7F + 0x80) << 16 | (vec.y * 0x7F + 0x80) << 8 | (vec.z * 0x7F + 0x80));
			}
		}
	}
}

class Texture extends BitmapData
{
	public function Texture(heightMap:BitmapData, seaHeight:uint)
	{
		super(heightMap.width, heightMap.height, false, 0x229900);
		var paletteR:Array = [];
		var paletteG:Array = [];
		var paletteB:Array = [];
		var r:Number;
		for (var i:uint = 0; i < 256; i++)
		{
			if (i >= seaHeight)
			{
				r = (i - seaHeight) / (256 - seaHeight);
				if (r > 0.7)
				{
					paletteR[i] = (0x99 + 0x66 * (r - 0.7) / (1 - 0.7)) << 16;
					paletteG[i] = (0x66 + 0x99 * (r - 0.7) / (1 - 0.7)) << 8;
					paletteB[i] = (0x00 + 0xFF * (r - 0.7) / (1 - 0.7));
				}
				else if (r > 0.15)
				{
					paletteR[i] = (0x00 + 0x99 * (r - 0.15) / (0.7 - 0.15)) << 16;
					paletteG[i] = (0xCC - 0x66 * (r - 0.15) / (0.7 - 0.15)) << 8;
					paletteB[i] = (0x00 + 0x00 * (r - 0.15) / (0.7 - 0.15));
				}
				else
				{
					paletteR[i] = (0xCC - 0xCC * r / 0.15) << 16;
					paletteG[i] = (0x99 + 0x33 * r / 0.15) << 8;
					paletteB[i] = (0x33 - 0x33 * r / 0.15);
				}
			}
			else
			{
				r = i / seaHeight;
				paletteR[i] = 0;
				paletteG[i] = Math.pow(r, 5) * 0x66 << 8;
				paletteB[i] = (r * 0.5 + 0.5) * 0xFF;
			}
		}
		paletteMap(heightMap, rect, rect.topLeft, paletteR, paletteG, paletteB);
	}
}
