package
{
	import com.sleepydesign.components.SDDialog;
	import com.sleepydesign.text.SDTextField;
	import com.sleepydesign.utils.SystemUtil;
	
	import flash.display.Sprite;
	import flash.external.ExternalInterface;

	[SWF(backgroundColor="0xCCCCCC", frameRate = "30", width = "400", height = "300")]
	public class TestExternalInterface extends Sprite
	{
		public var _SDTextField:SDTextField;

		public function TestExternalInterface()
		{
			_SDTextField = new SDTextField("123");
			addChild(_SDTextField);
			createUI();
		}
		
		private function createUI():void
		{
			// SDDialog#2
			var _SDDialog2:SDDialog = new SDDialog(
				<question id="0">
					<![CDATA[Welcome! please log-in]]>
					<answer src="js:logIn()"><![CDATA[login]]></answer>
				</question>, false);

			_SDDialog2.x = 300;
			_SDDialog2.y = 200;
			addChild(_SDDialog2);
			
			// External Interface
			SystemUtil.listenJS("apply", apply);
		}
		
		private function OnClick():void
		{
			trace("OnClick()");
			ExternalInterface.call("fromSwf", "OnClick");
		}
		
		public function logIn(pText:String=null):void
		{
			trace("logIn()");
			_SDTextField.text = "Welcomme : "+pText;
		}
		
		public function apply(functionName:String, arg:String):void
		{
			trace("setProperty()");
			//_SDTextField.text = pText;
			this[functionName].apply(this, [arg]);
		}
	}
}