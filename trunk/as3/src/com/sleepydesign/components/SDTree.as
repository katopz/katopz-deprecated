package com.sleepydesign.components
{
	import flash.events.MouseEvent;

	import org.osflash.signals.Signal;

	/**
	 *
	 *	@example
	 *	var xml:XML =
	 *	<foo1>
	 *		<foo1>
	 *		 	<bar1/>
	 *		</foo1>
	 *		<bar1>
	 *		 	<foo1>
	 *		 		<bar1/>
	 *		 		<bar2/>
	 *		 	</foo1>
	 *		</bar1>
	 *	</foo1>
	 *	var tree:Tree = new Tree(xml);
	 *
	 * @author katopz
	 *
	 */
	public class SDTree extends SDComponent
	{
		private var _xml:XML;
		private var _root:SDTreeNode;

		public var currentNode:SDTreeNode;

		public static var rowCount:int = 1;

		public static var nodeWidth:int;
		public static var nodeHeight:int;

		private var _needLabel:Boolean;
		private var _isRadio:Boolean;
		private var _isOpen:Boolean;

		public var nodeSignal:Signal = new Signal(SDTreeNode);

		public function SDTree(xml:XML = null, isOpen:Boolean = false, needLabel:Boolean = true, isRadio:Boolean = false, style:ISDStyle = null)
		{
			super(style);

			_xml = xml;
			_needLabel = needLabel;
			_isRadio = isRadio;
			_isOpen = isOpen;

			if (!_xml)
				return;

			nodeWidth = _style.SIZE + _style.SIZE * .5;
			nodeHeight = _style.SIZE + _style.SIZE * .5;

			_root = parseXMLNode(_xml);

			if (_root)
			{
				_root.selected = false || _isOpen;
				setNode(_root, _root.selected);
			}

			draw();

			addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
		}

		private function onClick(event:MouseEvent):void
		{
			if (event.target is SDTreeNode)
			{
				var node:SDTreeNode = event.target as SDTreeNode;
				node.selected = !node.selected;
				setFocus(node);
			}
		}

		private function parseXMLNode(xml:XML, node:SDTreeNode = null):SDTreeNode
		{
			var _x:Number = (node) ? node.x : -nodeWidth;
			var _y:Number = nodeHeight * rowCount++;

			var _name:String = String(xml.@label).length > 0 ? String(xml.@label) : String(xml.name());

			var _id:String;

			if (!_needLabel)
			{
				if (node)
				{
					_id = node.id + "." + String(xml.name());
					_id += "_" + (node.numNode++);
				}
				else
				{
					_id = String(xml.name());
				}
			}
			else
			{
				//menu need label, it's SiteMap
				if (String(xml.@label).length > 0)
				{
					_id = "$" + String(xml.@id);
				}
				else
				{
					return null;
				}
			}

			var _node:SDTreeNode = new SDTreeNode(_name);
			_node.x = nodeWidth + _x;
			_node.parentNode = node ? node : null;
			_node.id = _id;
			_node.data = xml;

			if (node && node.parentNode)
			{
				_node.path = node.path + "/" + _id;
			}
			else
			{
				_node.path = _id;
			}

			//trace(" ! Path	: " + _node.path);
			addChild(_node);

			if (xml.children().length() > 0)
			{
				var childs:Array = [];
				for each (var child:XML in xml.children())
				{
					var _nextNode:SDTreeNode = parseXMLNode(child, _node);
					if (_nextNode)
					{
						childs.push(_nextNode);
					}
				}

				if (childs.length)
				{
					_node.childs = childs.slice();
				}
			}
			return _node;
		}

		private function drawNode(node:SDTreeNode = null):void
		{
			if (node)
			{
				node.draw();
				for each (var child:SDTreeNode in node.childs)
				{
					drawNode(child);
				}
			}
		}

		private function setNode(node:SDTreeNode = null, isOpen:Boolean = true):void
		{
			if (!node)
				return;

			//trace(node.id, ":", isOpen);

			node.isOpen = isOpen;
			for each (var child:SDTreeNode in node.childs)
			{
				if (_isRadio)
				{
					// single instance
					if (!child.parentNode || !child.parentNode.selectedNode)
					{
						//root
						setNode(child, node.isOpen);
					}
					else
					{
						child.isOpen = (child.parentNode.selectedNode == child);
						setNode(child, node.isOpen && child.isOpen);
					}
				}
				else
				{
					// multiple instance
					setNode(child, isOpen && child.selected && node.selected);
				}
			}
		}

		override public function draw():void
		{
			rowCount = 1;
			drawNode(_root);
		}

		public function setFocusByPath(path:String):SDTreeNode
		{
			if (!path)
				return null;

			var _paths:Array = path.split("/");
			return setFocusById(_paths.pop());
		}

		public function setFocusById(id:String):SDTreeNode
		{
			if (currentNode && currentNode.id == id)
				return currentNode;

			var node:SDTreeNode = getNodeById(_root, id);

			if (node)
				setFocus(node);

			return node;
		}

		public function setFocus(node:SDTreeNode):SDTreeNode
		{
			if (_isRadio)
			{
				// clear old
				if (currentNode)
				{
					currentNode.close(true);
				}
				node.open();
			}
			else
			{
				// toggle
				if (node.selected)
				{
					node.open();
				}
				else
				{
					node.close();
				}
			}

			// reset

			setNode(_root);
			currentNode = node;

			// view
			draw();

			// tell someone?
			//dispatchEvent(new TreeEvent(TreeEvent.CHANGE_NODE_FOCUS, node));
			nodeSignal.dispatch(node);
			return node;
		}

		public function getPathById(id:String):String
		{
			var node:SDTreeNode = getNodeById(_root, id);
			return node ? node.path : "";
		}

		public function getNodeById(node:SDTreeNode, id:String):SDTreeNode
		{
			if (!node)
				return null;
			if (!node.childs)
				return null;
			var index:int = node.childs.length;
			var foundNode:SDTreeNode;
			while (!foundNode && --index >= 0)
			{
				if (node.childs[index].id == id)
				{
					foundNode = node.childs[index];
					//trace( " ! Found : "+foundNode.id);
					return foundNode;
				}
				else
				{
					foundNode = getNodeById(node.childs[index], id);
				}
			}
			return foundNode;
		}

		override public function destroy():void
		{
			//child
			for each (var child:SDTreeNode in _root.childs)
				child.destroy();
			
			//signal
			nodeSignal.removeAll();
			nodeSignal = null;

			// referer
			_xml = null;
			_root = null;

			currentNode = null;

			super.destroy();
		}
	}
}