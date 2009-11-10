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
			
            graph0.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler0);
            graph0.mouseEnabled = true;
            graph0.useHandCursor = true;
            graph0.buttonMode = true;
			
            graph1.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler1);
            graph1.mouseEnabled = true;
            graph1.useHandCursor = true;
            graph1.buttonMode = true;
			
            addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
            addEventListener(MouseEvent.MOUSE_OUT, mouseUpHandler);
			
			//trace(dataPath)
			
			//test();

			
		}
		
        private function mouseUpHandler(param1:MouseEvent) : void
        {
            if (graph0)
            {
                graph0.stopDrag();
            }
            if (graph1)
            {
                graph1.stopDrag();
            }
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
		
		
		public function xmlLoadCompleteHandler(event:Event):void
		{
			
			var loader:URLLoader = event.target as URLLoader;
			var data:XML = new XML( loader.data );
			
			var data0:Array = new Array();
			var data1:Array = new Array();
			
			//var half = data.STATION.length()/2;
			
			for (var i:int = 0; i < data.STATION.length(); i++)
			{
				//if(i<half){
					data0.push(data.STATION[i]);
				//}else{
					data1.push(data.STATION[i]);
				//}
			}
			
			data0.sortOn("VALUE", Array.DESCENDING | Array.NUMERIC);
			
            iGraph0.width = data.STATION.length() * 760 / 25;
            iGraph0.width = Math.max(iGraph0.width, 760);
			
            iGraph1.width = data.STATION.length() * 760 / 25;
            iGraph1.width = Math.max(iGraph1.width, 760);
			
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
		
        private function mouseDownHandler0(param1:MouseEvent) : void
        {
			var min = graph0.x
			var max = -(graph0.width-760);
			
			graph0.startDrag(false,new Rectangle(min,graph0.y,max,0));
        }
		
        private function mouseDownHandler1(param1:MouseEvent) : void
        {
			var min = graph1.x
			var max = -(graph1.width-760);
			
			graph1.startDrag(false,new Rectangle(min,graph1.y,max,0));
        }
		
		//_________________________________________________________________ Update
		
		public override function onUpdate(event:ContentEvent):void {
			if(event.content.name=="FloodGraph"){
				//setGraph(event.data.@id);
				setGraph("VALUE");
			}
		}
		
	}

}