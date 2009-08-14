package com.si3d.materials
{
	import com.si3d.lights.Light;
	import com.si3d.lights.LightMap;
	
	import flash.display.*;
	import flash.geom.*;

	public class Material extends BitmapData
	{
		public var alpha:Number=1; // The alpha value is available for renderSolid()
		public var doubleSided:int=0; // set doubleSided=-1 if double sided material

		/** constructor */
		function Material(dif:int=256, spc:int=256)
		{
			super(dif, spc, false);
			setColor2(0xFF0000, 1);
		}

		/** set color. */
		public function setBitmap(bitmapData:BitmapData):Material
		{
			draw(bitmapData);
			/*
			var lmap:LightMap=new LightMap(width, height);
			draw(lmap.diffusion(amb, dif), null, null, "hardlight");
			draw(lmap.specular(spc, pow), null, null, "add");
			lmap.dispose();
			*/
			return this;
		}
		
		/** set color. */
		public function setColor(col:uint, amb:int=64, dif:int=192, spc:int=0, pow:Number=8, emi:int=0, doubleSided:Boolean=false):Material
		{
			fillRect(rect, col);
			var lmap:LightMap=new LightMap(width, height);
			draw(lmap.diffusion(amb, dif), null, null, "hardlight");
			draw(lmap.specular(spc, pow), null, null, "add");
			lmap.dispose();
			return this;
		}

		/** calculate color by light and normal vector. */
		public function getColor(l:Light, n:Vector3D):uint
		{
			var dir:Vector3D=l.world, hv:Vector3D=l.halfVector;
			var ln:int=int((dir.x * n.x + dir.y * n.y + dir.z * n.z) * (width - 1)), hn:int=int((hv.x * n.x + hv.y * n.y + hv.z * n.z) * (height - 1));
			if (ln < 0)
				ln=(-ln) & doubleSided;
			if (hn < 0)
				hn=(-hn) & doubleSided;
			return getPixel(ln, hn);
		}

		static public function calculateTexCoord(texCoord:Point, light:Light, normal:Vector3D, doubleSided:Boolean=false):void
		{
			var v:Vector3D=light.world;
			texCoord.x=v.x * normal.x + v.y * normal.y + v.z * normal.z;
			if (texCoord.x < 0)
				texCoord.x=(doubleSided) ? -texCoord.x : 0;
			v=light.halfVector;
			texCoord.y=v.x * normal.x + v.y * normal.y + v.z * normal.z;
			if (texCoord.y < 0)
				texCoord.y=(doubleSided) ? -texCoord.y : 0;
		}

		//public var colorTable:BitmapData=new BitmapData(256, 256, false);
		private var _nega_filter:int=0;

		public function setColor2(color:uint, alpha_:Number=1.0, amb:int=64, dif:int=192, spc:int=0, pow:Number=8, emi:int=0, doubleSided:Boolean=false):Material
		{
			var i:int, r:int, c:int, lightTable:BitmapData=new BitmapData(256, 256, false), rct:Rectangle=new Rectangle();

			// base color
			alpha=alpha_;
			this.fillRect(this.rect, color);

			// ambient/diffusion/emittance
			var ea:Number=(256 - emi) * 0.00390625, eb:Number=emi * 0.5;
			r=dif - amb;
			rct.width=1;
			rct.height=256;
			rct.y=0;
			for (i=0; i < 256; ++i)
			{
				rct.x=i;
				lightTable.fillRect(rct, (((i * r) >> 8) + amb) * 0x10101);
			}
			this.draw(lightTable, null, new ColorTransform(ea, ea, ea, 1, eb, eb, eb, 0), BlendMode.HARDLIGHT);

			// specular/power
			if (spc > 0)
			{
				rct.width=256;
				rct.height=1;
				rct.x=0;
				for (i=0; i < 256; ++i)
				{
					rct.y=i;
					c=int(Math.pow(i * 0.0039215686, pow) * spc);
					lightTable.fillRect(rct, ((c < 255) ? c : 255) * 0x10101);
				}
				this.draw(lightTable, null, null, BlendMode.ADD);
			}
			lightTable.dispose();

			// double sided
			_nega_filter=(doubleSided) ? -1 : 0;

			return this;
		}

		
		public function getColor2(light:Light, normal:Vector3D):uint
		{
			var v:Vector3D, ln:int, hn:int, sign:int;

			// ambient
			v=light.world;
			ln=int((v.x * normal.x + v.y * normal.y + v.z * normal.z) * 255);
			sign=((ln & 0x80000000) >> 31);
			ln=(ln ^ sign) & ((~sign) | _nega_filter);

			// specular
			v=light.halfVector;
			hn=int((v.x * normal.x + v.y * normal.y + v.z * normal.z) * 255);
			sign=((hn & 0x80000000) >> 31);
			hn=(hn ^ sign) & ((~sign) | _nega_filter);

			return this.getPixel(ln, hn);
		}
		
		/** calculate color by light and normal vector. */
		public function getColor3(light:*, normal:Vector3D):uint
		{
			var dir:Vector3D=light.direction, hv:Vector3D=light.halfVector;
			var ln:int=int((dir.x * normal.x + dir.y * normal.y + dir.z * normal.z) * 255), hn:int=int((hv.x * normal.x + hv.y * normal.y + hv.z * normal.z) * 255);
			if (ln < 0)
				ln=(-ln) & _nega_filter;
			if (hn < 0)
				hn=(-hn) & _nega_filter;
			return this.getPixel(ln, hn);
		}
	}
}