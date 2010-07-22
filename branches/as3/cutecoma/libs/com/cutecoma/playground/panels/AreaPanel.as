package com.cutecoma.playground.panels
{
	import com.cutecoma.playground.events.AreaEditorEvent;
	import com.cutecoma.primitives.SDGrid;
	import com.cutecoma.primitives.SDSquare;
	import com.sleepydesign.components.SDButton;
	import com.sleepydesign.components.SDPanel;
	import com.sleepydesign.display.SDSprite;
	import com.sleepydesign.events.EventManager;
	import com.sleepydesign.net.LoaderUtil;
	import com.sleepydesign.text.SDTextField;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import org.osflash.signals.Signal;
	
	[SWF(backgroundColor="0xFFFFFF", frameRate="30", width="800", height="480")]
	public class AreaPanel extends SDSprite
	{
		private const HEX_STRING:String = "0123456789ABCDEF";
		
		private var _areaID:String;
		private var _cellWidth:int = 16;
		private var _cellHeight:int = 16;
		private var _grid:SDGrid;
		private var _tfColor:SDTextField;
		
		private var _marker:SDSquare;
		
		private var _okButton:SDButton;
		
		public var isEdit:Boolean = true;
		
		/**
		 * id	Area id as String
		 */		
		public var changeSignal:Signal = new Signal(/*id*/String);
		public var closeSignal:Signal = new Signal();
		
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
			LoaderUtil.loadXML("app.xml", onXML);
		}
		
		private function onXML(event:Event):void
		{
			if (event.type != "complete")
				return;
			
			var _xml:XML = event.target.data;
			create(_xml.world.area.text().split(","));
		}
		
		private function create(areaLists:Array):void
		{
			// panel
			var _panel:SDPanel = new SDPanel();
			addChild(_panel);
			_panel.setSize(_cellWidth * 16 + 40, _cellHeight * 16 + 40 + 10);
			_panel.align = "center";
			
			// grid
			_grid = new SDGrid(_cellWidth, _cellHeight, 16, 16, null, null, 0xCCCCCC, 0.25, 0xFFFFFF, 1);
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
			
			// cell
			for each (var _areaID:String in areaLists)
			{
				var _point:Point = new Point(int(HEX_STRING.indexOf(_areaID.charAt(0))), int(HEX_STRING.indexOf(_areaID.charAt(1))));
				var _color:Number = Number("0x00FF"+_areaID);
				var _areaCell:SDSquare = new SDSquare(_cellWidth, _cellHeight, _color, .5, 1, _color);
				_panel.addChild(_areaCell);
				_areaCell.x = _grid.x + _point.x * _cellWidth;
				_areaCell.y = _grid.y + _point.y * _cellHeight;
			}
			
			// marker
			_marker = new SDSquare(_cellWidth, _cellHeight, 0xFFFF00, .5, 1, 0xFF9900);
			_panel.addChild(_marker);
			_marker.x = _grid.x;
			_marker.y = _grid.y;
			_marker.visible = false;
			
			// text
			_tfColor = new SDTextField("Please select area...");
			_panel.addChild(_tfColor);
			_tfColor.x = 18;
			_tfColor.y = _panel.height - _tfColor.height - 6;
			
			// button
			var _cancelButton:SDButton = new SDButton("cancel");
			_panel.addChild(_cancelButton);
			_cancelButton.x = _panel.width - _cancelButton.width - 20;
			_cancelButton.y = _panel.height - _cancelButton.height - 6;
			
			_okButton = new SDButton("ok");
			_panel.addChild(_okButton);
			_okButton.x = _cancelButton.x - _okButton.width - 4;
			_okButton.y = _cancelButton.y;
			_okButton.alpha = .25;
			
			// event
			_panel.addEventListener(MouseEvent.CLICK, onGridClick);
			
			_cancelButton.addEventListener(MouseEvent.CLICK, onCancel);
		}
		
		private function onGridClick(event:MouseEvent):void
		{
			// OB
			if(_grid.mouseX > _grid.width || _grid.mouseY > _grid.height)
				return;
			
			var _point:Point = new Point(int(_grid.mouseX / _cellWidth), int(_grid.mouseY / _cellHeight));
			
			_marker.x = _grid.x + _point.x * _cellWidth;
			_marker.y = _grid.y + _point.y * _cellHeight;
			
			_areaID = HEX_STRING.charAt(_point.x) + HEX_STRING.charAt(_point.y);
			_tfColor.text = "Area : " + _areaID;
			
			_marker.visible = true;
			
			// edit mode or click avaliable area
			if(isEdit || event.target is SDSquare)
			{
				_okButton.removeEventListener(MouseEvent.CLICK, onOK);
				_okButton.addEventListener(MouseEvent.CLICK, onOK);
				_okButton.alpha = 1;
			}else{
				_okButton.removeEventListener(MouseEvent.CLICK, onOK);
				_okButton.alpha = .25;
			}
		}
		
		private function onOK(event:MouseEvent):void
		{
			visible = false;
			//EventManager.dispatchEvent(new AreaEditorEvent(AreaEditorEvent.AREA_ID_CHANGE, _areaID));
			changeSignal.dispatch(_areaID);
		}
		
		private function onCancel(event:MouseEvent):void
		{
			visible = false;
			//EventManager.dispatchEvent(new Event(Event.CLOSE));
			closeSignal.dispatch();
		}
	}
}