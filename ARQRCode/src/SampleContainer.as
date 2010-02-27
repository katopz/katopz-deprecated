package
{
	import com.sleepydesign.utils.LoaderUtil;
	
	import flash.display.Sprite;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	[SWF(backgroundColor="0x333333", frameRate="30", width="320", height="240")]
	public class SampleContainer extends Sprite
	{
		private var _label:TextField;
		private var _reader:Sprite;
		
		public function SampleContainer()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
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
			
			//_label.x = 34-200;
			//_label.y = 480/2-200;
			
			_label.text = " i'm parent container!\n click me to open/close reader.";
			addChild(_label);
			
			addEventListener(Event.ADDED_TO_STAGE, onStage);
			
			// listen for code
			Oishi.addEventListener(DataEvent.DATA, onGetCode);
			
			// default setting
			/*
			Oishi.ROTATION_X = -90;
			Oishi.ROTATION_Z = -90;
			
			Oishi.SCALE_X = -1;
			Oishi.SCALE_Z = -1;
			*/
			
			Oishi.POSITION_Y = 320;
			Oishi.POSITION_Z = -100;
			
			Oishi.USE_DEDUG = false;
			Oishi.USE_CAMERA = true;
			Oishi.USE_CONTEXT = false;
			Oishi.MODEL_DATA_URL = "serverside/modelData.xml";
			
			Oishi.MATRIX3D_INTERPOLATE = .25;
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
				LoaderUtil.load("reader.swf", onLoad);
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
				addChild(_reader);
			}
		}
	}
}