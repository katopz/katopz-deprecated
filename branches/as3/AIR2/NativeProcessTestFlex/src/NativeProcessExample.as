package
{
    import flash.desktop.NativeProcess;
    import flash.desktop.NativeProcessStartupInfo;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.NativeProcessExitEvent;
    import flash.events.ProgressEvent;
    import flash.filesystem.File;
    import flash.utils.*;
    
    [SWF(width=460, height=320, frameRate=24, backgroundColor=0x000000)]
    public class NativeProcessExample extends Sprite
    {
        public var process:NativeProcess;

        public function NativeProcessExample()
        {
            if(NativeProcess.isSupported)
            {
                setupAndLaunch();
            }
            else
            {
                trace("NativeProcess not supported.");
            }
        }
        
        public function setupAndLaunch():void
        {     
            var nativeProcessStartupInfo:NativeProcessStartupInfo = new NativeProcessStartupInfo();
            var file:File = File.applicationDirectory.resolvePath("HelloSTD.exe");
            nativeProcessStartupInfo.executable = file;

            var processArgs:Vector.<String> = new Vector.<String>();
            processArgs[0] = "foo";
            nativeProcessStartupInfo.arguments = processArgs;

            process = new NativeProcess();
            
            process.addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, onOutputData);
            process.addEventListener(ProgressEvent.STANDARD_ERROR_DATA, onErrorData);
            process.addEventListener(NativeProcessExitEvent.EXIT, onExit);
            process.addEventListener(IOErrorEvent.STANDARD_OUTPUT_IO_ERROR, onIOError);
            process.addEventListener(IOErrorEvent.STANDARD_ERROR_IO_ERROR, onIOError);
            process.addEventListener(Event.ACTIVATE, onActivate);
            
            process.start(nativeProcessStartupInfo);
            trace(process.running);
            
            addEventListener(Event.ENTER_FRAME, onEnterFrame);
        }
        private var _time:int=0;
        public function onEnterFrame(event:Event):void
        {
        	process.standardInput.writeUTFBytes("foo");
        	trace(getTimer()-_time);
        	_time = getTimer();
        }
        public function onActivate(event:Event):void
        {
            trace(event);
        }
        public function onOutputData(event:ProgressEvent):void
        {
            trace("Got: ", process.standardOutput.readUTFBytes(process.standardOutput.bytesAvailable)); 
        }
        
        public function onErrorData(event:ProgressEvent):void
        {
            trace("ERROR -", process.standardError.readUTFBytes(process.standardError.bytesAvailable)); 
        }
        
        public function onExit(event:NativeProcessExitEvent):void
        {
            trace("Process exited with ", event.exitCode);
        }
        
        public function onIOError(event:IOErrorEvent):void
        {
             trace(event.toString());
        }
    }
}