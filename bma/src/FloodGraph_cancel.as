/**
* ...
* @author katopz@sleepydesign.com
* @version 0.1
*/

package {
	import flash.geom.Rectangle;
	import flash.system.Security;
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import fl.data.DataProvider;

	import com.sleepydesign.site.*;
	import com.sleepydesign.utils.*;

	import com.yahoo.astra.fl.charts.*;
	import com.yahoo.astra.fl.charts.series.*;

	public class FloodGraph extends Content{
		
		//TODO path config
		public var rootPath:String = "Flood/";
		
		
		public var type = "Graph";
		
		public var graph0;
		public var graph1;
		
		public var isTest = false;
		
		var series0, series1:LineSeries
		
		public function FloodGraph(){
			
			Security.allowDomain("*")
			
			graph0 = iGraph0;
			graph1 = iGraph1;
			
			dp = new DataProvider();
			//iComboBox.dataProvider = dp;
			//iComboBox.addEventListener(Event.CHANGE, onComboChange);
			
			//trace(dataPath)
			
			graph1.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			graph1.mouseEnabled = true;
			graph1.useHandCursor = true;
			graph1.buttonMode= true;
			addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			
			//graph1.mask = GraphicUtil.createRect(graph1);
			
			//test();

			
		}
		
		public function test(){
			trace("Self Test")
			
			isTest = true
			
			var dataPath:String = "../serverside/FloodmonAllStation.xml";
			
			setGraph("VALUE");
			
		}
		
		//_________________________________________________________________ Graph

		public function createGraph(graph, type){
			
			var chart = graph;
			
			chart.horizontalField = "@id";
			chart.verticalField = type;
			
			series0 = new LineSeries();
			series1 = new LineSeries();
			
		}
		
		public function setGraph(type){
			
			createGraph(graph0, type);
			createGraph(graph1, type);
			
			var dataPath = XMLUtil.getNodeById(config,"FloodGraphData").@src;
			var method = String(XMLUtil.getNodeById(config,"FloodGraphData").@method).toUpperCase();
			
			if(isTest){
				dataPath = "../serverside/FloodmonAllStation.xml";
			}
			
			var loader:URLLoader = new URLLoader();
			loader.addEventListener( Event.COMPLETE, xmlLoadCompleteHandler );
			
			var request = new URLRequest( URLUtil.killCache(dataPath) )
			loader.load(request);
			
			/*
			var dataPath = XMLUtil.getNodeById(config,"FloodGraphData").@src;
			var method = String(XMLUtil.getNodeById(config,"FloodGraphData").@method).toUpperCase();
			
			if(isTest){
				dataPath = "http://localhost/yourpath/serverside/Flood/getStationList.php";
			}
			
			var loader:URLLoader = new URLLoader();
			loader.addEventListener( Event.COMPLETE, xmlLoadCompleteHandler );
			
			var request = new URLRequest( URLUtil.killCache(dataPath) )
			
            var variables:URLVariables = new URLVariables();
            variables.type = type;
            request.data = variables;
			request.method = (method==URLRequestMethod.POST)?request.method = URLRequestMethod.POST:URLRequestMethod.GET;
			
			loader.load(request);
			*/
		}

		var dp:DataProvider
		var gap = 10;
		var data:XML
		public function xmlLoadCompleteHandler(event:Event):void
		{
			
			var loader:URLLoader = event.target as URLLoader;
			data = new XML( loader.data );
			
			var data0:Array = new Array();
			var data1:Array = new Array();
			
			//var half = data.STATION.length()/2;
			var limit = 20;
			
			var list = "";
			dp = new DataProvider();
			
			for (var i:int = 0; i < data.STATION.length(); i++)
			{
				if(limit--){
					data0.push(data.STATION[i]);
				}
				//
				data1.push(data.STATION[i]);
				
				var row:int = int(i / 10);
				
				if (i%gap==0 )
				{
					list = data.STATION[i].@id;
					list += " -> ";
					if(data.STATION[i+gap-1]){
						list += data.STATION[i + gap-1].@id;
					}else {
						list += data.STATION[data.STATION.length()-1].@id;
					}
					trace(list)
					
					dp.addItem( { label: list, data:i} );
					
					
				}
			}
			
			iGraph1.width = data.STATION.length() * 760/25;
			iGraph1.width = Math.max(iGraph1.width, 760);
			//iComboBox.dataProvider = dp;
			
			data0.sortOn("VALUE", Array.DESCENDING | Array.NUMERIC);
			
			//trace(data)
			
			/*
			var series1:ColumnSeries = new ColumnSeries();
			series1.displayName = "RAIN_24HOUR";
			series1.dataProvider = data.STATION;
			chart.setStyle( "seriesMarkerSizes", [ 12 ] );
			*/
			
			series0.dataProvider = data0;
			series1.dataProvider = data1;
			
			graph0.dataProvider = [data0,series0];
			graph1.dataProvider = [data1,series1];
			
			//all done
			var mom = (parent as Content)
			if(mom)mom.ready();
		}
		
		private function mouseUpHandler(event:MouseEvent):void
		{
			if (graph1)
			{
				graph1.stopDrag();
			}
		}
		
		private function mouseDownHandler(event:MouseEvent):void
		{
			var min = graph1.x
			var max = -(graph1.width-760);
			
			graph1.startDrag(false,new Rectangle(min,graph1.y,max,0));
		}
		
		/*
		private function onComboChange(event:Event):void
		{
			trace("onComboChange:" + iComboBox.value);
			
			var data1:Array = new Array();
			var max:uint = Math.min(data.STATION.length(), int(iComboBox.value) + gap);
			
			trace(String(iComboBox.value) + " -> " + String(max))
			
			for (var i:int = int(iComboBox.value); i < max; i++)
			{
				data1.push(data.STATION[i]);
			}
			
			graph1.dataProvider = [data1,series1];
		}
		*/
		//_________________________________________________________________ Update
		
		public override function onUpdate(event:ContentEvent):void {
			if(event.content.name=="FloodGraph"){
				//setGraph(event.data.@id);
				setGraph("VALUE");
			}
		}
		
	}

}