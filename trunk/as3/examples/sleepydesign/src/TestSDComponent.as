package
{
	import com.sleepydesign.components.SDButton;
	import com.sleepydesign.components.SDDialog;
	import com.sleepydesign.components.SDScrollPane;
	import com.sleepydesign.components.SDSlider;
	import com.sleepydesign.components.SDSpeechBalloon;
	import com.sleepydesign.components.SDTextInput;
	import com.sleepydesign.display.SDSprite;
	import com.sleepydesign.text.SDTextField;
	
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.events.Event;

	[SWF(backgroundColor="0xCCCCCC", frameRate = "30", width = "400", height = "300")]
	public class TestSDComponent extends Sprite
	{	
		public function TestSDComponent()
		{
			addEventListener(Event.ADDED_TO_STAGE, onStage);
		}
		
		private function onStage(event:Event):void
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;

			// create SDScrollPane
			var _SDScrollPane:SDScrollPane = new SDScrollPane();
			_SDScrollPane.setSize(200, 220);
			_SDScrollPane.align = "center-stage";
			addChild(_SDScrollPane);

			// create content
			var content:SDSprite = new SDSprite();

			// SDSquare
			//var _SDSquare:SDSquare = new SDSquare(100, 100, 0xFF0000);
			//content.addChild(_SDSquare);

			// TextInput
			var _TextInput:SDTextInput = new SDTextInput("<b>t</b>estttttttttttttttttttttttttttttttttty");
			//_TextInput.label.autoSize = "left";
			_TextInput.width = 250;
			_TextInput.y = 10;
			content.addChild(_TextInput);

			// SDButton
			var _SDButton:SDButton = new SDButton("test");
			_SDButton.x = 80;
			_SDButton.y = 30;
			content.addChild(_SDButton);

			// SDBalloon
			var _SDBalloon:SDSpeechBalloon = new SDSpeechBalloon("DialogBalloon test");
			_SDBalloon.float = "center";
			_SDBalloon.x = 110;
			_SDBalloon.y = 100;
			addChild(_SDBalloon);

			// SDDialog
			var _SDDialog:SDDialog = new SDDialog(
				<question id="0">
					<![CDATA[Who say <b>Hello World</b>?<br/>Do you remember?]]>
					<answer src="as:jump(1)"><![CDATA[Maybe me]]></answer>
					<question id="1">
						<![CDATA[Really you?]]>
						<answer src="as:jump(2)"><![CDATA[Yes!]]></answer>
						<question id="2">
							<![CDATA[Are you Sure?]]>
							<answer src="as:jump(3)"><![CDATA[Holy Yes!]]></answer>
							<question id="3" src="as:hide()"><![CDATA[OK!]]></question>
							<answer src="as:jump(1)"><![CDATA[Hell No!]]></answer>
						</question>
						<answer src="as:jump(0)"><![CDATA[No!]]></answer>
					</question>
					<answer src="http://www.google.com"><![CDATA[Try ask google!]]></answer>
				</question>, this);

			_SDDialog.x = 300;
			_SDDialog.y = 200;
			
			addChild(_SDDialog);
			/*
			// SDDialog#2
			var _SDDialog2:SDDialog = new SDDialog( 
				<question id="0">
					<![CDATA[Welcome! please log-in]]>
					<answer src="js:login()"><![CDATA[login]]></answer>
				</question>, this);

			_SDDialog2.x = 300;
			_SDDialog2.y = 200;
			addChild(_SDDialog2);
*/
			_SDScrollPane.addContent(content);
		}
	}
}