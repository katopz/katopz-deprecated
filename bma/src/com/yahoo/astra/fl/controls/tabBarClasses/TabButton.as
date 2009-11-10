/*
Copyright (c) 2007, Yahoo! Inc. All rights reserved.
Code licensed under the BSD License:
http://developer.yahoo.com/flash/license.html
*/
package com.yahoo.astra.fl.controls.tabBarClasses
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import fl.controls.Button;
	import flash.text.TextFieldAutoSize;
	import fl.events.ComponentEvent;
	import fl.core.InvalidationType;

	/**
	 * A button type designed for use with the TabBar component.
	 * 
	 * @see com.yahoo.astra.fl.controls.TabBar
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     * @author Josh Tynjala
	 */
	public class TabButton extends Button
	{
		
	//--------------------------------------
	//  Static Properties
	//--------------------------------------
	
		/**
		 * @private
		 */
		private static var defaultStyles:Object =
		{
			icon: null,
			
			upSkin: "Tab_upSkin",
			downSkin: "Tab_downSkin",
			overSkin: "Tab_overSkin",
			disabledSkin: "Tab_disabledSkin",
			selectedUpSkin: "Tab_selectedUpSkin",
			selectedDownSkin: "Tab_selectedUpSkin",
			selectedOverSkin: "Tab_selectedUpSkin",
			selectedDisabledSkin: "Tab_selectedDisabledSkin",
			
			focusRectSkin: null,
			focusRectPadding: null,
			textFormat: null,
			disabledTextFormat: null,
			embedFonts: null,
			textPadding: 10,
			verticalTextPadding: 2
		};
		
	//--------------------------------------
	//  Static Methods
	//--------------------------------------
		
		/**
         * @copy fl.core.UIComponent#getStyleDefinition()
         *
		 * @includeExample ../core/examples/UIComponent.getStyleDefinition.1.as -noswf
		 *
         * @see fl.core.UIComponent#getStyle()
         * @see fl.core.UIComponent#setStyle()
         * @see fl.managers.StyleManager
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		public static function getStyleDefinition():Object
		{
			return defaultStyles;
		}
		
	//--------------------------------------
	//  Constructor
	//--------------------------------------
		
		/**
		 * Constructor.
		 */
		public function TabButton()
		{
			super();
		}
		
	//--------------------------------------
	//  Properties
	//--------------------------------------
		
		/**
		 * @private
		 * This component will resize based on the size of its label.
		 */
		override public function set label(value:String):void
		{
			this._label = value;
			this.invalidate(InvalidationType.SIZE);
			this.invalidate(InvalidationType.STYLES);
			this.dispatchEvent(new ComponentEvent(ComponentEvent.LABEL_CHANGE));
		}
		
	//--------------------------------------
	//  Protected Methods
	//--------------------------------------
	
		/**
		 * @private
		 * When a tab is selected, it cannot be deselected.
		 */
		override protected function toggleSelected(event:MouseEvent):void
		{
			if(!this.selected)
			{
				this.selected = true;
				this.dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		/**
		 * @private
		 * We're going to resize based on the size of the label, rather than the avatar
		 */
		override protected function configUI():void
		{
			super.configUI();
			this.textField.autoSize = TextFieldAutoSize.LEFT;
		}
		
		/**
		 * @private
		 */
		override protected function draw():void
		{
			if(this.textField.text != this._label)
			{
				this.textField.text = this._label;
				this.width = this.textField.width + (this.getStyleValue("textPadding") as Number) * 2;
				//this.height = this.textField.height + (this.getStyleValue("verticalTextPadding") as Number) * 2;
			}
			super.draw();
		}
	}
}