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
	
	import com.sleepydesign.SleepyDesign;
	import com.sleepydesign.site.*;
	import com.sleepydesign.utils.*;
	public class CanalGraph extends Content{
		
		//TODO path config
		public var rootPath:String = "Canal/"; 
		public var stationPath:String = rootPath+"30_graph/stations/";
		public var sectionPath:String = rootPath+"20_station/sections/";
		
		var station;
		var section;
		
		var sectionArray:Array;
		var stationArray:Array;
		
		var factor=20;
		
		//var floodObject:Object;
		var sectionDetail;
		
		var totalCanal = 0
		var totalCanalLoaded = 0
		var currentCanal,currentCanalId
		var xmlData
		
		var isTest : Boolean = false;
		
		public function CanalGraph(){
			/*
			_this = super.parent as Content;
			
			trace(_this)
			*/
			Security.allowDomain("*")
			
			iStation.mask = GraphicUtil.createRect(iStation);
			iSection.mask = GraphicUtil.createRect(iSection);	
			
			iSection.buttonMode = true
			
			station = new Content(iStation);
			section = new Content(iSection);
			
			station.extra = new Object();
			section.extra = new Object();
			
			var mom = (parent as Content)
			if(mom){
				config = mom.config;
			}
			
			//section.x = -400
			
			//test()
		}
		
		public function test(){
			trace("Self Test")
			
			isTest  = true

			config = 
			<config>
				<canal>
					<item label="คลองบางเขน" src="Canal/30_graph/stations/BK.swf"/>
					<item label="คลองบางซื่อ" src="Canal/30_graph/stations/BS.swf"/>
					<item label="คลองเปรมประชากร" src="Canal/30_graph/stations/KP.swf"/>
					<item label="คลองลาดพร้าว" src="Canal/30_graph/stations/LP.swf"/>
					<item label="คลองสามเสน" src="Canal/30_graph/stations/SA.swf"/>
					<item label="คลองแสนแสบ" src="Canal/30_graph/stations/SS.swf"/>
					<item label="คลองคูเมืองเดิม" src="Canal/30_graph/stations/PK.swf"/>
				</canal>
			</config>
			
			stationPath = "stations/";
			sectionPath = "../20_station/sections/";
			var dataPath = "../../serverside/"+rootPath+"getData.php";
			
			dataPath = "../serverside/CanalGraph.xml";
			
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onUpdateTest);
			
			var request = new URLRequest( URLUtil.killCache(dataPath) )
			loader.load(request);
			
		}
		
		//_________________________________________________________________ Station

		public function setStation(iData:Object=null){
			
			//createStation(iData)
			
			var dataPath = XMLUtil.getNodeById(config,"CanalGraphList").@src;
			var method = String(XMLUtil.getNodeById(config,"CanalGraphList").@method).toUpperCase();
			
			if(isTest){
				dataPath = "../serverside/CanalGraph.xml";
			}
			
			currentCanal = iData.@NAME;
			//trace("*"+currentCanal)
			
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onStationDataComplete);
			
			var request = new URLRequest( URLUtil.killCache(dataPath) )
			
			loader.load(request);	
			
			
		}
		
		public function onStationDataComplete(event:Event):void {
			
			SleepyDesign.log(" ^ "+event.type);
			var loader:URLLoader = event.target as URLLoader;
			var xml:XML = new XML(loader.data);
			
			for each(var item in xml..CANAL){
				
				if(currentCanal==item.@NAME){
					//trace(item)
					createStation(item);
					
				}
				
			}
			xmlData = xml
			
		}
		
		public function createStation(iData:Object=null){
			
			//trace("setStation:"+iData)
			
			//get src
			for each(var item in config.canal..item){
				
				if(item.@label == iData.@NAME){
					var canalSrc = item.@src
				}
			}
			
			if(iData){
				
				//data
				stationArray = new Array();
				for each(item in iData..STATION){
					stationArray.push({id:item.ID,status:Number(item.STATUS)});
					//trace(item.ID+":"+item.STATUS)
					//hack
					//stationArray.push({id:item.ID,status:Number(item.STATUS)});
					
				}
				
				//new?
				if(station.extra.src!=canalSrc){
					//trace("new")
					if(station){
						station.remove();
					}
					if(isTest){
						station.load("../../"+canalSrc);
					}else{
						station.load(canalSrc);
					}
					station.addEventListener(ContentEvent.COMPLETE, onStationComplete);
					//station.addEventListener(ContentEvent.ERROR, onStationError);
					
					station.extra.src = canalSrc;
					//iStationName.htmlText = iName;
					
				}else{
					updateStation();
				}
				
			}
		}
		
		public function updateStation():void {
			
			for(var i in stationArray){
				var led = station.content[stationArray[i].id]as MovieClip;
				if(led){
					led.gotoAndStop(2-Number(stationArray[i].status));
				}
			}
			
			
		}
		
		public function onStationError(event:ContentEvent):void {
			SleepyDesign.log(" ^ "+event.type);
			//station.load(stationPath+"default.swf");
		}
		
		public function onStationComplete(event:ContentEvent):void {
			
			SleepyDesign.log(" ^ "+event.type);
			updateStation();
			
		}
		
		//_________________________________________________________________ Section

		public function setSection(iData:Object=null){
			
			var dataPath = XMLUtil.getNodeById(config,"CanalGraphData").@src;
			var method = String(XMLUtil.getNodeById(config,"CanalGraphData").@method).toUpperCase();
			
			if(isTest){
				dataPath = "../serverside/CanalGraph.xml";
			}
			
			currentCanal = iData.@NAME;
			
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onSectionDataComplete);
			
			var request = new URLRequest( URLUtil.killCache(dataPath) )
			
			loader.load(request);	
			
		}
		/*
		public function onSectionDataComplete(event:ContentEvent):void {
			
			SleepyDesign.log(" ^ "+event.type);
			createSection();
			
		}
		*/
		public function createSection(iID:String,iSubSection){

/*
			if(iSubSection.flood){
				iSubSection.removeChild(iSubSection.flood);
			}
*/
			
			var flood = iSubSection.flood = iSubSection.addChild(new MovieClip())
			var floodObject = iSubSection.floodObject
			
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
                //trace("catch:"+error);
            }
			
			if(!flood.bank){
				
				flood.bank = flood.addChild(new MovieClip())
				
				flood.bank.left = GraphicUtil.createRect(iSubSection,flood.bank);
				flood.bank.right = GraphicUtil.createRect(iSubSection,flood.bank);
				
				flood.bank.left.width = flood.bank.left.width/2;
				flood.bank.right.width = flood.bank.right.width/2;
				
				flood.bank.right.x = flood.bank.right.width;
				
			}
			
			var y0 = 208-96
			
			flood.water.height = y0+floodObject.height*factor
			flood.bank.left.height = y0+floodObject.left*factor;
			flood.bank.right.height = y0+floodObject.right*factor;
			
			flood.bank.left.y = 208-flood.bank.left.height;
			flood.bank.right.y = 208-flood.bank.right.height;
			
			var canelName = String(floodObject.canelName).replace("เขต","<br/>เขต");
			canelName = String(canelName).replace("(","<br/>(");
			canelName = String(canelName).replace("คลองเปรมประชากร","<br/>คลองเปรมประชากร");
			canelName = String(canelName).replace("คลองเจ้าคุณสิงห์","<br/>คลองเจ้าคุณสิงห์");

			iSubSection.detail.canelName.htmlText = canelName;
				
			iSubSection.detail.waterValue.htmlText = floodObject.height;
			iSubSection.detail.leftBank.htmlText = floodObject.left;
			iSubSection.detail.rightBank.htmlText = floodObject.right;
			
			iSubSection.detail.waterValue.y = 8+(208-flood.water.height)*128/208
			iSubSection.detail.leftBank.y = 8+flood.bank.left.y*128/208
			iSubSection.detail.rightBank.y = 8+flood.bank.right.y*128/208
			
			iSubSection.flood.width = 120
			iSubSection.flood.height*=128/208
			iSubSection.flood.y = -10
			
		}

		public function onSectionError(event:ContentEvent):void {
			SleepyDesign.log(" ^ "+event.type);
			event.target.load(sectionPath+"default.swf");
		}
		
		public function onSectionComplete(event:ContentEvent):void {
			SleepyDesign.log(" ^ "+event.type);
			event.content.mask = event.target.parent.parent.flood.bank
			if(++totalCanalLoaded==totalCanal){
				section.extra.canel.addChild(new Fake2D(section.extra.graph,10,0.02 ))
				section.extra.detail.visible=true;
				
				iSection.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
				
				addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
				
				iSection.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
				iSection.addEventListener(MouseEvent.MOUSE_OUT, mouseUpHandler);
				iSection.addEventListener(MouseEvent.ROLL_OUT, mouseUpHandler);
			}
		}		
		
		//_________________________________________________________________ MouseEvent
		
		private function mouseUpHandler(event:MouseEvent):void {
			if(section){
				section.stopDrag();
			}
		}
		
		private function mouseDownHandler(event:MouseEvent):void {
			var min = 0
			var max = -(section.width+20-iSection.mask.width);
			
			section.startDrag(false,new Rectangle(min,section.y,max,0));
		}
		
		//_________________________________________________________________ Data
		
		public function onSectionDataComplete(event:Event):void {
			
			SleepyDesign.log(" ^ "+event.type);
			var loader:URLLoader = event.target as URLLoader;
			var xml:XML = new XML(loader.data);
			
			//trace(xml)
			/*
			var loader:URLLoader = event.target as URLLoader;
			var xml:XML = new XML(loader.data);
			*/
			/*
			var item = xml.STATION[0];
			
			floodObject = new Object();
			
			floodObject.height = Number(item.VALUE)
			floodObject.left =  Number(item.LEFT)
			floodObject.right =  Number(item.RIGHT)
			
			createSection(xml.STATION.@id)
			*/
			
			//clean
			/*
			if(sectionArray){
				for(var i in sectionArray){
					station.removeChild(sectionArray[j]);
					//sectionArray[j].remove();
				}
			}
			*/
			
			if(section.extra.detail){
				section.removeChild(section.extra.detail);
			}
			
			if(section.extra.canel){
				section.removeChild(section.extra.canel);
			}
			
			if(section.extra.graph){
				section.removeChild(section.extra.graph);
			}
			
			totalCanalLoaded = 0;
			
			section.extra.graph = section.addChild(new MovieClip())
			section.extra.canel = section.addChild(new MovieClip())
			section.extra.detail = section.addChild(new MovieClip())
			
			section.extra.graph.x = 4;
			section.extra.canel.x = 4;
			
			section.extra.canel.y = 38;
			section.extra.detail.y = 20;
			
			sectionArray = new Array();
			
			section.extra.graph.visible=false;
			section.extra.detail.visible=false;
			var j=0
			
			//var item = xml.STATION;
			
			for each(var canal in xml..CANAL){
				
				if(currentCanal==canal.@NAME){
					for each(var item in canal..STATION){
						var floodObject = new Object();
						
						floodObject.canelName = item.NAME;
						
						floodObject.height = Number(item.VALUE)
						floodObject.left =  Number(item.LEFT)
						floodObject.right =  Number(item.RIGHT)

						sectionArray[j] = section.extra.graph.addChild(new MovieClip());

						sectionArray[j].detail = section.extra.detail.addChild(new iSectionDetail());
						
						//sectionArray[j].detail.y = 17;
						
						//sectionArray[j].y = -100
						sectionArray[j].x = 124*j;
						sectionArray[j].detail.x = 124*j;
						sectionArray[j].floodObject = floodObject;
						
						//sectionArray[j] = new Content(section)
						
						createSection(item.@id,sectionArray[j])
						
						
						j++

						totalCanal = j;
						
						currentCanalId = item.@id;
					}
				}
			}

			/*
			if(section.width>iSection.mask.width){
				//too big
				section.scaleX = iSection.mask.width/section.width
			}else{
				section.scaleX = 100
			}
			*/
			
			section.x = 0;
			
			//all done
			var mom = (parent as Content)
			if(mom){
				mom.ready();
			}
		}
		
		//_________________________________________________________________ Update
		
		public override function onUpdate(event:ContentEvent):void {
			if(event.content.name=="CanalGraph"){
				if(event.data.@NAME){
					//trace("CanalGraph.onUpdate:"+event.data.@NAME)
					setStation(event.data)
					setSection(event.data)
				}
			}
		}	
		
		public function onUpdateTest(event:Event):void {
			
			SleepyDesign.log(" ^ "+event.type);
			var loader:URLLoader = event.target as URLLoader;
			var xml:XML = new XML(loader.data);
			
			setStation(xml.CANAL[5])
			setSection(xml.CANAL[5])
			
		}		
		
	}

}