package com.cutecoma.playground.data
{
	import flash.net.registerClassAlias;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;

	public class ViewData implements IExternalizable
	{
		registerClassAlias("com.cutecoma.playground.data.ViewData", ViewData);

		public var cameraData:CameraData;

		public function ViewData(cameraData:CameraData = null)
		{
			if(cameraData)
			{
				this.cameraData = cameraData;
			}else{
				this.cameraData = new CameraData(0, 200, -1000);
				this.cameraData.rotationX = 7.5;	
			}
		}

		// _______________________________________________________internal

		public function parse(raw:*):void
		{
			cameraData = raw.cameraData ? CameraData(raw.cameraData) : cameraData;
		}

		// _______________________________________________________ external

		public function writeExternal(output:IDataOutput):void
		{
			output.writeObject({cameraData: cameraData});
		}

		public function readExternal(input:IDataInput):void
		{
			parse(input.readObject());
		}
	}
}