package 
{
	import com.sleepydesign.site.view.components.Page;
	
	import flash.display.MovieClip;
	
	public class Authen extends Page
	{
		[Embed(source="../fla/simple-login.swf", symbol="FormClip")]
		private var FormClip:Class;
		private var formClip:MovieClip;
		
		public function Authen()
		{
			// asset
			formClip = addChild(new FormClip()) as MovieClip;
			
			// TODO :
			// intit config.xml
		}
	}
}