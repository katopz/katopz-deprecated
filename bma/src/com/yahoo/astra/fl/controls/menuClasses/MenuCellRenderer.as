/*
Copyright (c) 2007, Yahoo! Inc. All rights reserved.
Code licensed under the BSD License:
http://developer.yahoo.com/flash/license.html
*/
package com.yahoo.astra.fl.controls.menuClasses {
import flash.text.TextFormat;
import flash.filters.BevelFilter;
import flash.display.Graphics;
import flash.display.DisplayObject;
import fl.controls.listClasses.CellRenderer;
import com.yahoo.astra.fl.controls.Menu;
 
//--------------------------------------
//  Styles
//--------------------------------------
/**
 * The icon to display when a menu has a submenu
 *
 * @default MenuBranchIcon
 *
 * @langversion 3.0
 * @playerversion Flash 9.0.28.0
 */
[Style(name="branchIcon", type="Class")]
/**
 * The graphic to use for menu separators
 *
 * @default MenuSeparatorSkin
 *
 * @langversion 3.0
 * @playerversion Flash 9.0.28.0
 */
[Style(name="separatorSkin", type="Class")]
/**
 * The up skin
 *
 * @default MenuCellRenderer_upSkin
 *
 * @langversion 3.0
 * @playerversion Flash 9.0.28.0
 */
[Style(name="upSkin", type="Class")]
/**
 * The down skin
 *
 * @default MenuCellRenderer_downSkin
 *
 * @langversion 3.0
 * @playerversion Flash 9.0.28.0
 */
[Style(name="downSkin", type="Class")]
/**
 * The over skin
 *
 * @default MenuCellRenderer_overSkin
 *
 * @langversion 3.0
 * @playerversion Flash 9.0.28.0
 */
[Style(name="overSkin", type="Class")]
/**
 * The disabled skin
 *
 * @default MenuCellRenderer_disabledSkin
 *
 * @langversion 3.0
 * @playerversion Flash 9.0.28.0
 */
[Style(name="disabledSkin", type="Class")]
/**
 * The selected disabled skin
 *
 * @default MenuCellRenderer_selectedDisabledSkin
 *
 * @langversion 3.0
 * @playerversion Flash 9.0.28.0
 */
[Style(name="selectedDisabledSkin", type="Class")]
/**
 * The selected up skin
 *
 * @default MenuCellRenderer_selectedUpSkin
 *
 * @langversion 3.0
 * @playerversion Flash 9.0.28.0
 */
[Style(name="selectedUpSkin", type="Class")]
/**
 * The selected down skin
 *
 * @default MenuCellRenderer_selectedDownSkin
 *
 * @langversion 3.0
 * @playerversion Flash 9.0.28.0
 */
[Style(name="selectedDownSkin", type="Class")]
/**
 * The selected over skin
 *
 * @default MenuCellRenderer_selectedOverSkin
 *
 * @langversion 3.0
 * @playerversion Flash 9.0.28.0
 */
[Style(name="selectedOverSkin", type="Class")]
/**
 * The text padding
 *
 * @default 5
 *
 * @langversion 3.0
 * @playerversion Flash 9.0.28.0
 */
[Style(name="upSkin", type="Number", format="Length")]
//--------------------------------------
//  Class description
//--------------------------------------
/**
 * The MenuCellRenderer is the default renderer of a Menu's rows, 
 * adding support for branch icons and display of submenus.
 *
 * @langversion 3.0
 * @playerversion Flash 9.0.28.0
 * @includeExample examples/ButtonExample.as
 */	
public class MenuCellRenderer extends CellRenderer
{
	public function MenuCellRenderer() {
	super();
	menu = parent as Menu;
    
}
		
		
	//----------------------------------
	//  branchIcon
    //----------------------------------
	/**
	 *  Displays the branch icon
	 *  in this renderer.
	 *  
	 *  @default  
	 */
	protected var branchIcon:DisplayObject;
	
	
	//----------------------------------
	//  menu
    //----------------------------------
	/**
	 *  @private
	 *  Storage for the menu property.
	 */
	private var _menu:Menu;
	/**
	 *  Contains a reference to the associated Menu control.
	 * 
	 *  @default null 
	 */
	public function get menu():Menu
	{
		return _menu;
	}
	/**
	 *  @private
	 */
	public function set menu(value:Menu):void
	{
		_menu = value;
	}
	
	//----------------------------------
	//  subMenu
    //----------------------------------
	/**
	 *  @private
	 *  Storage for the menu property.
	 */
	private var _subMenu:Menu;
	/**
	 *  Contains a reference to the associated subMenu, if any.
	 * 
	 *  @default null 
	 */
	public function get subMenu():Menu
	{
		return _subMenu;
	}
	/**
	 *  @private
	 */
	public function set subMenu(value:Menu):void
	{
		_subMenu = value;
	}
	
	
	 /**
	 * @private
	 *
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0
	 */
	 private static var defaultStyles:Object = {  upSkin:"MenuCellRenderer_upSkin",
												  downSkin:"MenuCellRenderer_downSkin",
												  overSkin:"MenuCellRenderer_overSkin",
												  disabledSkin:"MenuCellRenderer_disabledSkin",
												  selectedDisabledSkin:"MenuCellRenderer_selectedDisabledSkin",
												  selectedUpSkin:"MenuCellRenderer_selectedUpSkin",
												  selectedDownSkin:"MenuCellRenderer_selectedDownSkin",
												  selectedOverSkin:"MenuCellRenderer_selectedOverSkin",
												  branchIcon: "MenuBranchIcon",
												  checkIcon: "MenuCheckIcon",
												  separatorSkin: "MenuSeparatorSkin",
												  textPadding: 5
												 };
 	/**
	 * @private
	 *
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0
	 */												  
	public static function getStyleDefinition():Object { 
		return defaultStyles; 
	}
									
	 /**
	 * @private
	 *
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0
	 */									
	override protected function drawLayout():void {
		var textPadding:Number = Number(getStyleValue("textPadding"));
		var textFieldX:Number = 0;
		var fullWidth:int;
		
		// Align text
		if (label.length > 0) {
			textField.visible = true;
			
			textField.height = textField.textHeight + 4;
			textField.x = textFieldX + textPadding + 10;
			textField.y = Math.round((height-textField.height)>>1);
		} else {
			textField.visible = false;
		}
		
		// Size highlight
		fullWidth = Math.max(textField.textWidth + textPadding + 25, width);
		
		width = fullWidth;
		background.width = fullWidth;
		background.height = height;
		
		//show an arrow if there's a submenu
		if(data.hasOwnProperty("data"))
		{
			if (!branchIcon)
			{
				var branchIconStyle:Object = getStyleValue("branchIcon");
				if (branchIconStyle != null)
				{
					branchIcon = getDisplayObjectInstance(branchIconStyle);
				}
				
				if (branchIcon != null)
				{ 
					branchIcon.visible = true;
					addChild(branchIcon);
				}
			}
			if(branchIcon)
			{
				branchIcon.x = width - 5 - branchIcon.width;
				branchIcon.y = Math.round((height-branchIcon.height)>>1);
			}
			
		}
		
		//set enabled
		if(data.hasOwnProperty("enabled"))
		{
			if(!data.enabled is Boolean && data.enabled is String)
			{
				enabled = data.enabled.toLowerCase() == "true";
			}
		}
		
		if(data.hasOwnProperty("type"))
		{
			var type:String = data.type.toLowerCase();
			// Separator
			if (type == "separator")
			{
				label = "";
				enabled = false;
				var separatorStyle:Object = getStyleValue("separatorSkin");	
				if (separatorStyle != null)
				{ 
					icon = getDisplayObjectInstance(separatorStyle);
					icon.visible = true;
					icon.width = fullWidth - 3;
				}
				return;
			}
			
			//Checks
			if(type == "check")
			{
				var checkIcon:Object = getStyleValue("checkIcon");	
				if (checkIcon != null)
				{ 
					icon = getDisplayObjectInstance(checkIcon);
				}
					 
				if(data.hasOwnProperty("selected"))
				{
					if(!data.selected is Boolean && data.selected is String)
					{
						data.selected = data.selected.toLowerCase() == "true";
					}
				}
				else data.selected = false;
				icon.visible = data.selected;
			}
			
			// Align icon
			if (icon != null) {
				icon.x = textPadding;
				icon.y = Math.round((height-icon.height)>>1);
				
			}
		}
		
		
	}
	
		/**
         * @private (protected)
         *
		 * Makes the label resize to its contents
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		override protected function configUI():void {
			super.configUI();
			
			textField.autoSize = "left";
		}
}
}