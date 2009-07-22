/**
 * Stok3d - getting you stoked on Flash Player native 3D
 * Copyright (C) 2009  David Lenaerts
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * Author information:
 * David Lenaerts
 * url: http://www.derschmale.com
 * mail: david.lenaerts@gmail.com
 *
 * NOTE: The textures used in this programme are not covered by the license. The HangarDoors set
 * is made by Florian Zender (http://www.florianzender.com/) and it is used with his kind permission.
 *
 */

package
{
	import com.derschmale.stok3d.filters.EnvMapFaces;
	import com.derschmale.stok3d.filters.EnvMapPhongFilter;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	
	import open3d.materials.BitmapMaterial;
	import open3d.objects.Object3D;
	import open3d.objects.Plane;
	import open3d.objects.Sphere;
	import open3d.view.SimpleView;

	/**
	 * Native FP10 3D Environment Mapping demo
	 */

	[SWF(width="600", height = "600", frameRate = "30", backgroundColor = "0x000000")]
	public class ExEnvMapPhongExample extends SimpleView
	{
		[Embed(source="envMapPhong/2008_HangarDoors_TextureDiff_large.jpg")]
		private var Texture:Class;

		[Embed(source="envMapPhong/2008_HangarDoors_TextureNormal_large.jpg")]
		private var NormalMap:Class;

		[Embed(source="envMapPhong/2008_HangarDoors_TextureSpec_large.jpg")]
		private var SpecularMap:Class;

		[Embed(source="envMapPhong/left.jpg")]
		private var ReflLeft:Class;

		[Embed(source="envMapPhong/right.jpg")]
		private var ReflRight:Class;

		[Embed(source="envMapPhong/front.jpg")]
		private var ReflFront:Class;

		[Embed(source="envMapPhong/back.jpg")]
		private var ReflBack:Class;

		[Embed(source="envMapPhong/top.jpg")]
		private var ReflTop:Class;

		[Embed(source="envMapPhong/bottom.jpg")]
		private var ReflBottom:Class;

		private var _startX:Number;
		private var _startY:Number;

		private var _mouseDown:Boolean;

		private var _surface:Sprite;

		private var _filter:EnvMapPhongFilter;

		private var _lightRotation:Number = 0;

		private var bitmapData:BitmapData;
		private var plane:Plane;
		private var step:Number = 0;

		private var spheres:Vector.<Sphere>;

		override protected function create():void
		{
			initView();
			initFilter();

			stage.addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
			stage.addEventListener(KeyboardEvent.KEY_UP, handleKeyUp);
			//addEventListener(Event.ENTER_FRAME, handleEnterFrame);

			renderer.isFaceDebug = true;
		}

		private function initView():void
		{
			// init background
			var bg:Bitmap = new Bitmap(new ReflBack().bitmapData);
			bg.width = stage.stageWidth;
			bg.height = stage.stageWidth;
			addChild(bg);

			// add on top
			addChild(renderer.view);

			var textField:TextField = new TextField();
			textField.textColor = 0xffffff;
			textField.multiline = true;
			textField.text = "Click & drag : Rotate surface\n" + "+/- : Change surface reflectance\n" + "PgUp/PgDown : Change surface relief";
			textField.width = textField.textWidth + 10;
			textField.height = textField.textHeight + 10;
			textField.x = stage.stageWidth - textField.width;
			addChild(textField);
			// init rotatable surface, make sure registration point is in center
			var bmp:Bitmap = new Texture();
			//bmp.x = -bmp.width*.5;
			//bmp.y = -bmp.height*.5;
			_surface = new Sprite();
			_surface.addChild(bmp);

			// higher z gives better reflections
			_surface.z = 1000;

			// position and scale
			_surface.x = stage.stageWidth * .5;
			_surface.y = stage.stageHeight * .5;

			_surface.scaleY = 4;
			_surface.scaleX = 4;

			addChild(_surface);

			// my turn
			_surface.visible = false;
			bitmapData = bmp.bitmapData;

			/*
			   var planeMaterial:BitmapMaterial = new BitmapMaterial(bitmapData);

			   plane = new Plane(_surface.width, _surface.height, planeMaterial, 10, 10);
			   renderer.addChild(plane);
			   plane.rotationX = -45;
			 */

			createCubic();
		}

		private function createCubic():void
		{
			var segment:uint = 6;
			var amount:uint = 3;
			var radius:uint = 45;
			var gap:uint = amount;

			var sphere:Sphere;
			for (var i:int = -amount / 2; i < amount / 2; ++i)
				for (var j:int = -amount / 2; j < amount / 2; ++j)
					for (var k:int = -amount / 2; k < amount / 2; ++k)
					{
						// TODO : share material
						sphere = new Sphere(radius, segment, segment, new BitmapMaterial(bitmapData));
						renderer.addChild(sphere);
						sphere.x = gap * radius * i + gap * radius / 2;
						sphere.y = gap * radius * j + gap * radius / 2;
						sphere.z = gap * radius * k + gap * radius / 2;
					}

			renderer.world.rotationX = 30;

			//stage.addEventListener(MouseEvent.MOUSE_MOVE, toggleZSort);
		}

		private function handleKeyUp(event:KeyboardEvent):void
		{
			switch (event.keyCode)
			{
				case 107: // +
					_filter.alpha += 0.1;
					if (_filter.alpha > 1)
						_filter.alpha = 1;
					_surface.filters = [_filter];
					break;
				case 109: // -
					_filter.alpha -= 0.1;
					if (_filter.alpha < 0.0)
						_filter.alpha = 0.0;
					_surface.filters = [_filter];
					break;
				case Keyboard.PAGE_UP:
					_filter.normalMapStrength += 0.03;
					if (_filter.normalMapStrength > 0.4)
						_filter.normalMapStrength = 0.4;
					_surface.filters = [_filter];
					break;
				case Keyboard.PAGE_DOWN:
					_filter.normalMapStrength -= 0.03;
					if (_filter.normalMapStrength < 0.0)
						_filter.normalMapStrength = 0.0;
					_surface.filters = [_filter];
					break;
			}
		}

		/**
		 * Create the EnvMapFilter object and assign it to the surface
		 */
		private function initFilter():void
		{
			var faces:Array = [];
			faces[EnvMapFaces.LEFT] = new ReflLeft().bitmapData;
			faces[EnvMapFaces.RIGHT] = new ReflRight().bitmapData;
			faces[EnvMapFaces.TOP] = new ReflTop().bitmapData;
			faces[EnvMapFaces.BOTTOM] = new ReflBottom().bitmapData;
			faces[EnvMapFaces.FRONT] = new ReflFront().bitmapData;
			faces[EnvMapFaces.BACK] = new ReflBack().bitmapData;

			_filter = new EnvMapPhongFilter(faces, 1, 5, 20, new NormalMap().bitmapData, 0.3, new SpecularMap().bitmapData);
			_filter.ambientColor = 0x000010;
			_filter.specularColor = 0xffff99;
			_filter.update(_surface);
			_surface.filters = [_filter];
			bitmapData.draw(_surface);
		}

		/**
		 * Indicate rotation has started with the current mouse position as motion reference
		 */
		private function handleMouseDown(event:MouseEvent):void
		{
			_mouseDown = true;
			_startX = mouseX;
			_startY = mouseY;
		}

		/**
		 * Indicate rotation has stopped
		 */
		private function handleMouseUp(event:MouseEvent):void
		{
			_mouseDown = false;
		}

		/**
		 * Update filter and surface position
		 */
		override protected function draw():void
		{
			// move the light's position
			_lightRotation += .03;
			_filter.lightPosition.x = Math.sin(_lightRotation) * 1000;
			_filter.lightPosition.y = Math.sin(_lightRotation * 2) * 100;
			_filter.lightPosition.z = Math.cos(_lightRotation) * 300 - 50;

			if (_mouseDown)
			{
				_surface.rotationY += (_startX - mouseX) * .01;
				_surface.rotationX += (_startY - mouseY) * .01;
			}

			_filter.update(_surface);
			_surface.filters = [_filter];
			bitmapData.draw(_surface);
			/*
			   for (var i:int = 0; i<plane.vin.length/3; ++i)
			   {
			   plane.setVertices(i, "z", (i+1)*0.1*Math.sin(step+i/10));
			   step+=0.001;
			   }
			 */
			var world:Object3D = renderer.world;
			world.rotationX = (mouseX - stage.stageWidth / 2) / 5;
			world.rotationZ = (mouseY - stage.stageHeight / 2) / 5;
			world.rotationY++;

			//debugText.appendText(", Move mouse left/right to toggle ZSort : " + renderer.isMeshZSort);
		}
	}
}