package de.nulldesign.nd3d.geom 
{
	/**
	 * Basic UV mapping coordinates class
	 * @author Lars Gerckens (lars@nulldesign.de)
	 */
	public class UV 
	{

		public var u:Number;
		public var v:Number;

		public function UV(u:Number = 0, v:Number = 0) 
		{
			this.u = u;
			this.v = v;
		}

		public function toString():String 
		{
			return "UV: " + u + " / " + v;
		}

		public function clone():UV 
		{
			return new UV(u, v);
		}
	}
}
