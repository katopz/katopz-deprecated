package map
{
	import flash.events.*;
	import flash.net.*;

	import graphics.*;

	public class Map extends EventDispatcher
	{
		private var _Markers:Vector.<Marker> = null;

		public function Map(param1:String = null)
		{
			if (param1)
				this.loadFile(param1);
		}

		public function loadXML(param1:XML):void
		{
			var _loc_3:XML = null;
			var _loc_2:* = param1..marker;
			this._Markers = new Vector.<Marker>;
			for each (_loc_3 in _loc_2)
				this._Markers.push(new Marker(_loc_3.@photo, _loc_3.@latitude, _loc_3.@longitude));
		}

		public function loadFile(param1:String):void
		{
			var _loc_2:* = new URLRequest(param1);
			var _loc_3:* = new URLLoader();
			_loc_3.addEventListener(Event.COMPLETE, this.loadCompleteHandler);
			_loc_3.load(_loc_2);
		}

		public function get markers():Vector.<Marker>
		{
			return this._Markers;
		}

		private function loadCompleteHandler(event:Event):void
		{
			this.loadXML(new XML((event.target as URLLoader).data));
			dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}