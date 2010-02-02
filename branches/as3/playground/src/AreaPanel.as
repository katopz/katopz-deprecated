package
{
	import com.cutecoma.playground.events.AreaBuilderEvent;
	import com.sleepydesign.components.SDButton;
	import com.sleepydesign.components.SDPanel;
	import com.sleepydesign.draw.SDGrid;
	import com.sleepydesign.styles.SDStyle;
	import com.sleepydesign.text.SDTextField;
	import com.sleepydesign.utils.LoaderUtil;
	import com.sleepydesign.utils.StringUtil;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	[SWF(backgroundColor="0xFFFFFF", frameRate="30", width="800", height="480")]
	public class AreaPanel extends Sprite
	{
		private var _areaID:String;
		private var _cellWidth:int = 16;
		private var _cellHeight:int = 16;
		private var _grid:SDGrid;
		private var _tfColor:SDTextField;
		
		private const HEX_STRING:String = "0123456789ABCDEF";
		
		public function AreaPanel()
		{
			addEventListener(Event.ADDED_TO_STAGE, onStage);
		}

		private function onStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onStage);
			init();
		}

		private function init():void
		{
			LoaderUtil.loadXML("config.xml", onXML);
		}
		
		private function onXML(event:Event):void
		{
			if(event.type!="complete")
				return;
			
			var _xml:XML = event.target.data;
			create(_xml.world.area.text().split(","));
		}
		
		private function create(areaLists:Array):void
		{
			SDStyle.BACKGROUND_ALPHA = .5;

			var _panel:SDPanel = new SDPanel();
			addChild(_panel);
			_panel.setSize(_cellWidth * 16 + 40, _cellHeight * 16 + 40 + 10);
			_panel.align = "center";

			// grid
			_grid = new SDGrid(_cellWidth, _cellHeight, 16, 16, null, null, 0xCCCCCC, 0.25, 0xEEEEEE, 1);
			_panel.addChild(_grid);
			_grid.x = 20;
			_grid.y = 20;

			for (var i:int = 0; i < _cellWidth; i++)
			{
				var _tfH:SDTextField = new SDTextField(HEX_STRING.charAt(i));
				_panel.addChild(_tfH);
				_tfH.x = 4 + _grid.x + i * 16;
				_tfH.y = 1;

				var _tfV:SDTextField = new SDTextField(HEX_STRING.charAt(i));
				_panel.addChild(_tfV);
				_tfV.x = 5;
				_tfV.y = -1 + _grid.y + i * 16;
			}

			// text
			_tfColor = new SDTextField("Color : 0");
			_panel.addChild(_tfColor);
			_tfColor.x = 18;
			_tfColor.y = _panel.height - _tfColor.height - 6;

			// button
			var _cancelButton:SDButton = new SDButton("cancel");
			_panel.addChild(_cancelButton);
			_cancelButton.x = _panel.width - _cancelButton.width - 20;
			_cancelButton.y = _panel.height - _cancelButton.height - 6;

			var _okButton:SDButton = new SDButton("ok");
			_panel.addChild(_okButton);
			_okButton.x = _cancelButton.x - _okButton.width - 4;
			_okButton.y = _cancelButton.y;
			
			// event
			_panel.addEventListener(MouseEvent.CLICK, onGridClick);
			
			_okButton.addEventListener(MouseEvent.CLICK, onOK);
			_cancelButton.addEventListener(MouseEvent.CLICK, onCancel);
		}
		
		private function onGridClick(event:MouseEvent):void
		{
			_areaID = HEX_STRING.charAt(int(_grid.mouseX/(_cellWidth*1))) + HEX_STRING.charAt(int(_grid.mouseY/(_cellHeight*1)));
			_tfColor.text = _areaID;
		}
		
		private function onOK(event:MouseEvent):void
		{
			visible = false;
			dispatchEvent(new AreaBuilderEvent(AreaBuilderEvent.AREA_ID_CHANGE, _areaID));
		}
		
		private function onCancel(event:MouseEvent):void
		{
			visible = false;
			dispatchEvent(new Event(Event.CLOSE));
		}
	}
}