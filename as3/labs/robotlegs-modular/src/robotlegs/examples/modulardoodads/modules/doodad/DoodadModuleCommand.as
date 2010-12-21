package robotlegs.examples.modulardoodads.modules.doodad
{
    import org.robotlegs.mvcs.Command;
    import org.robotlegs.utilities.modular.core.IModuleEventDispatcher;
    
    import robotlegs.examples.modulardoodads.common.events.LoggingEvent;
    import robotlegs.examples.modulardoodads.common.events.ModuleCommandTriggerEvent;
    import robotlegs.examples.modulardoodads.modules.doodad.events.DoodadModuleEvent;
    import robotlegs.examples.modulardoodads.modules.doodad.signals.DoodadModuleSignal;
    
    public class DoodadModuleCommand extends Command
    {
        [Inject]
        public var event:ModuleCommandTriggerEvent;
        
        [Inject]
        public var moduleDispatcher:IModuleEventDispatcher;
		
		[Inject]
		public var doodadModuleSignal:DoodadModuleSignal;
        
        override public function execute():void
        {
            moduleDispatcher.dispatchEvent(new LoggingEvent(LoggingEvent.MESSAGE, "Module Command Executed!"));
            dispatch(new DoodadModuleEvent(DoodadModuleEvent.FLASH_YOUR_DOODAD));
			doodadModuleSignal.dispatch(DoodadModuleSignal.FLASH_YOUR_DOODAD);
        }
    }
}