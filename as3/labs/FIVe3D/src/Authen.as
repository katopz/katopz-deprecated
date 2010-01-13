package
{
	import com.sleepydesign.controls.FormBuilder;
	import com.sleepydesign.display.SDSprite;
	import com.sleepydesign.events.FormEvent;
	import com.sleepydesign.net.LoaderTool;
	import com.sleepydesign.utils.XMLUtil;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLVariables;

	public class Authen extends SDSprite
	{
		//[Embed(source="assets/simple-login.swf", symbol="FormClip")]
		private var FormClip:Class;
		public var logInClip:Sprite = new FormClip() as Sprite;

		public function Authen()
		{
			// asset
			addChild(logInClip);

			// get external config
			LoaderTool.loadXML("config.xml", onGetConfig);
		}

		private function onGetConfig(event:Event):void
		{
			// wait until complete
			if (event.type != "complete")
				return;
			var _xml:XML = XMLUtil.getXMLById(event.target.data, "logInForm");
			var _form:FormBuilder = new FormBuilder(logInClip, _xml, formHandler);
			_form.returnType = URLVariables;
		}
		
		private function formHandler(event:FormEvent):void
		{
			trace(" ^ formHandler : "+event);
			if(event.type == FormEvent.GET_SERVER_DATA)
				trace(" ^ onServerData :" + event.data.result)
		}
	}
}