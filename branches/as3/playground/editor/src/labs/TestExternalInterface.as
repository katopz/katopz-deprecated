package labs
{
	import com.sleepydesign.components.SDDialog;
	import com.sleepydesign.utils.SystemUtil;
	
	import flash.display.Sprite;

	[SWF(backgroundColor="0xCCCCCC", frameRate = "30", width = "800", height = "600")]
	public class TestExternalInterface extends Sprite
	{
		private var _SDDialog:SDDialog;
		private var _viewerID:String = "";
		private var _viewerDisplayName:String = "";
		
		private var _editorTool:EditorTool;
		
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
				</question>, this);

			_SDDialog.x = stage.stageWidth/2;
			_SDDialog.y = stage.stageHeight/2;
			addChild(_SDDialog);
			
			// External Interface Proxy
			SystemUtil.listenJS("onJSSignIn", onJSSignIn);
			SystemUtil.listenJS("onJSSignOut", onJSSignOut);
			SystemUtil.listenJS("onJSGetData", onJSGetData);
			SystemUtil.listenJS("onJSDialog", onJSDialog);
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
			
			// EditorTool
			addChild(_editorTool = new EditorTool());
			_editorTool.initXML("config.xml");
		} 
		
		public function onJSDialog(string:String):void
		{
			trace(" ! onJSDialog : " + string);
			_SDDialog.xmlText = string;
		}
		
		public function onJSGetData(saveData:Object):void
		{
			trace("'"+"132"+"'");
			_SDDialog.xmlText = '<question id="0"><![CDATA[Welcome ('+ _viewerID +'): '
			+ _viewerDisplayName+'<br/>Data : '+saveData['time']+']]>'
			+ '<answer src="js:saveData('+("'"+String(new Date())+"'")+')"><![CDATA[Save : '+String(new Date())+']]></answer>'
			+ '<answer src="js:signOut()"><![CDATA[Sign Out]]></answer></question>';
		}	
		
		public function onJSSignOut():void
		{
			
		}
		
		// proxy for js
		public function apply(functionName:String, arg:String):void
		{
			this[functionName].apply(this, [arg]);
		}
	}
}