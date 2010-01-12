package
{
	import com.cutecoma.controls.FormBuilder;
	import com.cutecoma.display.CCSprite;
	import com.cutecoma.events.FormEvent;
	import com.cutecoma.net.LoaderTool;
	import com.cutecoma.utils.XMLUtil;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLVariables;

	public class Authen extends CCSprite
	{
		[Embed(source="assets/simple-login.swf", symbol="FormClip")]
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