package
{
	import com.sleepydesign.utils.LoaderUtil;
	
	import flash.display.Sprite;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	[SWF(backgroundColor="0x333333", frameRate="30", width="640", height="480")]
	public class SampleContainer extends Sprite
	{
		private var _label:TextField;
		private var _reader:Sprite;
		
		public function SampleContainer()
		{
			_label = new TextField();
			_label.autoSize = "left"
			_label.cacheAsBitmap = true;
			_label.multiline = true;
			_label.defaultTextFormat = new TextFormat("Tahoma", 12, 0xFF0000);
			_label.background = true;
			_label.backgroundColor = 0x111111;
			_label.selectable = true;
			_label.mouseWheelEnabled = true;
			_label.mouseEnabled = true;
			
			_label.x = 640-200;
			_label.y = 480/2-200;
			
			_label.text = " i'm parent container!\n click me to open/close reader.";
			addChild(_label);
			
			addEventListener(Event.ADDED_TO_STAGE, onStage);
			
			// listen for code
			Oishi.addEventListener(DataEvent.DATA, onGetCode);
		}
		
		private function onGetCode(event:DataEvent):void
		{
			_label.appendText("\n get code : "+event.data);
		}
		
		private function onStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onStage);
			_label.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		private function onClick(event:Event):void
		{
			if(!_reader)
			{
				LoaderUtil.load("main.swf", onLoad);
			}else{
				if(_reader.visible)
				{	
					_reader["hide"]();
				}else{
					_reader["show"]();
				}
			}
		}
		
		private function onLoad(event:Event):void
		{
			if(event.type=="complete")
			{
				_reader = event.target.content as Sprite;
				_reader["isOnline"] = false;
				addChild(_reader);
			}
		}
	}
}