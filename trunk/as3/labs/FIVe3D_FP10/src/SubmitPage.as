package
{
	import com.greensock.TweenLite;
	import com.sleepydesign.data.DataProxy;
	import com.sleepydesign.display.SDSprite;
	import com.sleepydesign.events.FormEvent;
	import com.sleepydesign.managers.EventManager;
	import com.sleepydesign.net.LoaderUtil;
	import com.sleepydesign.site.FormTool;
	import com.sleepydesign.skins.Preloader;
	import com.sleepydesign.utils.XMLUtil;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLVariables;

	[SWF(width="1680",height="822",frameRate="30",backgroundColor="#000000")]
	public class SubmitPage extends SDSprite
	{
		[Embed(source="assets/ThaiMap.swf", symbol="FormClip")]
		private var FormClip:Class;
		public var formClip:Sprite = new FormClip() as Sprite;
		
		private var _stageWidth:int;
		private var _stageHeight:int;

		public function SubmitPage()
		{
			/*
			//test
			if(stage && parent == stage)
			{
				DataProxy.addData("$CANDLE_TIME", new Date().valueOf());
				DataProxy.addData("$CANDLE_X", 100);
				DataProxy.addData("$CANDLE_Y", 200);
			}
			*/
			
			EventManager.addEventListener(FormEvent.EXTERNAL_SUBMIT, formHandler);
			
			// asset
			addChild(formClip);
			
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
			var _xml:XML = XMLUtil.getXMLById(event.target.data, "submitForm");
			FormTool.useDebug = true;
			_form = new FormTool(formClip, _xml, formHandler);
			_form.returnType = URLVariables;
		}
		
		private var _form:FormTool;
		
		private function formHandler(event:Event):void
		{
			trace(" ^ formHandler : "+event);
			
			if(event.type == FormEvent.COMPLETE)
			{
				_form.removeEventListener(FormEvent.COMPLETE, formHandler);
				
				DataProxy.addData("$CANDLE_EMAIL", FormEvent(event).data.email);
				DataProxy.addData("$CANDLE_MSG", FormEvent(event).data.msg);
				
				TweenLite.to(this, 0.5, {autoAlpha: 0, onComplete: function():void
				{
					dispatchEvent(new Event(FormEvent.DATA_CHANGE));
				}});
			}
			else if(event.type == FormEvent.EXTERNAL_SUBMIT)
			{
				_form.isSubmit = true;
				_form.submit();
			}
			else if(event.type == Event.COMPLETE)
			{
				dispatchEvent(new Event(Event.CLOSE));
				destroy();
			}
			
			/*
			if(event.type == Event.COMPLETE)
			{
				//trace(" ^ onServerData :" + event.target.data.result);
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
				formClip.filters = [new BlurFilter(4,4,1)];
				formClip.mouseEnabled = false;
			}
			*/
			
			_stageWidth = 1680;//stage.stageWidth;
			_stageHeight = 822;//stage.stageHeight;
			
			// resize
			stage.addEventListener(Event.RESIZE, onResize);
			draw();
		}
		
		private function draw():void
		{
			trace(" ! draw2 : " + stage.stageWidth, stage.stageHeight);
			//pos
			var _x0:int = int((_stageWidth-stage.stageWidth)/2);
			var _y0:int = int((_stageHeight-stage.stageHeight)/2);
			
			//x = -stage.stageWidth/2;
			y = _y0;
		}
		
		private function onResize(event:Event):void
		{
			draw();
		}
	}
}