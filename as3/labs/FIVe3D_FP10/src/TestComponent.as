package
{
	import com.sleepydesign.components.DialogBalloon;
	import com.sleepydesign.display.SDSprite;

	public class TestComponent extends SDSprite
	{
		public function TestComponent()
		{
			var _test:DialogBalloon = new DialogBalloon("1111111111111");
			_test.x=100;
			_test.y=100;
			addChild(_test);
			
			trace(Test.getFakeData())
		}
	}
}