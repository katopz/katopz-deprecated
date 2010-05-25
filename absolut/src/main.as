package
{
	import application.ApplicationFacade;
	
	import com.sleepydesign.display.SDSprite;
	
	import application.view.components.Board;
	
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
		private var facade:ApplicationFacade;new ApplicationFacade
		
		// view
		private var _board:Board;
		
		public function Main()
		{
			facade = ApplicationFacade.getInstance();
			facade.sendNotification(ApplicationFacade.STARTUP, this);
		}
		/*	
			// init view
			_board = new Board();
			_board.initSignal.addOnce(init);
			addChild(_board);
		}
		
		private function init():void
		{
			// init controller
			
			// hook keyboard
			KeyboardController.getInstance().initContainer(stage);
			KeyboardController.keySignal.add(_board.shuffle);
			
			// hook mouse
			BoardController.getInstance().initContainer(_board);
			BoardController.mouseSignal.add(_board.onClick);
			
			// start!
			
		}
		
		override public function destroy():void
		{
			_board.destroy();
			_board = null;
			
			super.destroy();
		}
		*/
	}
}