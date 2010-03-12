package com.cutecoma.playground.data
{
	import away3dlite.core.base.Object3D;

	public class ModelData extends Object
	{
		public var id:String;
		public var xml:XML;

		public var model:Object3D;
		public var path:String;

		public function ModelData(id:String, xml:XML, model:Object3D, path:String)
		{
			this.id = id;
			this.xml = xml;
			this.model = model;
			this.path = path;
		}
	}
}