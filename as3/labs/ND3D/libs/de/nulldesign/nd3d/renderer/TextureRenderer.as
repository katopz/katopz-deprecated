package de.nulldesign.nd3d.renderer 
{
	import de.nulldesign.nd3d.geom.Vertex;
	import de.nulldesign.nd3d.material.LineMaterial;
	import de.nulldesign.nd3d.material.Material;
	import de.nulldesign.nd3d.material.PixelMaterial;
	import de.nulldesign.nd3d.material.WireMaterial;
	import flash.geom.Point;

	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.geom.Matrix;		

	/**
	 * The TextureRenderer
	 * @author Lars Gerckens (www.nulldesign.de)
	 */
	public class TextureRenderer
	{
		/**
		 * Renders a set of lines
		 * @param	gfx
		 * @param	material
		 * @param	vertexList
		 */
		public function renderLine(gfx:Graphics, material:LineMaterial, vertexList:Array):void
		{
			var v0:Vertex;
			var v1:Vertex;
			var length:uint = vertexList.length;
			var thickness:Number = material.thickness;
			var alpha:Number = material.alpha;
      
			gfx.lineStyle(thickness, material.color, alpha);
      
			for(var i:uint = 0;i < length - 1; i++)
			{
				v0 = vertexList[i];
				v1 = vertexList[i + 1];
				gfx.moveTo(v0.screenX, v0.screenY);
				gfx.lineTo(v1.screenX, v1.screenY);
				gfx.endFill();
			}
		}
		
		/**
		 * Renders a vertex as a pixel
		 * @param	gfx
		 * @param	material
		 * @param	a Vertex
		 */
		public function renderPixel(gfx:Graphics, material:PixelMaterial, a:Vertex):void
		{
			gfx.lineStyle();
			gfx.beginFill(material.color, material.alpha);
			gfx.drawCircle(a.screenX, a.screenY, material.thickness * a.scale);
			gfx.endFill();
		}
		/**
		 * Renders a flat colored face
		 * @param	wireFrameMode
		 * @param	calculatedColor
		 * @param	gfx
		 * @param	material
		 * @param	v1
		 * @param	v2
		 * @param	v3
		 */
		public function renderFlatFace(wireFrameMode:Boolean, calculatedColor:Number, gfx:Graphics, 
										material:Material, v1:Vertex, v2:Vertex, v3:Vertex):void
		{
			if(wireFrameMode)
			{
				gfx.lineStyle(1, 0xFFFFFF, 1);
			}
			else
			{
				var wMat:WireMaterial = material as WireMaterial;
				if(wMat)
				{
					gfx.lineStyle(1, material.color, material.alpha);
					if(wMat.fillAlpha > 0) gfx.beginFill(wMat.fillColor, wMat.fillAlpha);
				}
				else
				{
					gfx.lineStyle();
					gfx.beginFill(calculatedColor, material.alpha);
				}
			}
      
			gfx.moveTo(v1.screenX, v1.screenY);
			gfx.lineTo(v2.screenX, v2.screenY);
			gfx.lineTo(v3.screenX, v3.screenY);
			gfx.lineTo(v1.screenX, v1.screenY);
			gfx.endFill();
		}

		/**
		 * Renders a bitmap to the screen
		 * @param graphics object
		 * @param bitmap object
		 * @param transformed vertex
		 */
		public function render2DSprite(gfx:Graphics, material:Material, a:Vertex):void 
		{
			// render bitmap sprites
			var textureBitmap:BitmapData = material.texture;
			var scale:Number = a.scale;
			var width:Number = (textureBitmap.width * scale) / 2;
			var height:Number = (textureBitmap.height * scale) / 2;
			var x0:Number = a.screenX - width;
			var y0:Number = a.screenY - height;
			var x1:Number = x0 + width * 2;
			var y1:Number = y0 + height * 2;

			var tMat:Matrix = new Matrix();
			tMat.scale(scale, scale);
			tMat.translate(x0, y0);

			gfx.lineStyle();
			gfx.beginBitmapFill(textureBitmap, tMat, false, true);
			gfx.moveTo(a.screenX, a.screenY);
			gfx.moveTo(x0, y0);
			gfx.lineTo(x1, y0);
			gfx.lineTo(x1, y1);
			gfx.lineTo(x0, y1);
			gfx.lineTo(x0, y0);
			gfx.endFill();
		}

		/**
		 * renders a textured triangle (original code by Andre Michelle, www.andre-michelle.com)
		 * @param graphics object
		 * @param material
		 * @param face 1st vertex
		 * @param face 2nd vertex
		 * @param face 3rd vertex
		 * @param array of 3 UV-map instances
		 * @param between 0 and 1, defines the strength of the light
		 * @param ambient color
		 */
		public function renderUV(gfx:Graphics, material:Material, a:Vertex, b:Vertex, c:Vertex, uvMap:Array, colorFactor:Number, ambientColor:uint):void 
		{
			var x0:Number = a.screenX;
			var y0:Number = a.screenY;
			var x1:Number = b.screenX;
			var y1:Number = b.screenY;
			var x2:Number = c.screenX;
			var y2:Number = c.screenY;
			
			var texture:BitmapData = material.texture;
			if(!texture) return;

			var w:Number = texture.width;
			var h:Number = texture.height;
				
			var u0:Number = uvMap[0].u * w;
			var v0:Number = uvMap[0].v * h;
			var u1:Number = uvMap[1].u * w;
			var v1:Number = uvMap[1].v * h;
			var u2:Number = uvMap[2].u * w;
			var v2:Number = uvMap[2].v * h;

			var sMat:Matrix = new Matrix();
			var tMat:Matrix = new Matrix();
			
			tMat.tx = u0;
			tMat.ty = v0;
		
			tMat.a = (u1 - u0) / w;
			tMat.b = (v1 - v0) / w;
			tMat.c = (u2 - u0) / h;
			tMat.d = (v2 - v0) / h;
		
			sMat.a = (x1 - x0) / w;
			sMat.b = (y1 - y0) / w;
			sMat.c = (x2 - x0) / h;
			sMat.d = (y2 - y0) / h;
		
			sMat.tx = x0;
			sMat.ty = y0;
		
			tMat.invert();
			tMat.concat(sMat);
			
			var smoothing:Boolean = material.smoothed;
			// check if points are not to close to each other, disable smoothing
			// beginBitmapFill draw bug?!
			if(smoothing) 
			{ 
				var u:Point = new Point(x1 - x0, y1 - y0);
				var v:Point = new Point(x2 - x0, y2 - y0);
				var dot:Number = u.x * v.x + u.y * v.y;
				var angle:Number = Math.acos(dot / (u.length * v.length)) * 180 / Math.PI;

				if(angle < 5 || angle > 175) 
				{
					smoothing = false;
				}
			}
			
			gfx.lineStyle();
			gfx.beginBitmapFill(texture, tMat, false, smoothing);
			gfx.moveTo(x0, y0);
			gfx.lineTo(x1, y1);
			gfx.lineTo(x2, y2);
			gfx.lineTo(x0, y0);
			gfx.endFill();
			
			if(material.calculateLights && colorFactor < 1) 
			{
				gfx.beginFill(ambientColor, 1 - colorFactor);
				gfx.moveTo(x0, y0);
				gfx.lineTo(x1, y1);
				gfx.lineTo(x2, y2);
				gfx.lineTo(x0, y0);
				gfx.endFill();
			}
		}
	}
}
