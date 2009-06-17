package com.sleepydesign.components
{
    import com.sleepydesign.events.SDEvent;
    import com.sleepydesign.events.SDMouseEvent;
    import com.sleepydesign.net.Red5Connector;
    
    import flash.display.DisplayObjectContainer;
    import flash.events.KeyboardEvent;
	
	public class SDChatBox extends SDComponent
	{
		private var connector		:Red5Connector;
		private var chatInputText	:SDInputText
		
		public function SDChatBox()
		{
			chatInputText = new SDInputText();
			chatInputText.width = 200;
			addChild(chatInputText);
			
			var chatButton:SDButton = new SDButton("Talk");
			chatButton.x = chatInputText.width;
			chatButton.addEventListener(SDMouseEvent.CLICK, onClick);
			addChild(chatButton);
			
			chatInputText.addEventListener(KeyboardEvent.KEY_DOWN, onEnter);
			super();
		}
		
		private function onEnter(event:KeyboardEvent):void
		{
			if(event.keyCode==13)
				submit();
		}
		
		private function onClick(event:SDMouseEvent):void
		{
			submit();
		}
		
		private function submit():void
		{
			trace( " * Submit");
			dispatchEvent(new SDEvent(SDEvent.UPDATE, {msg:chatInputText.text}));
		}
	}
}
