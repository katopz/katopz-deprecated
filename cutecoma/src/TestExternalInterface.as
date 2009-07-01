package
{
	import com.sleepydesign.components.SDDialog;
	import com.sleepydesign.text.SDTextField;
	import com.sleepydesign.utils.SystemUtil;
	
	import flash.display.Sprite;

	[SWF(backgroundColor="0xCCCCCC", frameRate = "30", width = "400", height = "300")]
	public class TestExternalInterface extends Sprite
	{
		public var _SDDialog:SDDialog;

		public function TestExternalInterface()
		{
			createUI();
		}
		
		private function createUI():void
		{
			// SDDialog
			_SDDialog = new SDDialog(
				<question id="0">
					<![CDATA[Welcome! please log-in]]>
					<answer src="js:logInJS()"><![CDATA[login]]></answer>
				</question>, false);

			_SDDialog.x = stage.stageWidth/2;
			_SDDialog.y = stage.stageHeight/2;
			addChild(_SDDialog);
			
			// External Interface Proxy
			SystemUtil.listenJS("logIn", logIn);
			SystemUtil.listenJS("logOut", logOut);
		}
		
		public function logIn(personID:String="", personDisplayName:String=""):void
		{
			trace(" ! logIn");
			_SDDialog.xmlText = '<question id="0"><![CDATA[Welcomme ('+ personID +'): '+personDisplayName+']]>'+'<answer src="js:logOutJS()"><![CDATA[logout]]></answer></question>';
		}
		
		public function logOut():void
		{
			trace(" ! logOut");
			_SDDialog.xmlText = <question id="0">
					<![CDATA[Bye!]]>
					<answer src="js:logInJS()"><![CDATA[login]]></answer>
				</question>;
		}
		
		// proxy for js
		public function apply(functionName:String, arg:String):void
		{
			this[functionName].apply(this, [arg]);
		}
	}
}