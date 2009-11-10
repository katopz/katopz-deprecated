/**
* ...
* @author katopz@sleepydesign.com
* @version 0.1
*/

package com.sleepydesign.site{

	import flash.ui.*;
	import flash.events.*;
	import flash.display.*;
	import flash.utils.Dictionary;
	
	import com.sleepydesign.SleepyDesign;
	import com.sleepydesign.site.*;
	
	public class Panel extends Content{
		
		public var contents             : Array;
		public var currentContent       : Content;
		
		public var contentDictionary    : Dictionary;
		
		public function Panel(iParent:Sprite=null,iName:String=null){
			super(iParent,iName);
			//
			contents = new Array();
			currentContent = null;
			
			contentDictionary = new Dictionary( true );
			
			extra = new Object();
		}
		
		//_________________________________________________________________ Panel control
		/*
		public function menuItemSelectHandler(event:ContextMenuEvent):void {
			setFocus(contents[0])
		}
			
		public function showMenu():void {
			
			this.currentContent.visible = false
			
			var myMenu:ContextMenu = new ContextMenu();
			myMenu.hideBuiltInItems();
			
			for(var i in contents){
				var cutItem:ContextMenuItem = new ContextMenuItem(i+".Content");
				cutItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, menuItemSelectHandler);
				
				myMenu.customItems.push(cutItem);
			}
			
			this.contextMenu = myMenu;
			
			//menuItemSelectHandler(null)
		}
		*/
		
		//TODO dic
		public function setFocusAt(iIndex:Number):void {
			SleepyDesign.log("setFocusAt : "+iIndex);
			
			if(iIndex==-1){
				
				currentContent.hide();
				currentContent = null;
				
			}else{
				
				setFocus(contents[iIndex]);				
			}
			
		}
		
		public function setFocusByName(iName:String):void {	
			
			setFocus(getContentByName(iName));
			
		}
		
		public function getContentByName( name:String ):Content{
			return this.contentDictionary[ name ];
		}
		
		public function setFocus(iContent:Content):void {	
			
			if(currentContent != iContent){
				SleepyDesign.log(" # setFocus : "+iContent.name)
				
				for (var i in contents) {
					
					if (contents[i] != iContent) {
						//contents[i].onLostFocus();
						contents[i].hide();
						//contents[i].visible = false;
						//contents[i].alpha = 0.5
						//dispatchEvent({type:"onLostFocus", target:contents[i]});
						dispatchEvent(  new ContentEvent( ContentEvent.LOSTFOCUS, currentContent) );
					} else {
						currentContent = iContent;
						contents[i].visible = true;
						contents[i].show();
						//contents[i].onSetFocus();
						//contents[i].alpha = 1
						dispatchEvent(  new ContentEvent( ContentEvent.SETFOCUS, currentContent) );
					}
				}
			}else{
				dispatchEvent(  new ContentEvent( ContentEvent.SETFOCUS, currentContent) );
			}
		}
		
		public function addContent(iContent:Content){
			addChild(iContent);
			contents.push(iContent);
			contentDictionary[iContent.name] = iContent
			iContent.visible = false;
			return iContent
		}
		
		public function removeContent(iContent:Content){
			//contents.push(iContent);
		}
		/*
		public function add(iURL:String){
			create(iURL);
		}
		*/
	}

}