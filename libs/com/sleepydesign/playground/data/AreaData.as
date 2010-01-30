package com.sleepydesign.playground.data
{
	import flash.net.registerClassAlias;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;

	public class AreaData implements IExternalizable
	{
		registerClassAlias("com.sleepydesign.game.data.AreaData", AreaData);

		public var id:String;
		public var background:String;
		public var src:String;
		public var width:Number;
		public var height:Number;
		public var scene:SceneData;

		public function AreaData(id:String=null, background:String=null, src:String=null, width:Number=0, height:Number=0, scene:SceneData=null)
		{
			if(!id)return;
			
			this.id = id;
			this.background = background;
			this.src = src;
			this.width = width;
			this.height = height;
			this.scene = scene;
		}

		// _______________________________________________________internal

		public function parse(raw:*):AreaData
		{
			id = raw.id ? String(raw.id) : id;
			background = raw.background ? String(raw.background) : background;
			src = raw.src ? String(raw.src) : src;
			width = raw.width ? Number(raw.width) : width;
			height = raw.height ? Number(raw.height) : height;
			scene = raw.scene ? SceneData(raw.scene) : scene;
			
			return this;
		}

		// _______________________________________________________ external

		public function writeExternal(output:IDataOutput):void
		{
			output.writeObject({id: id, background: background, src: src, width: width, height: height, scene: scene});
		}

		public function readExternal(input:IDataInput):void
		{
			parse(input.readObject());
		}
	}
}