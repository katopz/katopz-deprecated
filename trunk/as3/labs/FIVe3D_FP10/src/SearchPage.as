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
	
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.net.URLVariables;

	[SWF(width="1680",height="822",frameRate="30",backgroundColor="#000000")]
	public class SearchPage extends SDSprite
	{
		[Embed(source="assets/ThaiMap.swf", symbol="SearchClip")]
		private var SearchClip:Class;
		public var searchClip:Sprite = new SearchClip() as Sprite;

		public function SearchPage()
		{
			// asset
			addChild(searchClip);
			
			//loader
			if(!LoaderUtil.loaderClip)
				LoaderUtil.loaderClip = new Preloader(this, 1680, 822);

			// get external config
			LoaderUtil.loadXML("config.xml", onGetConfig);
		}

		private function onGetConfig(event:Event):void
		{
			// wait until complete
			if (event.type != "complete")
				return;
			var _xml:XML = XMLUtil.getXMLById(event.target.data, "searchForm");
			FormTool.useDebug = true;
			_form = new FormTool(searchClip, _xml, formHandler);
			_form.returnType = URLVariables;
			
			// cancel
			SimpleButton(searchClip["closeButton"]).addEventListener(MouseEvent.CLICK, function():void
			{
				Search.isGetResult = false;
				
				searchClip.filters = null;
				searchClip.mouseEnabled = true;
				
				dispatchEvent(new Event(Event.CLOSE));
				destroy();
			});
		}
		
		private var _form:FormTool;
		
		private function formHandler(event:Event):void
		{
			Search.isGetResult = false;
			
			//trace(" ^ formHandler : "+event);
			if(event.type == Event.COMPLETE)
			{
				//trace(" ^ onServerData :" + event.target.data.result);
				var _data:* = event.target.data;
				if(event.target.data.result=="ok")
				{
					Search.isGetResult = true;
					
					// get data
					DataProxy.addData("$SEARCH_MSG", _data.msg);
					DataProxy.addData("$SEARCH_EMAIL", _data.email);
					
					DataProxy.addData("$SEARCH_X", _data.x);
					DataProxy.addData("$SEARCH_Y", _data.y);
					
					//close
					TweenLite.to(this, 0.5, {autoAlpha: 0, onComplete: function():void
					{
						dispatchEvent(new Event(Event.CLOSE));
						destroy();
					}});
				}else{
					_form.alert(_data.result);
					searchClip.filters = null;
					searchClip.mouseEnabled = true;
				}
			} 
			else if(event.type == FormEvent.SUBMIT)
			{
				searchClip.filters = [new BlurFilter(4,4,1)];
				searchClip.mouseEnabled = false;
			}
		}
	}
}