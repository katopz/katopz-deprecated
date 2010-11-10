package
{
	import com.sleepydesign.net.FileUtil;
	import com.sleepydesign.system.SystemUtil;

	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;

	[SWF(backgroundColor="0xCCCCCC", frameRate="30", width="400", height="300")]
	public class TestSystemUtil extends Sprite
	{
		public function TestSystemUtil()
		{
			// browse
			SystemUtil.addContext(this, "Browse Image", function():void
				{
					FileUtil.openImage(function(event:Event):void
						{
							trace("openImage:" + event);
							if (event.type == Event.COMPLETE)
								addChild(event.target["content"] as Bitmap);
						});
				});
		}
	}
}