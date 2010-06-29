package com.cutecoma.playground.data
{
	import away3dlite.core.base.Object3D;

	public class ModelData extends Object
	{
		public var id:String;

		public var model:Object3D;

		public function ModelData(id:String, model:Object3D)
		{
			this.id = id;
			this.model = model;
		}
	}
}