package
{
	import application.ApplicationFacade;
	import application.model.DataProxy;

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

		public function Main()
		{
			// init
			facade = ApplicationFacade.getInstance();
			facade.sendNotification(ApplicationFacade.STARTUP, this);

			// auto start
			facade.sendNotification(ApplicationFacade.START_GAME, this);
			var data:DataProxy = facade.retrieveProxy(DataProxy.NAME) as DataProxy;
			data.resetGame();
			data.inGame = true;
		}

		override public function destroy():void
		{
			facade = null;
			super.destroy();
		}
	}
}