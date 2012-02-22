package
{
	import org.osflash.signals.Signal;

	public class Global
	{
		public static var config:XML;

		public static var GRAPH_ROTATION:Number = 0;

		// tab
		public static const ALL_TAB:String = "all";
		public static const TUNNEL_TAB:String = "TN";
		public static const FLOOD_TAB:String = "FL";

		private static var _tabID:String = ALL_TAB;

		private static var _tabIDChangeSignal:Signal = new Signal(String);

		public static function get tabIDChangeSignal():Signal
		{
			return _tabIDChangeSignal;
		}

		public static function get tabID():String
		{
			return _tabID;
		}

		public static function set tabID(value:String):void
		{
			if (_tabID == value)
				return;

			_tabID = value;

			_tabIDChangeSignal.dispatch(_tabID);
		}

		// graph
		public static var ALL_GRAPH_COLOR:Number = 0x729FCF;
		public static var FLOOD_GRAPH_COLOR:Number = 0x4E70AF;
		public static var TUNNEL_GRAPH_COLOR:Number = 0x76AD96;
	}
}
