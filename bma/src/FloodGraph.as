/**
* ...
* @author katopz@sleepydesign.com
* @version 0.1
*/

package {
	import com.sleepydesign.containers.Cursor;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.Security;
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import gs.TweenMax;
	
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
			
			graph0 = iGraphContainer0;
			graph1 = iGraphContainer1;
			
            graph0.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler0);
            graph0.mouseEnabled = !true;
            graph0.useHandCursor = !true;
            graph0.buttonMode = !true;
			
            graph1.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler1);
            graph1.mouseEnabled = !true;
            graph1.useHandCursor = !true;
            graph1.buttonMode = !true;
			
            addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
            addEventListener(MouseEvent.MOUSE_OUT, mouseUpHandler);
			
			//trace(dataPath)
			
			//test();
			
			var cursor1:Cursor = new Cursor(this, iGraphContainer0);
			var cursor2:Cursor = new Cursor(this, iGraphContainer1);
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
			
			//sort alphabet
			var data3:Array = new Array();
			var _data0:Array = new Array();
			var _value:Number=-1;
			for each(var _data:* in data0)
			{
				//new group
				if (_value!=Number(_data.VALUE))
				{
					//mem value
					_value = Number(_data.VALUE);
					
					//mem data
					if (_data0)
					{
						//sort alphabet
						_data0.sortOn("@id");
						
						//concat
						data3 = data3.concat(_data0);
						
						//reset
						_data0 = [];						
					}
				}
				_data0.push(_data);
			}
			
			_data0.sortOn("@id");
			data3 = data3.concat(_data0);
			
            graph0.width = data.STATION.length() * 760 / 20;
            graph0.width = Math.max(graph0.width, 760);
			
            graph1.width = data.STATION.length() * 760 / 20;
            graph1.width = Math.max(graph1.width, 760);
			
			//trace(data)
			
			/*
			var series1:ColumnSeries = new ColumnSeries();
			series1.displayName = "RAIN_24HOUR";
			series1.dataProvider = data.STATION;
			chart.setStyle( "seriesMarkerSizes", [ 12 ] );
			*/
			
			series0.dataProvider = data3;
			series1.dataProvider = data1;
			
			graph0.dataProvider = [data3, series0];
			graph1.dataProvider = [data1, series1];
			
			/*
			var graphBitmap:BitmapData = GraphicUtil.getBitmapData(this, false);
			var fake0:Sprite = new Sprite();
			addChild(fake0);
			fake0.addChild(new Bitmap(graphBitmap));
			*/
			
			TweenMax.to(this,0.5,{onComplete:draw})
			
			//all done
			var mom = (parent as Content)
			if(mom)mom.ready();
		}
		
		private var fake0:Sprite
		private var fake1:Sprite
		
        private function mouseDownHandler0(param1:MouseEvent) : void
        {
			var min = graph0.x
			var max = -(graph0.width-760);
			
			graph0.startDrag(false, new Rectangle(min, graph0.y, max, 0));
			//draw();
        }
		
        private function mouseDownHandler1(param1:MouseEvent) : void
        {
			var min = graph1.x
			var max = -(graph1.width-760);
			
			graph1.startDrag(false,new Rectangle(min,graph1.y,max,0));
        }
		
		//_________________________________________________________________ Update
		
		private function draw():void
		{
			var graphBitmap:BitmapData = GraphicUtil.getBitmapData(graph0, false);
			var axisBitmap:BitmapData = new BitmapData(33, graphBitmap.height);
			axisBitmap.copyPixels(graphBitmap, new Rectangle(0, 0, 33, 190), new Point());
			
			if (fake0)
			{
				fake0.parent.removeChild(fake0);
				fake0 = null;
			}
			
			fake0 = new Sprite();
			addChild(fake0);
			fake0.x = graph0.x;
			fake0.y = graph0.y;
			fake0.addChild(new Bitmap(axisBitmap));
			
			//
			
			var graphBitmap:BitmapData = GraphicUtil.getBitmapData(graph1, false);
			var axisBitmap:BitmapData = new BitmapData(33, graphBitmap.height);
			axisBitmap.copyPixels(graphBitmap, new Rectangle(0, 0, 33, 190), new Point());
			
			if (fake1)
			{
				fake1.parent.removeChild(fake1);
				fake1 = null;
			}
			
			fake1 = new Sprite();
			addChild(fake1);
			fake1.x = graph1.x;
			fake1.y = graph1.y;
			fake1.addChild(new Bitmap(axisBitmap));
		}
		
		public override function onUpdate(event:ContentEvent):void {
			if (event.content.name == "FloodGraph")
			{
				//setGraph(event.data.@id);
				setGraph("VALUE");
			}
		}
		
	}

}