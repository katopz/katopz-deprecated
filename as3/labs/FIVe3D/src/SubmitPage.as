package
{
	import com.greensock.TweenLite;
	import com.sleepydesign.data.DataProxy;
	import com.sleepydesign.display.SDSprite;
	import com.sleepydesign.events.FormEvent;
	import com.sleepydesign.net.LoaderUtil;
	import com.sleepydesign.site.FormTool;
	import com.sleepydesign.skins.Preloader;
	import com.sleepydesign.utils.XMLUtil;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.net.URLVariables;

	[SWF(width="1132",height="654",frameRate="30",backgroundColor="#000000")]
	public class SubmitPage extends SDSprite
	{
		[Embed(source="assets/ThaiMap.swf", symbol="FormClip")]
		private var FormClip:Class;
		public var formClip:Sprite = new FormClip() as Sprite;

		public function SubmitPage()
		{
			//test
			if(stage && parent == stage)
			{
				DataProxy.addData("$CANDLE_TIME", new Date().valueOf());
				DataProxy.addData("$CANDLE_X", 100);
				DataProxy.addData("$CANDLE_Y", 200);
			}
			
			// asset
			addChild(formClip);
			
			//loader
			if(!LoaderUtil.loaderClip)
				LoaderUtil.loaderClip = new Preloader(this, 1132, 654);

			// get external config
			LoaderUtil.loadXML("config.xml", onGetConfig);
		}

		private function onGetConfig(event:Event):void
		{
			// wait until complete
			if (event.type != "complete")
				return;
			var _xml:XML = XMLUtil.getXMLById(event.target.data, "submitForm");
			FormTool.useDebug = true;
			var _form:FormTool = new FormTool(formClip, _xml, formHandler);
			_form.returnType = URLVariables;
		}
		
		private function formHandler(event:Event):void
		{
			trace(" ^ formHandler : "+event);
			if(event.type == Event.COMPLETE)
			{
				trace(" ^ onServerData :" + event.target.data.result);
				filters = [new GlowFilter(0x0000,0,0,0,0,0)];
				TweenLite.to(this, 0.5, {autoAlpha: 0, onComplete: function():void
				{
					dispatchEvent(new Event(Event.CLOSE));
					destroy();
				}});
			} 
			else if(event.type == FormEvent.SUBMIT)
			{
				DataProxy.addData("$CANDLE_EMAIL", FormEvent(event).data.email);
				DataProxy.addData("$CANDLE_MSG", FormEvent(event).data.msg);
				
				trace("add $CANDLE_EMAIL : "+DataProxy.getDataByID("$CANDLE_EMAIL"));
				trace("add $CANDLE_MSG : "+DataProxy.getDataByID("$CANDLE_MSG"));
			}
		}
	}
}