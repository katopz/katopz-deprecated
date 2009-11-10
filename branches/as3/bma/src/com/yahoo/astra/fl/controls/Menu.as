/*
Copyright (c) 2007, Yahoo! Inc. All rights reserved.
Code licensed under the BSD License:
http://developer.yahoo.com/flash/license.html
*/
package com.yahoo.astra.fl.controls{
	
import com.yahoo.astra.fl.controls.menuClasses.MenuCellRenderer;
import com.yahoo.astra.fl.data.XMLDataProvider;
import com.yahoo.astra.fl.events.MenuEvent;
import com.yahoo.astra.fl.managers.PopUpManager;
import fl.controls.List;
import fl.controls.listClasses.CellRenderer;
import fl.containers.BaseScrollPane;
import fl.core.InvalidationType;
import fl.data.DataProvider;
import fl.events.ListEvent;
import fl.transitions.*;
import fl.transitions.easing.*;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.MovieClip;
import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.filters.BlurFilter;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.ui.Keyboard;
import flash.utils.*;
//--------------------------------------
//  Events
//--------------------------------------
/**
 * Dispatched when the user rolls the pointer over a row.
 *
 * @eventType com.yahoo.astra.fl.events.MenuEvent.ITEM_ROLL_OVER
 *
 * @see #event:itemRollOut
 * 
 * @langversion 3.0
 * @playerversion Flash 9.0.28.0
 */
[Event(name="itemRollOver", type="com.yahoo.astra.fl.events.MenuEvent")]	
/**
 * Dispatched when the user rolls the pointer off a row.
 *
 * @eventType com.yahoo.astra.fl.events.MenuEvent.ITEM_ROLL_OUT
 *
 * @see #event:itemRollOver
 *
 * @langversion 3.0
 * @playerversion Flash 9.0.28.0
 */
[Event(name="itemRollOut", type="com.yahoo.astra.fl.events.MenuEvent")]
 
 /**
 * Dispatched when the user clicks an item in the menu. 
 *
 * @eventType com.yahoo.astra.fl.events.MenuEvent.ITEM_CLICK
 *
 * @langversion 3.0
 * @playerversion Flash 9.0.28.0
 */
[Event(name="itemClick", type="com.yahoo.astra.fl.events.MenuEvent")]
/**
 * Dispatched when a different item is selected in the Menu.
 *
 * @eventType flash.events.Event.CHANGE
 *
 * @langversion 3.0
 * @playerversion Flash 9.0.28.0
 */
[Event(name="change", type="flash.events.Event")]
/**
 * Dispatched when a menu is shown
 *
 * @eventType com.yahoo.astra.fl.events.MenuEvent.MENU_SHOW
 *
 * @langversion 3.0
 * @playerversion Flash 9.0.28.0
 */
[Event(name="menuShow", type="com.yahoo.astra.fl.events.MenuEvent")]
/**
 * Dispatched when a menu is hidden.
 *
 * @eventType com.yahoo.astra.fl.events.MenuEvent.MENU_HIDE
 *
 * @langversion 3.0
 * @playerversion Flash 9.0.28.0
 */
[Event(name="menuHide", type="com.yahoo.astra.fl.events.MenuEvent")]
	
//--------------------------------------
//  Other metadata
//--------------------------------------
[IconFile("assets/Menu.png")]
 
//--------------------------------------
//  Class description
//--------------------------------------
/**
 *  The Menu class creates an array of menus from an XML data provider.
 *  Add the Menu to your library (either by dragging it onto the stage and then deleting it, or
 *  dragging it directly to your library). Then call the static <code>Menu.createMenu(parent)</code> 
 *  method to create a menu, and call <code>yourMenuInstance.show()</code> to display it.
 *
 *  @author Alaric Cole
 */
	 
public class Menu extends List {
	//--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    /**
     *  Constructor.
     *
     *  <p>Applications do not normally call the Menu constructor directly.
     *  Call the <code>Menu.createMenu()</code> method.</p>
	 *  @see #createMenu()
     */
	public function Menu() {
		super();
		
		//Make it initially invisible
		visible=false;
		
		tabEnabled=false;
		
		verticalScrollPolicy = horizontalScrollPolicy = "off";
		
		addEventListener(MenuEvent.ITEM_ROLL_OVER,itemRollOver);
		addEventListener(MenuEvent.ITEM_ROLL_OUT,itemRollOut);
	}
	
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
	private var realParent:DisplayObjectContainer;
	
	// the anchor is the row in the parent menu that opened to be this menu
	// or the row in this menu that opened to be a submenu
	private var anchorRow:MenuCellRenderer;
	// reference to the ID of the last opened submenu within a menu level
	private var anchor:String;
	// reference to the rowIndex of a menu's anchor in the parent menu
	private var anchorIndex:int=-1;
	private var subMenu:Menu;
	/**
	 *  @private
	 *  When this timer fires, we'll open a submenu
	 */
	private var openSubMenuTimer:int=0;
	/**
	 *  @private
	 *  When this timer fires, we'll hide this menu
	 */
	private var closeTimer:int=0;
	
	/**
	 * @private
	 *
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0
	 */
	private static var defaultStyles:Object = {
												skin:"MenuSkin",
												cellRenderer:MenuCellRenderer,
												contentPadding:null,
												disabledAlpha:null
												};
	/**
	 * @private
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0
	 */
	public static function getStyleDefinition():Object { 
		return mergeStyles(defaultStyles, BaseScrollPane.getStyleDefinition());
	}
	/**
	 * @private
	 *
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0
	 */
	//private static var defaultStyles:Object = {backgroundSkin:"MenuSkin"}
	//--------------------------------------------------------------------------
	//  parentMenu
	//--------------------------------------------------------------------------
	/**
	 *  @private
	 */
	protected var _parentMenu:Menu;
	/**
	 *  The parent menu in a hierarchical chain of menus, where the current 
	 *  menu is a submenu of the parent.
	 * 
	 *  @return The parent Menu control. 
	 */
	public function get parentMenu():Menu {
		return _parentMenu;
	}
	/**
	 *  @private
	 */
	public function set parentMenu(value:Menu):void {
		_parentMenu=value;
	}
	
	/**
	 *  Get the current set of submenus for a Menu
	 * @return all submenus of this menu, if any
	 */
	public function get subMenus():Array {
		var arr:Array=[];
		for (var i:int=0; i < dataProvider.length; i++) {
			var d:Object=dataProvider.getItemAt(i);
			if (d) {
				var c:MenuCellRenderer=MenuCellRenderer(itemToCellRenderer(d));
				if (c) {
					var m:Menu=c.subMenu;
					//
					if (m) {
						arr.push(m);
					}
				}
			}
		}
		return arr;
	}
	
	  
   /**
	 *  @private
	 */
   protected var tween:Tween;
   
	//--------------------------------------------------------------------------
	// 
	// Overridden Properties
	//
	//--------------------------------------------------------------------------
	//----------------------------------
    //  labelField
    //----------------------------------
    [Inspectable(category="Data", defaultValue="label")]
    /**
     *  Name of the field in the items in the <code>dataProvider</code>
     *  Array to display as the label in the TextInput portion and drop-down list.
     *  By default, the control uses a property named <code>label</code>
     *  on each Array object and displays it.
     *  <p>However, if the <code>dataProvider</code> items do not contain
     *  a <code>label</code> property, you can set the <code>labelField</code>
     *  property to use a different property.</p>
     *
     */
    override public function get labelField():String
    {
        return _labelField;
    }
    /**
     *  @private
     */
    override public function set labelField(value:String):void
    {
        //support @ modifiers for XML converted to Object via XMLDataProvider
		if(value.indexOf("@") == 0) value = value.slice(1); 
        super.labelField = value;
    }
	//--------------------------------------------------------------------------
	//  dataProvider
	//--------------------------------------------------------------------------
[Collection(collectionClass="com.yahoo.astra.fl.data.XMLDataProvider", collectionItem="fl.data.SimpleCollectionItem", identifier="item")]
	/**
	 *  Gets or sets the data model of the list of items to be viewed. 
	 *  A data provider can be shared by multiple list-based components. 
	 *  Changes to the data provider are immediately available to all components that use it as a data source.
	 * 
	 *  To use XML data, you should set the dataProvider as type <code>XMLDataProvider</code>:
	 *  <code>menu.dataProvider = new XMLDataProvider(someXML);</code>
	 *
	 *  However, using the <code>createMenu()</code> method and passing in XML will do this for you.
	 *
	 *  @see com.yahoo.astra.fl.data.XMLDataProvider
	 *  @default null
	 */
	override public function  get dataProvider():DataProvider
	{
		return _dataProvider;
	}
	override public function set dataProvider(value:DataProvider):void {
			if((value is DataProvider && value.length == 0) || value is XMLDataProvider) 
			{
				_dataProvider = value;
				clearSelection();
                invalidateList();
			}
		else throw new TypeError("Error: Type Coercion failed: cannot convert " + value + " to com.yahoo.astra.fl.data.XMLDataProvider");
	}
	
	
	//--------------------------------------------------------------------------
    //
    //  Class methods
    //
    //--------------------------------------------------------------------------
    /**
     *  Creates and returns an instance of the Menu class. The Menu control's 
     *  content is determined by the method's <code>xmlDataProvider</code> argument. The 
     *  Menu control is placed in the parent container specified by the 
     *  method's <code>parent</code> argument.
     * 
     *  This method does not show the Menu control. Instead, 
     *  this method just creates the Menu control and allows for modifications
     *  to be made to the Menu instance before the Menu is shown. To show the 
     *  Menu, call the <code>Menu.show()</code> method.
     *
     *  @param parent A container that the PopUpManager uses to place the Menu 
     *  control in. The Menu control may not actually be parented by this object.
     * 
     *  @param xmlDataProvider The data provider for the Menu control. 
     *  @see #dataProvider 
     *  
     *  @return An instance of the Menu class. 
     *
     *  @see #popUpMenu()
	 *  @see com.yahoo.astra.fl.data.XMLDataProvider
     */		
	public static function createMenu(inParent:DisplayObjectContainer,xmlDataProvider:Object = null):Menu {
		var menu:Menu=new Menu;
		menu.realParent=inParent;
		
		//add to the stage as popup
		popUpMenu(menu,inParent,xmlDataProvider);
		return menu;
	}
	
    /**
     *  Sets the dataProvider of an existing Menu control and places the Menu 
     *  control in the specified parent container.
     *  
     *  This method does not show the Menu control; you must use the 
     *  <code>Menu.show()</code> method to display the Menu control. 
     * 
     *  The <code>Menu.createMenu()</code> method uses this method.
     *
     *  @param menu Menu control to popup. 
     * 
     *  @param parent A container that the PopUpManager uses to place the Menu 
     *  control in. The Menu control may not actually be parented by this object.
     *  If you omit this property, the method sets the Menu control's parent to 
     *  the stage. 
     * 
     *  @param xmlDataProvider dataProvider object set on the popped up Menu. If you omit this 
     *  property, the method sets the Menu data provider to a new, empty XML object.
     */
	public static function popUpMenu(menu:Menu,parent:DisplayObjectContainer,dp:Object = null):void {
		if (!dp) dp = new XML();
			
		menu.dataProvider = new XMLDataProvider(dp);
		menu.invalidateList();
	}
	/**
	 *  @private
	 *  Removes the root menu from the display list.  This is called only for
	 *  menus created using "createMenu".
	 * 
	 */
	private static function menuHideHandler(event:MenuEvent):void {
		var menu:Menu=Menu(event.target);
		if (! event.isDefaultPrevented() && event.menu == menu) {
			PopUpManager.removePopUp(menu);
			menu.removeEventListener(MenuEvent.MENU_HIDE,menuHideHandler);
		}
	}
	
	/**
	 *  @private
	 *  Removes the main menu and submenus from the stage.
	 * 
	 */	
	protected function hideAllMenus():void {
		getRootMenu().hide();
		getRootMenu().deleteDependentSubMenus();
	}
	
	/**
	 *  @private
	 *  Removes all menus and submenus from the stage.
	 * 
	 */
	protected function deleteDependentSubMenus():void {
		if (subMenus.length > 0) {
			var n:int=subMenus.length;
			for (var i:int=0; i < n; i++) {
				var m:Menu=subMenus[i]  as  Menu;
				m.deleteDependentSubMenus();
				//m.hide();
				//more responsive to make invisble rather than hide()
				m.visible=false;
			}
		}
	}
	/**
     *  Shows the Menu control. If the Menu control is not visible, this method 
     *  places the Menu in the upper-left corner of the stage, resizes the Menu control as needed, 
	 *  and makes it visible.
     * 
     *  The x and y arguments of the <code>show()</code> method specify the 
     *  coordinates of the upper-left corner of the Menu control relative to the 
     *  stage, which is not necessarily the direct parent of the Menu control. 
     * 
     *  For example, if the Menu control is in a container, the x and y coordinates are 
     *  relative to the stage, not the container.
     *
     *  @param x Horizontal location of the Menu control's upper-left 
     *  corner (optional).
     *  @param y Vertical location of the Menu control's upper-left 
     *  corner (optional).
     */
	public function show(xShow:Object=null,yShow:Object=null):void {
		//if empty, forget it
		if (dataProvider && dataProvider.length == 0) {
			return;
		}
		// If parent is closed, then don't show a submenu
		if (parentMenu && ! parentMenu.visible && parentMenu.selectedIndex < 0) {
			return;
		}
		// If already visible, why bother?
		//if (visible) {
			//return;
		//}
		//don't highlight anything
		selectedIndex= caretIndex = -1;
		
		//Pop up the menu
		if(!this.parent && realParent)
		{
			PopUpManager.addPopUp(this,realParent);
		}
		//if it's been added by dragging onto stage
		else
		{
			if(parent)
			{
				realParent = parent;
				parent.removeChild(this);
				PopUpManager.addPopUp(this,realParent);
			}
		}
		
		drawNow();
		
		//resize the menu to its rows
		var maxW:int = 0;
		var totalHeights:int = 0;
		var n:int=dataProvider.length;
		
		//loop through all renderers
		for (var i:int=0; i < n; i++) {
			var item:Object = dataProvider.getItemAt(i);
			var c:MenuCellRenderer=itemToCellRenderer(item)  as  MenuCellRenderer;
			var w:int;
			var h:int; 
			if(!c)
			{
				break;
			}
			w =  (c.width?c.width:10);
			h= c.height;
			
			totalHeights += h;
			if( w > maxW) 
			{
				maxW = w;
			}
			
		}
		
		
		//set the width of the menu to the largest width of the renderers
		width = (maxW < 10 ? 10: maxW);
		rowCount = n;
		//height = totalHeights;
		
		//HACK: separator isn't resizing due to the row's width not being
		//set immediately, so we force all row widths to the Menu's width
		for (var t:int=0; t < n; t++) {
			var itm:Object = dataProvider.getItemAt(t);
			var r:MenuCellRenderer=itemToCellRenderer(itm)  as  MenuCellRenderer;
			if(!r)
			break;
			
			r.width = maxW;
			
			r.drawNow();
		}
		
		addEventListener(MenuEvent.MENU_HIDE,menuHideHandler,false,-50);
		// Fire an event
		var menuEvent:MenuEvent=new MenuEvent(MenuEvent.MENU_SHOW);
		menuEvent.menu=this;
		//menuEvent.menuBar = sourceMenuBar;
		getRootMenu().dispatchEvent(menuEvent);
		// Activate the menu
		this.setFocus();
		// Position it
		if (xShow !== null && ! isNaN(Number(xShow))) {
			x=Number(xShow);
		}
		if (yShow !== null && ! isNaN(Number(yShow))) {
			y=Number(yShow);
		}
		// Adjust for menus that extend out of bounds
		if (this != getRootMenu()) {
			var shift:Number=x + width - stage.width;
			if (shift > 0) {
				x=Math.max(x - shift,0);
			}
		}
		// Make it visible
		visible=true;
		
		//disabled items aren't rendering properly with addtostage feature
		
		drawNow();
		// If the user clicks outside the menu, then hide the menu
		stage.addEventListener(MouseEvent.MOUSE_DOWN,mouseDownOutsideHandler,false,0,true);
	}
	
	//--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------
	/**
     *  @private
	 *  Set up keyboard navigation specific to the Menu
     */
	override protected function keyDownHandler(event:KeyboardEvent):void {
		
		super.keyDownHandler(event);
		
		var row:MenuCellRenderer=selectedIndex < 0 ? null : itemToCellRenderer(dataProvider.getItemAt(selectedIndex))  as  MenuCellRenderer;
		var rowData:Object=row?row.data.data:null;
		var mnu:Menu=row?MenuCellRenderer(row).menu:null;
		switch (event.keyCode) {
			case Keyboard.ENTER :
			case Keyboard.SPACE :
				if (row) {
					if (rowData) {
						//if the row has its own data (taken from XML and thrown into an object)
						var m:Menu=openSubMenu(row);
						//m.selectedIndex=0;
						//m.selectedIndex=m.caretIndex = 0;
					}
				} else {
					var menuEvent=new MenuEvent(MenuEvent.ITEM_CLICK);
					menuEvent.menu=this;
					menuEvent.index=this.selectedIndex;
					//menuEvent.menuBar = sourceMenuBar;
					//menuEvent.label = itemToLabel(rowData);
					menuEvent.item=rowData;
					menuEvent.itemRenderer=row;
					getRootMenu().dispatchEvent(menuEvent);
					/*menuEvent=new MenuEvent(MenuEvent.CHANGE);
					menuEvent.menu=this;
					menuEvent.index=this.selectedIndex;
					//menuEvent.menuBar = sourceMenuBar;
					//menuEvent.label = itemToLabel(rowData);
					menuEvent.item=rowData;
					menuEvent.itemRenderer=row;
					getRootMenu().dispatchEvent(menuEvent);*/
					hideAllMenus();
				}
				break;
			case Keyboard.ESCAPE :
				hideAllMenus();
				break;
			case Keyboard.LEFT :
				//Move to the proper spot on the parent menu, if there is one
				if (parentMenu) {
					//parentMenu.selectedIndex = 
					parentMenu.selectedIndex=anchorIndex;//?anchorIndex:-1;
					parentMenu.setFocus();
					hide();
				}
				
				break;
			case Keyboard.RIGHT :
				//Move to the top of the submenu, if there is one
				//deleteDependentSubMenus();
				//var row:MenuCellRenderer = itemToCellRenderer(event.item) as MenuCellRenderer;
				if (row) {
					if (rowData) {
						//if the row has its own data (taken from XML and thrown into an object)
						var m2:Menu=openSubMenu(row);
						m2.selectedIndex=0;
					}
				}
				break;
		}
	}
	
	/**
	 * @private (protected)
	 * Moves the selection in a vertical direction in response
	 * to the user selecting items using the up-arrow or down-arrow
	 *
	 * @param code The key that was pressed (e.g. Keyboard.DOWN)
	 *
	 * @param shiftKey <code>true</code> if the shift key was held down 
	 *
	 * @param ctrlKey <code>true</code> if the ctrl key was held down 
	 *
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0
	 */
	override protected function moveSelectionVertically(code:uint, shiftKey:Boolean, ctrlKey:Boolean):void {
		var pageSize:int = Math.max(Math.floor(calculateAvailableHeight() / rowHeight), 1);
		var newCaretIndex:int = -1;
		var dir:int = 0;
		switch (code) {
			case Keyboard.UP :
				if (caretIndex > 0) {
					newCaretIndex = caretIndex - 1;
				}
				break;
			case Keyboard.DOWN :
				if (caretIndex < length - 1) {
					newCaretIndex = caretIndex + 1;
				}
				break;
			case Keyboard.PAGE_UP :
				if (caretIndex > 0) {
					newCaretIndex = Math.max(caretIndex - pageSize, 0);
				}
				break;
			case Keyboard.PAGE_DOWN :
				if (caretIndex < length - 1) {
					newCaretIndex = Math.min(caretIndex + pageSize, length - 1);
				}
				break;
			case Keyboard.HOME :
				if (caretIndex > 0) {
					newCaretIndex = 0;
				}
				break;
			case Keyboard.END :
				if (caretIndex < length - 1) {
					newCaretIndex = length - 1;
				}
				break;
		}
		if (newCaretIndex >= 0) {
			var item:Object = dataProvider.getItemAt(newCaretIndex);
			var row:MenuCellRenderer=itemToCellRenderer(item)  as  MenuCellRenderer;
			
			doKeySelection(newCaretIndex, shiftKey, ctrlKey);
			scrollToSelected();
			if(!row.enabled) moveSelectionVertically(code, shiftKey, ctrlKey);
		}
		
	}
	
	/**
	 *  @private
	 *  Recreates ListEvents as MenuEvents 
	 */
	override public function dispatchEvent(event:Event):Boolean {
		if (!(event is MenuEvent) && event is ListEvent && 
					(event.type == ListEvent.ITEM_ROLL_OUT ||
					event.type == ListEvent.ITEM_ROLL_OVER) ) {
			// we don't want to dispatch ListEvent.ITEM_ROLL_OVER or
			// ListEvent.ITEM_ROLL_OUT or ListEvent.CHANGE events 
			// because Menu dispatches its own 
			event.stopImmediatePropagation();
			var meV:MenuEvent = new MenuEvent(event.type,
														 event.bubbles,
														 event.cancelable, null, this, 
			 ListEvent(event).item, null, itemToLabel(ListEvent(event).item) );
			return super.dispatchEvent(meV);
		}
		// in case we encounter a ListEvent.ITEM_CLICK from 
		// a superclass that we did not account for, 
		// lets convert the ListEvent and pass it on up to 
		// avoid an RTE
		if (!(event is MenuEvent) && event is ListEvent && 
					(event.type == ListEvent.ITEM_CLICK)) {
			event.stopImmediatePropagation();
			var me:MenuEvent = new MenuEvent(event.type,
														 event.bubbles,
														 event.cancelable, null, this, 
			 ListEvent(event).item, null, itemToLabel(ListEvent(event).item) );
			return super.dispatchEvent(me);
		}
		// we'll let everything else go through
		return super.dispatchEvent(event);
	}
	
	//--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
 
	/**
	 *  Hides the Menu control and any of its submenus if visible
	 */
	public function hide():void {
		if (visible) {
			var duration:Number = getStyle("openDuration") as Number;
			if (!duration) {
				duration = .125;
			}
			
			//Hack to get certain transitions to work on device fonts; thanks, Scott!
			if (filters.length < 1) {
				//if no one has put any filters, we do so
				//this causes it to be cached as a bitmap 
				//and allows transparency on device fonts
				var filter:BlurFilter=new BlurFilter(0,0,1);
				var fltrs:Array = [filter];
				filters = fltrs;
			}
			// Stop any tween that's running
			if (tween)
				tween.stop();
				
			tween=new Tween(this,'alpha',Regular.easeOut,1,0, duration,true);
			tween.addEventListener(TweenEvent.MOTION_FINISH,onTweenEnd);
		}
	}
    /**
     *  @private
	 *  Creates a submenu for this menu
     */
	protected function openSubMenu(row:MenuCellRenderer):Menu {
		var rootMenu:Menu=getRootMenu();
		var mnu:Menu;
		var overlap:int = 3;
		// check to see if the menu exists, if not create it
		if (! MenuCellRenderer(row).menu) {
			mnu=Menu.createMenu(rootMenu,row.data.data);
			mnu.visible=false;
			mnu.parentMenu=this;
			//mnu.showRoot = showRoot;
			mnu.labelField=rootMenu.labelField;
			mnu.labelFunction=rootMenu.labelFunction;
			mnu.iconField=rootMenu.iconField;
			mnu.iconFunction=rootMenu.iconFunction;
			mnu.rowHeight=rootMenu.rowHeight;
			mnu.anchorRow=row;
			mnu.anchorIndex=row.listData.index;
			selectedIndex = row.listData.index;
			row.subMenu=mnu;
			//setting scales causes a redraw loop
			//mnu.scaleY = rootMenu.scaleY;
			//mnu.scaleX = rootMenu.scaleX;
			mnu.realParent=this.realParent;
			// mnu.sourceMenuBar = sourceMenuBar;
		} else {
			mnu=MenuCellRenderer(row).menu;
		}
		
		var r:DisplayObject=DisplayObject(row);
		var pt:Point=new Point(0,0);
		pt = r.localToGlobal(pt);
		// if this is loaded from another swf, global coordinates could be wrong
		if (r.root) {
			pt=r.root.globalToLocal(pt);
		}
		mnu.show(pt.x + mnu.parentMenu.width - overlap,pt.y);
		//hack for resetting caretIndex (used by moveSelectionVertically)
		//caretIndex isn't being updated to synchronize with selectedIndex, so 
		//you'd have to press the down key twice to get the selection to move
		mnu.caretIndex = 0;
		
		return mnu;
	}
	/**
	 *  @private
	 */
	private function closeSubMenu(menu:Menu):void {
		menu.hide();
		menu.closeTimer=0;
	}
	
	/**
	 *  @private
	 *  Sets everything back to normal when the hidden Menu's fade ends
	 */
	protected function onTweenEnd(event:TweenEvent):void {
		//set the menu back to normal, and off the display list
		var m:Menu = event.currentTarget.obj as Menu;
		m.visible=false;
		// Now that the menu is no longer visible, it doesn't need
		// to listen to mouseDown events anymore.
		stage.removeEventListener(MouseEvent.MOUSE_DOWN,mouseDownOutsideHandler);
		m.alpha=1;
		// Fire an event
		//could be fired earlier, but it messes with the tween
		var menEvent:MenuEvent=new MenuEvent(MenuEvent.MENU_HIDE);
		menEvent.menu=m;
		//menuEvent.menuBar = sourceMenuBar;
		getRootMenu().dispatchEvent(menEvent);
	}
	
	/**
	 * @private
	 * From any menu, walks up the parent menu chain and finds the root menu.
	 */
	protected function getRootMenu():Menu {
		var target:Menu=this;
		while (target.parentMenu) {
			target = target.parentMenu;
		}
		return target;
	}
	/**
	 *  @private
	 *  Checks to see if a mouse event was fired from a Menu
	 */
	private function isMouseOverMenu(event:MouseEvent):Boolean {
		var target:DisplayObject = DisplayObject(event.target);
		while (target) {
			if (target is Menu) {
				return true;
			}
			target = target.parent;
		}
		return false;
	}
	
	// -------------------------------------------------------------------------
	// Event Handlers
	// -------------------------------------------------------------------------
	
	/**
	 * @private (protected)
	 * Does Menu-specific item clicks
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0
	 */
	override protected function handleCellRendererClick(event:MouseEvent):void {
		var renderer:MenuCellRenderer = event.currentTarget as MenuCellRenderer;
		var itemIndex:uint = renderer.listData.index;
		
		if (!getRootMenu().dispatchEvent(new MenuEvent(MenuEvent.ITEM_CLICK,false,true,null,
		   renderer.menu,renderer.data, renderer,itemToLabel(renderer.data) ,itemIndex)) || !_selectable) {
			return;
		}
		var selectIndex:int = selectedIndices.indexOf(itemIndex);
		var i:int;
		
		renderer.selected = true;
		_selectedIndices = [itemIndex];
		lastCaretIndex = caretIndex = itemIndex;
		var item:Object = renderer.data;
		if (item.hasOwnProperty("type")) {
			var type:String = item.type.toLowerCase();
			// Check box
			if (type == "check") {
				renderer.data.selected = !renderer.data.selected;
				invalidate();
			}
		}
		hideAllMenus();
		//dispatchEvent(new Event(Event.CHANGE));
		invalidate(InvalidationType.DATA);
	}
	
	/**
	 *  @private
	 */
	private function mouseDownOutsideHandler(event:MouseEvent):void {
		if (!isMouseOverMenu(event) )
			hide();
		}
	/**
	 *  @private
	 *  Extend the behavior from SelectableList to pop up submenus
	 */
	protected function itemRollOver(event:MenuEvent):void {
		deleteDependentSubMenus();
		var row:MenuCellRenderer=itemToCellRenderer(event.item)  as  MenuCellRenderer;
		
		selectedIndex = -1;
		if (row.data.data) {
			//if the row has its own data (taken from XML and thrown into an object)
			// If the menu is not visible, pop it up after a short delay
			if (!row.subMenu || !row.subMenu.visible)
			{
				if (openSubMenuTimer)
					clearInterval(openSubMenuTimer);
 
				openSubMenuTimer = setTimeout(
					function(row:MenuCellRenderer):void
					{
						openSubMenu(row);
						
					},
					175,
					row);
			}
		}
	}
	/**
	 *  @private
	 *  Make submenu disappear when another item is hovered
	 */
	protected function itemRollOut(event:MenuEvent):void {
		var row:MenuCellRenderer=itemToCellRenderer(event.item)  as  MenuCellRenderer;
		if (!row.subMenu || !row.subMenu.visible) {
			selectedIndex=-1;
		}
	}
	
}
}