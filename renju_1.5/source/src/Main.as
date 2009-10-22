package 
{
	import application.ApplicationFacade;
	
	import flash.display.Sprite;
	
	[SWF(backgroundColor="0xCCCCCC",frameRate="30",width="800",height="600")]
	public class Main extends Sprite
	{
		private var facade:ApplicationFacade;
		
		public function Main()
		{
			facade = ApplicationFacade.getInstance();
			facade.sendNotification(ApplicationFacade.STARTUP, this);
		}
	}
}
