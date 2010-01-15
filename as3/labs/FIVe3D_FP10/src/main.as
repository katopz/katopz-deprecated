package
{
	import com.sleepydesign.display.SDSprite;
	import com.sleepydesign.net.LoaderUtil;
	
	import flash.display.Loader;

	[SWF(width="1680",height="822",frameRate="30",backgroundColor="#000000")]
	public class main extends SDSprite
	{
		public function main()
		{
			addChild(LoaderUtil.loadAsset("bg.jpg"));
			addChild(LoaderUtil.load("CandlePage.swf") as Loader);
		}
	}
}