package com.cutecoma.game.events
{
	import com.sleepydesign.events.SDEvent;

	public class PlayerEvent extends SDEvent
	{
		public static const UPDATE			: String = "update";
		public static const COMPLETE		: String = "complete";
		public static const REMOVED			: String = "removed";
		
		public static const SPAWN			: String = "spawn";
		public static const ENTER			: String = "enter";
		public static const IDLE			: String = "idle";
		public static const EXIT			: String = "exit";
		
		public static const SIT				: String = "sit";
		public static const STAND			: String = "stand";
		public static const SLEEP			: String = "sleep";
		
		public static const WALK			: String = "walk";
		public static const WALK_COMPLETE	: String = "walkComplete";
		
		public static const JUMP			: String = "jump";
		
		public static const TALK			: String = "talk";
		
		public static const ATTACK			: String = "attack";
		public static const SPELL			: String = "spell";
		
		public static const ACT_COMPLETE	: String = "actComplete";
		
		public static const ANIMATIONS_COMPLETE	: String = "animationsComplete";
		public static const LOAD_COMPLETE 		: String = "loadComplete";
		
		public static const RALLY			: String = "rally";
		
		public function PlayerEvent(type:String, data:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, data, bubbles, cancelable);
			this.data = data;
		}		
	}
}