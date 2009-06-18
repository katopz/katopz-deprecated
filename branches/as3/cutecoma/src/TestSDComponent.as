package 
{
	 import com.sleepydesign.components.SDBalloon;
	 import com.sleepydesign.components.SDButton;
	 import com.sleepydesign.components.SDInputText;
	 import com.sleepydesign.components.SDScrollPane;
	 import com.sleepydesign.core.SDSprite;
	 import com.sleepydesign.draw.SDSquare;
	 
	 import flash.display.Sprite;
	 import flash.display.StageScaleMode;
	 
	[SWF(backgroundColor="0xCCCCCC", frameRate="30", width="400", height="300")]
	public class TestSDComponent extends Sprite
	{
		public function TestSDComponent()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			 
			// create SDScrollPane
			var container:SDScrollPane= new SDScrollPane();
			addChild(container);
			container.setSize(100, 200);
			//container.panel.scrollRect = new Rectangle(0,0,100,150);
			 
			// create content
			var content:SDSprite = new SDSprite();
			 
			 // SDSquare
			var _SDSquare:SDSquare = new SDSquare(100, 100, 0xFF0000);
			content.addChild(_SDSquare);
			 
			// SDInputText
			var _SDInputText:SDInputText = new SDInputText("<b>t</b>estttttttttttttttttttttttttttttttttty");
			_SDInputText.label.autoSize = "left";
			_SDInputText.y = 10;
			content.addChild(_SDInputText);
			 
			// SDButton
			var _SDButton:SDButton = new SDButton("test");
			_SDButton.x = 80;
			_SDButton.y = 30;
			content.addChild(_SDButton);
			 
			 // SDButton
			var _SDBalloon:SDBalloon = new SDBalloon("SDBalloon test");
			_SDBalloon.x = 100;
			_SDBalloon.y = 100;
			addChild(_SDBalloon);
			 
			 // link
			 container.addContent(content);
		}
	 }
}