package 
{
	import com.sleepydesign.site.view.components.Page;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	public class Authen extends Page
	{
		[Embed(source="../fla/simple-login.swf", symbol="FormClip")]
		private var FormClip:Class;
		public var logInClip:Sprite;
		
		public function Authen()
		{
			// asset
			logInClip = new FormClip() as Sprite;
			addChild(logInClip);
			
			//trace("logInClip" + logInClip);
			
			super("Authen");
			
			// TODO :
			// intit config.xml
		}
	}
}