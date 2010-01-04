package de.nulldesign.nd3d.utils 
{

	public class ColorUtil 
	{
		public static function hex2rgb(h:uint):Object 
		{
			return {r:h >> 16, g:h >> 8 & 255, b:h & 255};
		}

		public static function rgb2hex(r:uint, g:uint, b:uint):Number 
		{
			return (r << 16 | g << 8 | b);
		}
	}
}