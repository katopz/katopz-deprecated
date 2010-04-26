package
{
	import away3dlite.core.utils.Debug;
	
	import com.sleepydesign.components.SDDialog;
	import com.sleepydesign.system.SystemUtil;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.events.Event;
	import flash.text.TextField;

	[SWF(backgroundColor="0xCCCCCC", frameRate = "30", width = "800", height = "600")]
	public class LogIn extends Sprite
	{
		private var _SDDialog:SDDialog;
		private var _viewerID:String = "";
		private var _viewerDisplayName:String = "";
		
		private var _editorTool:EditorTool;
		
		public function LogIn()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		protected function onAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			
			
			createUI();
		}
		
		private function createUI():void
		{
			// SDDialog
			_SDDialog = new SDDialog(
				<question>
					<![CDATA[Welcome! Guest, please log-in]]>
					<answer src="js:signIn()"><![CDATA[Sign in]]></answer>
					<answer src="as:onJSSignIn()"><![CDATA[Sign in as Guest]]></answer>
				</question>, this);

			_SDDialog.align = StageAlign.TOP_RIGHT;
			addChild(_SDDialog);
			
			// External Interface Proxy
			SystemUtil.listenJS("onJSSignIn", onJSSignIn);
			SystemUtil.listenJS("onJSSignOut", onJSSignOut);
			SystemUtil.listenJS("onJSGetData", onJSGetData);
			SystemUtil.listenJS("onJSDialog", onJSDialog);
		}
		
		public function onJSSignIn(viewerID:String = null, viewerDisplayName:String = null):void
		{
			trace(" ! onJSSignIn");
			_viewerID = viewerID || String(new Date().valueOf());
			_viewerDisplayName = viewerDisplayName || "guest" + _viewerID;
			
			_SDDialog.xmlText = '<question><![CDATA[Welcome ('+ _viewerID +'): '
			+ _viewerDisplayName+']]>'
			+ '<answer src="as:newData()"><![CDATA[New]]></answer>'
			+ '<answer src="js:loadData()"><![CDATA[Load]]></answer>'
			+ '<answer src="as:saveData()"><![CDATA[Save]]></answer>'
			+ '<answer src="js:signOut()"><![CDATA[Sign Out]]></answer></question>';
		}
		private var _currentData:Object;
		public function newData(charData:Object = null):void
		{
			_currentData = charData;
			
			// EditorTool
			if(_editorTool)
				return;
			
			EditorTool.initSignal.add(onEditorInit);
			EditorTool.changeSignal.add(onEditorChange);
			addChild(_editorTool = new EditorTool());
			_editorTool.initXML("config.xml");
		} 
		
		public function onEditorChange(charData:Object):void
		{
			_currentData = charData;
			
			trace("onEditorChange:"+_currentData['char'].meshes[0]);
			trace("onEditorChange:"+_currentData['char'].meshes[1]);
			trace("onEditorChange:"+_currentData['char'].meshes[2]);
			trace("onEditorChange:"+_currentData['char'].meshes[3]);
			trace("onEditorChange:"+_currentData['char'].meshes[4]);
			
			//redrawSaveDialog(charData);
		}
		
		public function onEditorInit():void
		{
			if(_currentData)
			{
				trace("onEditorInit:"+_currentData['char'].meshes[0]);
				trace("onEditorInit:"+_currentData['char'].meshes[1]);
				trace("onEditorInit:"+_currentData['char'].meshes[2]);
				trace("onEditorInit:"+_currentData['char'].meshes[3]);
				trace("onEditorInit:"+_currentData['char'].meshes[4]);
				_editorTool.openJSON(_currentData['char']);
			}
		}
		
		public function onJSDialog(string:String):void
		{
			trace(" ! onJSDialog : " + string);
			_SDDialog.xmlText = string;
		}
		
		public function onJSGetData(charData:Object):void
		{
			_currentData = charData;
			
			trace("onJSGetData:"+_currentData['char'].meshes[0]);
			trace("onJSGetData:"+_currentData['char'].meshes[1]);
			trace("onJSGetData:"+_currentData['char'].meshes[2]);
			trace("onJSGetData:"+_currentData['char'].meshes[3]);
			trace("onJSGetData:"+_currentData['char'].meshes[4]);
			
			//redrawSaveDialog(charData);
			newData(charData);
		}	
		/*
		private function redrawSaveDialog(charData:Object):void
		{
			_SDDialog.xmlText = '<question><![CDATA[Welcome ('+ _viewerID +'): '
				+ '<answer src="as:saveData()"><![CDATA[Save]]></answer>'
				+ '<answer src="js:signOut()"><![CDATA[Sign Out]]></answer></question>';
		}
		*/
		
		public function saveData():void
		{
			trace("saveData:"+_currentData['char'].meshes[0]);
			trace("saveData:"+_currentData['char'].meshes[1]);
			trace("saveData:"+_currentData['char'].meshes[2]);
			trace("saveData:"+_currentData['char'].meshes[3]);
			trace("saveData:"+_currentData['char'].meshes[4]);
			
			SystemUtil.callJS("saveData", _currentData);
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