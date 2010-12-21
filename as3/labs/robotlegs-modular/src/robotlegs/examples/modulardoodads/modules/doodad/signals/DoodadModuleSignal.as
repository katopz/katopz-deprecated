package robotlegs.examples.modulardoodads.modules.doodad.signals
{
	import org.osflash.signals.Signal;
	
	public class DoodadModuleSignal extends Signal
	{
		public static const DO_STUFF_REQUESTED:String = "doStuffRequested";
		public static const REMOVE:String = "doodadModule/remove";
		public static const FLASH_YOUR_DOODAD:String = "flashYourDoodad";
		
		public function DoodadModuleSignal()
		{
			super(String);
		}
	}
}