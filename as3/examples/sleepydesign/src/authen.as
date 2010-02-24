package
{
	import com.sleepydesign.display.SDSprite;
	import com.sleepydesign.net.LoaderUtil;
	import com.sleepydesign.site.FormTool;
	import com.sleepydesign.utils.XMLUtil;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLVariables;

	public class authen extends SDSprite
	{
		[Embed(source="assets/simple-authen.swf", symbol="FormClip")]
		private var FormClip:Class;
		public var logInClip:Sprite = new FormClip() as Sprite;
		private var _form:FormTool;

		public function authen()
		{
			// asset
			addChild(logInClip);

			// get external config
			LoaderUtil.loadXML("authen.xml", onGetConfig);
			
			addEventListener(Event.ADDED_TO_STAGE, onStage);
		}

		private function onStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onStage);
			logInClip.x = stage.stageWidth/2 - logInClip.width/2;
			logInClip.y = stage.stageHeight/2 - logInClip.height/2;
		}
		
		private function onGetConfig(event:Event):void
		{
			// wait until complete
			if (event.type != "complete")
				return;
			var _xml:XML = XMLUtil.getXMLById(event.target.data, "logInForm");
			_form = new FormTool(logInClip, _xml, formHandler);
			_form.returnType = URLVariables;
		}
		
		private function formHandler(event:Event):void
		{
			trace(" ^ formHandler : "+event);
			if(event.type ==  Event.COMPLETE)
				trace(" ^ onServerData :" + event.target.data.msg);
		}
		
		override public function destroy():void
		{
			trace(this , "destroy");
			super.destroy();
			
			_form.destroy();
			_form = null;
			
			removeChild(logInClip);
			logInClip = null;
		}
	}
}