package com.cutecoma.game.utils
{
	public class Math3DUtil
	{
		public static function distance( source:*, target:* ):Number
		{
			var x :Number = source.x - target.x;
			var y :Number = source.y - target.y;
			var z :Number = source.z - target.z;
			return Math.sqrt( x*x + y*y + z*z );
		}
		
		public function interpolate( ev:*, alpha:Number=0.5 ):void
		{
			x += alpha * (ev.x - x);
			y += alpha * (ev.y - y);
			z += alpha * (ev.z - z);
		}
	}
}
