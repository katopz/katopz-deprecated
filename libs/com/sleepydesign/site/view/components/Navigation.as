/**
 * PureMVC Flash/AS3 site demo
 * Copyright (c) 2008 Yee Peng Chia <peng@hubflanger.com>
 * 
 * This work is licensed under a Creative Commons Attribution 3.0 United States License.
 * Some Rights Reserved.
 * 
 * Modify by Todsaporn Banjerdkit <katopz@sleepydesign.com>
 * Under a Creative Commons Attribution 3.0 Thailand License.
 * 
 */
package com.sleepydesign.site.view.components
{
	import com.sleepydesign.application.core.SDApplication;
	import com.sleepydesign.components.SDTreeNode;
	import com.sleepydesign.core.SDContainer;
	import com.sleepydesign.events.SDEvent;
	import com.sleepydesign.site.ApplicationFacade;
	import com.sleepydesign.site.model.SWFAddressProxy;
	import com.sleepydesign.site.model.vo.SiteVO;
	import com.sleepydesign.utils.URLUtil;
	
	import flash.events.*;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;

	public class Navigation extends SDContainer
	{
		private var tree:SiteMap;
		public static var queuePaths:Array; 
		public static var currrentPath:String;
		public static var defaultPath:String;
		
		// Singleton
		private static var instance : Navigation;
        public static function getInstance() : Navigation 
        {
            if ( instance == null ) instance = new Navigation();
            return instance as Navigation;
        }
		public function Navigation(id:String="navigation")
		{
			if ( instance == null )
				instance = this;
			
			super(id);
		}
		
		// ______________________________ Initialize ______________________________
		
		public function parse(raw:Object=null):void
		{
			var data:SiteVO = SiteVO(raw.data);
			var navIDs:Array = [];//raw.navIDs;
			var navLabels:Array = [];
			var navSources:Array = [];
			
			/**
			 * initializes currentSection to the first id in navIDs array or external focus defined in site tag
			 */
			//ApplicationFacade.currentSection = ApplicationFacade.currentSection?ApplicationFacade.currentSection:navIDs[ 0 ];
			
			for ( var i:uint=0; i<navIDs.length; i++ ) 
			{
				var id:String = navIDs[ i ];
				//var vo:ContentVO = _data[ id ];
				/* 
        		var data:SiteVO = SiteVO(_siteDataProxy.getData());
        		var vo:ContentVO = ContentVO(data.contents.find( id ));
				*/
				
				//var vo:ContentVO = ContentVO(data.contents.findBy( id ));
				//navLabels[ id ] = vo.label;
				//navSources[ id ] = vo.source
			} 
			
			_config = {xml:data.xml};//, navIDs:navIDs, navLabels:navLabels, navSources:navSources}
			
		} 
		
		// ______________________________ Create ______________________________
		
		override public function create(config:Object=null):void
		{
			config = _config = config?config:_config;
			/*
			for ( var i:uint=0; i<this.config.navIDs.length; i++ ) 
			{
				var id:String = this.config.navIDs[ i ];
				var btn:SDButton = navButtons[ i ];
				
				btn.data = id;
				//btn.label = this.config.navLabels[ id ];
				btn.buttonMode = true;
				btn.mouseChildren = false;
				

				btn.addEventListener( MouseEvent.CLICK, onClickHandler, false, 0, true );
			}
			*/
			
			// TODO : move this to system layer, no xml woohoo suppose to be here, only type object here!
			
			var cm : ContextMenu = new ContextMenu();
			cm.hideBuiltInItems();
			var ci:ContextMenuItem = new ContextMenuItem("Site Map", true);
			cm.customItems = [ci];
			//trace("SDApplication.instance.stage:"+SDApplication.instance);
			
			if(!SDApplication.getInstance().contextMenu)
				SDApplication.getInstance().contextMenu = new ContextMenu();
			
			SDApplication.getInstance().contextMenu.customItems.unshift(ci);// = cm;
			
			ci.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onSiteMapSelect);
			
			tree = new SiteMap(config.xml);
			tree.x = 10
			tree.y = 10
			tree.addEventListener(SDEvent.CHANGE_FOCUS, onSiteMap);
			tree.visible = false;
			addChild(tree);
		}
		
		private function onSiteMapSelect(event:ContextMenuEvent):void
		{
			tree.visible = !tree.visible;
		}
		
		private function getPathFromNode(node:SDTreeNode):String
		{
			return node.path.split("$").join("");
		}
		
		private function onSiteMap(event:SDEvent):void
		{
			var node:SDTreeNode = SDTreeNode(event.data.node);
			//var path:String = node.path.split("$").join("");
			trace(" * onSiteMap\t: "+node.path);
			//setSectionByPath(node.path);
			
			dispatchEvent( new SDEvent( SDEvent.CHANGE_FOCUS, {node:node, path:getPathFromNode(node)}));
		}
		
		/**
		 * Called whenever a SECTION_CHANGED notification is sent to the
		 * framework. Loops through navButtons and sets selected button to 
		 * selected state
		 */
		public function setSectionByPath( path:String ):void
		{	
			if(ApplicationFacade.focusPath == path && currrentPath == path)return;
			
			trace(" * setSectionByPath : "+path);
			/*
			// tree need update
			if(tree.currentNode && tree.currentNode.path.split("$").join("")!=path)
			{
				trace("\n / [Navigation] --------------------------------------");
				trace(" * tree.currentNode.path : "+tree.currentNode.path.split("$").join(""));
				trace(" -------------------------------------- [Navigation] /\n");
			}*/
			
			// set
			var id:String = path.split("/").pop();
			setSectionById(id);
			
			// update
			currrentPath = path;
			ApplicationFacade.focusPath = path;
		}
		
		public function setSectionById(id:String):void
		{	
			if(!tree)return;
			
			trace(" * tree.setSectionById\t: " + id);
			var node:SDTreeNode = tree.setFocusById(id);
			
			// someone try to change focus?
			dispatchEvent( new SDEvent( SDEvent.SET_FOCUS, { id:id }));
			
			if(node && currrentPath&& currrentPath!=ApplicationFacade.focusPath)
			{
				trace(" ! CHANGE_FOCUS\t: "+ node.path);
				//dispatchEvent( new SDEvent( SDEvent.CHANGE_FOCUS, { node:node, path:node.path, section:SWFAddressUtil.segmentURI(node.path)}));
				dispatchEvent( new SDEvent( SDEvent.CHANGE_FOCUS, {node:node, path:getPathFromNode(node)}));
			}
		}
		
		public function getPathById(id:String) : String
		{
			return tree.getPathById(id);
		}
		
		// ______________________________ Event Handler ____________________________
		
		/**
		 * Nav button pressed event handler. 
		 * Communicates with NavMediator using Flash's built-in Event model
		 */
		/*
		private function onClickHandler( evt:Event ):void
		{
			setFocusById( evt.target.data );
		}
		*/
		
		public static function setFocusById( id:String ):void
		{
			trace(" * Navigation.setFocusById : "+ id);
			// sometime call from dependency
			if(instance)
				instance.setSectionById(id);
			//instance.dispatchEvent( new SDEvent( SDEvent.CHANGE_FOCUS, {id:id}));
		}
		
		public static function getURL(id:String, uri:String, window:String = "_blank"):void 
		{
			trace(" * Navigation.getURL : "+ uri);
			URLUtil.getURL(uri, window);
			
			// sometime call from dependency
			if(instance)
				instance.dispatchEvent( new SDEvent( SDEvent.UPDATE, { id:id }));
		}
	}
}