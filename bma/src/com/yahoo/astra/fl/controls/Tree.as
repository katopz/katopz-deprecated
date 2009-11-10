/*
Copyright (c) 2007, Yahoo! Inc. All rights reserved.
Code licensed under the BSD License:
http://developer.yahoo.com/flash/license.html
*/
package com.yahoo.astra.fl.controls {
	import fl.core.UIComponent;
	import flash.display.*;
	import fl.controls.List;
	import fl.controls.listClasses.*;
	import fl.controls.ScrollPolicy;
	import fl.data.DataProvider;
	import fl.events.*;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getDefinitionByName;
	import com.yahoo.astra.fl.controls.treeClasses.*;
	import fl.core.InvalidationType;
	
//--------------------------------------
//  Class description
//--------------------------------------

/**
 *  The Tree class creates a List-based Tree component that displays hierarchical information.
 *  The Tree rendering is achieved via a custom TreeDataProvider that receives and parses an XML data structure
 *  and a supplied TreeCellRenderer (though other CellRenderers can be used in lieu of the default one.)
 *
 *  @author Allen Rabinovich
 *  @see com.yahoo.astra.fl.controls.treeClasses.TreeDataProvider
 
 */

	public class Tree extends List {

	//--------------------------------------------------------------------------
    //
    //  Class methods
    //
    //--------------------------------------------------------------------------

    /**
     *  Creates and returns an instance of the Tree class. The Tree control's content
	 *  is determined by assigning a TreeDataProvider to the dataProvider field of
	 *  the Tree class.
     * 
     *  To display the Tree, add it as a child to your current display list or drag an instance
	 *  of the Tree onto Stage.
     *
     *  @return An instance of the Tree class. 
     *
	 *  @see com.yahoo.astra.fl.controls.treeClasses.TreeDataProvider
     */		
		public function Tree() {
			super();
			addEventListener(ListEvent.ITEM_CLICK, nodeClick);
			addEventListener(ListEvent.ITEM_DOUBLE_CLICK, nodeClick);
			setStyle('cellRenderer', TreeCellRenderer);
		}

	/**
	 *  @private
	 *  Default Node click behavior
	 */				
		private function nodeClick(event:ListEvent):void {
			var dp:TreeDataProvider = dataProvider as TreeDataProvider;
			var node:Object = dp.getItemAt(event.index);
			dp.toggleNode(event.index);
		}
		/**
         * Gets or sets the name of the field in the <code>dataProvider</code> object 
         * to be displayed as the label for the TextInput field and drop-down list. 
		 *
         * <p>By default, the component displays the <code>label</code> property 
		 * of each <code>dataProvider</code> item. If the <code>dataProvider</code> 
		 * items do not contain a <code>label</code> property, you can set the 
		 * <code>labelField</code> property to use a different property.</p>
         *
         * <p><strong>Note:</strong> The <code>labelField</code> property is not used 
         * if the <code>labelFunction</code> property is set to a callback function.</p>
         * 
         * @default "label"
         *
         * @see #labelFunction 
		 *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		override public function get labelField():String {
			return _labelField;
		}
		
		/**
         * @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		override public function set labelField(value:String):void {
			if (value == _labelField) { return; }
			if (value.substr(0,1) == "@") {
				_labelField = value.substr(1);
			}
			else {
				_labelField = value;
			}
			invalidate(InvalidationType.DATA);
		}		
		
		

		
    /**
     *  Gets or sets the data model of the Tree of items to be displayed. 
	 *  The Tree dataProvider is required to be of type TreeDataProvider. 
	 *  Changes to the data provider are immediately available to all Tree 
	 *  components that use it as a data source. 
     *
     *  @default null
     *
	 *  @see com.yahoo.astra.fl.controls.treeClasses.TreeDataProvider
     */		
	 		
		override public function get dataProvider () : DataProvider {
			return _dataProvider;
		}

		override public function set dataProvider(value:DataProvider):void {

			if ((value is DataProvider && value.length == 0) || value is TreeDataProvider) {
				if (_dataProvider != null) {
					_dataProvider.removeEventListener(DataChangeEvent.DATA_CHANGE,handleDataChange);
					_dataProvider.removeEventListener(DataChangeEvent.PRE_DATA_CHANGE, onPreChange);
				}
				_dataProvider = value;

				_dataProvider.addEventListener(DataChangeEvent.DATA_CHANGE,handleDataChange,false,0,true);
				_dataProvider.addEventListener(DataChangeEvent.PRE_DATA_CHANGE,onPreChange,false,0,true);
				clearSelection();
				invalidateList();
			}
			else {
			throw new TypeError("Error: Type Coercion failed: cannot convert " + value + " to TreeDataProvider.");
			}
		}
		
	}
}