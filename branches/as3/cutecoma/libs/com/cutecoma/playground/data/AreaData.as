package com.cutecoma.playground.data
{
	import flash.net.registerClassAlias;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;

	public class AreaData implements IExternalizable
	{
		registerClassAlias("com.cutecoma.playground.data.AreaData", AreaData);

		public var id:String;
		public var background:String;
		public var width:Number;
		public var height:Number;
		public var viewData:ViewData;
		public var mapData:MapData;
		
		public var version:Number = 1;
		public static const CURRENT_VERION:Number = 1;

		public function AreaData(id:String = null, background:String = null, width:Number = 0, height:Number = 0, viewData:ViewData = null, mapData:MapData = null)
		{
			this.id = id;
			this.background = background;
			this.width = width;
			this.height = height;
			this.viewData = viewData || new ViewData();
			this.mapData = mapData || new MapData();
		}

		// _______________________________________________________internal

		public function parse(raw:*):AreaData
		{
			id = raw.id ? String(raw.id) : id;
			background = raw.background ? String(raw.background) : background;
			width = raw.width ? Number(raw.width) : width;
			height = raw.height ? Number(raw.height) : height;

			if (!raw.version)
			{
				// old version
				if(raw.scene)
					viewData.cameraData.parse_v0(raw.scene.camera);
				mapData = raw.map ? MapData(raw.map) : mapData;
				version = CURRENT_VERION;
				
				background = background.split("/").pop();
			}
			else
			{
				// new version
				viewData = raw.viewData ? ViewData(raw.viewData) : viewData;
				mapData = raw.mapData ? MapData(raw.mapData) : mapData;
				version = raw.version ? Number(raw.version) : version;
			}

			return this;
		}

		// _______________________________________________________ external

		public function writeExternal(output:IDataOutput):void
		{
			output.writeObject({version:CURRENT_VERION, id: id, background: background, 
					width: width, height: height, 
					viewData: viewData, mapData:mapData});
		}

		public function readExternal(input:IDataInput):void
		{
			parse(input.readObject());
		}
	}
}