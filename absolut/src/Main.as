package
{
	import application.ApplicationFacade;
	
	import com.sleepydesign.display.SDSprite;

	/**
	 * TODO
	 *
	 * - check for gameover condition
	 * - add real score
	 *
	 * @author katopz
	 */
	[SWF(backgroundColor="#FFFFFF", frameRate="30", width="800", height="600")]
	public class Main extends SDSprite
	{
		private var facade:ApplicationFacade;
		new ApplicationFacade

		public function Main()
		{
			facade = ApplicationFacade.getInstance();
			facade.sendNotification(ApplicationFacade.STARTUP, this);
		}

		override public function destroy():void
		{
			facade = null;
			super.destroy();
		}
	}
}