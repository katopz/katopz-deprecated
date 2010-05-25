package
{
	import com.sleepydesign.display.SDSprite;

	import controller.KeyboardController;
	import controller.BoardController;

	import view.Board;

	/**
	 * TODO
	 *
	 * - check for gameover condition
	 * - add real score
	 *
	 * @author katopz
	 */
	[SWF(backgroundColor="#FFFFFF", frameRate="30", width="800", height="600")]
	public class main extends SDSprite
	{
		// view
		private var _board:Board;

		public function main()
		{
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
	}
}