package com.sleepydesign.io
{
	import flash.net.registerClassAlias;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	
	public class IOPosition implements IExternalizable 
	{
		registerClassAlias( "com.sleepydesign.io.IOPosition", IOPosition );
		
		public var x:Number;
		public var y:Number;
		public var z:Number;
		
		public function IOPosition( x:Number=0, y:Number=0, z:Number=0) 
		{
			this.x = x;
			this.y = y;
			this.z = z;
		}

		public function writeExternal( output: IDataOutput ): void
		{
			output.writeFloat(x);
			output.writeFloat(y);
			output.writeFloat(z);
		}
		
		public function readExternal( input: IDataInput ): void
		{
			x = Number(input.readFloat());
			y = Number(input.readFloat());
			z = Number(input.readFloat());
		}
		
		public function toString(): String
		{
			return "Position [ "+"x:" + x + ", y:" + y + ", z:" + z +" ]";
		}		
	}
}
