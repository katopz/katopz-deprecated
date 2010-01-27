package
{
	import com.greensock.TweenLite;
	import com.sleepydesign.data.DataProxy;
	import com.sleepydesign.display.DrawUtil;
	import com.sleepydesign.display.SDSprite;
	import com.sleepydesign.events.FormEvent;
	import com.sleepydesign.managers.EventManager;
	import com.sleepydesign.net.LoaderUtil;
	import com.sleepydesign.site.FormTool;
	import com.sleepydesign.skins.Preloader;
	import com.sleepydesign.text.SDTextField;
	import com.sleepydesign.utils.XMLUtil;
	
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLVariables;

	//[SWF(width="1680",height="822",frameRate="30",backgroundColor="#FFFFFF")]
	[SWF(width="1132", height="654", frameRate="30", backgroundColor="#000000")]
	public class SubmitPage extends SDSprite
	{
		//1000*600
		[Embed(source="assets/ThaiMap.swf", symbol="FormClip")]
		private var FormClip:Class;
		public var formClip:Sprite = new FormClip() as Sprite;
		
		private var _stageWidth:int;
		private var _stageHeight:int;
		
		private var _bg:Sprite; 
		
		public static var data:Object; 

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
			
			_bg = new Sprite();
			addChild(_bg);
			
			EventManager.addEventListener(FormEvent.EXTERNAL_SUBMIT, formHandler);
			
			// asset
			addChild(formClip);
			
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
			var _xml:XML = XMLUtil.getXMLById(event.target.data, "submitForm");
			_form = new FormTool(formClip, _xml, formHandler);
			_form.returnType = URLVariables;
			draw();
			
			formClip["closeButton"].addEventListener(MouseEvent.CLICK, onClose);
			
			var ok:* = _xml.vars
			_msgs = String(_xml.vars.text()).split(",");
			_comboButton = formClip["comboButton"];
			_comboButton.addEventListener(MouseEvent.CLICK, onCombo);
		}
		
		private var _msgs:Array;
		private var _comboBox:Sprite;
		private var _comboButton:SimpleButton;
		
		private function onCombo(event:MouseEvent):void
		{
			if(!_comboBox)
			{
				_comboBox = DrawUtil.drawRect(400-2, 20*_msgs.length, 0x000000, .75, 0xCE9F12);
				_comboBox.alpha = 0;
				_comboBox.visible = false;
				for(var i:int=0;i<_msgs.length;i++)
				{
					//bg
					var _comboItem:Sprite = DrawUtil.drawRect(400, 20, 0x111111,.75);
					_comboItem.tabIndex = i;
					_comboItem.y = i*20+1;
					_comboBox.addChild(_comboItem);
					
					//text
					var _label:SDTextField = new SDTextField(_msgs[i]);
					_label.autoSize = "left";
					_label.textColor = 0xFFFFFF;
					_label.y = i*20+1;
					_comboBox.addChild(_label);
					
					_comboItem.buttonMode = true;
					
					_comboItem.addEventListener(MouseEvent.CLICK, function(event:MouseEvent):void{
						formClip["msgInput"].text = _msgs[Sprite(event.target).tabIndex];
						TweenLite.to(_comboBox, .25, {autoAlpha:0});
					});
				}
				
				addChild(_comboBox);
				
				_comboBox.addEventListener(MouseEvent.ROLL_OUT, function(event:MouseEvent):void{
					TweenLite.to(_comboBox, .25, {autoAlpha:0});
				});
			}
			
			if(_comboBox.alpha<1)
				TweenLite.to(_comboBox, .25, {autoAlpha:1});
			else
				TweenLite.to(_comboBox, .25, {autoAlpha:0});
			
			_comboBox.x = formClip.x+_comboButton.x;
			_comboBox.y = formClip.y+_comboButton.y+_comboButton.height+20+2;
		}
		
		private function onClose(event:MouseEvent):void
		{
			root.stage.removeEventListener(Event.RESIZE, onResize);
			data = _form.data;
			_form.destroy();
			destroy();
			dispatchEvent(new Event(Event.CANCEL));
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
				
				data = FormEvent(event).data;
				
				TweenLite.to(this, 0.5, {autoAlpha: 0, onComplete: function():void
				{
					dispatchEvent(new Event(FormEvent.DATA_CHANGE));
				}});
			}
			else if(event.type == FormEvent.EXTERNAL_SUBMIT)
			{
				_form.isSubmit = true;
				_form.submit(data);
			}
			else if(event.type == Event.COMPLETE)
			{
				dispatchEvent(new Event(Event.CLOSE));
				if(root.stage)
					root.stage.removeEventListener(Event.RESIZE, onResize);
				_form.destroy();
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
		}
		
		private function draw():void
		{
			//trace(" ! draw2 : " + root.stage.stageWidth, root.stage.stageHeight);
			//pos
			var _x0:int = int((_stageWidth-root.stage.stageWidth)/2);
			var _y0:int = int((_stageHeight-root.stage.stageHeight)/2);
			
			//x = _x0+root.stage.stageWidth/2-1057/2+50;
			//y = _y0+root.stage.stageHeight/2-356/2;
			formClip.x = _x0+root.stage.stageWidth/2-1057/2+45;
			formClip.y = _y0+root.stage.stageHeight/2-356/2;
			
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
	}
}