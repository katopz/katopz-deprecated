package com.sleepydesign.components.items
{

	public class ItemData extends Object
	{
		public var id:String;
		public var title:String;
		public var src:String;
		public var type:String;

		public function ItemData(id:String, title:String, src:String, type:String = "")
		{
			this.id = id;
			this.title = title;
			this.src = src;
			this.type = type;
		}
	}
}