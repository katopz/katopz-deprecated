package com.sleepydesign.components
{
	import com.sleepydesign.events.SDEvent;
	import com.sleepydesign.events.SDMouseEvent;
	import com.sleepydesign.styles.SDStyle;
	
	/**
	 * 
	 * 
___________________________________________________________

[Sample]
var xml:XML = 
<foo1>
	<foo1>
		<bar1/>
	</foo1>
	<bar1>
		<foo1>
			<bar1/>
			<bar2/>
		</foo1>
	</bar1>
</foo1>
var tree:SDTree = new SDTree(this,10,10,xml);
___________________________________________________________

 *  
 	* 
	 * @author katopz
	 * 
	 */	
	public class SDTree extends SDComponent
	{
		private var _xml:XML;
		private var _tf:SDLabel;
		private var _root:SDTreeNode;
		
		public var currentNode:SDTreeNode;
		
		public static var rowCount:int = 1;
		
		public static var nodeWidth:int = SDStyle.SIZE+SDStyle.SIZE*.5;
		public static var nodeHeight:int = SDStyle.SIZE+SDStyle.SIZE*.5;
		
		private var _needLabel:Boolean = false;
		private var _isRadio:Boolean = false;
		private var _isOpen:Boolean = false;
		
		public function SDTree(xml:XML = null, isOpen:Boolean = false, needLabel:Boolean = false, isRadio:Boolean = false)
		{
			_xml = xml;
			_needLabel = needLabel;
			_isRadio = isRadio;
			_isOpen = isOpen;
			
			super();
		}
		
		/*
		override public function init(raw:Object=null):void
		{
			if(!_config)
				_config = raw?raw:{needLabel:false, isRadio:false};
			super.init(raw);
		}
		
		
		override public function parse(raw:Object=null):void
		{
			// default
			_config = raw;
		}
		*/
		
		override public function create(config:Object=null):void
		{
			super.create(config);
			if(!_xml)return;
			
			_root = parseXMLNode(_xml);
			
			if(_root)
			{
				//close by default
				if(config && _isOpen)
				{
					_root.selected = _isOpen;//?config.isOpen:false;
				}else{
					_root.selected = false || _isOpen;
				}
				setNode(_root, _root.selected);
			}
		}
		
		private function parseXMLNode(xml:XML, node:SDTreeNode = null) : SDTreeNode
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
			
			var _node:SDTreeNode = new SDTreeNode(_name);
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
			_node.addEventListener(SDMouseEvent.CLICK, onClick, false, 0, true);
			
			if(xml.children().length()>0)
			{
				var childs:Array = [];
				for each (var child:XML in xml.children()) 
				{
					var _nextNode:SDTreeNode = parseXMLNode(child, _node);
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
		
		private function drawNode(node:SDTreeNode = null) : void
		{
			if(node)
			{
				node.draw();
				for each (var child:SDTreeNode in node.childs) 
				{
					drawNode(child);
				}
			}
		}
		
		private function setNode(node:SDTreeNode = null, isOpen:Boolean = true) : void
		{
			if(!node)return;
			
			node.isOpen = isOpen;
			for each (var child:SDTreeNode in node.childs)
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
					setNode(child, isOpen && child.selected);
				}
			}
		}
		
		override public function draw():void
		{
			rowCount = 1;
			drawNode(_root);
			super.draw();
		}
		
		public function setFocusById(id:String) : SDTreeNode
		{
			if(currentNode && currentNode.id==id)return null;
			var node:SDTreeNode = getNodeById(_root, id);
			
			if(node)
				setFocus(node);
			
			return node;
		}

		public function setFocus(node:SDTreeNode) : SDTreeNode
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
			dispatchEvent(new SDEvent(SDEvent.CHANGE_FOCUS, {node:node}));
			return node;
		}
		
        public function getPathById(id:String) : String
        {
        	var node:SDTreeNode = getNodeById(_root, id);
        	return node?node.path:"";
        }
        
        public function getNodeById(node:SDTreeNode, id:String) : SDTreeNode
        {	
			if(!node)return null;
			if(!node.childs)return null;
			var index:int = node.childs.length;
			var foundNode:SDTreeNode;
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
		
		private function onClick(event:SDEvent):void
		{
			var node:SDTreeNode = SDTreeNode(event.currentTarget);
			
			setFocus(node);
			dispatchEvent(new SDEvent(SDMouseEvent.CLICK, {node:node}));
		}
	}
}