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

		public function authen()
		{
			// asset
			addChild(logInClip);

			// get external config
			LoaderUtil.loadXML("authen.xml", onGetConfig);
		}

		private function onGetConfig(event:Event):void
		{
			// wait until complete
			if (event.type != "complete")
				return;
			var _xml:XML = XMLUtil.getXMLById(event.target.data, "logInForm");
			var _form:FormTool = new FormTool(logInClip, _xml, formHandler);
			_form.returnType = URLVariables;
		}
		
		private function formHandler(event:Event):void
		{
			trace(" ^ formHandler : "+event);
			if(event.type ==  Event.COMPLETE)
				trace(" ^ onServerData :" + event.target.data.msg);
		}
	}
}