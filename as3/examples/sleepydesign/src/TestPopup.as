package
{
	import com.sleepydesign.display.DrawUtil;
	import com.sleepydesign.net.URLUtil;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	[SWF(backgroundColor="0xFFFFFF", frameRate="30", width="800", height="600")]
	public class TestPopup extends Sprite
	{
		public function TestPopup()
		{
			addChild(DrawUtil.drawRect(new Rectangle(0,0,100,100))).addEventListener(MouseEvent.CLICK, function():void{URLUtil.getPopup("http://google.com", "test", "width=800,height=600")});
		}
	}
}