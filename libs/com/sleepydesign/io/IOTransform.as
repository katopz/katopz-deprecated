package com.sleepydesign.io
{
	import flash.net.registerClassAlias;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	
	public class IOTransform implements IExternalizable
	{
		registerClassAlias( "com.sleepydesign.io.IOTransform", IOTransform );
		
		public var transformArray:Array;
		
		public function IOTransform( transformArray:Array = null) 
		{
			this.transformArray = transformArray?transformArray.slice():[];
		}

		public function writeExternal( output: IDataOutput ): void
		{
			output.writeObject(transformArray);
		}
		
		public function readExternal( input: IDataInput ): void
		{
			transformArray = input.readObject() as Array;
		}
		
		public function toString(): String
		{
			return "Transform [ " + transformArray + " ]";
		}		
	}
}
