package
{
	import com.sleepydesign.components.SDDialog;
	import com.sleepydesign.utils.SystemUtil;
	
	import flash.display.Sprite;

	[SWF(backgroundColor="0xCCCCCC", frameRate = "30", width = "400", height = "300")]
	public class TestExternalInterface extends Sprite
	{
		private var _SDDialog:SDDialog;
		private var _viewerID:String = "";
		private var _viewerDisplayName:String = "";
		
		public function TestExternalInterface()
		{
			createUI();
		}
		
		private function createUI():void
		{
			// SDDialog
			_SDDialog = new SDDialog(
				<question id="0">
					<![CDATA[Welcome! Guest, please log-in]]>
					<answer src="js:signIn()"><![CDATA[Sign In]]></answer>
				</question>, false);

			_SDDialog.x = stage.stageWidth/2;
			_SDDialog.y = stage.stageHeight/2;
			addChild(_SDDialog);
			
			// External Interface Proxy
			SystemUtil.listenJS("onJSSignIn", onJSSignIn);
			SystemUtil.listenJS("onJSSignOut", onJSSignOut);
			SystemUtil.listenJS("onJSGetData", onJSGetData);
		}
		
		public function onJSSignIn(viewerID:String, viewerDisplayName:String):void
		{
			trace(" ! onJSSignIn");
			_viewerID = viewerID;
			_viewerDisplayName = viewerDisplayName;
			
			_SDDialog.xmlText = '<question id="0"><![CDATA[Welcome ('+ viewerID +'): '
			+ viewerDisplayName+']]>'
			+ '<answer src="js:loadData()"><![CDATA[Load]]></answer>'
			+ '<answer src="js:signOut()"><![CDATA[Sign Out]]></answer></question>';
		}
		
		public function onJSSignOut():void
		{
			trace(" ! onJSSignOut");
			_SDDialog.xmlText = <question id="0">
					<![CDATA[Bye!]]>
					<answer src="js:signIn()"><![CDATA[Sign In]]></answer>
				</question>;
		}
		
		public function onJSGetData(saveData:Object):void
		{
			trace("'"+"132"+"'");
			_SDDialog.xmlText = '<question id="0"><![CDATA[Welcome ('+ _viewerID +'): '
			+ _viewerDisplayName+'<br/>Data : '+saveData['time']+']]>'
			+ '<answer src="js:saveData('+("'"+String(new Date())+"'")+')"><![CDATA[Save : '+String(new Date())+']]></answer>'
			+ '<answer src="js:signOut()"><![CDATA[Sign Out]]></answer></question>';
		}	
		
		// proxy for js
		public function apply(functionName:String, arg:String):void
		{
			this[functionName].apply(this, [arg]);
		}
	}
}