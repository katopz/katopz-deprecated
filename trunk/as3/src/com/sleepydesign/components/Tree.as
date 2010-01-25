package com.sleepydesign.components
{
	import com.sleepydesign.events.TreeEvent;
	import com.sleepydesign.text.SDTextField;
	
	import flash.events.MouseEvent;

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
	public class Tree extends AbstractComponent
	{
		private var _xml:XML;
		private var _tf:SDTextField;
		private var _root:TreeNode;
		
		public var currentNode:TreeNode;
		
		public static var rowCount:int = 1;
		
		public static var nodeWidth:int = DefaultSkin.SIZE+DefaultSkin.SIZE*.5;
		public static var nodeHeight:int = DefaultSkin.SIZE+DefaultSkin.SIZE*.5;
		
		private var _needLabel:Boolean;
		private var _isRadio:Boolean;
		private var _isOpen:Boolean;
		
		public function Tree(xml:XML = null, isOpen:Boolean = false, needLabel:Boolean = true, isRadio:Boolean = false)
		{
			_xml = xml;
			_needLabel = needLabel;
			_isRadio = isRadio;
			_isOpen = isOpen;
			
			if(!_xml)return;
			
			_root = parseXMLNode(_xml);
			
			if(_root)
			{
				_root.selected = false || _isOpen;
				setNode(_root, _root.selected);
			}
			
			draw();
			
			addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
		}
		
		private function onClick(event:MouseEvent):void
		{
			if(event.target is TreeNode)
			{
				var node:TreeNode = event.target as TreeNode;
				node.selected = !node.selected;
				setFocus(node);
			}
		}
		
		private function parseXMLNode(xml:XML, node:TreeNode = null) : TreeNode
		{
			var _x:Number = (node)?node.x:-nodeWidth;
			var _y:Number = nodeHeight * rowCount++;
			
			var _name:String = String(xml.@label).length>0?String(xml.@label):String(xml.name());
			
			var _id:String;
			
			if(!_needLabel)
			{
				if(node)
				{
					_id = node.id + "." + String(xml.name());
					_id += "_"+(node.numNode++);
				}else{
					_id = String(xml.name());
				}
			}else{
				//menu need label, it's SiteMap
				if(String(xml.@label).length>0)
				{
					_id = "$"+String(xml.@id);
				}else{
					return null;
				}
			}
			
			var _node:TreeNode = new TreeNode(_name);
			_node.x = nodeWidth + _x;
			_node.parentNode = node?node:null;
			_node.id = _id;
			_node.data = xml;
			
			if(node && node.parentNode)
			{
				_node.path = node.path + "/" + _id;
			}else{
				_node.path = _id;
			} 
			
			//trace(" ! Path	: " + _node.path);
			addChild(_node);
			
			if(xml.children().length()>0)
			{
				var childs:Array = [];
				for each (var child:XML in xml.children()) 
				{
					var _nextNode:TreeNode = parseXMLNode(child, _node);
					if(_nextNode)
					{
						childs.push(_nextNode);
					}
				}
				
				if(childs.length)
				{
					_node.childs = childs.slice();
				}
			}
			return _node;
		}
		
		private function drawNode(node:TreeNode = null) : void
		{
			if(node)
			{
				node.draw();
				for each (var child:TreeNode in node.childs) 
				{
					drawNode(child);
				}
			}
		}
		
		private function setNode(node:TreeNode = null, isOpen:Boolean = true) : void
		{
			if(!node)return;
			
			//trace(node.id, ":", isOpen);
			
			node.isOpen = isOpen;
			for each (var child:TreeNode in node.childs)
			{
				if(_isRadio)
				{
					// single instance
					if(!child.parentNode||!child.parentNode.selectedNode)
					{
						//root
						setNode(child, node.isOpen );
					}else{
						child.isOpen = (child.parentNode.selectedNode==child);
						setNode(child, node.isOpen && child.isOpen );
					}
				}else{
					// multiple instance
					setNode(child, isOpen && child.selected && node.selected);
				}
			}
		}
		
		override public function draw():void
		{
			rowCount = 1;
			drawNode(_root);
			super.draw();
		}
		
		public function setFocusByPath(path:String) : TreeNode
		{
			if(!path)
				return null;
			
			var _paths:Array = path.split("/");
			return setFocusById(_paths.pop());
		}
		
		public function setFocusById(id:String) : TreeNode
		{
			if(currentNode && currentNode.id==id)
				return currentNode;
			
			var node:TreeNode = getNodeById(_root, id);
			
			if(node)
				setFocus(node);
			
			return node;
		}

		public function setFocus(node:TreeNode) : TreeNode
		{
			if(_isRadio)
			{
				// clear old
				if(currentNode)
				{
					currentNode.close(true);
				}
				node.open();
			}else{
				// toggle
				if(node.selected)
				{
					node.open();
				}else{
					node.close();
				}
			}
			
			// reset
			setNode(_root);
			currentNode = node;
			
			// view
			draw();
			
			// tell someone?
			dispatchEvent(new TreeEvent(TreeEvent.CHANGE_NODE_FOCUS, node));
			return node;
		}
		
        public function getPathById(id:String) : String
        {
        	var node:TreeNode = getNodeById(_root, id);
        	return node?node.path:"";
        }
        
        public function getNodeById(node:TreeNode, id:String) : TreeNode
        {	
			if(!node)return null;
			if(!node.childs)return null;
			var index:int = node.childs.length;
			var foundNode:TreeNode;
			while(!foundNode && --index>=0)
			{
				if(node.childs[index].id==id)
				{
					foundNode = node.childs[index];
					trace( " ! Found : "+foundNode.id);
					return foundNode;
				}else {
					foundNode = getNodeById(node.childs[index], id);
				}
			}
	        return foundNode;
		}
	}
}