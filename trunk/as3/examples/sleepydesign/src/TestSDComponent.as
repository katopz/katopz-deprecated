package
{
	import com.sleepydesign.components.SDButton;
	import com.sleepydesign.components.SDComponent;
	import com.sleepydesign.components.SDDialog;
	import com.sleepydesign.components.SDScrollPane;
	import com.sleepydesign.components.SDSpeechBalloon;
	import com.sleepydesign.components.SDTextInput;
	import com.sleepydesign.display.SDSprite;

	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;

	[SWF(backgroundColor="0xCCCCCC", frameRate="30", width="640", height="480")]
	public class TestSDComponent extends Sprite
	{
		public function TestSDComponent()
		{
			addEventListener(Event.ADDED_TO_STAGE, onStage);
		}

		private var content:SDSprite;
		private var _SDScrollPane:SDScrollPane;

		private function onStage(event:Event):void
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;

			// create SDScrollPane
			_SDScrollPane = new SDScrollPane();
			_SDScrollPane.setSize(200, 220);
			_SDScrollPane.align = SDComponent.ALIGN_CENTER_STAGE;
			addChild(_SDScrollPane);

			// create content
			content = new SDSprite();

			// TextInput
			var _TextInput:SDTextInput = new SDTextInput("<b>t</b>estttttttty");
			//_TextInput.label.autoSize = "left";
			_TextInput.width = 150;
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
			var _SDDialog:SDDialog = new SDDialog(<question id="0">
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

			_SDScrollPane.addContent(content);
		}

		private function onClick(event:MouseEvent):void
		{
			// SDButton
			var _SDButton:SDButton = new SDButton("test");
			_SDButton.x = 180;
			_SDButton.y = 40;
			content.addChild(_SDButton);

			_SDScrollPane.draw();
		}
	}
}