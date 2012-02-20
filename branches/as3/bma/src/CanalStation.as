/**
* ...
* @author katopz@sleepydesign.com
* @version 0.1
*/

package {
	import flash.system.Security;
	import flash.geom.*
	import flash.display.*
	import flash.events.*;
	import flash.net.*;
	import flash.text.*;
	
	import com.sleepydesign.SleepyDesign;
	import com.sleepydesign.site.*;
	import com.sleepydesign.utils.*;
	
	import com.sleepydesign.containers.Cursor;

	public class CanalStation extends Content{
		
		//TODO path config
		
		public var stationPath:String = "Canal/20_station/stations/";
		public var sectionPath:String = "Canal/20_station/sections/";
		
		public var type = "Station";
		
		var station;
		var section;
		
		var factor=20;
		var floodObject:Object;
		var sectionDetail;
		
		var isTest : Boolean = false;
		
		public function CanalStation(){
			Security.allowDomain("*")
			
			//TODO animaited mask
			iStation.mask = GraphicUtil.createRect(iStation);
			iSection.mask = GraphicUtil.createRect(iSection);	
			
			station = new Content(iStation);
			section = new Content(iSection);
			
			station.extra = new Object();
			section.extra = new Object();
			
			sectionDetail = addChild(new iSectionDetail());
			sectionDetail.x = iSection.x
			sectionDetail.y = iSection.y
				
			initTrend();
			
			//test()
		}
		
		public function test(){
			trace("Self Test")
			
			isTest  = true
			
			//var dataPath:String = "serverside/"+rootPath+"getData.php";
			
			stationPath = "stations/";
			sectionPath = "sections/";
			//dataPath = "../../"+dataPath;
			
			setStation("KP02","ok")
			setSection("KP02")
			
		}
		
		//_________________________________________________________________ Station

		public function setStation(iID:String,iName:String){
			//trace("******setStation:"+iID)
			if(station.extra.id!=iID){
				if(station){
					station.remove();
				}
				station.extra.id = iID;
				station.addEventListener(Event.COMPLETE, onStationComplete);
				station.load(stationPath+iID+".swf");
				
				iStationName.htmlText = iID+ " - "+iName;
			}
		}
		
		public function onStationComplete(event:ContentEvent):void {
			SleepyDesign.log(" ^ "+event.type);
		}	
		
		//_________________________________________________________________ Section
		
		public function setSection(iID:String){
			var dataPath = XMLUtil2.getNodeById(config,"CanalStationData").@src;
			
			if(isTest){
				dataPath = "../serverside/";
			}			
			
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onComplete);
			
			var request = new URLRequest( URLUtil.killCache(dataPath+ "Canal_"+iID+".xml") );
			loader.load(request);
			
			/*
			var dataPath = XMLUtil.getNodeById(config,"CanalStationData").@src;
			var method = String(XMLUtil.getNodeById(config,"CanalStationData").@method).toUpperCase();
			
			if(isTest){
				dataPath = "http://localhost/yourpath/Canal/serverside/Canal_"+iID+".xml";
			}
			
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onComplete);
			
			var request = new URLRequest( URLUtil.killCache(dataPath) )
            var variables:URLVariables = new URLVariables();
            variables.id = iID;
            request.data = variables;
			request.method = (method==URLRequestMethod.POST)?request.method = URLRequestMethod.POST:URLRequestMethod.GET;
			
			loader.load(request);
			*/
		}
		
		public function createSection(iID:String){
			
			if(section.extra.canel){
				section.removeChild(section.extra.canel);
			}
			
			if(section.extra.flood){
				section.removeChild(section.extra.flood);
			}

			section.extra.flood = section.addChild(new MovieClip())
			var flood = section.extra.flood;
			
			if(!flood.water1){
				flood.water1 = flood.addChild(new Water(new Rectangle(0,-208,357,208),0.1,180,0x0099FF, 0x0033FF, 0x0099FF));
				flood.water2 = flood.addChild(new Water(new Rectangle(0,-208,357,208),0.1,180,0xFFFF99, 0xFFFF33, 0xFFFF99));
				flood.water1.y = 208;
				flood.water2.y = 208;
				flood.water1.visible = false;
			}
				
			flood.content = new Content(flood);
			
			flood.content.addEventListener(ContentEvent.COMPLETE, onSectionComplete);
			flood.content.addEventListener(ContentEvent.ERROR, onSectionError);
			
			try {
				flood.content.load(sectionPath+iID+".swf");
			}catch( error:* ) {
                trace("catch:"+error);
            }
			
			if(!flood.bank){
				
				flood.bank = flood.addChild(new MovieClip())
				
				flood.bank.left = GraphicUtil.createRect(section,flood.bank);
				flood.bank.right = GraphicUtil.createRect(section,flood.bank);
				
				flood.bank.left.width = flood.bank.left.width/2;
				flood.bank.right.width = flood.bank.right.width/2;
				
				flood.bank.right.x = flood.bank.right.width;
				
			}
			
			flood.water1.height = 108+floodObject.height*factor
			flood.water2.height = 108+floodObject.height*factor
			
			flood.bank.left.height = 108+floodObject.left*factor;
			flood.bank.right.height = 108+floodObject.right*factor;
			
			flood.bank.left.y = 208-flood.bank.left.height;
			flood.bank.right.y = 208-flood.bank.right.height;
			
			sectionDetail.waterValue.text = floodObject.height;
			sectionDetail.leftBank.text = floodObject.left;
			sectionDetail.rightBank.text = floodObject.right;
			
			// if higher than critical value
			if(floodObject.height < floodObject.warning)
			{
				flood.water1.visible = true;
				flood.water2.visible = false;
			}else{
				flood.water1.visible = false;
				flood.water2.visible = true;
			}
			
			sectionDetail.waterValue.y = 208-flood.water1.height
			sectionDetail.leftBank.y = flood.bank.left.y
			sectionDetail.rightBank.y = flood.bank.right.y
		}

		public function onSectionError(event:ContentEvent):void {
			SleepyDesign.log(" ^ "+event.type);
			section.extra.flood.content.load(sectionPath+"default.swf");
		}
		
		public function onSectionComplete(event:ContentEvent):void {
			SleepyDesign.log(" ^ "+event.type);
			event.content.mask = section.extra.flood.bank
			section.extra.canel = section.addChild(new Fake2D(section.extra.flood,20 ))
		}		
		
		//_________________________________________________________________ Data
		
		public function onComplete(event:Event):void {
			var mom = (parent as Content)
			if(mom){
				mom.ready();
			}
			
			SleepyDesign.log(" ^ "+event.type);
			var loader:URLLoader = event.target as URLLoader;
			var xml:XML = new XML(loader.data);
			
			var item = xml.STATION;
				
			//iAlarm.WARNING.text = item.WARNING
			iAlarm.WARNING.text = item.WARNING
			iAlarm.ALARM_WARNING.text = item.ALARM_WARNING
			
			//TODO custom error
			if(item.STATUS=="1"){
				iDetail.STATUS.htmlText = "<FONT COLOR=\"#FF0000\">ขัดข้อง</FONT>"
			}else{
				iDetail.STATUS.htmlText = "<FONT COLOR=\"#00FF00\">ปกติ</FONT>"
			}
			
			iDetail.LATITUDE.text = item.LATITUDE
			iDetail.LONGITUDE.text = item.LONGITUDE
			
			iDetail.VALUE.text = item.VALUE
			iDetail.LEFT.text = item.LEFT
			iDetail.RIGHT.text = item.RIGHT
			iDetail.ALARM_EDGE.text = item.ALARM_EDGE
			
			floodObject = new Object();
			
			floodObject.height = Number(item.VALUE)
			floodObject.left =  Number(item.LEFT)
			floodObject.right =  Number(item.RIGHT)
			
			floodObject.warning =  Number(item.WARNING);
			
			createSection(xml.STATION.@id)
			
		}
		
		//_________________________________________________________________ Update
		
		public override function onUpdate(event:ContentEvent):void {
			if(event.content.name=="CanalStation"){
				setStation(event.data.@id,event.data.CANAL_NAME)
				setSection(event.data.@id);
				
				trace(" ! setGraph : " + event.data.@id);
				
				try{
					setGraph(event.data.@id);
				}catch(e:*){trace(e)};
			}
		}		
		
		//_________________________________________________________________ History
		
		private var graph;
		private var popdown;
		
		public function initTrend():void
		{
			Menu.trendSignal.add(onTrend);
			
			popdown = this["iPopDown"] as MovieClip;
			
			popdown.iGraph.mask = GraphicUtil.createRect(popdown.iGraph);
			
			graph = new Content(popdown.iGraph);
			graph.extra = new Object();
			
			popdown.iGraph.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			
			addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			
			popdown.iGraph.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			popdown.iGraph.addEventListener(MouseEvent.MOUSE_OUT, mouseUpHandler);
			popdown.iGraph.addEventListener(MouseEvent.ROLL_OUT, mouseUpHandler);
			
			var cursor2:Cursor = new Cursor(this, popdown.iGraph);
			
			popdown.visible = false;
			
			//test();
		}
		
		private function onTrend():void
		{
			popdown.visible = !popdown.visible; 
		}
		
		private function mouseUpHandler(event:MouseEvent):void
		{
			if (graph.extra.flood)
			{
				graph.extra.flood.stopDrag();
			}
		}
		
		private function mouseDownHandler(event:MouseEvent):void
		{
			var min = 0
			var max = -(graph.extra.flood.width - 763);
			
			graph.extra.flood.startDrag(false, new Rectangle(min, graph.extra.flood.y, max, 0));
		}
		
		public function setGraph(iID)
		{
			var dataPath = XMLUtil2.getNodeById(config, "CanalHistoryData").@src;
			
			if (isTest)
				dataPath = "../serverside/";
			
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, xmlLoadCompleteHandler);
			
			var request = new URLRequest(URLUtil.killCache(dataPath + "CanalHistory_" + iID + ".xml"))
			loader.load(request);
			
			popdown.iGraph.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			popdown.iGraph.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			popdown.iGraph.addEventListener(MouseEvent.MOUSE_OUT, mouseUpHandler);
			popdown.iGraph.addEventListener(MouseEvent.ROLL_OUT, mouseUpHandler);
		}
		
		public function xmlLoadCompleteHandler(event:Event):void
		{
			var loader:URLLoader = event.target as URLLoader;
			var data:XML = new XML(loader.data);
			
			var dataProvider:Array = new Array();
			var captionNum = 0;
			
			var baseY = 104 - 29;
			var graphFactor = 70 / 100;
			
			if (graph.extra.flood)
				graph.removeChild(graph.extra.flood);
			
			graph.extra.flood = graph.addChild(new MovieClip());
			graph.extra.flood.y = baseY
			
			var myFlood = graph.extra.flood.addChild(new Sprite());
			
			// VALUE
			var floodShape = myFlood.addChild(new Shape());
			var flood = floodShape.graphics;
			
			//_________________________________________water
			
			// VALUE
			flood.lineStyle(0.5, 0xFFFF00, 1);
			flood.moveTo(0, 0);
			
			var stationXML = data.children()[0]
			var total = stationXML.child("*").length();
			
			for (var i = total - 2; i >= 0; i--)
			{
				var lastXML = stationXML.children()[i + 1];
				if (((captionNum) % 4) == 0)
				{
					var caption = graph.extra.flood.addChild(new iCaption());
					caption.x = captionNum * 60 / 4;
					caption.title.htmlText = lastXML.DATE + "<br/>" + lastXML.TIME;
				}
				
				if(i == total - 2)
					flood.moveTo(0, -graphFactor * Number(lastXML.VALUE));
				
				flood.lineTo(captionNum, -graphFactor * Number(lastXML.VALUE));
				
				captionNum++;
			}
			
			myFlood.width *= 60 / 4;
			
			// VALUE
			flood.endFill();
			
			graph.extra.flood.x = -(graph.extra.flood.width - 763);
		}

	}
}