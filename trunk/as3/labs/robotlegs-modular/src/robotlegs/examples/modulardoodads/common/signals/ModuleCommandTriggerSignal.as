package robotlegs.examples.modulardoodads.common.signals
{
	import org.osflash.signals.Signal;
	
	public class ModuleCommandTriggerSignal extends Signal
	{
		public static const TRIGGER_MODULE_COMMAND:String = "triggerModuleCommand";
		
		public function ModuleCommandTriggerSignal()
		{
			super(String);
		}
	}
}