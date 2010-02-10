package com.cutecoma.engine3d.core.signal
{

	public class Signal extends Object
	{
		private var _id:String;
		public static const UPDATE:String = "signal.update";

		public function Signal(param1:String)
		{
			_id = param1;
		}

		public function get id():String
		{
			return _id;
		}
	}
}