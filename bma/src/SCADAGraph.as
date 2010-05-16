package
{
	import com.sleepydesign.site.*;
	import com.sleepydesign.utils.*;
	import com.yahoo.astra.fl.charts.*;
	import com.yahoo.astra.fl.charts.series.*;

	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.Security;
	import flash.text.*;

	public class SCADAGraph extends Content
	{
		//TODO path config
		public var rootPath:String = "SCADA/";

		public var type = "Graph";

		public var graph0;
		public var graph1;

		public var isTest = false;

		public var rtype;

		var series0, series1:LineSeries

		public function SCADAGraph()
		{
			Security.allowDomain("*");

			graph0 = iGraph0;
			graph1 = iGraph1;
			
			//test();
		}

		public function test()
		{
			trace("Self Test")

			var dataPath:String = "serverside/" + rootPath + "GraphList.xml";
			dataPath = "../../" + dataPath;

			isTest = true
			//var data = <RAIN id="15MIN">Past 15 Min.</RAIN>
			var data = <RAIN id="24HOUR">Past 24 Hr.</RAIN>
			setGraph(data);

		}

		//_________________________________________________________________ Graph

		public function createGraph(graph, type)
		{
			var chart = graph;

			chart.horizontalField = "LABEL";
			chart.verticalField = rtype;

			series0 = new LineSeries();
			series1 = new LineSeries();
		}

		public function setGraph(iData)
		{
			var iID = iData.@id;
			var iName = iData;

			iName0.text = iName
			iName1.text = iName

			if (iID == "DAILY_ACC_RAIN")
			{
				rtype = "DAILY_ACC_RAIN"
			}
			else
			{
				rtype = "RAIN_" + iID
			}

			createGraph(graph0, iID);
			createGraph(graph1, iID);

			var dataPath = StringUtil.getNodeById(config, "SCADAGraphData").@src;
			var method = String(StringUtil.getNodeById(config, "SCADAGraphData").@method).toUpperCase();

			if (isTest)
			{
				dataPath = "../serverside/";
			}

			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, xmlLoadCompleteHandler);

			var request = new URLRequest(URLUtil.killCache(dataPath + "SCADAAllStation_" + iID + ".xml"))
			loader.load(request);
		/*
		   createGraph(graph0, type);
		   createGraph(graph1, type);

		   //TODO sent type
		   var dataPath = StringUtil.getNodeById(config,"SCADAGraphData").@src;
		   var method = String(StringUtil.getNodeById(config,"SCADAGraphData").@method).toUpperCase();

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
			var data:XML = new XML(loader.data);

			var data0:Array = new Array();
			var data1:Array = new Array();

			var half = data.STATION.length() / 2;

			for (var i:int = 0; i < data.STATION.length(); i++)
			{
				if (i < half)
					data0.push(data.STATION[i]);
				else
					data1.push(data.STATION[i]);
			}

			series0.dataProvider = data0;
			series1.dataProvider = data1;

			graph0.dataProvider = [data0, series0];
			graph1.dataProvider = [data1, series1];

			//all done
			var mom = (parent as Content)
			if (mom)
				mom.ready();
		}

		//_________________________________________________________________ Update

		public override function onUpdate(event:ContentEvent):void
		{
			if (event.content.name == "SCADAGraph")
			{
				setGraph(event.data);
			}
		}
	}
}