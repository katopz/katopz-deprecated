/**
* ...
* @author katopz@sleepydesign.com
* @version 0.1
*/

package {
	import com.sleepydesign.containers.Cursor;
	import flash.system.Security;
	import flash.geom.*
	import flash.display.*
	import flash.events.*;
	import flash.net.*;
	import flash.text.*;
	
	import com.sleepydesign.SleepyDesign;
	import com.sleepydesign.site.*;
	import com.sleepydesign.utils.*;
	
	import caurina.transitions.Tweener;

	public class FloodStation extends Content{
		
		//TODO path config
		
		public var stationPath:String = "Flood/20_station/stations/";
		public var sectionPath:String = "Flood/20_station/sections/";
		public var roadPath:String = "Flood/20_station/roads/";
		
		public var type = "Station";
		
		var station;
		var section;
		var graph;
		
		var popup,popdown,road;
		
		var factor=1;
		var floodObject:Object;
		var detail;
		
		var isTest : Boolean = false;
		
		public function FloodStation()
		{
			Security.allowDomain("*")
			
			popup = iPopup as MovieClip;
			popdown = iPopDown as MovieClip;
			
			//TODO animaited mask
			popup.iStation.mask = GraphicUtil.createRect(popup.iStation);
			popup.iRoad.mask = GraphicUtil.createRect(popup.iRoad);
			
			popdown.iSection.mask = GraphicUtil.createRect(popdown.iSection);
			popdown.iGraph.mask = GraphicUtil.createRect(popdown.iGraph);
			
			station = new Content(popup.iStation);
			road = new Content(popup.iRoad);
			road.extra = new Object();
			
			section = new Content(popdown.iSection);
			section.extra = new Object();
			
			graph = new Content(popdown.iGraph);
			graph.extra = new Object();
			
			detail = popdown.iDetail;
			
			popup.popdownButton.addEventListener(MouseEvent.MOUSE_DOWN, stationDownClick);
			popdown.popupButton.addEventListener(MouseEvent.MOUSE_DOWN, stationUpClick);
			
			popdown.iGraph.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			
			addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			
			popdown.iGraph.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			popdown.iGraph.addEventListener(MouseEvent.MOUSE_OUT, mouseUpHandler);
			popdown.iGraph.addEventListener(MouseEvent.ROLL_OUT, mouseUpHandler);
			
			//popdown.iGraph.buttonMode = true
			
			popdown.visible = false;
			
			var cursor1:Cursor = new Cursor(this, popup.iRoad);
			var cursor2:Cursor = new Cursor(this, popdown.iGraph);
			
			//test()
		}
		
		//080610
		private var customAlpha:Number = .5;
		private var customColor:Number = 0x6CA8DE;
		private var customBlendmode:String = "normal";
		
		private function mouseUpHandler(event:MouseEvent):void {
			if(graph.extra.flood){
				graph.extra.flood.stopDrag();
			}
		}
		
		private function mouseDownHandler(event:MouseEvent):void {
			var min = 0
			var max = -(graph.extra.flood.width-763);
			
			graph.extra.flood.startDrag(false,new Rectangle(min,graph.extra.flood.y,max,0));
			//MOUSE_OUT
			/*
			var slide=graph.extra.flood;
			var slideFactor=-(event.currentTarget.mouseX-(763/2))
			
			trace(slideFactor)
			
			var nextX = slide.x+slideFactor;
			
			//min
			if(nextX>0){
				nextX = 0
			}
			//max
			if(nextX<-(slide.width-763)){
				nextX = -(slide.width-763)
			}
			
			Tweener.addTween(slide,{x:nextX, time:0.25, transition:"easeoutquad"})
			*/
		}

		
		public function test(){
			trace("Self Test")
			
			isTest  = true
			
			//var dataPath:String = "serverside/"+rootPath+"getData.php";
			
			stationPath = "stations/";
			sectionPath = "sections/";
			roadPath = "roads/";
			
			//dataPath = "../../"+dataPath;
			var test : XML =
			  <STATION id="FL21">
				<NAME>ถนนประชาสงเคราะห์ เขตดินแดง </NAME>
				<VALUE>30</VALUE>
				<STATUS>1</STATUS>
				<STATUS_PUMP>0</STATUS_PUMP>
			  </STATION>
			
			setStation(test)
			//setSection("FL21")
			setGraph("FL21")
			
		}
		
		//_________________________________________________________________ Station
		
		private function stationUpClick(event:MouseEvent):void {
			Tweener.addTween(popup, { onStart:function() { popup.visible = true }, alpha:1, time:0.5, delay:0, transition:"easeoutquad" } );
			Tweener.addTween(popdown, { onComplete:function() { popdown.visible = false }, alpha:0, time:0.5, delay:0, transition:"easeoutquad" } );
		}
		
		private function stationDownClick(event:MouseEvent):void {
			Tweener.addTween(popup, { onComplete:function() { popup.visible = false }, alpha:0, time:0.5, delay:0, transition:"easeoutquad" } );
			Tweener.addTween(popdown, { onStart:function() { popdown.visible = true }, alpha:1, time:0.5, delay:0, transition:"easeoutquad" } );
		}
		
		var id="-1";
		var iValue:Number
		public function setStation(iData){
			var iID:String = iData.@id
			var iName:String = iData.NAME
			iValue = Number(iData.VALUE)
			/*
			popup.iStationDetail.id.htmlText = iData.@id
			var _desc = String(iData.NAME).replace("ช่วง", "<br/>ช่วง");
			_desc = _desc.replace("เขต","<br/>เขต");
			popup.iStationDetail.desc.htmlText = _desc
			*/
			
			//gotoAndStop
			if (id != iID)
			{
				id=iID
				popup.visible = true;
				popup.alpha = 1;
				
				popdown.visible = false;
				popdown.alpha = 0;
				//Tweener.addTween(popup, {onStart:function(){popup.visible = true}, alpha:1, time:0.5, delay:0,transition:"easeoutquad"});
				
				if(station){
					station.remove();
				}
				
				station.load(stationPath+iID+".swf");
				station.addEventListener(ContentEvent.COMPLETE, onStationComplete);
			}else{
				//updateStation()
				
			}
			//ADDITION//special request to ignore id>22
			trace(" ! id : "+Number(iID.substr(2)) );
			if (Number(iID.substr(2)) > 21)
			{
				popup.visible = false;
				popup.alpha = 0;
				
				popdown.visible = true;
				popdown.alpha = 1;
				
				popdown.popupButton.visible = false;
			}else
			{
				popdown.popupButton.visible = true;
			}
			
			
			popdown.iStationName.htmlText = iID+ " - "+iName;
			
			var dataPath = XMLUtil.getNodeById(config,"FloodStationData").@src;
			var method = String(XMLUtil.getNodeById(config,"FloodStationData").@method).toUpperCase();
			
			var _customAlpha:String = String(XMLUtil.getNodeById(config,"FloodStationData").@alpha);
			var _customColor:String = String(XMLUtil.getNodeById(config, "FloodStationData").@color);
			var _customBlendmode:String = String(XMLUtil.getNodeById(config, "FloodStationData").@blendmode);
			
			customAlpha = (_customAlpha!="")?Number(_customAlpha)/100:customAlpha;
			customColor = (_customColor != "")?Number(_customColor):customColor;
			customBlendmode = (_customBlendmode != "")?String(_customBlendmode):customBlendmode;
			
			//customAlpha = 1
			//customColor = Number("0xFF0000")
			
			trace(" ! customAlpha : " + customAlpha);
			trace(" ! customColor : " + customColor);
			trace(" ! customBlendmode : " + customBlendmode);
			
			if(isTest){
				dataPath = "../serverside/";
			}
			
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onComplete);
			
			var request = new URLRequest( URLUtil.killCache(dataPath+"Floodmon_"+iID+".xml") )
			
			loader.load(request);
			
			/*
			var dataPath = XMLUtil.getNodeById(config,"FloodStationData").@src;
			var method = String(XMLUtil.getNodeById(config,"FloodStationData").@method).toUpperCase();
			
			if(isTest){
				dataPath = "http://localhost/yourpath/Flood/serverside/getStationData.php";
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
		
		public function onStationComplete(event:ContentEvent):void {
			
			SleepyDesign.log(" ^ "+event.type);
			station.content.gotoAndStop(1);
			updateStation();
			
		}
		
		public function updateStation():void {
			if(floodObject.height!=null){
				iValue = floodObject.height
			}
			try{
				trace("updateStation:"+iValue);
				//trace("totalFrames:"+station.content.totalFrames)
				if(iValue<0){
					iValue = 0;
				}
				if(iValue>100){
					iValue = 100;
				}
				var factor = iValue*station.content.totalFrames/100;
				var frame = 1+Math.ceil(factor)
				if(frame>station.content.totalFrames){
					frame = station.content.totalFrames;
				}
				station.content.gotoAndStop(frame);
				trace("gotoAndStop:"+frame);
			}catch(e){
				
			}
		}
		
		//_________________________________________________________________ Section2
		
		public function createRoad(iID:String){
			
			if(road.extra.flood){
				road.removeChild(road.extra.flood);
			}
			
			road.extra.flood = road.addChild(new MovieClip())
			var flood = road.extra.flood;
			
			flood.content = new Content(flood);
			
			if(!flood.water){
				var _water2:Water2 = new Water2(new Rectangle(20, -125, 2520, 125), customAlpha, 0,customColor)
				_water2.blendMode = customBlendmode;
				trace(" ! apply customBlendmode : " +customBlendmode);
				
				flood.water = flood.addChild(_water2);
				flood.water.y = 125;
				
				flood.road = flood.addChild(new MovieClip());
				
				flood.ruler = flood.addChild(new iRuler());
				flood.ruler.x = 20
				flood.ruler.y = 125-10;
			}
			
			var y0 = 125 - 103
			
			flood.water.height = y0 + floodObject.height * .915;
			
			flood.content.addEventListener(ContentEvent.COMPLETE, onRoadComplete);
			flood.content.addEventListener(ContentEvent.ERROR, onRoadError);
			
			try {
				flood.content.load(roadPath+iID+".swf");
			}catch( error:* ) {
                trace("catch:"+error);
            }
			
			iPopup.pointer.y = 508 - floodObject.height* .915;
			iPopup.pointer.label.text = String(floodObject.height + " cm.");
		}

		public function onRoadError(event:ContentEvent):void {
			SleepyDesign.log(" ^ "+event.type);
			//road.extra.flood.content.load(roadPath+"default.swf");
		}
		
		public function onRoadComplete(event:ContentEvent):void {
			SleepyDesign.log(" ^ " + event.type);
			
			road.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler2);
			
			addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler2);
			
			road.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler2);
			//road.addEventListener(MouseEvent.MOUSE_OUT, mouseUpHandler2);
			road.addEventListener(MouseEvent.ROLL_OUT, mouseUpHandler2);
			
			road.buttonMode = true
			road.extra.flood.x = 20 - road.extra.flood.width * .5 + popup.iRoad.mask.width * .5

			var _road:MovieClip = event.content.road as MovieClip;
			if (_road)
			{
				//trace("+"+_road)
				var roadBitmap:Bitmap = new Bitmap(GraphicUtil.getBitmapData(_road));
				roadBitmap.x = _road.x;
				roadBitmap.y = _road.y;
				road.extra.flood.road.addChild(roadBitmap);
			}
			
		}
		
		//_________________________________________________________________ MouseEvent
		
		private function mouseUpHandler2(event:MouseEvent):void {
			if(road.extra.flood){
				road.extra.flood.stopDrag();
			}
		}
		
		private function mouseDownHandler2(event:MouseEvent):void {
			var min = 0
			var max = -(road.extra.flood.width-popup.iRoad.mask.width);
			
			road.extra.flood.startDrag(false,new Rectangle(min,0,max,0));
		}
		
		//_________________________________________________________________ Section
		
		public function setSection(iID:String){
			
		}
		
		public function createSection(iID:String){
			//trace("createSection")
			
			if(section.extra.flood){
				section.removeChild(section.extra.flood);
			}

			section.extra.flood = section.addChild(new MovieClip())
			var flood = section.extra.flood;
			
			if(!flood.water){
				flood.water = flood.addChild(new Water(new Rectangle(0,-180,763,180), 1, 1));
				flood.water.y = 180;
			}
			
			if(!flood.bank){
				
				flood.bank = flood.addChild(new MovieClip())
				
				flood.bank.left = GraphicUtil.createRect(flood.water,flood.bank);
				flood.bank.right = GraphicUtil.createRect(flood.water,flood.bank);
				
				flood.bank.left.width = 200;
				flood.bank.right.width = 763-200;
				
				flood.bank.right.x = 200;
				
				//flood.bank.y = 180;
				
			}
			
			var y0 = 180-120
			
			flood.water.height = y0+floodObject.height*factor;
			flood.bank.right.height = y0+floodObject.roadHeight*factor;
			
			flood.bank.right.y = 180-flood.bank.right.height;
			
			section.extra.detail.waterHeight.y = 180-flood.water.height-16
			section.extra.detail.roadHeight.y = flood.bank.right.y-16
			
			flood.content = new Content(flood);
			flood.content.addEventListener(ContentEvent.COMPLETE, onSectionComplete);
			flood.content.addEventListener(ContentEvent.ERROR, onSectionError);
			
			//trace(sectionPath+iID+".swf");
			try {
				flood.content.load(sectionPath+iID+".swf");
			}catch( error:* ) {
                trace("catch:"+error);
            }
			
			popdown.pointer.y = 180 + 16 - floodObject.height * factor;
			
			if (Number(iID.substr(2)) > 21)
			{
				popdown.pointer.visible = true;
			}else {
				popdown.pointer.visible = false;
			}
		}

		public function onSectionError(event:ContentEvent):void {
			SleepyDesign.log(" ^ "+event.type);
			section.extra.flood.content.load(sectionPath+"default.swf");
		}
		
		public function onSectionComplete(event:ContentEvent):void {
			SleepyDesign.log(" ^ "+event.type);
			event.content.mask = section.extra.flood.bank
			//section.extra.fake2D.addChild(new Fake2D(section.extra.flood,20,0.1 ))
		}
		
		//_________________________________________________________________ Data
		
		public function onComplete(event:Event):void {
			var mom = (parent as Content)
			if(mom)mom.ready();
			
			SleepyDesign.log(" ^ "+event.type);
			var loader:URLLoader = event.target as URLLoader;
			var xml:XML = new XML(loader.data);
			
			var item = xml.STATION;
			
			//setGraph
			if(section.extra.fake2D){
				section.removeChild(section.extra.fake2D);
			}
			section.extra.fake2D = section.addChild(new Sprite())
			
			//setStationDetail
			if(section.extra.detail){
				iPopDown.removeChild(section.extra.detail);
			}
			section.extra.detail = iPopDown.addChild(new iSectionDetail())
			section.extra.detail.x = popdown.iSection.x
			section.extra.detail.y = popdown.iSection.y
			
			//setDetail
			popdown.iDetail.ALERT.htmlText = item.ALERT;
			
			if(item.STATUS=="1"){
				popdown.iDetail.COM.htmlText = "<FONT COLOR=\"#FF0000\">Fail</FONT>"
			}else {
				popdown.iDetail.COM.htmlText = "<FONT COLOR=\"#00FF00\">OK</FONT>"
			}
			if (item.STATUS_PUMP == "1") {
				popdown.iDetail.STATUS.htmlText = "<FONT COLOR=\"#FF0000\">Pump On</FONT>"
			}else {
				popdown.iDetail.STATUS.htmlText = "<FONT COLOR=\"#0000FF\">Pump Off</FONT>"
			}
			
			popdown.iDetail.LAST_START.htmlText = item.LAST_START;
			popdown.iDetail.LAST_STOP.htmlText = item.LAST_STOP;
			popdown.iDetail.MAX.htmlText = item.MAX;
			
			floodObject = new Object();
			
			floodObject.height = Number(item.VALUE)
			floodObject.roadHeight = Number(item.ROAD_HEIGHT)
			
			section.extra.detail.waterHeight.htmlText = floodObject.height;
			section.extra.detail.roadHeight.htmlText = floodObject.roadHeight;
			
			popdown.pointer.label.text = String(floodObject.height + " cm.");
			
			createSection(xml.STATION.@id)
			createRoad(xml.STATION.@id)
			
			popdown.iValue = floodObject.height
			updateStation();
			
		}
		//_________________________________________________________________ History
		
		public function setGraph(iID){
			var dataPath = XMLUtil.getNodeById(config,"FloodHistoryData").@src;
			var method = String(XMLUtil.getNodeById(config,"FloodHistoryData").@method).toUpperCase();
			
			if(isTest){
				dataPath = "../serverside/";
			}
			
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, xmlLoadCompleteHandler);
			
			var request = new URLRequest( URLUtil.killCache(dataPath+"FloodmonHistory_"+iID+".xml") )
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
			var data:XML = new XML( loader.data );
			
			var dataProvider:Array = new Array();
			var captionNum = 0;
			
			//data.normalize();
			
			var baseY = 104-29;
			var graphFactor = 70/100;
			
			if(graph.extra.flood){
				graph.removeChild(graph.extra.flood);
			}
			
			graph.extra.flood = graph.addChild(new MovieClip());
			graph.extra.flood.y = baseY
			
			var myFlood = graph.extra.flood.addChild(new Sprite());
			var floodShape = myFlood.addChild(new Shape());
			var flood = floodShape.graphics;
			
			
			//graph.extra.flood = myFlood;
			
			//_________________________________________water
			
			var fillType:String = GradientType.LINEAR;
			var colors:Array = [0x0033FF, 0x0099FF];
			var alphas:Array = [0, 1];
			var ratios:Array = [0x00, 0xFF];
			var matr:Matrix = new Matrix();
			matr.rotate(180)
			var spreadMethod:String = SpreadMethod.PAD;

			flood.beginGradientFill(fillType, colors, alphas, ratios, matr, spreadMethod);
			
			flood.lineStyle(0.5,0x0099FF,0.5)
			
			//flood.beginFill(0x0000FF);
			flood.moveTo(0,0);

			var stationXML = data.children()[0]
			
			var total = stationXML.child("*").length();
			
			//for (var i=0;i<total-1;i++){
			for (var i=total-2;i>0;i--){
				
				var lastXML = stationXML.children()[i+1];
				if(((captionNum) % 4)==0){
					
					var caption = graph.extra.flood.addChild(new iCaption());
					caption.x = captionNum*60/4;
					//caption.y = baseY
					caption.title.htmlText = lastXML.DATE+"<br/>"+lastXML.TIME;
					
				}
				//flood.water = flood.addChild(new Water(new Rectangle(0,0,12,Number(lastXML.VALUE))));
				flood.lineTo(captionNum,-graphFactor*Number(lastXML.VALUE))
				captionNum++
			}
			flood.lineTo(total-2,0);
			myFlood.width*=60/4;
			flood.endFill();
			
			graph.extra.flood.x = -(graph.extra.flood.width-763);
			
			//createGraph();
		}
		
		public function createGraph(){
			if(graph.extra.fake2D){
				graph.removeChild(graph.extra.fake2D);
			}
			graph.extra.fake2D = graph.addChild(new Sprite());
			graph.extra.fake2D.addChild(new Fake2D(graph.extra.flood,20,0.05 ))
		}
		
		//_________________________________________________________________ Update
		
		public override function onUpdate(event:ContentEvent):void {
			if(event.content.name=="FloodStation"){
				setStation(event.data)
				//setSection(event.data.@id)
				setGraph(event.data.@id)
			}
		}
		
	}

}