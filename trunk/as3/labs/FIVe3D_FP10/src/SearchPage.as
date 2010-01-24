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
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLVariables;
	
	//[SWF(width="1680",height="822",frameRate="30",backgroundColor="#FFFFFF")]
	[SWF(width="1132", height="654", frameRate="30", backgroundColor="#000000")]
	public class SearchPage extends SDSprite
	{
		[Embed(source="assets/ThaiMap.swf", symbol="SearchClip")]
		private var SearchClip:Class;
		public var searchClip:Sprite = new SearchClip() as Sprite;
		
		private var _stageWidth:int;
		private var _stageHeight:int;
		
		private var _bg:Sprite; 
		
		public function SearchPage()
		{
			_bg = new Sprite();
			addChild(_bg);
			
			// asset
			addChild(searchClip);
			
			//loader
			if(!LoaderUtil.loaderClip)
				LoaderUtil.loaderClip = new Preloader(this);

			// get external config
			LoaderUtil.loadXML("config.xml", onGetConfig);
			
			addEventListener(Event.ADDED_TO_STAGE, onStage);
		}
		
		private function onStage(evnt:Event):void
		{
			_stageWidth = root.stage.stageWidth;
			_stageHeight = root.stage.stageHeight;
			
			// resize
			root.stage.scaleMode = StageScaleMode.NO_SCALE;
			root.stage.align = StageAlign.TOP_LEFT;
			root.stage.addEventListener(Event.RESIZE, onResize);
			draw();
		}

		private function onGetConfig(event:Event):void
		{
			// wait until complete
			if (event.type != "complete")
				return;
			var _xml:XML = XMLUtil.getXMLById(event.target.data, "searchForm");
			_form = new FormTool(searchClip, _xml, formHandler);
			_form.returnType = URLVariables;
			
			// cancel
			SimpleButton(searchClip["closeButton"]).addEventListener(MouseEvent.CLICK, function():void
			{
				Search.isGetResult = false;
				
				searchClip.filters = null;
				searchClip.mouseEnabled = true;
				
				dispatchEvent(new Event(Event.CLOSE));
				root.stage.removeEventListener(Event.RESIZE, onResize);
				destroy();
			});
		}
		
		private function draw():void
		{
			//trace(" ! draw2 : " + root.stage.stageWidth, root.stage.stageHeight);
			//pos
			var _x0:int = int((_stageWidth-root.stage.stageWidth)/2);
			var _y0:int = int((_stageHeight-root.stage.stageHeight)/2);
			
			//x = _x0+root.stage.stageWidth/2-1057/2+50;
			//y = _y0+root.stage.stageHeight/2-356/2;
			searchClip.x = _x0+root.stage.stageWidth/2-595/2+45;
			searchClip.y = _y0+root.stage.stageHeight/2-344/2;
			
			_bg.x = _x0;
			_bg.y = _y0;
			
			_bg.graphics.clear();
			_bg.graphics.beginFill(0x000000, 0.75);
			_bg.graphics.drawRect(-root.stage.stageWidth/2, -root.stage.stageHeight/2, root.stage.stageWidth+root.stage.stageWidth/2, root.stage.stageHeight+root.stage.stageHeight/2);
			_bg.graphics.endFill();
		}
		
		private function onResize(event:Event):void
		{
			draw();
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