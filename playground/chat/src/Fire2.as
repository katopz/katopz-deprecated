//////////////////////////////////////////////////
//	class jp.nya.project.effects.Fire [AS3.0]
//	@author: Hiroyuki Hara	www.project-nya.jp
//////////////////////////////////////////////////
package
{

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.GradientType;
	import flash.display.InterpolationMethod;
	import flash.display.Shape;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.filters.DisplacementMapFilter;
	import flash.filters.DisplacementMapFilterMode;
	import flash.geom.Matrix;
	import flash.geom.Point;
	[SWF(backgroundColor="#000000", frameRate="30", width="800", height="480")]
	public class Fire2 extends Sprite {
		// プロパティ
		private var xPos:uint;
		private var yPos:uint;
		private var fireWidth:uint;
		private var fireHeight:uint;
		private var noise:Sprite;
		private var noiseBD:BitmapData;
		private var light:Shape;
		private var lightOffset:uint;
		private var flare:Sprite;
		private var flareBase:Sprite;
		private var fire:Shape;
		private var flareBD:BitmapData;
		private var baseMask:Shape;
		private var fireMask:Shape;
		private var map:DisplacementMapFilter;
		private static var baseX:uint = 12;
		private static var baseY:uint = 24;
		private static var numOctaves:uint = 3;
		private var randomSeed:uint;
		private var speedList:Array;
		private static var speed:uint = 2;
		private var offsetsList:Array;
		private var scale:Number = 0;

		// コンストラクタ
		public function Fire2() 
		{
			init(100,100, {x:200, y:200, offset:1});
			burn();
		}

		// メソッド
		public function init(w:uint, h:uint, option:Object):void {
			fireWidth = w;
			fireHeight = h;
			if (option.x != undefined) xPos = option.x;
			if (option.y != undefined) yPos = option.y;
			if (option.offset != undefined) lightOffset = option.offset;
			initialize();
		}
		private function initialize():void {
			createPerlinNoise(fireWidth, fireHeight);
			if (lightOffset) createLight();
			createFlare(fireWidth, fireHeight);
		}
		private function createPerlinNoise(w:uint, h:uint):void {
			noise = new Sprite();
			addChild(noise);
			noise.visible = false;
			noiseBD = new BitmapData(w + 40, h + 40, true);
			noise.addChild(new Bitmap(noiseBD));
		}
		private function createLight():void {
			light = new Shape();
			addChild(light);
			light.visible = false;
			light.x = xPos;
			light.y = yPos + lightOffset;
			createGradientLight(light);
		}
		private function createFlare(w:uint, h:uint):void {
			flare = new Sprite();
			addChild(flare);
			flare.visible = false;
			flare.x = xPos;
			flare.y = yPos;
			flare.blendMode = BlendMode.ADD;
			var blur:BlurFilter = new BlurFilter(16, 16, 3);
			baseMask = new Shape();
			addChild(baseMask);
			baseMask.x = xPos;
			baseMask.y = yPos - fireHeight*0.1;
			baseMask.scaleX = baseMask.scaleY = 2;
			createEggMask(baseMask);
			flare.mask = baseMask;
			baseMask.filters = [blur];
			flare.cacheAsBitmap = true;
			baseMask.cacheAsBitmap = true;
			flareBase = new Sprite();
			flare.addChild(flareBase);
			fire = new Shape();
			flareBase.addChild(fire);
			createGradientFire(fire);
			fireMask = new Shape();
			flareBase.addChild(fireMask);
			createEggMask(fireMask);
			fireMask.filters = [blur];
			fire.mask = fireMask;
			fire.cacheAsBitmap = true;
			fireMask.cacheAsBitmap = true;
			flareBD = new BitmapData(w + 40, h + 40, true);
			randomSeed = Math.floor(Math.random()*100);
			speedList = new Array();
			offsetsList = new Array();
			for (var n:uint = 0; n < numOctaves; n++) {
				var xSpeed:Number = Math.random()*speed - speed*0.5;
				var ySpeed:Number = Math.random()*speed + speed*3;
				speedList[n] = new Point(xSpeed, ySpeed);
				offsetsList[n] = new Point(0, 0);
			}
		}
		public function burn():void {
			flare.visible = true;
			addEventListener(Event.ENTER_FRAME, createFire, false, 0, true);
			fireMask.scaleX = fireMask.scaleY = scale;
			light.visible = true;
			light.scaleX = light.scaleY = scale;
			removeEventListener(Event.ENTER_FRAME, clearFire);
			addEventListener(Event.ENTER_FRAME, burnFire, false, 0, true);
		}
		private function burnFire(evt:Event):void {
			scale += (1 - scale)*0.2;
			fireMask.scaleX = fireMask.scaleY = scale;
			light.scaleX = light.scaleY = scale;
			if (Math.abs(1 - scale) < 0.005) {
				scale = 1;
				removeEventListener(Event.ENTER_FRAME, burnFire);
			}
		}
		public function clear():void {
			removeEventListener(Event.ENTER_FRAME, burnFire);
			addEventListener(Event.ENTER_FRAME, clearFire, false, 0, true);
		}
		private function clearFire(evt:Event):void {
			scale += (0 - scale)*0.2;
			fireMask.scaleX = fireMask.scaleY = scale;
			light.scaleX = light.scaleY = scale;
			if (Math.abs(0 - scale) < 0.005) {
				scale = 0;
				light.visible = false;
				removeEventListener(Event.ENTER_FRAME, createFire);
				removeEventListener(Event.ENTER_FRAME, clearFire);
			}
		}
		private function createFire(evt:Event):void {
			for (var n:uint = 0; n < numOctaves; n++) {
				offsetsList[n].x += speedList[n].x;
				offsetsList[n].y += speedList[n].y;
			}
			noiseBD.lock();
			noiseBD.perlinNoise(baseX, baseY, numOctaves, randomSeed, false, true, 1, true, offsetsList);
			noiseBD.unlock();
			flareBD.lock();
			flareBD.draw(noise);
			var point:Point = new Point(0, 0);
			map = new DisplacementMapFilter(flareBD, point, 1, 1, -10, 90, DisplacementMapFilterMode.CLAMP, 0xFFFFFF);
			flareBD.unlock();
			flareBase.filters = [map];
		}
		private function createGradientFire(target:Shape):void {
			var w:uint = fireWidth + 40;
			var h:uint = fireHeight + 40;
			var colors:Array = [0xFF0000, 0x990000, 0xFF9900, 0xFFFF66, 0xFFFFFF, 0xFFFFFF];
			var alphas:Array = [1, 1, 1, 1, 1, 1];
			var ratios:Array = [25, 51, 127, 204, 229, 255];
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(w, -h, -0.5*Math.PI, 0, 0);
			target.graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, matrix, SpreadMethod.PAD, InterpolationMethod.RGB, 0.75);
			target.graphics.drawRect(-w*0.5, -h+20, w, h);
			target.graphics.endFill();
		}
		private function createEggMask(target:Shape):void {
			var w:Number = fireWidth;
			var h:Number = fireHeight;
			target.graphics.beginFill(0xFFFFFF);
			target.graphics.moveTo(-w*0.5, -h*0.2);
			target.graphics.curveTo(-w*0.4, -h, 0, -h);
			target.graphics.curveTo(w*0.4, -h, w*0.5, -h*0.2);
			target.graphics.curveTo(w*0.5, 0, 0, 0);
			target.graphics.curveTo(-w*0.5, 0, -w*0.5, -h*0.2);
			target.graphics.endFill();
		}
		private function createGradientLight(target:Shape):void {
			var colors:Array = [0xFFFF00, 0xFFFF00, 0xFFCC00, 0x000000];
			var alphas:Array = [0.6, 0.3, 0.2, 0];
			var ratios:Array = [0, 102, 153, 255];
			var matrix:Matrix = new Matrix();
			var w:Number = fireWidth*1.6;
			var h:Number = fireWidth*0.4;
			matrix.createGradientBox(w, h, 0, -w*0.5, -h*0.5);
			target.graphics.beginGradientFill(GradientType.RADIAL, colors, alphas, ratios, matrix, SpreadMethod.PAD, InterpolationMethod.RGB, 0);
			target.graphics.drawEllipse(-w*0.5,  -h*0.5, w, h);
			target.graphics.endFill();
		}

	}

}
