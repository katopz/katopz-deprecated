package com.cutecoma.image.editors
{
	import flash.geom.Rectangle;

	public class SizeHandle extends SDSquare
	{
		private var bound:Rectangle;

		public function SizeHandle(x:Number, y:Number, size:uint = 12)
		{
			super(size, size, 0xFFFF00, .75, .5, 0x000000, "c");

			// position
			this.x = x;
			this.y = y;
		}
	}
}