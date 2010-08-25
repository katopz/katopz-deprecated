package
{
	import com.sleepydesign.components.SDButton;
	import com.sleepydesign.components.SDDialog;
	import com.sleepydesign.components.SDScrollPane;
	import com.sleepydesign.components.SDSpeechBalloon;
	import com.sleepydesign.components.SDTextInput;
	import com.sleepydesign.display.SDSprite;
	import com.sleepydesign.system.SystemUtil;
	import com.sleepydesign.text.SDTextField;
	
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.external.ExternalInterface;

	[SWF(backgroundColor="0xCCCCCC", frameRate = "30", width = "400", height = "300")]
	public class TestSDComponent extends Sprite
	{
		public function logIn(nick:String):void
		{
			alpha = .1;
		} 
		
		public var _SDTextField:SDTextField;
		
		public function TestSDComponent()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;

			// create SDScrollPane
			var container:SDScrollPane = new SDScrollPane();
			addChild(container);
			container.setSize(100, 200);
			//container.panel.scrollRect = new Rectangle(0,0,100,150);

			// create content
			var content:SDSprite = new SDSprite();

			// SDTextInput
			var _SDTextInput:SDTextInput = new SDTextInput("<b>t</b>estttttttttttttttttttttttttttttttttty");
			_SDTextInput.label.autoSize = "left";
			_SDTextInput.y = 10;
			content.addChild(_SDTextInput);

			// SDButton
			var _SDButton:SDButton = new SDButton("test");
			_SDButton.x = 80;
			_SDButton.y = 30;
			content.addChild(_SDButton);

			// SDSpeechBalloon
			var _SDSpeechBalloon:SDSpeechBalloon = new SDSpeechBalloon("SDSpeechBalloon test");
			_SDSpeechBalloon.x = 100;
			_SDSpeechBalloon.y = 100;
			addChild(_SDSpeechBalloon);

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
				</question>);

			_SDDialog.x = 100;
			_SDDialog.y = 200;
			addChild(_SDDialog);
			
			// SDDialog#2
			var _SDDialog2:SDDialog = new SDDialog(
				<question id="0">
					<![CDATA[Welcome! please log-in]]>
					<answer src="js:login()"><![CDATA[login]]></answer>
				</question>, false);

			_SDDialog2.x = 300;
			_SDDialog2.y = 200;
			addChild(_SDDialog2);
			
			// External Interface
			SystemUtil.listenJS("logIn", logIn);
			_SDTextField = new SDTextField("wait...");
			_SDTextField.x = 200;
			addChild(_SDTextField);

			// link
			container.addContent(content);
			
			_SDTextField.text = "setProperty";
			
			if(SystemUtil.isExternal())
			{
				ExternalInterface.marshallExceptions = true;
				ExternalInterface.addCallback("setProperty",setProperty);
			}
		}
		
		public function setProperty(pText:String):void
		{
			trace("setProperty()")
			_SDTextField.text = pText;
		}	
	}
}