package com.cutecoma.playground.data
{
	import flash.net.registerClassAlias;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;

	public class SceneData implements IExternalizable
	{
		registerClassAlias("com.cutecoma.playground.data.SceneData", SceneData);

		public var camera:CameraData;

		public var animated:Boolean;
		public var interactive:Boolean;
		public var autoClipping:Boolean;
		public var autoCulling:Boolean;

		public var width:Number;
		public var height:Number;

		public function SceneData(camera:CameraData = null)
		{
			if(camera)
			{
				this.camera = camera;
			}else{
				this.camera = new CameraData(0, 200, -1000);
				this.camera.rotationX = 7.5;	
			}
		}

		// _______________________________________________________internal

		public function parse(raw:*):void
		{
			camera = raw.camera ? CameraData(raw.camera) : camera;
		}

		// _______________________________________________________ external

		public function writeExternal(output:IDataOutput):void
		{
			output.writeObject({camera: camera});
		}

		public function readExternal(input:IDataInput):void
		{
			parse(input.readObject());
		}
	}
}