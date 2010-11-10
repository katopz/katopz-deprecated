package com.sleepydesign.components
{
	import com.sleepydesign.display.SDSprite;
	import com.sleepydesign.text.SDTextField;

	import flash.display.LineScaleMode;

	public class SDTreeNode extends SDComponent
	{
		public var id:String;

		protected var _back:SDSprite;
		protected var _button:SDSprite;
		protected var _label:SDTextField;
		protected var _labelText:String = "";
		protected var _selected:Boolean = false;
		private var _selectedNode:SDTreeNode;

		public var childs:Array;
		public var parentNode:SDTreeNode;
		public var isOpen:Boolean = true;

		public var path:String;

		public var numNode:uint = 0;

		public var data:XML;

		public function SDTreeNode(label:String = "", style:ISDStyle = null)
		{
			super(style);

			_labelText = label;

			buttonMode = true;
			useHandCursor = true;

			_back = new SDSprite();
			addChild(_back);

			_button = new SDSprite();
			_button.visible = false;
			addChild(_button);

			_label = new SDTextField(_labelText);
			_label.autoSize = "left";
			addChild(_label);

			draw();
		}

		override public function draw():void
		{
			var _size:int = 6;

			if (childs)
			{
				// folder
				_back.graphics.clear();
				_back.graphics.lineStyle(0.25, 0x000000, 1, true, LineScaleMode.NONE);
				_back.graphics.moveTo(0, _size / 2);
				_back.graphics.lineTo(_size, _size / 2);
				_back.graphics.moveTo(_size / 2, 0);
				_back.graphics.lineTo(_size / 2, _size);
				_back.graphics.endFill();

				/*
				   _button.graphics.clear();
				   _button.graphics.beginFill(_style.BUTTON_COLOR);
				   _button.graphics.drawRect(2, 2, _width - 4, _height - 4);
				   _button.graphics.endFill();
				 */
			}
			else
			{
				// file
				_back.graphics.clear();
				_back.graphics.lineStyle(0.25, 0x000000, 1, true, LineScaleMode.NONE);
				_back.graphics.moveTo(0, _size / 2);
				_back.graphics.lineTo(_size, _size / 2);
				//_back.graphics.moveTo(8/2, 0);
				//_back.graphics.lineTo(8/2, 8);
				_back.graphics.endFill();

				/*
				   _button.graphics.clear();
				   _button.graphics.beginFill(_style.BUTTON_COLOR);
				   _button.graphics.drawRect(2, 2, _width - 4, _height - 4);
				   _button.graphics.endFill();
				 */
			}

			_label.x = _width + 2;
			_label.y = -_label.height * .25;
			_label.text = _labelText;

			if (parentNode)
			{
				if (parentNode.isOpen && parentNode.selected)
				{
					y = SDTree.nodeHeight * SDTree.rowCount++;
					visible = true
				}
				else
				{
					y = parentNode.y;
					visible = false
				}
			}
		}

		public function open():void
		{
			isOpen = true;
			selected = true;

			if (parentNode)
			{
				parentNode.open();
				parentNode.selectedNode = this;
			}
		}

		public function close(isClear:Boolean = false):void
		{
			isOpen = false;
			selected = false;

			if (parentNode && isClear)
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

			if (parentNode)
			{
				if (_selected)
				{
					parentNode.selectedNode = this;
				}
				else
				{
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

		override public function destroy():void
		{
			// referer
			_back = null;
			_button = null;
			_label = null;
			_selectedNode = null;

			childs = null;
			parentNode = null;

			data = null;

			super.destroy();
		}
	}
}