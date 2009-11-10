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
			var dataPath = XMLUtil.getNodeById(config,"CanalStationData").@src;
			
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
			
			if(!flood.water){
				flood.water = flood.addChild(new Water(new Rectangle(0,-208,357,208)));
				flood.water.y = 208
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
			
			flood.water.height = 108+floodObject.height*factor
			flood.bank.left.height = 108+floodObject.left*factor;
			flood.bank.right.height = 108+floodObject.right*factor;
			
			flood.bank.left.y = 208-flood.bank.left.height;
			flood.bank.right.y = 208-flood.bank.right.height;
			
			sectionDetail.waterValue.text = floodObject.height;
			sectionDetail.leftBank.text = floodObject.left;
			sectionDetail.rightBank.text = floodObject.right;
			
			sectionDetail.waterValue.y = 208-flood.water.height
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
				iDetail.STATUS.htmlText = "<FONT COLOR=\"#FF0000\">Fail</FONT>"
			}else{
				iDetail.STATUS.htmlText = "<FONT COLOR=\"#00FF00\">OK</FONT>"
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
			
			createSection(xml.STATION.@id)
			
		}
		
		//_________________________________________________________________ Update
		
		public override function onUpdate(event:ContentEvent):void {
			if(event.content.name=="CanalStation"){
				setStation(event.data.@id,event.data.CANAL_NAME)
				setSection(event.data.@id)
			}
		}		
		
	}

}