package
{
	import away3dlite.containers.Particles;
	import away3dlite.core.base.Particle;
	import away3dlite.materials.*;
	import away3dlite.primitives.*;
	import away3dlite.templates.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Matrix;
	import flash.geom.Vector3D;

	[SWF(backgroundColor="#DDDDDD",frameRate="30",quality="MEDIUM",width="800",height="600")]
	/**
	 * @author katopz
	 */
	public class ExParticles extends FastTemplate
	{
		private var particles:Particles;
		private var materials:Vector.<BitmapData>;

		private const radius:uint = 300;
		private const max:int = 3000;
		private const size:uint = 10;

		private const numFrames:uint = 30;

		override protected function onInit():void
		{
			//camera.y = -1000;
			camera.lookAt(new Vector3D());

			// speed up
			view.mouseEnabled = false;

			// create materials
			materials = createMaterial();

			// create particles
			particles = new Particles(view);

			var segment:Number = 40 * 2 * Math.PI / max;

			var i:Number = 0;
			for (var j:int = 0; j < max; j++)
			{
				particles.addParticle(new Particle(radius * Math.cos(segment * j), (1 / 10) * (-max / 2) + i, radius * Math.sin(segment * j), materials[0]));
				i += 1 / 10;
			}

			scene.addChild(particles);
		}

		private function createMaterial():Vector.<BitmapData>
		{
			var _materials:Vector.<BitmapData> = new Vector.<BitmapData>(30, true);

			for (var i:int = 0; i < numFrames; i++)
			{
				var shape:Shape = new Shape();
				drawDot(shape.graphics, size / 2, size / 2, size / 2, 0xFFFFFF - 0x00FF00 * Math.sin(Math.PI * i / 30), 0x000000);

				var bitmapData:BitmapData = new BitmapData(size, size, true, 0x00000000);
				bitmapData.draw(shape);

				_materials[i] = bitmapData;
			}

			return _materials;
		}

		private function drawDot(_graphics:Graphics, x:Number, y:Number, size:Number, colorLight:uint, colorDark:uint):void
		{
			var colors:Array = [colorLight, colorDark];
			var alphas:Array = [1.0, 1.0];
			var ratios:Array = [0, 255];
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(size * 2, size * 2, 0, x - size, y - size);

			_graphics.lineStyle();
			_graphics.beginGradientFill(GradientType.RADIAL, colors, alphas, ratios, matrix);
			_graphics.drawCircle(x, y, size);
			_graphics.endFill();
		}

		override protected function onPostRender():void
		{
			title = "Max : " + max + ", ";

			scene.rotationY++;

			// TODO : move to internal render
			var matrix:Matrix = new Matrix();
			var view_graphics:Graphics = view.graphics;
			view_graphics.clear();
			var _particles_lists:Vector.<Particle> = particles.lists;
			for each (var _particle:Particle in _particles_lists)
			{
				matrix.identity();
				
				var scale:Number;
				scale = matrix.a = matrix.d = _particle.scale;
				//trace(scale)
				matrix.tx = _particle.screenX;
				matrix.ty = _particle.screenY;

				view_graphics.beginBitmapFill(_particle.bitmapData, matrix, true);
				view_graphics.drawRect(_particle.screenX, _particle.screenY, _particle.width*scale, _particle.height*scale);
			}
			view_graphics.endFill();
		}
	}
}