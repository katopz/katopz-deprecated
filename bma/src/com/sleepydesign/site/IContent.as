package
{
	import flash.display.MovieClip;
	import flash.events.IEventDispatcher;
	
	public interface IContent extends IEventDispatcher {
		public function init ():void
		public function setStation(iID:String):void
		public function setSection(left,right,high):void
	}
	
}