package com.cutecoma.playground.components
{
	import com.sleepydesign.components.SDButton;
	import com.sleepydesign.components.SDComponent;
	import com.sleepydesign.components.SDTextInput;
	
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;

	public class SDChatBox extends SDComponent
	{
		private var chatInputText:SDTextInput;

		public function SDChatBox()
		{
			chatInputText = new SDTextInput();
			chatInputText.width = 200;
			addChild(chatInputText);

			var chatButton:SDButton = new SDButton("Talk");
			chatButton.x = chatInputText.width;
			chatButton.addEventListener(MouseEvent.CLICK, onClick);
			addChild(chatButton);

			chatInputText.addEventListener(KeyboardEvent.KEY_DOWN, onEnter);
			super();
		}

		private function onEnter(event:KeyboardEvent):void
		{
			if (event.keyCode == 13)
				submit();
		}

		private function onClick(event:MouseEvent):void
		{
			submit();
		}

		private function submit():void
		{
			trace(" * Submit");
			dispatchEvent(new SDEvent(SDEvent.UPDATE, {msg: chatInputText.text}));
		}
	}
}
