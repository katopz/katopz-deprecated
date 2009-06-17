package com.sleepydesign.game.vo
{
	public class PlayerVO
	{
		protected var _id:String;
		public function get id():String
		{
			return _id;
		}
		
		public function PlayerVO( id:String=null )
		{
			_id = id;
		}
	}
}