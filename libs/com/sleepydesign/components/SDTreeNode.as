package com.sleepydesign.components
{
	import com.sleepydesign.core.SDSprite;
	import com.sleepydesign.draw.SDSquare;
	import com.sleepydesign.events.SDEvent;
	import com.sleepydesign.events.SDMouseEvent;
	import com.sleepydesign.styles.SDStyle;
	
	import flash.events.MouseEvent;
	
	public class SDTreeNode extends SDComponent
	{
		protected var _back:SDSprite;
		protected var _button:SDSprite;
		protected var _label:SDLabel;
		protected var _labelText:String = "";
		protected var _selected:Boolean = false;
		private var _selectedNode:SDTreeNode;
		
		public var childs:Array;
		public var parentNode:SDTreeNode;
		public var isOpen:Boolean = true;
		
		public var path:String;
		
		public var numNode:uint = 0;
		private var closeFolder:SDSquare = new SDSquare(SDStyle.SIZE, SDStyle.SIZE, SDStyle.BACKGROUND);
		
		public var data:XML;
		
		public function SDTreeNode(label:String = "")
		{
			_labelText = label;
			super();
		}
		
		override public function init(raw:Object=null):void
		{
			super.init(raw);
			buttonMode = true;
			useHandCursor = true;
			setSize(SDStyle.SIZE, SDStyle.SIZE);
		}
		
		override public function create(config:Object=null):void
		{
			_back = new SDSprite();
			addChild(_back);
			
			_button = new SDSprite();
			_button.visible = false;
			addChild(_button);
			
			_label = new SDLabel();
			addChild(_label);
			addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
		}
		
		override public function draw():void
		{
			if (childs)
			{
				// folder
				_back.graphics.clear();
				_back.graphics.beginFill(SDStyle.BACKGROUND);
				_back.graphics.drawRect(0, 0, _width, _height);
				_back.graphics.endFill();
				
				_button.graphics.clear();
				_button.graphics.beginFill(SDStyle.BUTTON_COLOR);
				_button.graphics.drawRect(2, 2, _width - 4, _height - 4);
				_button.graphics.endFill();
				
			}else {
				// file
				_back.graphics.clear();
				_back.graphics.beginFill(SDStyle.BACKGROUND);
				_back.graphics.drawCircle(_width*.5, _width*.5, _width*.5);
				_back.graphics.endFill();
				
				_button.graphics.clear();
				_button.graphics.beginFill(SDStyle.BUTTON_COLOR);
				_button.graphics.drawCircle(_width * .5, _width * .5, _width * .3);
				_button.graphics.endFill();
			}
				
			_label.x = _width + 2;
			_label.y = - _label.height*.5;
			_label.text = _labelText;
			
			if (parentNode) 
			{
				if (parentNode.isOpen&&parentNode.selected) 
				{
					y = SDTree.nodeHeight * SDTree.rowCount++;
					visible = true
				}else {
					y = parentNode.y;
					visible = false
				}
			}
			super.draw();
		}
		
		private function onClick(event:MouseEvent):void
		{
			selected = !selected;
			dispatchEvent(new SDEvent(SDMouseEvent.CLICK));
		}
		
		public function open():void
		{
			isOpen = true;
			selected = true;
			
			if(parentNode)
			{
				parentNode.open();
				parentNode.selectedNode = this;
			}
		}
		
		public function close(isClear:Boolean=false):void
		{
			isOpen = false;
			selected = false;
			
			if(parentNode && isClear)
			{
				parentNode.close(isClear);
				parentNode.selectedNode = null;
			}
		}
		
		public function set label(str:String):void
		{
			_labelText = str;
			draw();
		}
		
		public function get label():String
		{
			return _labelText;
		}
		
		public function set selected(s:Boolean):void
		{
			_selected = s;
			_button.visible = _selected;
			
			if(parentNode)
			{
				if(_selected)
				{
					parentNode.selectedNode = this;
				}else{
					parentNode.selectedNode = null;
				}
			}
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}
		
		public function set selectedNode(node:SDTreeNode):void
		{
			_selectedNode = node;
		}
		
		public function get selectedNode():SDTreeNode
		{
			return _selectedNode;
		}
	}
}