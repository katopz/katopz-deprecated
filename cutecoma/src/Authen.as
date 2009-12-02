package 
{
	import com.sleepydesign.site.view.components.Page;
	
	import flash.display.MovieClip;
	
	public class Authen extends Page
	{
		[Embed(source="../fla/simple-login.swf", symbol="FormClip")]
		private var FormClip:Class;
		public var logInClip:MovieClip;
		
		public function Authen()
		{
			// asset
			logInClip = addChild(new FormClip()) as MovieClip;
			
			super("Authen");
			
			alpha = .1
			// TODO :
			// intit config.xml
		}
	}
}