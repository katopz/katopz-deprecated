/**
*
* @author katopz@sleepydesign.com
* @version 0.1
*/

package {

	
	import fl.accessibility.ComboBoxAccImpl;
	import flash.system.Security;
	import flash.display.*;
	import flash.net.*;
	import flash.ui.*;
	import flash.text.*;
	import flash.utils.Timer;
	
	import flash.events.*;
	import fl.events.ListEvent;
	import com.sleepydesign.SleepyDesign;
	import com.sleepydesign.site.*;
	import com.sleepydesign.utils.*;

	import fl.data.SimpleCollectionItem;
	import fl.data.DataProvider;
	import fl.controls.*;
	import fl.containers.*;
	import fl.controls.listClasses.*;

	import fl.core.UIComponent;
	import fl.data.DataProvider;
	
	import caurina.transitions.Tweener;
	
	import com.sleepydesign.utils.*;

	public class shell extends Panel
	{
		public static var configXML:XML;
		
		var isExternal            : Boolean = false;
		
		/*
		var page                  : String;
		
		var Canal                 : Panel;
		var SCADA                 : Panel;
		var Flood                 : Panel;
		*/
		
		var task
		
		var ticker
		
		var totalContent          : Number = 0;
		var contentLoaded         : Number = 0;
		var currentItem;
		
		var listWidth             : Number = 160;
		var currentListName       : String = "";
		
		var externalPage	       : String = "";
		
		public function shell(){
			
			SleepyDesign.log("=============================[ shell ]=============================");
			Security.allowDomain("*");
			
			getConfig("config.xml");
			this.addEventListener(ContentEvent.GETCONFIG, onShellGetConfig);
			
		}
		
		public function onShellGetConfig(event:ContentEvent):void {
			
			SleepyDesign.log(" ^ " + event.type);
			
			//external
			for (var i in loaderInfo.parameters) {
				if (i == "page") {
					externalPage = loaderInfo.parameters[i];
				}
			}
			
			Global.config = config;
			createShell();
		}
		
		public function createShell():void {
			
			contentLoaded = 0;
			
			for each(var panelXML in config..panel){

				var _panel:Panel = new Panel(this,panelXML.@id);
				createPanel(_panel);
				addContent(_panel);
				
				_panel.addEventListener(ContentEvent.SETFOCUS, onContentSetFocus);
				_panel.addEventListener(ContentEvent.LOSTFOCUS, onContentLostFocus);
				
			}
			
			this.addEventListener(ContentEvent.SETFOCUS, onPanelSetFocus);
			setFocusByName(config.@focus);
			
			//_________________________________________________________________ Menu
			
			createSiteMap();
			
		}
		
		public function createPanel(iPanel:Panel):void {
			
			//page = iPanel.name;
			
			iPanel.extra = new Object();
			
			var panelId = iPanel.name;
			var panelConfig = XMLUtil.getNodeById(config,panelId);
			
			//_________________________________________________________________ Background
			
			iPanel.extra.background = new Content(iPanel);
			iPanel.extra.background.load(panelConfig.background.@src);
			
			//_________________________________________________________________ Foreground
			
			iPanel.extra.foreground = new Content(iPanel);
			iPanel.extra.foreground.load(panelConfig.foreground.@src);
			iPanel.extra.foreground.addEventListener(ContentEvent.COMPLETE, onForegroundComplete);
			
			//_________________________________________________________________ Content
			
			var mapId = iPanel.name+"Map";
			var mapConfig = XMLUtil.getNodeById(config,mapId);
			
			iPanel.extra.map = new Content(iPanel,mapId);
			iPanel.extra.map.config = mapConfig;
			iPanel.extra.map.load(mapConfig.@src);
			iPanel.extra.map.addEventListener(ContentEvent.COMPLETE, onPageComplete);
			iPanel.extra.map.addEventListener(ContentEvent.READY, onPageReady);
			iPanel.addContent(iPanel.extra.map);
			
			iPanel.extra.map.extra = {shell:this,selectedIndex:-1,ttl:mapConfig.@ttl}
			
			totalContent++;
			
			var graphId = iPanel.name+"Graph";
			var graphConfig = XMLUtil.getNodeById(config,graphId);
			
			iPanel.extra.graph = new Content(iPanel,graphId);
			iPanel.extra.graph.config = graphConfig;
			iPanel.extra.graph.load(graphConfig.@src);
			iPanel.extra.graph.addEventListener(ContentEvent.COMPLETE, onPageComplete);
			iPanel.extra.graph.addEventListener(ContentEvent.READY, onPageReady);
			iPanel.addContent(iPanel.extra.graph);
			
			iPanel.extra.graph.extra = {shell:this,selectedIndex:-1,ttl:graphConfig.@ttl}
			
			totalContent++;
			
			var stationId = iPanel.name+"Station";
			var stationConfig = XMLUtil.getNodeById(config,stationId);
			
			iPanel.extra.station = new Content(iPanel,stationId);
			iPanel.extra.station.config = stationConfig;
			iPanel.extra.station.load(stationConfig.@src);
			iPanel.extra.station.addEventListener(ContentEvent.COMPLETE, onPageComplete);
			iPanel.extra.station.addEventListener(ContentEvent.READY, onPageReady);
			iPanel.addContent(iPanel.extra.station);
			
			iPanel.extra.station.extra = {shell:this,selectedIndex:-1,ttl:stationConfig.@ttl}
			
			totalContent++;
			
			//_________________________________________________________________ Left Panel
			
			createList(iPanel);
			
			if (externalPage) {
				iPanel.setFocusByName(iPanel.name+externalPage);
			}else {
				iPanel.setFocus(iPanel.extra.map);
			}
		}
		
		public function setFocusIndex(iPanel:Panel,iIndex:uint):void {
			trace(" - setFocusIndex:"+iIndex)
			iPanel.extra.focusIndex = iIndex
		}
		
		public function updatePanel():void {
			
			//stopPolling()

			//var panel = iPanel;
			//var page = iPanel.currentContent;
			
			SleepyDesign.log("=============================[ "+page.name+" ]=============================")
			
			if(page==panel.extra.map){
				//special case for map
				panel.extra.list.selectedIndex=-1
				
				update();
				
			}else if(page.name=="FloodGraph"){
				//special case for Floodgraph
				panel.extra.list.selectedIndex=-1
				
				update();
				
			}else{
				//new list
				if(panel.extra.list.selectedIndex==-1){
					
					if(page.extra.focusIndex==-1){
						//no focus
						setItem(getItemByIndex(0));
						panel.extra.focusIndex=0
					}else{
						
						if(panel.extra.focusIndex!=-1){
							//external focus
							setItem(getItemByIndex(panel.extra.focusIndex));
							panel.extra.focusIndex=-1
						}else{
							//history focus
							setItem(getItemByIndex(page.extra.focusIndex));
						}
						
					}
					
				}
			}
			
			//_________________________________________________________________ Menu
			
			task.menu.dataprovider = page.config.menu
		}
		
		public function onPanelSetFocus(event:ContentEvent):void {
			SleepyDesign.log(" ^ "+event.type+" : "+event.content.name);
			//var panel = (currentContent as Panel);
			//var page = (currentContent as Panel).currentContent;
			//trace("*************onPanelSetFocus")
			if(currentListName!=page.name){
				getList(XMLUtil.getNodeById(page.config,page.name+"List").@src);
			}
		}
		
		public function onContentSetFocus(event:ContentEvent):void {
			
			SleepyDesign.log(" ^ "+event.type+" : "+event.content.name);
			//var panel = (currentContent as Panel);
			//var page = (currentContent as Panel).currentContent;
			
			if(currentListName!=page.name){
				getList(XMLUtil.getNodeById(config,page.name+"List").@src);
			}
			
		}
		
		public function onContentLostFocus(event:ContentEvent):void {

		}
		
		public function subFocus(id){
			
			try{
				(currentContent as Panel).setFocus(currentContent.extra[id]);
			}catch(e:*){
				//trace(e)
			}
			
		}
		
		public function createSiteMap(){
			
			var myMenu:ContextMenu = new ContextMenu();
			myMenu.hideBuiltInItems();
			
			for each (var panelXML in config..panel){
				
				var cutItem:ContextMenuItem = new ContextMenuItem(panelXML.@id);
				cutItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, menuItemSelectHandler);
				
				myMenu.customItems.push(cutItem);
				
			}
			
			this.contextMenu = myMenu;
			
			//var nav = addChild(new iNav());
			//nav.addEventListener(DockEvent.SELECTED, dockSelectHandler);
			
			task = addChild(new iTask());
			task.y = 558;
			task.menu = task.addChild(new Menu());
			
		}
		
		public function dockSelectHandler(event:DockEvent):void {
			
			subFocus(event.content);
			//setItem(currentContent.extra.list.selectedItem);
		}
		
		public function menuItemSelectHandler(event:ContextMenuEvent):void {
			setFocusByName(event.target.caption);
		}
		
		//_________________________________________________________________ Left Panel
		
		public function createList(iPanel:Panel):void {
			
			iPanel.extra.leftPanel = iPanel.addChild(new iList());
			
			iPanel.extra.list = iPanel.addChild(new List());

			iPanel.extra.focusIndex = -1;
			
			var list = iPanel.extra.list
			list.width = 160;
			list.height = 450;
			
			list.y=100;
			
			//updateLeftPanel()
			
		}
		
		public function updateLeftPanel():void {
			if(page){
				panel.extra.leftPanel.title.gotoAndStop(page.name)
			}
		}
		
		public function getList(iURL){
			trace(" > getList : "+iURL)
			var loader:URLLoader = new URLLoader();
			var request:URLRequest = new URLRequest( URLUtil.killCache(iURL) )
			
			loader.load(request);
			loader.addEventListener(Event.COMPLETE, onListComplete);
			
		}
		
		public function onListRollOver(event:MouseEvent):void {
			
			Tweener.removeTweens(currentContent.extra.list)
			
			if(currentContent.extra.list.width<listWidth){
				Tweener.addTween(currentContent.extra.list,{alpha:0.5,width:listWidth, time:0.25, transition:"easeoutquad"})
			}
			
		}
		
		public function onListRollOut(event:MouseEvent):void {
			
			Tweener.addTween(currentContent.extra.list,{alpha:1,width:160, time:0.25, delay:0,transition:"easeinquad"})
			
		}
		
		public function onListSelect(event:ListEvent):void {
			
			//update();
			
		}
		
		public function onListChange(event:Event):void {
			
			stopPolling()
			
			//var panel = currentContent as Panel;
			//var page = (currentContent as Panel).currentContent;
			
			
			if(page==panel.extra.map){
				//special case for map
				setFocusIndex(panel, panel.extra.list.selectedIndex)
				subFocus("station");
			}else if(page.name=="FloodGraph"){
				//special case for FloodGraph
				setFocusIndex(panel, panel.extra.list.selectedIndex)
				subFocus("station");
			}else{
				setItem(currentContent.extra.list.selectedItem)
			}
		}
		
		public function update(){
			
			stopPolling()
			
			//var panel = currentContent as Panel;
			SleepyDesign.log(" * "+ContentEvent.UPDATE+" : "+panel.currentContent.name)
			if(currentItem){
				dispatchEvent( new ContentEvent( ContentEvent.UPDATE, panel.currentContent, currentItem.data) );
				//TODO add event insteadOf call back hack
				trace(currentItem.id)
				task.menu.currentId = currentItem.id;
			}else{
				dispatchEvent( new ContentEvent( ContentEvent.UPDATE, panel.currentContent, null) );
			}
			
		}
		
		public function onTick(event:TimerEvent){
			update();
		}
		
		public function stopPolling(){
			trace(" > stopPolling");
			//clear
			if(ticker){
				ticker.reset();
			}
			
		}
		
		public function startPolling(){
			
			stopPolling()
			
			trace(" > startPolling");
			
			//var panel = currentContent as Panel;
			//var page = (currentContent as Panel).currentContent;
			
			if(!ticker){
				ticker = new Timer(page.extra.ttl);
				ticker.addEventListener(TimerEvent.TIMER, onTick);
        	}
			
            ticker.start();
			
        }
		
		public function lostFocus(iItem):void {
			//station.setStation("default")
		}
		
		public function getItemByIndex(iIndex) {
			return currentContent.extra.list.dataProvider.getItemAt(iIndex);
		}
		
		public function getIndexById(iId) {
			SleepyDesign.log("getIndexById : "+iId)
			
			for (var i=0;i<currentContent.extra.list.dataProvider.length;i++) {
				var item = currentContent.extra.list.dataProvider.getItemAt(i)
				if(item.id==iId){
					return i;
				}
			}
			return null;
			
		}
		
		public function getItemById(iId) {
			SleepyDesign.log("getItemById : "+iId)
			
			for (var i=0;i<currentContent.extra.list.dataProvider.length;i++) {
				var item = currentContent.extra.list.dataProvider.getItemAt(i)
				if(item.id==iId){
					return item;
				}
			}
			return null;
			
		}
		
		public function setItem(iItem):void {
			
			//var page = (currentContent as Panel).currentContent;
			
			if(iItem){
				currentItem = iItem
				
				currentContent.extra.list.selectedItem = currentItem
				
				page.extra.focusIndex = currentContent.extra.list.selectedIndex
				
				update();
			}
			
		}
		
		public function get panel(){
			if(currentContent){
				return (currentContent as Panel);
			}else{
				return null
			}
			
		}
		
		public function get page(){
			if(panel){
				if(panel.currentContent){
					return panel.currentContent;
				}else{
				return null
				}
			}else{
				return null
			}
		}
		
		
		public function onListComplete(event:Event):void {
			
			SleepyDesign.log(" ^ "+event.type);
			
			//var panel = (currentContent as Panel);
			//var page = (currentContent as Panel).currentContent;
			
			currentListName = page.name
			trace(" - currentListName : "+page.name)
			
			updateLeftPanel()
			
			var loader:URLLoader = event.target as URLLoader;
			var xml:XML = new XML(loader.data);
			
			var dp:DataProvider = new DataProvider();
			var item
			
			listWidth = 160
			var labelNormal = ""
			
			switch(currentContent.name){
				case "Canal" :
				
					switch(panel.currentContent){
						case panel.extra.graph :
							//trace("Canal.extra.graph ")
							for each (item in xml.CANAL) {
								labelNormal = item.@NAME;
								//trace(labelNormal);
								
								dp.addItem({id:item.@id,labelNormal:labelNormal,data:item})
								listWidth = Math.max(listWidth,String(labelNormal).length*6);
							}
						break;
						default :
							for each (item in xml.STATION) {
								labelNormal = item.@id+" "+item.CANAL_NAME+" "+item.NAME
								dp.addItem({id:item.@id,labelNormal:labelNormal,data:item})
								listWidth = Math.max(listWidth,String(labelNormal).length*6);
							}
						break;
					}
					
				break;
				
				case "SCADA" :
					switch(panel.currentContent){
						case panel.extra.graph :
							for each (item in xml.RAIN) {
								labelNormal = item
								dp.addItem({id:item.@id,labelNormal:labelNormal,data:item})
								listWidth = Math.max(listWidth,String(labelNormal).length*6);
							}
						break;
						default :
							for each (item in xml.STATION) {
								labelNormal = item.@id+" "+item.CANAL_NAME+" "+item.NAME
								dp.addItem({id:item.@id,labelNormal:labelNormal,data:item})
								listWidth = Math.max(listWidth,String(labelNormal).length*6);
							}
						break;
					}
				break;
				default :
					for each (item in xml.STATION) {
						labelNormal = item.@id+" "+item.CANAL_NAME+" "+item.NAME
						dp.addItem({id:item.@id,labelNormal:labelNormal,data:item})
						listWidth = Math.max(listWidth,String(labelNormal).length*6);
					}
					
				break;
			}
			
			var list = currentContent.extra.list;
			list.labelField = "labelNormal"
			list.dataProvider = new DataProvider(dp);
			
			list.addEventListener(MouseEvent.ROLL_OVER, onListRollOver);
			list.addEventListener(MouseEvent.ROLL_OUT, onListRollOut);
			list.addEventListener(ListEvent.ITEM_CLICK , onListSelect);
			list.addEventListener(Event.CHANGE, onListChange);

			updatePanel();

		}
		
		//_________________________________________________________________ Link
		
		public function onForegroundComplete(event:ContentEvent):void {
			var link = addChild(new iLink())
			link.web.buttonMode = true;
			link.bma.buttonMode = true;
			link.web.addEventListener(MouseEvent.CLICK, linkClick);
			link.bma.addEventListener(MouseEvent.CLICK, linkClick);
		}

		private function linkClick(event:MouseEvent):void {
			var target=event.currentTarget as MovieClip;
			var link = XMLUtil.getNodeById(config,target.name);
			URLUtil.goToURL(link.@src,link.@target);
		}
		
		//_________________________________________________________________ Content
		
		public function onPageReady(event:ContentEvent):void {
			
			startPolling();
			
		}
		
		public function onPageComplete(event:ContentEvent):void {
			
			if(event.content.onUpdate){
				this.addEventListener(ContentEvent.UPDATE, event.content.onUpdate);
			}
			
			if(++contentLoaded==totalContent){
				trace(" ^ onShellReady : "+totalContent)
				//setItem(getItemByIndex(0));
				//isReady = true;
				update();
			}
			
		}
		
	}

}