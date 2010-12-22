package robotlegs.examples.modulardoodads.modules.doodad
{
    import com.sleepydesign.system.DebugUtil;
    
    import mx.managers.FocusManager;
    
    import org.robotlegs.utilities.modular.mvcs.ModuleMediator;
    
    import robotlegs.examples.modulardoodads.common.events.LoggingEvent;
    import robotlegs.examples.modulardoodads.modules.doodad.events.DoodadModuleEvent;
    import robotlegs.examples.modulardoodads.modules.doodad.signals.DoodadModuleSignal;
    
    public class DoodadModuleMediator extends ModuleMediator
    {
        [Inject]
        public var view:DoodadModule;
		
		[Inject]
		public var doodadModuleSignal:DoodadModuleSignal;
        
        private var madeRequest:Boolean;
        
        override public function onRegister():void
        {
            addViewListener(DoodadModuleEvent.DO_STUFF_REQUESTED, handleDoStuffRequested, DoodadModuleEvent);
            addViewListener(DoodadModuleEvent.REMOVE, handleRemove);
            addModuleListener(DoodadModuleEvent.DO_STUFF_REQUESTED, handleDoStuffRequest, DoodadModuleEvent);
            addContextListener(DoodadModuleEvent.FLASH_YOUR_DOODAD, handleDoodadFlashRequest);
			
			doodadModuleSignal.add(handleDoodadFlashRequest2);
        }
        
        private function handleRemove(event:DoodadModuleEvent):void
        {
            dispatchToModules(new LoggingEvent(LoggingEvent.MESSAGE, "Removing DoodadModule"));
            dispatchToModules(event);
			
			doodadModuleSignal.remove(handleDoodadFlashRequest2);
			
            view.dispose();
        }
        
        private function handleDoStuffRequested(event:DoodadModuleEvent):void
        {
            madeRequest = true;
            dispatchToModules(new LoggingEvent(LoggingEvent.MESSAGE, "DoodadModule made request..."));
            moduleDispatcher.dispatchEvent(event);
        }
        
        private function handleDoStuffRequest(event:DoodadModuleEvent):void
        {
            if(!madeRequest)
            {
                view.color = Math.random()*0xFFFFFF;
                dispatchToModules(new LoggingEvent(LoggingEvent.MESSAGE, "DoodadModule changed color: " + view.color));
            }
            madeRequest = false;
        }
        
        private function handleDoodadFlashRequest(event:DoodadModuleEvent):void
        {
            view.flashIt();
        }
		
        private function handleDoodadFlashRequest2(wtf:String):void
        {
           DebugUtil.trace("wtf : " + wtf);
        }
    }
}