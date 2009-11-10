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
	import flash.utils.Dictionary;
	import flash.xml.XMLDocument;
	import flash.xml.XMLNode;
	
	import com.sleepydesign.SleepyDesign;
	import com.sleepydesign.site.*;
	import com.sleepydesign.utils.*;
	
	//TODO Fake2D Class
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Transform;

	public class SCADAStation extends Content{
		
		//TODO path config
		public var rootPath:String = "SCADA/";
		public var stationPath:String = rootPath+"20_station/stations/";
		public var sectionPath:String = rootPath+"20_station/sections/";
		
		public var type = "Station";
		
		var station;
		var section;
		var led;
		
		var pumps:Array;
		
		//TODO factor config
		var factor=20;
		
		var waterGateArray:Array;
		var waterObject
		var isTest : Boolean = false;
		
		var popup;
		
		//var stationAll;
		//var ledAll;
		
		public function SCADAStation(){
			Security.allowDomain("*")
			
			popup = iPopup as MovieClip;
			
			var iStation = popup.iStation
			var iSection = popup.iSection
			
			iStation.mask = GraphicUtil.createRect(iStation);
			iSection.mask = GraphicUtil.createRect(iSection);
			
			station = new Content(iStation);
			station.extra = new Object()
			
			led = new Content(popup.iLed);
			led.extra = new Object()
			
			section = new Content(iSection);
			section.extra = new Object();
			
			popup.visible = false
			
			//_____________________________________ All
			
			iE00.visible = false;
			
			test()
		}
		
		public function test(){
			trace("Self Test")
			
			isTest = true
			
			stationPath = "stations/";
			sectionPath = "sections/";
			
			//setStation("E41", "ok");
			//setStation("E15", "ok");
			setStation("E23","ok");
			
		}
			
		//_________________________________________________________________ Station

		var maxPump:Number;
		
		public function setStation(iID:String, iName:String) {
			//trace("setStation"+iID)
			currentSectionID = iID;
			
			if (iID == "E00") {
				
				iE00.visible = true;
				popup.visible = false;
				
				//name
				iE00.iStationName.htmlText = iID + " - " + iName;
				
				getPumpData(iID);
				
			}else {
				
				iE00.visible = false
				popup.visible = true
				
				if(station.extra.id!=iID){
					if(station){
						station.remove();
					}
					
					if(led.extra.pump){
						led.removeChild(led.extra.pump);
					}
					
					led.extra.pump = led.addChild(new Sprite());
					
					station.extra.id = iID;
					station.load(stationPath+iID+".swf");
					station.addEventListener(ContentEvent.COMPLETE, onStationComplete);
					
					popup.iStationName.htmlText = iID+ " - "+iName;
				}else{
					update()
				}
			}
		}
		
		public function update(){
			getPumpData(station.extra.id);
		}
		
		public function onStationComplete(event:ContentEvent):void {
			
			SleepyDesign.log(" ^ "+event.type);
			pumps = getPump(station.content as DisplayObjectContainer);
			
			update()
			
		}
		
		var gates:Dictionary
		
		public function getPump(container:DisplayObjectContainer) {
			
			var child:MovieClip;
			var childs:Array = new Array();
			
			gates = new Dictionary();
			
			var xgap = 21;
			var ygap = 32;
			var col = 18;
			var j:uint=0;
			
			for (var i:uint=0; i < container.numChildren; i++) {
				child = container.getChildAt(i) as MovieClip
				if(child){
					if (String(child.name).indexOf("g") == 0) {
						gates[child.name] = child;
					}else {
						//create pump
						var pumpLed = led.extra.pump.addChild(new iPump());
						pumpLed.x = 4+xgap*(j%col);
						pumpLed.y = 8+ygap*Math.floor(j/col);
						pumpLed.id.text = j+1;
						
						j++;
						
						childs.push({child:child,pumpLed:pumpLed})
					}
				}
			}
			return childs;
			
		}
		
		public function getPumpData(iID:String){
			var dataPath = XMLUtil.getNodeById(config,"SCADAStationData").@src;
			var method = String(XMLUtil.getNodeById(config,"SCADAStationData").@method).toUpperCase();
			
			if(isTest){
				dataPath = "../serverside/";
			}
			
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onComplete);
			
			var request = new URLRequest( URLUtil.killCache(dataPath+"SCADA_"+iID+".xml") )
			loader.load(request);
			
			/*
			var dataPath = XMLUtil.getNodeById(config,"SCADAStationData").@src;
			var method = String(XMLUtil.getNodeById(config,"SCADAStationData").@method).toUpperCase();
			
			if(isTest){
				dataPath = "http://localhost/yourpath/SCADA/serverside/getStationData.php";
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
		
		//_________________________________________________________________ Section
		
		public function createSection(type) {
			trace("createSection:"+type)
			
			if(section.extra.waterGate){
				section.removeChild(section.extra.waterGate);
			}

			section.extra.waterGate = section.addChild(new MovieClip())
			var waterGate = section.extra.waterGate;
			
			switch(type){
				case 0:
					waterGate.water = waterGate.addChild(new Water(new Rectangle(0,-180,386,180)));
				break;
				/*
				case 1:
					waterGate.water = waterGate.addChild(new Water(new Rectangle(163,-180,60,180)));
					waterGate.waterLeft = waterGate.addChild(new Water(new Rectangle(63,-180,110,180)));
					waterGate.waterRight = waterGate.addChild(new Water(new Rectangle(217,-180,110,180)));
				break;
				case 2:
					//waterGate.water = waterGate.addChild(new Water(new Rectangle(148,-180,90,180)));
					//waterGate.waterLeft = waterGate.addChild(new Water(new Rectangle(63,-180,80,180)));
					//waterGate.waterRight = waterGate.addChild(new Water(new Rectangle(242, -180, 80, 180)));
					waterGate.water = waterGate.addChild(new Water(new Rectangle(128,-180,130,180)));
					waterGate.waterLeft = waterGate.addChild(new Water(new Rectangle(69,-180,45,180)));
					waterGate.waterRight = waterGate.addChild(new Water(new Rectangle(272,-180,45,180)));
				break;
				case 3:
					waterGate.water = waterGate.addChild(new Water(new Rectangle(128,-180,130,180)));
					waterGate.waterLeft = waterGate.addChild(new Water(new Rectangle(69,-180,45,180)));
					waterGate.waterRight = waterGate.addChild(new Water(new Rectangle(272,-180,45,180)));
				break;
				case 4:
				case 5:
				case 6:
				*/
				default :
					waterGate.water = waterGate.addChild(new Water(new Rectangle(118,-180,150,180)));
					waterGate.waterLeft = waterGate.addChild(new Water(new Rectangle(0,-180,118,180)));
					waterGate.waterRight = waterGate.addChild(new Water(new Rectangle(272,-180,118,180)));
				break;
			}
			
			waterGate.water.y = 180;
			var y0 = 180 - 130;
			
			switch(type){
				case 0:
					//waterGate.water.height = y0 + ( waterObject.waterValue ) * factor;
					var h1 = y0+waterObject.left*factor;
					var hr = y0+waterObject.right*factor;
					waterGate.water.height = h1
				break;
				default :
					waterGate.waterLeft.y = 180
					waterGate.waterRight.y = 180
					waterGate.waterLeft.height = y0+waterObject.left*factor;
					waterGate.waterRight.height = y0+waterObject.right*factor;
					waterGate.water.height = (waterGate.waterLeft.height+waterGate.waterRight.height)/2
				break;
			}
			
			waterGate.content = new Content(waterGate);
			waterGate.content.addEventListener(ContentEvent.COMPLETE, onSectionComplete);
			
			try{
				if(isTest){
					if ((currentSectionID == "E15")||(currentSectionID == "E23")) {
						waterGate.content.load("sections/"+currentSectionID+".swf");
					}else {
						waterGate.content.load("sections/waterGate" + type + ".swf");
					}
				}else {
					if ((currentSectionID == "E15")||(currentSectionID == "E23")) {
						waterGate.content.load("SCADA/20_station/sections/"+currentSectionID+".swf");
					}else {
						waterGate.content.load("SCADA/20_station/sections/waterGate" + type + ".swf");
					}
				}
			}catch( error:* ) {
                trace("catch:"+error);
            }
		}
		
		var currentSectionID = "";
		
		public function setSection(iID:String){
			/*
			if(section){
				section.remove();
			}
			
			section.load(sectionPath+iID+".swf");
			
			section.addEventListener(ContentEvent.COMPLETE, onSectionComplete);
			*/
		}
		
		public function onSectionComplete(event:ContentEvent):void {
			SleepyDesign.log(" ^ "+event.type);
			var j = 0;
			try{
			for(var i in waterGateArray){
				var waterGateObject = waterGateArray[i];
				var gateOn = event.content["iGateOn" + waterGateObject.id]as MovieClip;
				
				event.content.iLHEIGHT.height = waterGateObject.ground;
				event.content.iRHEIGHT.height = waterGateObject.ground;
				
				event.content.iFLOOR.height = waterGateObject.floor;
				//event.content.iFLOOR.alpha = .5
				//special case left right
				
				gateOn.height = (waterGateObject._ground-waterGateObject._floor) * 20;
				
				if (((currentSectionID ==  "E23") ||(currentSectionID ==  "E15") )&& (i < 2)) {
					//gateOn.y = 30;
					//PERCENT CANCEL//gateOn.scaleX = waterGateObject.level / 100;
					gateOn.scaleX = (waterGateObject.maxLevel-waterGateObject.height) / waterGateObject.maxLevel;
					
				}else{
				//normal case
				
					if(waterGateObject.height>5){
						waterGateObject.height = 5
					}
					
					if(waterGateObject.height<-5){
						waterGateObject.height = -5
					}
					
					var hh = -10 + 180 - waterGateObject.floor
					var y0 = 170;
					
					//VALUE CANCEL//gateOn.y = -waterGateObject.floor+180+(0-waterGateObject.height)*factor
					//PERCENT CANCEL//gateOn.y = hh-(hh - 100) * (waterGateObject.level / 100);
					//VALUE CANCEL//gateOn.y = y0-(waterGateObject.waterValue + 2) * 20;
					//gateOn.y = y0 - (waterGateObject.waterValue/waterGateObject.maxLevel)*20*4 - waterGateObject.floor
					
					var percent = 1-(waterGateObject.maxLevel - waterGateObject.height) / waterGateObject.maxLevel;
					
					gateOn.y = hh- percent*gateOn.height
					
				}
				
				event.content["label" + waterGateObject.id].text = ++j;
				event.content["waterValue" + waterGateObject.id].text = waterGateObject.waterValue;
				event.content["waterValue" + waterGateObject.id].autoSize = "center";
			}
			}catch (e:*) {
				
			}
			section.extra.fake2D.addChild(new Fake2D(section.extra.waterGate,10,0.1 ))
			
		}
		
		//_________________________________________________________________ Data
		var maxPack = 0;
		var packs:Array = new Array();
		
		public function onCompleteAll(xml):void {
			
			var item = xml.STATION;
			var iRain = iE00.iRain;
			
			//setRainDetail
			iRain.RAIN_15MIN.text = item.RAIN_15MIN;
			iRain.RAIN_1HOUR.text = item.RAIN_1HOUR;
			iRain.RAIN_24HOUR.text = item.RAIN_24HOUR;
			
			iRain.RAIN_15MIN.autoSize = "center";
			iRain.RAIN_1HOUR.autoSize = "center";
			iRain.RAIN_24HOUR.autoSize = "center";
			
			iRain.WQSA.text = item.WQSA;
			iRain.WQDO.text = item.WQDO;
			iRain.WQPH.text = item.WQPH;
			iRain.WQEC.text = item.WQEC;
			
			iRain.WQSA.autoSize = "center";
			iRain.WQDO.autoSize = "center";
			iRain.WQPH.autoSize = "center";
			iRain.WQEC.autoSize = "center";
			
			//setLed
			iE00.PF.gotoAndStop(2-Number(item.PF))
			iE00.LB.gotoAndStop(2-Number(item.LB))
			iE00.DO.gotoAndStop(2-Number(item.DO))
			iE00.BT.gotoAndStop(2-Number(item.BT))
			
			iE00.CM.gotoAndStop(2-Number(item.STATUS))
			
			var stationXML = xml.children()[1];
			var total = stationXML.children().length();
			var gap = (758 - 58) / total*2;
			//create
			if (maxPack == 0) {
				for (var i:int = 0; i < total; i++) {
					var pack = new iPack();
					
					if(i<total*.5){
						pack.x = iE00._iPack0.x + i * gap;
						pack.y = iE00._iPack0.y;
					}else {
						pack.x = iE00._iPack1.x + int(i-total*.5) * gap;
						pack.y = iE00._iPack1.y;
					}
					
					iE00.addChild(pack);
					packs.push(pack);
					
				}
				maxPack = total;
			}
			
			iE00._iPack0.visible = false;
			iE00._iPack1.visible = false;
			
			//trace("**" + stationXML.children())
			
			//setup
			for (i = 0; i < maxPack; i++)
			{
				
				pack = packs[i];
				if (i < total) {
					pack.visible = true;
					
					item = stationXML.children()[i];
					
					pack.POWER.gotoAndStop(2-Number(item.POWER))
					pack.BATTERY.gotoAndStop(2-Number(item.BATTERY))
					pack.DOOR.gotoAndStop(2 - Number(item.DOOR))
					pack.BREAKER.gotoAndStop(2-Number(item.BREAKER))
					pack.RADIO.gotoAndStop(2 - Number(item.RADIO))
					//
					var result:XMLDocument = new XMLDocument();
					result.ignoreWhite = true;
					result.parseXML(item);
					
					pack.label.text = result.firstChild.nodeName;
					
				}else {
					pack.visible = false;
				}
				
			}
			
		}
		
		public function onComplete(event:Event):void {
			
			var loader:URLLoader = event.target as URLLoader;
			var xml:XML = new XML(loader.data);
			
			var item = xml.STATION;
			var iRain = popup.iRain;
			
			if (!popup.visible) {
				
				onCompleteAll(xml);
				
			}else{
			
				//setRainDetail
				iRain.RAIN_15MIN.text = item.RAIN_15MIN;
				iRain.RAIN_1HOUR.text = item.RAIN_1HOUR;
				iRain.RAIN_24HOUR.text = item.RAIN_24HOUR;
				
				iRain.WQSA.text = item.WQSA;
				iRain.WQDO.text = item.WQDO;
				iRain.WQPH.text = item.WQPH;
				iRain.WQEC.text = item.WQEC;
				
				//setPump
				var pump:String = String(item.PUMP_STATUS)
				
				for(var i=0;i<pump.length;i++){
					if(pumps[i]){
						pumps[i].child.gotoAndStop(2-Number(pump.charAt(i)))
						pumps[i].pumpLed.pump.gotoAndStop(2-Number(pump.charAt(i)))
					}
				}

				//setLed
				popup.PF.gotoAndStop(2-Number(item.PF))
				popup.LB.gotoAndStop(2-Number(item.LB))
				popup.DO.gotoAndStop(2-Number(item.DO))
				popup.BT.gotoAndStop(2-Number(item.BT))
				
				popup.CM.gotoAndStop(2-Number(item.STATUS))
				
				//setGraph
				if(section.extra.fake2D){
					section.removeChild(section.extra.fake2D);
				}
				section.extra.fake2D = section.addChild(new Sprite())
				
				//setStationDetail
				if(section.extra.detail){
					section.removeChild(section.extra.detail);
				}
				section.extra.detail = section.addChild(new iSectionDetail())
				
				section.extra.detail.FLOW.htmlText = item.FLOW
				
				if (String(item.DOOR_STATUS.DOOR).length > 0) {
					section.extra.detail.label.MSL_VALUE_IN.htmlText = item.MSL_VALUE_IN
					section.extra.detail.label.MSL_VALUE_OUT.htmlText = item.MSL_VALUE_OUT
					section.extra.detail.label.visible = true;
				}else{
					section.extra.detail.label0.MSL_VALUE_IN.htmlText = item.MSL_VALUE_IN
					section.extra.detail.label.visible = false;
				}
				
				TextField(section.extra.detail.label.MSL_VALUE_IN).autoSize = "center";
				TextField(section.extra.detail.label.MSL_VALUE_OUT).autoSize = "center";
				TextField(section.extra.detail.label0.MSL_VALUE_IN).autoSize = "center";
				
				//2008/03/27 special request for E41
				//2008/03/31 special request for E14
				try{
					if (String(item.@id) == "E41" || String(item.@id) == "E14") {
						trace(" ! Special request : "+String(item.@id))
						section.extra.detail.label.special.gotoAndStop(2);
					}else {
						section.extra.detail.label.special.gotoAndStop(1);
					}
				}catch (e:*) {
					//
				}
				
				section.extra.detail.label0.visible = !section.extra.detail.label.visible;
				
				section.extra.detail.BMA_VALUE_IN.htmlText = item.BMA_VALUE_IN
				section.extra.detail.BMA_VALUE_OUT.htmlText = item.BMA_VALUE_OUT
				
				waterObject = new Object();
				waterObject.left = Number(item.MSL_VALUE_IN);
				waterObject.right = Number(item.MSL_VALUE_OUT);
				
				waterGateArray = new Array();
				
				i = 1;
				var waterGateObject
				//setSection
				if(String(item.DOOR_STATUS.DOOR).length>0){
					
					for each(var door in item..DOOR_STATUS.DOOR){
						
						waterGateObject = new Object();
						
						waterGateObject.id = door.INDEX;
						waterGateObject.isOpen = (door.STATUS == "0");
						
						gates["g" + i++].visible = waterGateObject.isOpen;
						
						waterGateObject.height = Number(door.VALUE);
						waterGateObject.level = Number(door.LEVEL);
						//section.extra.detail["waterValue"+item.DOOR_STATUS.@num+"_"+door.INDEX].htmlText = waterGateObject.height;
						waterGateObject.waterValue = Number(waterGateObject.height);
						waterGateObject.ground = (2 + Number(item.DOOR_STATUS.HEIGHT)) * 20
						waterGateObject.floor = (2 + Number(item.DOOR_STATUS.FLOOR)) * 20
						
						waterGateObject._ground = Number(item.DOOR_STATUS.HEIGHT);
						waterGateObject._floor = Number(item.DOOR_STATUS.FLOOR);
						waterGateObject.maxLevel = Number(item.DOOR_STATUS.MAX_LEVEL);
						
						waterGateArray.push(waterGateObject);
						
					}
					createSection(Number(item.DOOR_STATUS.@num));
				}else {
					
					waterGateObject = new Object();
					
					waterGateObject.ground = (2 + Number(item.DOOR_STATUS.HEIGHT)) * 20
					waterGateObject.floor = (2 + Number(item.DOOR_STATUS.FLOOR)) * 20
					
					waterGateObject._ground = Number(item.DOOR_STATUS.HEIGHT);
					waterGateObject._floor = Number(item.DOOR_STATUS.FLOOR);
					waterGateObject.maxLevel = Number(item.DOOR_STATUS.MAX_LEVEL);
						
					waterGateArray.push(waterGateObject);
					createSection(0);
				}
			}
			//all done
			var panel = (parent as Content);
			if(panel){
				panel.ready();
			}
		}
		
		//_________________________________________________________________ Update
		
		public override function onUpdate(event:ContentEvent):void {
			if (event.content.name == "SCADAStation") {
				setStation(event.data.@id, event.data.NAME)
				//setSection(event.data.@id)
			}
		}
		
	}

}