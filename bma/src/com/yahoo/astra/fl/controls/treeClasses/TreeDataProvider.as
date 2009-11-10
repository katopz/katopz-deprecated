/*
Copyright (c) 2007, Yahoo! Inc. All rights reserved.
Code licensed under the BSD License:
http://developer.yahoo.com/flash/license.html
*/
package com.yahoo.astra.fl.controls.treeClasses {

	import flash.events.EventDispatcher;
	import fl.events.DataChangeEvent;
	import fl.events.DataChangeType;
	import RangeError;

	import fl.data.DataProvider;

	//--------------------------------------
	//  Class description
	//--------------------------------------

	/**
	 * The TreeDataProvider class provides methods and properties that allow you to query and modify
	 * the data in a Tree Component.
	 *
	 * <p>A <em>TreeDataProvider</em> is the current linear representation of the state of the Tree component.
	 * However, even if some nodes are not visible, the TreeDataProvider holds information about them in member
	 * fields of the visible nodes. For example, consider the following tree: 
	 *
	 * &lt;node&nbsp;label=\&quot;Folder&nbsp;1\&quot;&gt;
	 * <br />&nbsp;&nbsp;&nbsp;&lt;node&nbsp;label=\&quot;File&nbsp;1\&quot;/&gt;
	 * <br />&nbsp;&nbsp;&nbsp;&lt;node&nbsp;label=\&quot;File&nbsp;2\&quot;/&gt;
	 * <br />&lt;/node&gt;
	 * <br />&lt;node&nbsp;label=\&quot;Folder&nbsp;2\&quot;&gt;
	 * <br />&nbsp;&nbsp;&nbsp;&lt;node&nbsp;label=\&quot;File&nbsp;3\&quot;/&gt;
	 * <br />&nbsp;&nbsp;&nbsp;&lt;node&nbsp;label=\&quot;File&nbsp;4\&quot;/&gt;
	 * <br />&lt;/node&gt;
	 * 
	 * When the TreeDataProvider is initialized with the XML shown above, it will contain two items: one with label 
	 * "Folder 1", and one with label "Folder 2". However, each of these items will have a number of fields that tie
	 * them to the Tree structure. These fields are: <em>nodeType</em> (either branch or leaf), <em>nodeState</em>
	 * (either open or closed), <em>nodeLevel</em> (the depth within the tree), and <em>nodeChildren</em> (a set of 
	 * references to all of the node's children, if applicable. In the example, the node with label "Folder 1" will 
	 * have <em>nodeType</em> set to "branch node", <em>nodeState</em> set to "closed node", <em>nodeLevel</em> to 0, 
	 * and <em>nodeChildren</em> would contain references to nodes with labels "File 1" and "File 2".
	 * 
	 * When the node "Folder 1" is expanded, the <em>TreeDataProvider</em> will contain 4 items: "Folder 1", "File 1", 
	 * "File 2", "Folder 2".
	 *
	 * @author Allen Rabinovich
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0 
	 *
	 * <strong>Example usage:</strong><br/>
	 * <em>
	 * var mytree:Tree = new Tree();<br/>
	 * var myxml:XML = &lt;node&nbsp;label=\&quot;Folder&nbsp;1\&quot;&gt;&lt;node&nbsp;label=\&quot;File&nbsp;2\&quot;/&gt;&lt;/node&gt;;<br/>
	 * mytree.dp = new TreeDataProvider(myxml);<br/>
	 * addChild(mytree);<br/>
	 * </em>
	 */
	 
	public class TreeDataProvider extends DataProvider {

	/**
	 * A constant used for populating the <em>nodeState</em> field.
     */
 	     public static const OPEN_NODE = "openNode";
	/**
	 * A constant used for populating the <em>nodeState</em> field.
     */
		 public static const CLOSED_NODE = "closedNode";

	/**
	 * A constant used for populating the <em>nodeType</em> field.
     */
		 public static const BRANCH_NODE = "branchNode";
		 
	/**
	 * A constant used for populating the <em>nodeType</em> field.
     */
		 public static const LEAF_NODE = "leafNode";
	
		/**
		*  @private
	 	*  Used for traversing the tree
	 	*/				 
		 private var nodeCounter:int;
	
		/**
		 * Creates a new TreeDataProvider object using an instance of XML object as data source. 
		 * The hierarchical structure of the XML object is reproduced in the Tree as parent-child
		 * relationships between Objects. Each XML node is converted into an Object, and its attributes
		 * are converted to fields within the Object. In addition, the following values are populated 
		 * for each node: 
		 * <p><em>nodeType</em> - Can be either <em>BRANCH_NODE</em> or <em>LEAF_NODE</em>. Represents
		 * whether a Node has any children.</p>
		 * <p><em>nodeState</em> - If the node is a <em>BRANCH_NODE</em>, represents whether it's currently
		 * open or closed. The value can be either <em>OPEN_NODE</em> or <em>CLOSED_NODE</em></p>
		 * <p><em>nodeLevel</em> - The depth of the Node within the Tree. Can be used for indenting the node
		 * by the cell renderer.</p>
		 * <p><em>nodeChildren</em> - An Array of pointers to the objects representing children of the current node.</p>
		 * 
		 * @param data The XML data that is used to create the DataProvider.
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
				 
		public function TreeDataProvider(value:Object=null) {
			super(value);
		}

        /** 
		 * Toggles the node state of a branch node. If the node is currently open, it becomes closed; and vice versa.
		 * The effect on the dataProvider is as follows: if the node is being opened, all of its children are added
		 * to the dataProvider below the node; if the node is being closed, all of its children are removed from the
		 * dataProvider.
		 * The state of the child nodes of the current node is preserved; that is, if a child node of the current node
		 * is a branch node and was open when its parent node was closed, it will be open when the parent node is 
		 * reopened.
		 *
		 * @param nodeIndex The dataProvider index of the node to be toggled.
		 *
		 */
		public function toggleNode (nodeIndex:int) : void {
			var currentNode:Object = this.getItemAt(nodeIndex);
			
			if (currentNode.nodeType == TreeDataProvider.BRANCH_NODE) {
				
				if (currentNode.nodeState == TreeDataProvider.CLOSED_NODE) {
				  currentNode.nodeState = TreeDataProvider.OPEN_NODE;
				  nodeCounter = 0;
				  expandNode(nodeIndex);
				}
				
				else {
				currentNode.nodeState = TreeDataProvider.CLOSED_NODE;
				collapseNode(nodeIndex);
				}
				
			}
			
		}
		
       /** 
		 * @private
		 * Expands the node.
		 */	
		private function expandNode (nodeIndex:int) : void {
			var nodeArray:Array = new Array();
			var currentNode = this.getItemAt(nodeIndex);
			for (var childNodeIndex = 0; childNodeIndex < currentNode.nodeChildren.length; childNodeIndex++) {
				addTo(nodeArray, currentNode.nodeChildren[childNodeIndex]);
				}
			
			for (var i = 0; i < nodeArray.length; i++) {
				this.addItemAt(nodeArray[i], nodeIndex + 1 + i);
			}
		}
		
		
       /** 
		 * @private
		 * Retrieves all open children of a given node.
		 */	
		private function addTo (currentArray:Array, node:Object) {
			currentArray.push(node);
			if (node.nodeType == TreeDataProvider.BRANCH_NODE) {
					if (node.nodeState == TreeDataProvider.OPEN_NODE) {
						for (var childNodeIndex = 0; childNodeIndex < node.nodeChildren.length; childNodeIndex++) {
							addTo(currentArray, node.nodeChildren[childNodeIndex]);
						}
					}
			}
		}
		
		/** 
		 * @private
		 * Collapses the node by removing all objects below it in the dataProvider that are at a greater nodeLevel.
		 */	
		private function collapseNode (nodeIndex:int) : void {
			var currentNode:Object = this.getItemAt(nodeIndex);
			if (nodeIndex + 1 < this.length) {
			while (this.getItemAt(nodeIndex+1).nodeLevel > this.getItemAt(nodeIndex).nodeLevel) {
				this.removeItemAt(nodeIndex+1);
				if (nodeIndex + 1 >= this.length) {
					break;
				}
			}
			}
		}

		/** 
		 * @private
		 * Placeholder for next release.
		 */
		private function moveNode (oldNodeIndex:int, newNodeIndex:int) : void {
		}
		
		/**
		 * @private (protected)
		 * Overrides the DataProvider's main method for parsing objects
		 * to allow for hierarchical XML
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
		private function createTreeFromXML(xml:XML) : Array {
				
				var resultArray:Array = new Array();
				
				for each (var child:XML in xml.children()) {
				parseXMLNode(child, null, 0, resultArray);
				}
				
				return resultArray;
		}
		
       /** 
		 * @private
		 * Parses a specific XML node and gives it Tree-specific properties.
		 */	
		private function parseXMLNode(xml:XML, parentNode:Object, level:int, resultArray:Array) : void {
				var newNode:Object = new Object();
				var thisIndex:int = 0;
				newNode["nodeLevel"] = level;
				newNode["parentNode"] = parentNode;
				
				if (xml.children().length() > 0) { newNode["nodeType"] = TreeDataProvider.BRANCH_NODE; newNode["nodeChildren"] = new Array();}
				else { newNode["nodeType"] = TreeDataProvider.LEAF_NODE; }
				newNode["nodeState"] = TreeDataProvider.CLOSED_NODE;
				var attrs:XMLList = xml.attributes();
				for each (var attr:XML in attrs) {
					newNode[attr.localName()] = attr.toString();
				}
				if (parentNode == null) {
				resultArray.push(newNode);
				}
				else {
					parentNode.nodeChildren.push(newNode);
				}
				for each (var child:XML in xml.children()) {
				parseXMLNode(child, newNode, level+1, resultArray);
				}
			
		}
		/** 
		 * @private
		 * Checks whether something is a tree node.
		 */	
		private function isTreeNode (obj:Object) : Boolean {
			if (obj["nodeLevel"] == null || obj["nodeType"] == null || obj["nodeState"] == null || obj["parentIndex"] == null) {
				return false;
			}
			else {
				return true;
			}
		}
		
		/** 
		 * @private
		 * Initialized retrieval from a data object that's passed in. Currently only works with XML files.
		 */	

		override protected function getDataFromObject(obj:Object):Array {
			var arr:Array;
			var retArr:Array;
			if (obj is XML) {
				var xml:XML = obj as XML;
				retArr = createTreeFromXML(xml);
				return retArr;
			} else {
				throw new TypeError("Error: Type Coercion failed: cannot convert " + obj + " to TreeDataProvider.");
				return null;
			}
		}
	}

}