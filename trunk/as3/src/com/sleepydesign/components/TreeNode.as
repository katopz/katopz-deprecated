package com.sleepydesign.components
{
	import com.sleepydesign.display.SDSprite;
	import com.sleepydesign.text.SDTextField;
	
	import flash.events.MouseEvent;
	
	public class TreeNode extends AbstractComponent
	{
		public var id:String;
		
		protected var _back:SDSprite;
		protected var _button:SDSprite;
		protected var _label:SDTextField;
		protected var _labelText:String = "";
		protected var _selected:Boolean = false;
		private var _selectedNode:TreeNode;
		
		public var childs:Array;
		public var parentNode:TreeNode;
		public var isOpen:Boolean = true;
		
		public var path:String;
		
		public var numNode:uint = 0;
		
		public var data:XML;
		
		public function TreeNode(label:String = "")
		{
			_labelText = label;
			
			buttonMode = true;
			useHandCursor = true;

			_back = new SDSprite();
			addChild(_back);
			
			_button = new SDSprite();
			_button.visible = false;
			addChild(_button);
			
			_label = new SDTextField();
			addChild(_label);
			
			draw();
		}
		
		override public function draw():void
		{
			if (childs)
			{
				// folder
				_back.graphics.clear();
				_back.graphics.beginFill(DefaultSkin.BACKGROUND);
				_back.graphics.drawRect(0, 0, _width, _height);
				_back.graphics.endFill();
				
				_button.graphics.clear();
				_button.graphics.beginFill(DefaultSkin.BUTTON_COLOR);
				_button.graphics.drawRect(2, 2, _width - 4, _height - 4);
				_button.graphics.endFill();
				
			}else {
				// file
				_back.graphics.clear();
				_back.graphics.beginFill(DefaultSkin.BACKGROUND);
				_back.graphics.drawCircle(_width*.5, _width*.5, _width*.5);
				_back.graphics.endFill();
				
				_button.graphics.clear();
				_button.graphics.beginFill(DefaultSkin.BUTTON_COLOR);
				_button.graphics.drawCircle(_width * .5, _width * .5, _width * .3);
				_button.graphics.endFill();
			}
				
			_label.x = _width + 2;
			_label.y = - _label.height*.25;
			_label.text = _labelText;
			
			if (parentNode) 
			{
				if (parentNode.isOpen&&parentNode.selected) 
				{
					y = Tree.nodeHeight * Tree.rowCount++;
					visible = true
				}else {
					y = parentNode.y;
					visible = false
				}
			}
			super.draw();
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
		
		public function set selectedNode(node:TreeNode):void
		{
			_selectedNode = node;
		}
		
		public function get selectedNode():TreeNode
		{
			return _selectedNode;
		}
	}
}