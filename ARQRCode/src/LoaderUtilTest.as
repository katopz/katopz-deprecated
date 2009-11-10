package
{
	import com.sleepydesign.utils.FileUtil;
	
	import flash.display.Sprite;
	
	public class LoaderUtilTest extends Sprite
	{
		public function LoaderUtilTest()
		{
			FileUtil.openImageTo(this);
		}
	}
}