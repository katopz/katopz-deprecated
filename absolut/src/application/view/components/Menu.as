package application.view.components
{
	import com.sleepydesign.components.SDButton;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class Menu extends MovieClip
	{
		public static const START:String = "start";
		public static const RULES:String = "rules";
		public static const HINT:String = "hint";

		private var labelsArray:Array = ["new", "rules", "hint"];

		public function Menu()
		{
			drawMenu();
		}

		private function drawMenu():void
		{
			for (var i:Number = 0; i < labelsArray.length; i++)
			{
				var menuItem:SDButton = new SDButton(labelsArray[i]);
				menuItem.name = labelsArray[i];
				menuItem.x = 400;
				menuItem.y = i * 20;
				addChild(menuItem);
			}

			addEventListener(MouseEvent.CLICK, onClick);
		}

		private function onClick(event:MouseEvent):void
		{
			switch (event.target.name)
			{
				case "new":
					dispatchEvent(new Event(Menu.START));
					break;

				case "rules":
					dispatchEvent(new Event(Menu.RULES));
					break;
				
				case "hint":
					dispatchEvent(new Event(Menu.HINT));
					break;
			}
		}
	}
}